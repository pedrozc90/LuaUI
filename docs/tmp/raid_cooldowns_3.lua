local T, C, L = Tukui:unpack()

local GetTime = GetTime

local IsInGroup, IsInRaid = IsInGroup, IsInRaid
local GetNumGroupMembers = GetNumGroupMembers
local UnitGUID = UnitGUID

local GetPlayerInfoByGUID = GetPlayerInfoByGUID
local GetRaidRosterInfo = GetRaidRosterInfo

local GetSpellInfo, GetSpellBaseCooldown = GetSpellInfo, GetSpellBaseCooldown

local CanInspect, NotifyInspect = CanInspect, NotifyInspect
local GetActiveSpecGroup, GetTalentInfo = GetActiveSpecGroup, GetTalentInfo
local GetSpecialization, GetSpecializationInfo = GetSpecialization, GetSpecializationInfo
local GetInspectSpecialization, GetSpecializationInfoByID = GetInspectSpecialization, GetSpecializationInfoByID

----------------------------------------------------------------
-- Raid Cooldowns
----------------------------------------------------------------
if (not C.RaidCD.Enable) then return end

local SpellTable = {
    ["DRUID"] = {
        { spellID = 78675, type = "interrupt", specs = { [102] = true }, enabled = true },                  -- Solar Beam
        { spellID = 106839, type = "interrupt", specs = { [103] = true, [102] = true }, enabled = true }    -- Skull Bash
    },
    ["DEATHKNIGHT"] = {
        { spellID = 47528, type = "interrupt", enabled = true }                                             -- Mind Freeze
    },
    ["DEMONHUNTER"] = {
        { spellID = 183752, type = "interrupt", enabled = true }                                            -- Disrupt
    },
    ["HUNTER"] = {
        { spellID = 147362, type = "interrupt", enabled = true }                                            -- Counter Shot
    },
    ["MAGE"] = {
        { spellID = 2139, type = "interrupt", enabled = true }                                              -- Counterspell
    },
    ["PALADIN"] = {
        { spellID = 642, type = "defense", specs = { [66] = true }, enabled = true },                       -- Divine Shield
        { spellID = 31850, type = "defense", specs = { [66] = true }, enabled = true },                     -- Ardent Defender
        { spellID = 115750, type = "crowdcontrol", specs = { [66] = true }, enabled = true },               -- Bliding Light
        { spellID = 96231, type = "interrupt", specs = { [66] = true, [67] = true }, enabled = true }       -- Rebuke (15 sec)
    },
    ["PRIEST"] = {
        { spellID = 33206, type = "raid", specs = { [256] = true }, enabled = true },                       -- Pain Suppression
        { spellID = 62618, type = "raid", specs = { [256] = true }, enabled = true },                       -- Power Word: Barrier
        { spellID = 47788, type = "raid", specs = { [257] = true }, enabled = true },                       -- Guardian Spirit
        { spellID = 15487, type = "interrupt", specs = { [258] = true }, enabled = true },                  -- Silence
        { spellID = 15286, type = "raid", specs = { [258] = true }, enabled = true },                       -- Vampiric Embrace
        { spellID = 47585, type = "defense", specs = { [258] = true }, enabled = true },                    -- Dispersion
    },
    ["ROGUE"] = {
        { spellID = 1766, type = "interrupt", enabled = true }                                              -- Kick
    },
    ["MONK"] = {
        { spellID = 116705, type = "interrupt", enabled = true },                                           -- Spear Hand Strike
        { spellID = 115203, type = "defense", specs = { [268] = true }, enabled = true },                   -- Fortigying Brew
        { spellID = 122278, type = "defense", specs = { [268] = true }, talents = {}, enabled = true },                  -- Dampen Harm
        { spellID = 116849, type = "raid", specs = { [270] = true }, enabled = true },                      -- Life Cocoon
    },
    ["SHAMAN"] = {
        { spellID = 57994, type = "interrupt", enabled = true }                                             -- Wind Shear
    },
    ["WARLOCK"] = {
        { spellID = 20707 , type = "raid", enabled = true }                                                 -- Soulstone
    },
    ["WARRIOR"] = {
        { spellID = 871, type = "defense", specs = { [73] = true }, enabled = true },                           -- Shield Wall
        { spellID = 6552 , type = "interrupt", enabled = true },                                                -- Pummel
        { spellID = 97462, type = "raid", enabled = true },                                                     -- Rallying Cry
        { spellID = 107570, type = "interrupt", specs = { [73] = true }, talent = { 2, 3 }, enabled = true },   -- Storm Bold
    }
}

