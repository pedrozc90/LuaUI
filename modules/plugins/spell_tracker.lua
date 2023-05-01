local T, C, L = Tukui:unpack()

local IsInGroup, IsInRaid, IsInInstance = _G.IsInGroup, _G.IsInRaid, _G.IsInInstance
local UnitGUID, UnitName, UnitClass, UnitRace = _G.UnitGUID, _G.UnitName, _G.UnitClass, _G.UnitRace
local GetNumGroupMembers = _G.GetNumGroupMembers
local ClearInspectPlayer = _G.ClearInspectPlayer
local NotifyInspect = _G.NotifyInspect
local CanInspect = _G.CanInspect
local UnitIsConnected = _G.UnitIsConnected
local GetInspectSpecialization = _G.GetInspectSpecialization
local GetSpecializationInfoByID = _G.GetSpecializationInfoByID
local GetSpellInfo = _G.GetSpellInfo
local GetSpellBaseCooldown = _G.GetSpellBaseCooldown

----------------------------------------------------------------
-- SPELL TRACKER
----------------------------------------------------------------
if (not C.SpellTracker.Enable) then return end

-- local INSPECT_DELAY = 2
local INSPECT_INTERVAL = 1
-- local INSPECT_PAUSE_TIME = 2
local INSPECT_TIMEOUT = 180
local last_inspect = 0

local CombatlogEventTypes = {
    ["SPELL_CAST_SUCCESS"] = true,
    ["SPELL_CAST_FAILED"] = true
}

local SpellTable = {
    ["EVOKER"] = {},
    ["DRUID"] = {
        -- Balance
        [786750] = { enabled = true, specs = { 102 } },                         -- Solar Beam
        
        -- Guardian / Feral
        [106839] = { enabled = true, specs = { 103, 104 } }                     -- Skull Bash
    },
    ["DEATHKNIGHT"] = {
        [47528] = { enabled = true }                                            -- Mind Freeze
    },
    ["DEMONHUNTER"] = {
        [183752] = { enabled = true }                                           -- Disrupt
    },
    ["HUNTER"] = {
        [147362] = { enabled = true }                                           -- Counter Shot
    },
    ["MAGE"] = {
        [2139] = { enabled = true }                                             -- Counterspell
    },
    ["MONK"] = {
        [116705] = { enabled = true, isTalent = true }                          -- Spear Hand Strike
    },
    ["PALADIN"] = {
        [96231] = { enabled = true }                                            -- Rebuke (15 sec)
    },
    ["PRIEST"] = {
        -- Discipline
        [33206] = { enabled = true, specs = { 256 } },                          -- Pain Supression
        -- Shadow
        [15286] = { enabled = true, specs = { 258 }, isTalent = true },         -- Vampiric Embrace
        [15487] = { enabled = true, specs = { 258 }, isTalent = true }          -- Silence
    },
    ["ROGUE"] = {
        [1766] = { enabled = true }                                             -- Kick
    },
    ["SHAMAN"] = {
        [57994] = { enabled = true }                                            -- Wind Shear
    },
    ["WARLOCK"] = {
        [19647] = { enabled = true, isPet = true }                              -- SpellLock
    },
    ["WARRIOR"] = {
        [6552] = { enabled = true }                                             -- Pummel
    }
}

local SpellTracker = CreateFrame("Frame", "SpellTracker")
SpellTracker:RegisterEvent("PLAYER_LOGIN")
SpellTracker:RegisterEvent("PLAYER_ENTERING_WORLD")
SpellTracker:SetScript("OnEvent", function (self, event, ...)
    -- call one of the event handlers.
    if (not self[event]) then return end
    self[event](self, ...)
end)

function SpellTracker:PLAYER_LOGIN()
    self:SetPoint(unpack(C.SpellTracker.Anchor))
    self:SetSize(C.SpellTracker.BarWidth, C.SpellTracker.BarHeight)
    self.unit = "player"
    self.guid = UnitGUID(self.unit)
    self.class = select(2, UnitClass(self.unit))
    self.bars = {}
    self.group = {}
    self.inspect_queue = {}
