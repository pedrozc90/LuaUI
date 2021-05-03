local T, C, L = Tukui:unpack()

-- if (true) then return end

local UnitName, UnitClass, UnitGUID = UnitName, UnitClass, UnitGUID
local GetTime = GetTime
local IsInInstance, IsInGroup, IsInRaid = IsInInstance, IsInGroup, IsInRaid
local GetNumGroupMembers = GetNumGroupMembers
local GetSpellInfo, GetSpellCooldown, GetSpellBaseCooldown = GetSpellInfo, GetSpellCooldown, GetSpellBaseCooldown
local IsGUIDInGroup = IsGUIDInGroup
local GetRaidRosterInfo = GetRaidRosterInfo
local GetPlayerInfoByGUID = GetPlayerInfoByGUID
local GetSpecialization, GetSpecializationInfo = GetSpecialization, GetSpecializationInfo
local GetInspectSpecialization, GetSpecializationInfoForSpecID = GetInspectSpecialization, GetSpecializationInfoForSpecID

----------------------------------------------------------------
-- Interrupt Cooldowns
----------------------------------------------------------------
local MyGUID = UnitGUID("player")

local Events = {
    ["SPELL_CAST_SUCCESS"] = true,
    ["SPELL_CAST_FAILED"] = true,
    ["SPELL_INTERRUPT"] = false,
    ["SPELL_RESURRECT"] = true
}

local SpellTable = {
    ["DRUID"] = {
        { spellID = 78675, type = "interrupt", specs = { [102] = true }, enabled = true },                  -- Solar Beam
        { spellID = 106839, type = "interrupt", specs = { [103] = true, [102] = true }, enabled = true }    -- Skull Bash
    },
    ["DEATHKNIGHT"] = {
        { spellID = 475228, type = "interrupt", enabled = true }                                            -- Mind Freeze
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
        { spellID = 120954, type = "defense", specs = { [268] = true }, enabled = true },                   -- Fortigying Brew
        { spellID = 122278, type = "defense", specs = { [268] = true }, enabled = true },                   -- Dampen Harm
        { spellID = 116849, type = "raid", specs = { [270] = true }, enabled = true },                      -- Life Cocoon
    },
    ["SHAMAN"] = {
        { spellID = 57994, type = "interrupt", enabled = true }                                             -- Wind Shear
    },
    ["WARLOCK"] = {
        { spellID = 20707 , type = "raid", enabled = true }                                                 -- Soulstone
    },
    ["WARRIOR"] = {
        { spellID = 6552 , type = "interrupt", enabled = true },                                            -- Pummel
        { spellID = 97462, type = "raid", enabled = true }                                                  -- Rallying Cry
    }
}

local RaidCooldown = CreateFrame("Frame", "RaidCooldowns", UIParent)

function RaidCooldown.UpdateTimer(self, elapsed)
    self.time_left = (self.time_left or (self.expiration - GetTime())) - elapsed

    if (self.time_left > 0) then
        if (self.StatusBar) then
            self.StatusBar:SetValue(self.time_left)
        end

        if (self.StatusBar.Time) then
            self.StatusBar.Time:SetText(T.FormatTime(self.time_left))
        end
    else
        self.time_left = nil
        self.expiration = nil
        self.start = nil

        if (self.StatusBar) then
            self.StatusBar:SetValue(self.cooldown)
        end

        if (self.StatusBar.Time) then
            self.StatusBar.Time:SetText("Ready")
        end

        self:SetScript("OnUpdate", nil)
    end
    
end

local IsInMyGroup = function(guid)
    if ((not guid) or (not RaidCooldown.members)) then return false end
    return (RaidCooldown.members[guid] ~= nil)
end

function RaidCooldown:UpdatePosition()
    for index = 1, #self do
        if (index == 1) then
            self[index]:SetPoint("TOPLEFT", self, "TOPLEFT", 0, 0)
        else
            self[index]:SetPoint("TOP", self[index - 1], "BOTTOM", 0, -self.Spacing)
        end
    end
end