local hasRequiredSpec = function(spell, member)
    if (not spell.specs) then return true end
    return spell.specs[member.spellID or 0]
end

local hasRequiredTalent = function(spell, member)
    if (not spell.talents) then return true end
    local row, col = unpack(spell.talents)
    if (not row) then row = 0 end
    if (not col) then col = 0 end
    if (member.talents and member.talents[row]) then
        if (member.talents[row][col]) then
            return member.talents[row][col]
        end
    end
    return false
end

local validateRealm = function(realm)
    if (string.len(realm or "") == 0) then
        return GetRealmName()
    end
    return realm
end

local RaidCooldown = CreateFrame("Frame", "RaidCooldowns", UIParent)

function RaidCooldown.CooldownReady(self)
    if (self.StatusBar) then
        self.StatusBar:SetValue(100)
    end

    if (self.Timer) then
        self.Timer:SetText("Ready")
    end

    self.time_left = nil
    self.expiration = nil
    self.start = nil

    self:SetScript("OnUpdate", nil)
end

function RaidCooldown:FindCooldownIndex(guid, spellID)
    for index, f in ipairs(self) do
        if (f.guid == guid and f.spellID == spellID) then
            return index
        end
    end
    return nil
end

function RaidCooldown.UpdateTimer(self, elapsed)
    self.time_left = (self.time_left or (self.expiration - GetTime())) - elapsed
    if (self.time_left > 0) then
        if (self.StatusBar) then
            local percentage = (100 * (self.time_left or 0) / self.cooldown)
            self.StatusBar:SetValue(percentage)
        end

        if (self.Timer) then
            self.Timer:SetText(T.FormatTime(self.time_left))
        end
    else
        RaidCooldown.CooldownReady(self)
    end
    
end

function RaidCooldown:UpdatePositions()
    local Spacing = C.RaidCD.BarSpacing

    for index = 1, #self do
        if (index == 1) then
            self[index]:SetPoint("TOPLEFT", self, "TOPLEFT", 0, 0)
        else
            self[index]:SetPoint("TOP", self[index - 1], "BOTTOM", 0, -Spacing)
        end
    end
end