end

function SpellTracker:PLAYER_ENTERING_WORLD(isInitialLogin, isReloadingUi)
    -- local inInstance, instanceType = IsInInstance()
    -- if (inInstance) then
    --     self:EnableInspect()
    -- else
    --     self:DisableInspect()
    -- end
    self:EnableInspect()

    if (isInitialLogin or isReloadingUi) then
        self:RegisterEvent("GROUP_ROSTER_UPDATE")
        self:RegisterEvent("PARTY_MEMBER_DISABLE")
        self:RegisterEvent("PARTY_MEMBER_ENABLE")
        self:RegisterEvent("UNIT_SPELLCAST_SUCCEEDED")
    end

    self:OnGroupMembersChanged()
end

----------------------------------------------------------------
-- INSPECT
----------------------------------------------------------------
local function SpellTracker_OnUpdate(self, elapsed)
    self.elapsed = (self.elapsed or 0) + elapsed
    if (self.elapsed > INSPECT_INTERVAL) then
        self:RequestInspect()
        self.elapsed = 0
    end
end

function SpellTracker:EnableInspect()
    self:RegisterEvent("INSPECT_READY")
    self:SetScript("OnUpdate", SpellTracker_OnUpdate)
end

function SpellTracker:DisableInspect()
    self:UnregisterEvent("INSPECT_READY")
    if (self:IsInspectEnabled()) then
        self:SetScript("OnUpdate", nil)
    end
    ClearInspectPlayer()
    last_inspect = 0
end

function SpellTracker:GetQueueIndex(guid)
    for index, data in ipairs(self.inspect_queue) do
        if (data.guid == guid) then
            return index
        end
    end
end

function SpellTracker:Enqueue(unit, guid)
    if (not unit or not guid) then return end
    table.insert(self.inspect_queue, { unit, guid })
end

function SpellTracker:Dequeue(guid)
    local index = self:GetQueueIndex(guid)
    if (index) then
        table.remove(self.inspect_queue, index)
    end
end