function RaidCooldown:SpawnStatusBar(frame)
    
    local Height = frame:GetHeight()
    local Width = frame:GetWidth() - Height - self.Spacing
    local Texture = C.Medias.Blank
    local Font = T.GetFont(C.UnitFrames.Font)
    local Color = RAID_CLASS_COLORS[frame.class or T.MyClass]

    local StatusBar = CreateFrame("StatusBar", frame:GetName() .. "StatusBar", frame)
    StatusBar:SetPoint("TOPRIGHT", frame, "TOPRIGHT", 0, 0)
    StatusBar:SetSize(Width, Height)
    StatusBar:SetFrameStrata(self:GetFrameStrata())
    StatusBar:SetStatusBarTexture(Texture)
    StatusBar:SetStatusBarColor(Color.r, Color.g, Color.b)
    StatusBar:SetFrameLevel(6)
    StatusBar:CreateBackdrop()
    StatusBar.Backdrop:SetOutside()

    StatusBar:SetMinMaxValues(0, frame.cooldown)
    StatusBar:SetValue(frame.cooldown)

    StatusBar.Background = StatusBar:CreateTexture(nil, "BORDER")
    StatusBar.Background:SetAllPoints(StatusBar)
    StatusBar.Background:SetTexture(Texture)
    StatusBar.Background:SetVertexColor(0.15, 0.15, 0.15)

    StatusBar.Time = StatusBar:CreateFontString(nil, "OVERLAY")
    StatusBar.Time:SetFontObject(Font)
    StatusBar.Time:SetPoint("RIGHT", StatusBar, "RIGHT", -4, 0)
    StatusBar.Time:SetTextColor(0.84, 0.75, 0.65)
    StatusBar.Time:SetJustifyH("RIGHT")
    StatusBar.Time:SetText("Ready")

    StatusBar.Text = StatusBar:CreateFontString(nil, "OVERLAY")
    StatusBar.Text:SetFontObject(Font)
    StatusBar.Text:SetPoint("LEFT", StatusBar, "LEFT", 4, 0)
    StatusBar.Text:SetTextColor(0.84, 0.75, 0.65)
    StatusBar.Text:SetWidth(166)
    StatusBar.Text:SetJustifyH("LEFT")
    StatusBar.Text:SetText(frame.sourceName .. ": " .. frame.spellName)

    StatusBar.Button = CreateFrame("Frame", nil, StatusBar)
    StatusBar.Button:SetPoint("RIGHT", StatusBar, "LEFT", 0, 0)
    StatusBar.Button:SetSize(Height, Height)
    StatusBar.Button:CreateBackdrop()
    StatusBar.Button.Backdrop:SetOutside()

    StatusBar.Icon = StatusBar.Button:CreateTexture(nil, "ARTWORK")
    StatusBar.Icon:SetInside()
    StatusBar.Icon:SetTexCoord(unpack(T.IconCoord))
    StatusBar.Icon:SetTexture(frame.spellIcon)

    frame.StatusBar = StatusBar
end

function RaidCooldown:Spawn(index, sourceName, class, spellID, spellName, spellIcon, cooldown)
    print("Spawn", index, sourceName, class, spellID, spellName, spellIcon, cooldown)

    local frame = CreateFrame("Frame", self:GetName() .. index, self)
    frame:SetSize(self:GetWidth(), self.IconSize)
    -- frame:CreateBackdrop()
    frame.index = index
    frame.sourceName = sourceName
    frame.class = class
    frame.spellID = spellID
    frame.spellName = spellName
    frame.spellIcon = spellIcon
    frame.cooldown = cooldown

    self:SpawnStatusBar(frame)

    self[index] = frame
end

function RaidCooldown:FindCooldown(name, spellID)
    for i, t in ipairs(self) do
        if (t.sourceName == name and t.spellID == spellID) then
            return t.index
        end
    end
    return 0
end

function RaidCooldown:GetUnit(index)
    if (IsInRaid() and index) then
        return "raid" .. index
    elseif (IsInGroup() and index) then
        return "party" .. index
    end
    return nil
end