function RaidCooldown:Spawn(index, name, realm, class, spellName, spellIcon)
    -- print("SPAWNING", index, name, realm, class, spellName, spellIcon, self:GetName())

    local sourceName = (realm) and (name .. "-" .. realm) or name

    local Width, Height = C.RaidCD.BarWidth, C.RaidCD.BarHeight
    local Spacing = C.RaidCD.BarSpacing
    local Texture = C.Medias.Blank
    local Font = T.GetFont(C.UnitFrames.Font)

    local color = RAID_CLASS_COLORS[class]

    local Bar = CreateFrame("Frame", self:GetName() .. index, UIParent)
    Bar:SetSize(Width, Height)
    Bar:SetFrameStrata(self:GetFrameStrata())
    Bar:SetFrameLevel(self:GetFrameLevel() + 1)
    Bar:CreateBackdrop()

    local StatusBar = CreateFrame("StatusBar", Bar:GetName() .. "StatusBar", Bar)
    StatusBar:SetInside(Bar)
    StatusBar:SetFrameStrata(self:GetFrameStrata())
    StatusBar:SetFrameLevel(Bar:GetFrameLevel() + 1)
    StatusBar:SetStatusBarTexture(Texture)
    StatusBar:SetStatusBarColor(color.r, color.g, color.b, 1)
    StatusBar:SetMinMaxValues(0, 100)
    StatusBar:SetValue(80)
    -- StatusBar:CreateBackdrop()

    StatusBar.Background = StatusBar:CreateTexture(nil, "BORDER")
    StatusBar.Background:SetAllPoints(StatusBar)
    StatusBar.Background:SetTexture(Texture)
    StatusBar.Background:SetVertexColor(0.15, 0.15, 0.15)

    local Button = CreateFrame("Button", Bar:GetName() .. "Button", Bar)
    Button:SetPoint("RIGHT", StatusBar, "LEFT", -Spacing, 0)
    Button:SetSize(Height, Height)
    Button:CreateBackdrop()

    local Icon = Button:CreateTexture(nil, "ARTWORK")
	-- icon:SetAllPoints(button)
    Icon:SetInside(Button)
	Icon:SetTexCoord(unpack(T.IconCoord))
    Icon:SetTexture(spellIcon)

    local Text = StatusBar:CreateFontString(nil, "OVERLAY")
    Text:SetFontObject(Font)
    Text:SetPoint("LEFT", StatusBar, "LEFT", 5, 0)
    Text:SetTextColor(0.84, 0.75, 0.65)
    Text:SetWidth(0.8 * Width)
    Text:SetJustifyH("LEFT")
    Text:SetText(spellName .. ": " .. sourceName)

    local Timer = StatusBar:CreateFontString(nil, "OVERLAY")
    Timer:SetFontObject(Font)
    Timer:SetPoint("RIGHT", StatusBar, "RIGHT", -5, 0)
    Timer:SetTextColor(0.84, 0.75, 0.65)
    Timer:SetJustifyH("RIGHT")
    Timer:SetText("Ready")

    Bar.StatusBar = StatusBar
    Bar.Button = Button
    Bar.Icon = Icon
    Bar.Text = Text
    Bar.Timer = Timer

    return Bar
end

RaidCooldown:RegisterEvent("PLAYER_LOGIN")
RaidCooldown:RegisterEvent("PLAYER_ENTERING_WORLD")
-- RaidCooldown:RegisterEvent("GROUP_ROSTER_UPDATE")
-- RaidCooldown:RegisterEvent("GROUP_JOINED")
-- RaidCooldown:RegisterEvent("GROUP_LEFT")
-- RaidCooldown:RegisterEvent("INSPECT_READY")
RaidCooldown:SetScript("OnEvent", function(self, event, ...)
    print(event, ...)
    -- call one of the event handlers.
    self[event](self, ...)
end)

function RaidCooldown:PLAYER_LOGIN()
    self:SetPoint(unpack(C.RaidCD.Anchor))
    self:SetSize(C.RaidCD.BarWidth, C.RaidCD.BarHeight)
    -- self:CreateBackdrop()
    self.unit = "player"
    self.guid = UnitGUID(self.unit)
    self.class = select(2, UnitClass(self.unit))
    self.group = {}
end

function RaidCooldown:FindUnit(index, size, isParty, isRaid)
    if (isRaid) then
        -- raid index is between 1 and MAX_RAID_MEMBERS, including player
        return "raid" .. index
    elseif (isParty and (index < size)) then
        -- party index is between 1 and 4, excluding player
        return "party" .. index
    end
    return "player"
end

function RaidCooldown:FindUnitByGUID(guid)
    local isInGroup, isInRaid = IsInGroup(), IsInRaid()
    if (isInGroup or isInRaid) then
        local size = GetNumGroupMembers()
        for index = 1,  size do
            local unit = self:FindUnit(index, size, isInGroup, isInRaid)
            if (guid == UnitGUID(unit)) then
                return unit
            end
        end
    end
    return nil
end