function SpellTracker:GetNextOnQueue()
    if (#self.inspect_queue > 0) then
        local row = table.remove(self.inspect_queue)
        if (row) then
            return unpack(row)
        end
    end
    return nil, nil
end

function SpellTracker:RequestInspect()
    local now = GetTime()
    if (now - last_inspect < INSPECT_TIMEOUT) then return end

    if InCombatLockdown() then return end -- never inspect while in combat.
    if UnitIsDead("player") then return end  -- you can't inspect while dead, so do not even try.
    if (InspectFrame and InspectFrame:IsShown()) then return end -- do not mess with UI's inspection.

    local unit, guid = self:GetNextOnQueue()

    if (unit) then
        if (CanInspect(unit) and UnitIsConnected(unit)) then
            NotifyInspect(unit)
            last_inspect = now
        else
            print("Unit " .. unit .. " can not be inspected.")
            -- last_inspect = 0
        end
    end

    last_inspect = 0

    if (#self.inspect_queue == 0) then
        self:DisableInspect()
    end
end

function SpellTracker:IsInspectEnabled()
    return (self:GetScript("OnUpdate") ~= nil)
end

function SpellTracker:INSPECT_READY(guid)
    local now = GetTime()

    local m = self.group[guid]
    if m then
        local unit = m.unit

        if (m.talents) then
            wipe(m.talents)
        end

        local specID = GetInspectSpecialization(unit)
        local _, specName, specDescription, specIcon, role, _, _ = GetSpecializationInfoByID(specID)

        m.last_inspect = now
        m.inspected = true
        m.specID = specID
        m.role = role
        m.talents = self:GetTalents(unit, guid)

        self:Spawn(m)
    end

    ClearInspectPlayer()

    if (#self.inspect_queue == 0) then
        self:DisableInspect()
    end

    -- last_inspect = now
end

----------------------------------------------------------------
-- TALENTS
----------------------------------------------------------------
local GetNumTalents = _G.GetNumTalents
local GetNumTalentTabs = _G.GetNumTalentTabs
local GetActiveSpecGroup = _G.GetActiveSpecGroup

local function GetTalentsClassic(self, unit, guid)
    -- reference: https://wowpedia.fandom.com/wiki/API_GetTalentInfo/Classic
    local talents = {}

    local isInspect = (unit ~= "player")
    local ntabs = GetNumberTalentTabs()
    for tabIndex = 1, tabs do
        local ntalents = GetNumTalents(tabIndex)
        for talentIndex = 1, ntalents do
            local name, iconTexture, tier, column, rank, maxRank, isExceptional, available = GetTalentInfo(tabIndex, talentIndex, isInspect)
            -- talents[talentID] = {
            --     tier = tier,
            --     column = column,
            --     name = talentName,
            --     selected = selected,
            --     available = available,
            --     spellID = spellID,
            --     unknown = unknown,
            --     known = known
            -- }
        end
    end

    return talents
end

local function GetTalentsWrath(self, unit, guid)
    -- reference: https://wowpedia.fandom.com/wiki/API_GetTalentInfo/Wrath
    local talents = {}

    local isInspect = (unit ~= "player")
    local isPet = (unit)
    local groupIndex = GetActiveSpecGroup(isInspect)

    local ntabs = GetNumberTalentTabs()
    for tabIndex = 1, tabs do
        local ntalents = GetNumTalents(tabIndex)
        for talentIndex = 1, ntalents do
            local name, iconTexture, tier, column, rank, maxRank, isExceptional, available, previewRank, previewAvailable = GetTalentInfo(tabIndex, talentIndex, isInspect, isPet, groupIndex)
            print(unit, tabIndex, talentIndex, groupIndex, name, tier, column)
            -- talents[talentID] = {
            --     tier = tier,
            --     column = column,
            --     name = talentName,
            --     selected = selected,
            --     available = available,
            --     spellID = spellID,
            --     unknown = unknown,
            --     known = known
            -- }
        end
    end

    return talents
end

local function GetTalentsUnknown(self, unit, guid)
    local talents = {}

    for tier = 1, MAX_TALENT_TIERS do
        for column = 1, NUM_TALENT_COLUMNS do
            local talentID, talentName, _, selected, available, spellID, unknown, _, _, known, _ = GetTalentInfo(tier, column, activeSpec, isInspect, unit)
            talents[talentID] = {
                tier = tier,
                column = column,
                name = talentName,
                selected = selected,
                available = available,
                spellID = spellID,
                unknown = unknown,
                known = known
            }
        end
    end

    return talents
end

local function GetTalentsRetail(self, unit, guid)
    local talents = {}

    local configID = (guid == self.guid) and C_ClassTalents.GetActiveConfigID() or -1

    local configInfo = C_Traits.GetConfigInfo(configID)
    for _, treeID in ipairs(configInfo.treeIDs) do
        local nodeIDs = C_Traits.GetTreeNodes(treeID)
        for _, nodeID in ipairs(nodeIDs) do
            local nodeInfo = C_Traits.GetNodeInfo(configID, nodeID)
            if (nodeInfo) then
                local activeEntry = nodeInfo.activeEntry
                local activeRank = nodeInfo.activeRank
                if (activeEntry and activeRank > 0) then
                    local entryInfo = C_Traits.GetEntryInfo(configID, activeEntry.entryID)
                    if (entryInfo) then
                        local definitionInfo = C_Traits.GetDefinitionInfo(entryInfo.definitionID)
                        if (definitionInfo) then
                            talents[definitionInfo.spellID] = true
                        end
                    end
                end
            end
        end
    end

    return talents
end

SpellTracker.GetTalents = (
    (T.Retail and GetTalentsRetail)
    or (T.Classic and GetTalentsClassic)
    or (T.WotLK and GetTalentsWrath)
    or GetTalentsUnknown
)

function SpellTracker:UNIT_SPELLCAST_SUCCEEDED(unit, _, spellID)
    local guid = UnitGUID(unit)
    
    -- if a group member changes specialization, we need to inspect it again
    -- 200749 = 'Activating Specialization'
    -- 384255 = 'Changing Talents'
    if (spellID == 200749 or spellID == 384255 and self.group[guid]) then
        self:Enqueue(unit, guid)
    end
end

----------------------------------------------------------------
-- GROUP
----------------------------------------------------------------
function SpellTracker:GetGroupUnit(index)
    if (index and index > 0) then
        if (self.is_raid) then
            -- raid1 ... raidN
            -- raid index is between 1 and MAX_RAID_MEMBERS, including player
            return "raid" .. index
        elseif (self.is_party and (index < self.group_size)) then
            -- party1 ... partyN
            -- party index is between 1 and 4, excluding player
            return "party" .. index
        end
    end
    return nil
end

local cache = {}

function SpellTracker:OnGroupMembersChanged()
    self.is_party = IsInGroup()
    self.is_raid = IsInRaid()
    self.group_size = GetNumGroupMembers() or 1
    
    self.group_size = (self.group_size ~= 0) and self.group_size or 1
    -- look for new group members
    for index = 1, self.group_size do
        local unit = self:GetGroupUnit(index) or "player"
        if (unit) then
            local guid = UnitGUID(unit)     
            if (guid) then
                cache[guid] = unit
                if (not self.group[guid]) then
                    -- insert member into the group
                    self:AddGroupMember(index, unit, guid)
                    -- insert unit to inspect queue
                    self:Enqueue(unit, guid)
                else
                    -- update member informations
                    self.group[guid].position = index
                    self.group[guid].unit = unit
                end
            end
        end
    end

    -- look for members who left
    for guid, _ in pairs(self.group) do
        if (not cache[guid]) then
            self:RemoveGroupMember(guid)
        end
    end

    wipe(cache)
end

function SpellTracker:AddGroupMember(position, unit, guid)
    local _, class, _, race, sex, name, realm = GetPlayerInfoByGUID(guid)

    -- if (not race or string.len(race) == 0) then race = UnitRace(unit) end
    -- if (not name or string.len(name) == 0) then name = UnitName(unit) end
    -- if (not realm or string.len(realm) == 0) then realm = GetRealmName() end
    -- if (not class or string.len(class) == 0) then class = select(2, UnitClass(unit)) end

    print("ADD MEMBER", unit, guid, name, class, race, sex, realm)
    if (not class) then
        print("unable to define " .. unit .. " class.")
        return
    end

    self.group[guid] = {
        position = position,
        unit = unit,
        guid = guid,
        class = class,
        race = race,
        name = name,
        realm = realm,
        player = (guid == self.guid),
        last_inspect = -1    -- unit not inspected yet
    }
end

function SpellTracker:RemoveBar(bar)
    if (not bar) then return end

    bar:UnregisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
    bar:SetScript("OnEvent", nil)
    bar:SetScript("OnUpdate", nil)
    bar:Hide()
    bar = nil
end

function SpellTracker:RemoveGroupMember(guid)
    self:Dequeue(guid)
    if (self.group[guid]) then
        self.group[guid] = nil
    end

    local size = #self.bars
    for i = size, 1, -1 do
        if (self.bars[i].guid == guid) then
            local bar = table.remove(self.bars, i)
            self:RemoveBar(bar)
        end
    end

    self:UpdateBarPositions()
end

function SpellTracker:GROUP_ROSTER_UPDATE()
    self:OnGroupMembersChanged()
end

function SpellTracker:PARTY_MEMBER_ENABLE(unit)
    local guid = UnitGUID(unit)
    local member = self.group[guid]
    if (member and not member.inspected) then
        self:Enqueue(unit, guid)
    end

    if (#self.inspect_queue > 0 and not self:IsInspectEnabled()) then
        self:EnableInspect()
    end
end

----------------------------------------------------------------
-- FRAMES
----------------------------------------------------------------
function UpdateTimer(self, elapsed)
    self.time_left = (self.time_left or (self.expiration - GetTime())) - elapsed
    if (self.time_left > 0) then
        if (self.StatusBar) then
            local percentage = ceil((100 * self.time_left) / self.cooldown)
            self.StatusBar:SetValue(percentage)
        end

        if (self.Timer) then
            self.Timer:SetText(T.FormatTime(self.time_left))
        end
    else
        self:SetScript("OnUpdate", nil)
        self.time_left = nil

        if (self.StatusBar) then
            self.StatusBar:SetValue(100)
        end

        if (self.Timer) then
            self.Timer:SetText("Ready")
        end
    end
end

local function isSpecRequired(spell, specID)
    if (not spell.specs) then return true end
    for _, v in ipairs(spell.specs) do
        if (v == specID) then
            return true
        end
    end
    return false
end

function SpellTracker:GetBarIndex(guid, spellID)
    for index, bar in ipairs(self.bars) do
        if (bar.guid == guid and bar.spellID == spellID) then
            return index
        end
    end
    return nil
end

function SpellTracker:UpdateBarPositions()
    for index, bar in ipairs(self.bars) do
        bar:ClearAllPoints()
        if (index == 1) then
            bar:SetPoint("TOPLEFT", self, "TOPLEFT", 0, 0)
        else
            local prev = self.bars[index - 1]
            bar:SetPoint("TOP", prev, "BOTTOM", 0, -Spacing)
        end
    end
end

function SpellTracker:SpawnBar(index, unit, spellID)
    local Width, Height, Spacing = C.SpellTracker.BarWidth, C.SpellTracker.BarHeight, C.SpellTracker.BarSpacing
    local Texture = C.Medias.Blank
    local FontName, FontSize, FontStyle = C.Medias.Font, 10, ""

    local Name = self:GetName() .. string.upper(unit) .. spellID
    local Bar = CreateFrame("Frame", Name, self)
    Bar:SetSize(Width, Height)
    Bar:SetFrameStrata(self:GetFrameStrata())
    Bar:SetFrameLevel(self:GetFrameLevel() + 1)
    Bar:CreateBackdrop()

    local StatusBar = CreateFrame("StatusBar", Bar:GetName() .. "StatusBar", Bar)
    StatusBar:SetInside(Bar)
    StatusBar:SetFrameStrata(StatusBar:GetFrameStrata())
    StatusBar:SetFrameLevel(StatusBar:GetFrameLevel() + 1)
    StatusBar:SetStatusBarTexture(Texture)
    StatusBar:SetStatusBarColor(1, 1, 1, 1)
    StatusBar:SetMinMaxValues(0, 100)
    StatusBar:SetValue(100)

    StatusBar.Background = StatusBar:CreateTexture(nil, "BORDER")
    StatusBar.Background:SetAllPoints(StatusBar)
    StatusBar.Background:SetTexture(Texture)
    StatusBar.Background:SetVertexColor(0.15, 0.15, 0.15)

    local Button = CreateFrame("Button", Bar:GetName() .. "Button", Bar)
    Button:SetPoint("RIGHT", StatusBar, "LEFT", -Spacing, 0)
    Button:SetSize(Height, Height)
    Button:CreateBackdrop()

    local Icon = Button:CreateTexture(nil, "ARTWORK")
    Icon:SetInside(Button)
	Icon:SetTexCoord(unpack(T.IconCoord))
    -- Icon:SetTexture(spellIcon)

    local Text = StatusBar:CreateFontString(nil, "OVERLAY")
    -- Text:SetFontObject(Font)
    Text:SetFontTemplate(FontName, FontSize, FontStyle)
    Text:SetPoint("LEFT", StatusBar, "LEFT", 5, 0)
    Text:SetTextColor(0.84, 0.75, 0.65)
    Text:SetWidth(0.8 * Width)
    Text:SetJustifyH("LEFT")
    -- Text:SetText(spellName .. ": " .. name)

    local Timer = StatusBar:CreateFontString(nil, "OVERLAY")
    -- Timer:SetFontObject(Font)
    Timer:SetFontTemplate(FontName, FontSize, FontStyle)
    Timer:SetPoint("RIGHT", StatusBar, "RIGHT", -5, 0)
    Timer:SetTextColor(0.84, 0.75, 0.65)
    Timer:SetJustifyH("RIGHT")
    -- Timer:SetText("Ready")

    Bar:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
    Bar:SetScript("OnEvent", function (self, event, ...)
        if (event == "COMBAT_LOG_EVENT_UNFILTERED") then
            local _, eventType, _, sourceGUID, _, _, _, _, _, _, _ = CombatLogGetCurrentEventInfo()
            if (CombatlogEventTypes[eventType]) then
                local spellID, spellName, _ = select(12, CombatLogGetCurrentEventInfo())
                if (sourceGUID == self.guid and spellID == self.spellID) then
                    self.expiration = (GetTime() + self.cooldown)
                    self:SetScript("OnUpdate", UpdateTimer)
                end
            end
        end
    end)

    Bar.StatusBar = StatusBar
    Bar.Button = Button
    Bar.Icon = Icon
    Bar.Text = Text
    Bar.Timer = Timer

    return Bar
end

function SpellTracker:UpdateCooldown(talents, spellID, cooldown)
    if (talents) then
        -- PRIEST: Silence
        if (spellID == 15487) then
            -- Last Word: Reduces the cooldown of Silence by 15s.
            if (talents[263716]) then
                return cooldown - 15
            end
        -- DRUID: Solar Beam
        elseif (spellID == 78675) then
            -- Last Word: Reduces the cooldown of Silence by 15s.
            if (talents[202918]) then
                return cooldown - 15
            end
        end
    end
    return cooldown
end

function SpellTracker:UpdateBarInfo(bar, guid, name, class, spellID, spellName, spellIcon, cooldownMS)
    bar.guid = guid
    bar.spellID = spellID
    bar.spellName = spellName
    bar.cooldownMS = cooldownMS or 0

    local cooldown = (bar.cooldownMS / 1000)
    bar.cooldown = self:UpdateCooldown(self.group[guid].talents, spellID, cooldown)
    
    local color = RAID_CLASS_COLORS[class]
    
    if (bar.StatusBar) then
        bar.StatusBar:SetStatusBarColor(color.r, color.g, color.b, 1)
        -- bar.StatusBar:SetMinMaxValues(0, bar.cooldown)
    end

    if (bar.Icon) then
        bar.Icon:SetTexture(spellIcon)
    end

    if (bar.Text) then
        bar.Text:SetText(spellName .. ": " .. name)
    end

    if (bar.Timer) then
        bar.Timer:SetText("Ready")
    end
end

function SpellTracker:Spawn(m)
    local spells = SpellTable[m.class]
    if (not spells) then return end

    for spellID, spell in pairs(spells) do
        if (spell.enabled) then
            local valid = isSpecRequired(spell, m.specID)

            local spellName, spellRank, spellIcon, _, _, _, _, originalIcon = GetSpellInfo(spellID)
            local cooldownMS, gcdMS = GetSpellBaseCooldown(spellID)
            
            local index = self:GetBarIndex(m.guid, spellID)
            if (not index and valid) then
                index = (#self.bars + 1)
                local bar = self:SpawnBar(index, m.unit, spellID)
                
                bar:SetPoint("TOPLEFT", self, "TOPLEFT", 0, 0)
                bar:Show()

                self:UpdateBarInfo(bar, m.guid, m.name, m.class, spellID, spellName, spellIcon, cooldownMS)
                table.insert(self.bars, bar)
            elseif (index) then
                local bar = self.bars[index]
                bar.hide = (not valid)
                self:UpdateBarInfo(bar, m.guid, m.name, m.class, spellID, spellName, spellIcon, cooldownMS)
            end

            table.sort(self.bars, function(v, u)
                if (v.guid == u.guid) then
                    return v.spellID < u.spellID
                end
                v_pos = self.group[v.guid].position or 1000
                u_pos = self.group[u.guid].position or 999
                return v_pos < u_pos
            end)

            self:UpdateBarPositions()
        end
    end
end