function RaidCooldown:Init(spellID, name, realm, class)
    local spellName, _, spellIcon, _, _, _, _ = GetSpellInfo(spellID)
    local spellCooldownMs, _ = GetSpellBaseCooldown(spellID)
    local spellCooldown = (spellCooldownMs or 0) / 1000

    if (not spellCooldownMs) then
        print(spellID, spellName, name, realm, class)
    end

    local index = self:FindCooldown(name, realm, spellID)
    
    if (index == 0) then
        index = #self + 1

        self:Spawn(index, name, class, spellID, spellName, spellIcon, spellCooldown)
    end
end

function RaidCooldown:SpawnCooldowns(name, realm, class, specID)
        if (specID == 0) then return end
        
        local specName = select(2, GetSpecializationInfoForSpecID(specID))

        print("group member:", name, realm, class, specID, specName, #SpellTable[class])

        -- if (SpellTable[class]) then return end

        for _, v in pairs(SpellTable[class]) do
            if (v.enabled and ((v.specs == nil) or v.specs[specID])) then
                self:Init(v.spellID, name, realm, class)
            end
        end

        -- for index, spell in ipairs(SpellTable[class]) do
        --     -- if (spell.enabled and (not spell.specs or spell.specs[specID])) then
        --         print(index, spell.spellID, spell.specs)
        --         -- self:Init(spell.spellID, name, realm, class)
        --     -- end
        -- end
        -- self:UpdatePosition()
end

function RaidCooldown:InitMember(unit, guid)
    local _, class, _, _, _, name, realm = GetPlayerInfoByGUID(guid)
    if ((not realm) or (string.len(realm) == 0)) then
        realm = GetRealmName()
    end

    print("InitMember", unit, name, realm, class, guid)

    if (not self.members[guid]) then
        self.members[guid] = {}
    end

    self.members[guid].name = name
    self.members[guid].realm = realm
    self.members[guid].class = class
    self.members[guid].unit = unit

    if (guid == MyGUID) then
        local spec = GetSpecialization()
        local specID = GetSpecializationInfo(spec)

        self.members[guid].specID = specID

        self:SpawnCooldowns(name, realm, class, specID)
    else
        NotifyInspect(unit)
        self:RegisterEvent("INSPECT_READY")
    end
end

function RaidCooldown:UpdateGroups()

    local size = GetNumGroupMembers()

    for index = 1, size do
        
        local unit = self:GetUnit(index)
        
        local guid = (select(1, GetRaidRosterInfo(index))) and UnitGUID(unit) or UnitGUID("player")
        
        self:InitMember(unit, guid)

        -- local _, class, _, _, _, name, realm = GetPlayerInfoByGUID(guid)
        -- if ((not realm) or (string.len(realm) == 0)) then
        --     realm = GetRealmName()
        -- end

        -- print(index, unit, name, realm, class, guid)

        -- if (not self.members[guid]) then
        --     self.members[guid] = {}
        -- end

        -- self.members[guid].name = name
        -- self.members[guid].realm = realm
        -- self.members[guid].class = class
        -- self.members[guid].unit = unit

        -- if ((guid ~= MyGUID) and (not self.members[guid].inspected)) then
        --     print("inspecting", name)
        --     NotifyInspect(unit)
        --     self:RegisterEvent("INSPECT_READY")
        -- else
        -- --     print("player already inspected")
        --     self:Init(spellID, name, realm, class)
        -- end
    end

    for index, data in pairs(self.members) do
        for k, v in pairs(data) do
            print(k, v)
        end
        print(" -------- ")
    end

end

----------------------------------------------------------------
-- Events
----------------------------------------------------------------

function RaidCooldown:PLAYER_LOGIN()
    self:SetPoint("TOPLEFT", UIParent, "TOPLEFT", 100, -100)
    self:SetSize(255, 24)
    -- self:SetScale(C.General.UIScale)
    -- self:CreateBackdrop()
    self.IconSize = 24
    self.Spacing = 3
    self.members = {}
end

function RaidCooldown:PLAYER_ENTERING_WORLD()
    if (IsInGroup() or IsInRaid()) then
        self:UpdateGroups()
        self:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
    else
        self:UnregisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
    end
end

function RaidCooldown:GROUP_ROSTER_UPDATE(...)
    self:UpdateGroups()
    self:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
end

function RaidCooldown:GROUP_LEFT(...)
    self:UnregisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
end

function RaidCooldown:COMBAT_LOG_EVENT_UNFILTERED()
    local timestamp, eventType, hideCaster, sourceGUID, sourceName, sourceFlags, sourceRaidFlags, destGUID, destName, destFlags, destRaidFlags = CombatLogGetCurrentEventInfo()

    if ((not Events[eventType]) or IsInMyGroup(sourceGUID)) then return end

    local spellID, spellName, spellSchool, extraSpellID, extraSpellName, extraSchool = select(12, CombatLogGetCurrentEventInfo())

    local index = self:FindCooldown(sourceName, spellID)

    if (index > 0) then
        local start = GetTime()

        self[index].start = start
        self[index].expiration = start + self[index].cooldown

        print(timestamp, eventType, sourceName, spellName, spellID, index, self[index].start, self[index].expiration, self[index].cooldown)

        self[index]:SetScript("OnUpdate", RaidCooldown.UpdateTimer)
    end
end

function RaidCooldown:PLAYER_SPECIALIZATION_CHANGED(unit)
    local guid = UnitGUID(unit)
    if (self.members[guid]) then
        print("TALENT CHANGE", unit, guid)
    end
end

function RaidCooldown:INSPECT_READY(guid)
    local _, class, _, _, _, name, realm = GetPlayerInfoByGUID(guid)

    print("INSPECT", class, name, realm, guid)

    if (not self.members[guid]) then return end

    local member = self.members[guid]

    print(unpack(member))

    if (member.name == name and member.class == class) then
        local specID = GetInspectSpecialization(member.unit)

        if (specID > 0) then
            local x, specName, _, _, role, _ = GetSpecializationInfoForSpecID(specID)

            member.specID = specID
            member.specName = specName
            member.role = role

            print("group member:", name, realm, guid, x, specID, specName)

            local ClassSpellTable = SpellTable[class]
            if (not ClassSpellTable) then return end

            for _, spell in pairs(ClassSpellTable) do
                if (spell.enabled and (not spell.specs or spell.specs[specID])) then
                    self:Init(spell.spellID, name, realm, class)
                end
            end
            self:UpdatePosition()
        else
            print("group member is too far to inspect")
        end
    end

    self.members[guid].inspected = true
end

RaidCooldown:RegisterEvent("PLAYER_LOGIN")
RaidCooldown:RegisterEvent("PLAYER_ENTERING_WORLD")
RaidCooldown:RegisterEvent("PLAYER_SPECIALIZATION_CHANGED")
RaidCooldown:RegisterEvent("GROUP_ROSTER_UPDATE")
RaidCooldown:RegisterEvent("GROUP_LEFT")
RaidCooldown:SetScript("OnEvent", function(self, event, ...)
    if (event ~= "COMBAT_LOG_EVENT_UNFILTERED") then print(event, ...) end
    -- call one of the event handlers.
    self[event](self, ...)
end)

SLASH_RAIDCD1 = "/raidcd"
SlashCmdList["RAIDCD"] = function(cmd)
    if (cmd == "update") then
        RaidCooldown:UpdateGroups()
    elseif (cmd == "test") then

        local size = GetNumGroupMembers()
        local unitType = RaidCooldown:FindUnitType()
        
        for index = 1, size do
            local unit = (unitType == "party" or unitType == "raid") and (unitType .. index) or unitType
            local name_realm, _, _, _, _, class, _, _, _, _, _, _ = GetRaidRosterInfo(index)
            local name, realm = strsplit("-", name_realm)
            local spec_id = (unit == "player") and GetSpecialization() or GetInspectSpecialization(unit)
            
            print(index, unit, name_realm, class, name, realm, UnitGUID(unit), spec_id, GetSpecialization())
            print('--------------------------------------------------')
        end
    elseif (cmd == "inspect") then
        for k, v in pairs(RaidCooldown.members) do
            -- print(k, v.name, v.realm, v.unit)
            NotifyInspect(v.unit)
            RaidCooldown:RegisterEvent("INSPECT_READY")
        end
    end
end