function RaidCooldown:ScanTalent(guid)
    local unit = self:FindUnitByGUID(guid)
    local _, class, _, _, _, name, realm = GetPlayerInfoByGUID(guid)
    local isInspect = (guid ~= self.guid)
    
    realm = validateRealm(realm)
    
    local spec = (guid == self.guid) and GetSpecialization() or nil
    local specID = (guid == self.guid) and GetSpecializationInfo(spec) or GetInspectSpecialization(unit)
    if ((not specID) or (specID == 0)) then return end

    local member = self.group[guid]
    member.spec = spec
    member.specID = specID
    
    if (not member.talents) then
        member.talents = {}
    end

    local _, specName, _, _, _, _ = GetSpecializationInfoByID(specID)
    local activeSpec = GetActiveSpecGroup(isInspect)

    for row = 1, MAX_TALENT_TIERS do
        if (not member.talents[row]) then
            member.talents[row] = {}
        end

        for col = 1, NUM_TALENT_COLUMNS do
            local talentID, talentName, _, selected, available, spellID, unknown, _, _, known, grantedByAura = GetTalentInfo(row, col, activeSpec, isInspect, unit)
            member.talents[row][col] = selected
        end
    end
end

function RaidCooldown:SpawnMember(unit, showPlayer)
    unit = unit or self.unit
    local guid = UnitGUID(unit)
    if (unit ~= "player" and UnitIsUnit(unit, "player")) then return end

    local _, class, _, _, _, name, realm = GetPlayerInfoByGUID(guid)

    if (not class) then
        T.Debug(unit, guid, "not class found")
    end

    realm = validateRealm(realm)

    self.group[guid] = { name = name, realm = realm, unit = unit, class = class, spec = 0 }

    local isPlayer = (guid == self.guid)

    if (isPlayer) then
        self:ScanTalent(guid)
    elseif (CanInspect(unit)) then    
        T.Print("registering INSPECT_READY event", unit, name)
        self:RegisterEvent("INSPECT_READY")
        NotifyInspect(unit)
    else
        T.Debug(unit .. " needs to be queue for inspect.")
    end

    if (not SpellTable[class]) then
        SpellTable[class] = {}
    end

    for _, data in ipairs(SpellTable[class]) do
        
        local specID = self.group[guid].specID or 0
        local isSpecRequired = hasRequiredSpec(data, self.group[guid])
        local isTalentRequired = hasRequiredTalent(data, self.group[guid])

        if (data.enabled and isSpecRequired and isTalentRequired) then

            local spellName, _, spellIcon, _, _, _, _ = GetSpellInfo(data.spellID)
            
            if (spellName) then
                
                local index = self:FindCooldownIndex(guid, data.spellID);
                if (not index) then
                    index = (#self or 0) + 1

                    local spellCooldownMs, _ = GetSpellBaseCooldown(data.spellID)
                    local spellCooldown = (spellCooldownMs or 0) / 1000

                    local frame = self:Spawn(index, name, realm, class, spellName, spellIcon)
                    frame.sourceName = name
                    frame.class = class
                    frame.spellID = data.spellID
                    frame.spellName = spellName
                    frame.spellIcon = spellIcon
                    frame.cooldownMs = spellCooldownMs
                    frame.cooldownMs = spellCooldown
                    frame.guid = guid

                    self.CooldownReady(frame)

                    self[index] = frame
                else
                    T.Print("spell " .. data.spellID .. " already tracked.")
                end
            else
                T.Debug("spell " .. data.spellID .. " is invalid.")
            end
        end
    end
end

function RaidCooldown:InitializePlayer()
    if (not C.RaidCD.ShowPlayer) then return end
    self:SpawnMember(self.unit, true)
end

function RaidCooldown:InitializeGroup()
    local isInGroup, isInRaid, size = IsInGroup(), IsInRaid(), GetNumGroupMembers()

    for raidIndex = 1, size do
        local unit = self:FindUnit(raidIndex, size, isInGroup, isInRaid)
        self:SpawnMember(unit, false)
    end
end

function RaidCooldown:PLAYER_ENTERING_WORLD(isLogin, isReload)
    if (isLogin or isReload) then
        -- loading ui
    else
        -- zoned between map instances
    end

    -- step 1: check if player is in a group
    -- step 2: scan player talents
    -- step 3: spawn player bar if show player option is Texture
    -- step 4: get group size (party, raid or pvp)
    -- step 5: save group members
    -- step 6: spawn bars if spec/talent is required
    -- step 7: register events

    self:InitializePlayer()
    self:InitializeGroup()

    self:UpdatePositions()
    -- self:RegisterEvent("UNIT_SPELLCAST_SUCCEEDED")
    -- self:RegisterEvent("UNIT_SPELLCAST_FAILED")
    -- self:RegisterEvent("GROUP_ROSTER_UPDATE")
end

function RaidCooldown:GROUP_ROSTER_UPDATE()
    -- do nothing
    self:InitializeGroup()
end

function RaidCooldown:GROUP_JOINED(category, partyGUID)
    print("GROUP_JOINED", category, partyGUID)
end

function RaidCooldown:GROUP_LEFT(category, partyGUID)
    print("GROUP_LEFT", category, partyGUID)
end

local convertMsToS = function(value)
    return (value or 0) / 1000
end

-- if spell has cooldown modifier we need to update base cooldown time.
function RaidCooldown:PostUpdateCooldown(guid, spellID, cooldown)
    if (spellID == 1) then
        return convertMsToS(cooldown - 2000)
    end
    return convertMsToS(cooldown)
end

-- Initialize spell tracker timer when a spell is used by anybody from the group.
function RaidCooldown:UpdateCooldown(unit, spellID)
    local match = string.match(unit, "%a+")
    if (unit ~= "player" and match ~= "party" and match ~= "raid") then return end

    local guid = UnitGUID(unit)
    
    local index = self:FindCooldownIndex(guid, spellID)
    if (not index) then return end

    local name, _, icon, _, _, _, _ = GetSpellInfo(spellID)
    if (not name) then return end

    local cooldownMs, _ = GetSpellBaseCooldown(spellID)
    local cooldown = self:PostUpdateCooldown(guid, spellID, cooldownMs)

    local frame = self[index]
    frame.expiration = GetTime() + cooldown
    frame.cooldown = cooldown

    if (frame.Icon) then
        frame.Icon:SetTexture(icon)
    end

    if (frame.StatusBar) then
        frame.StatusBar:SetValue(100)
    end

    if (frame.Timer) then
        frame.Timer:SetText(T.FormatTime(cooldown))
    end

    frame:SetScript("OnUpdate", RaidCooldown.UpdateTimer)
end

-- castGUID = Cast-2-0-0-0-253087-0000000006
function RaidCooldown:UNIT_SPELLCAST_SUCCEEDED(unit, _, spellID)
    self:UpdateCooldown(unit, spellID)
end

function RaidCooldown:UNIT_SPELLCAST_FAILED(unit, _, spellID)
    self:UpdateCooldown(unit, spellID)
end

function RaidCooldown:INSPECT_READY(guid)
    self:ScanTalent(guid)
end

----------------------------------------------------------------
-- Commands
----------------------------------------------------------------
function RaidCooldown:TestGroup()
    local size = GetNumGroupMembers()
    print("group size:", size)
    for index = 1, size do
        local punit = "party" .. index
        local runit = "raid" .. index
        print(punit, UnitName(punit), UnitGUID(punit), runit, UnitName(runit), UnitGUID(runit))
        print(GetRaidRosterInfo(index))
        print("--------------------------------------------------")
    end
end

-- Player-3209-0A3DCDD6
SLASH_RAIDCD1 = "/raidcd"
SlashCmdList["RAIDCD"] = function(cmd)
    if (cmd == "group") then
        RaidCooldown:TestGroup()
    elseif (cmd == "test") then
        for guid, member in pairs(RaidCooldown.group) do
            if (member.talents) then
                for row in ipairs(member.talents) do
                    for col in ipairs(member.talents[row]) do
                        print(guid, member.name, member.realm, row, col, member.talents[row][col])
                    end
                end
            else
                print(guid, member.name, member.realm, "no talents found.")
            end
        end
    end
end

