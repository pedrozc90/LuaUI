local T, C, L = Tukui:unpack()

local _, ns = ...
local RaidCooldowns = ns.RaidCooldowns
local SpellTable = ns.RaidCooldowns.SpellTable

-- WoW API
local UnitGUID = _G.UnitGUID
local UnitClass = _G.UnitClass
local UnitIsUnit = _G.UnitIsUnit

local IsInGroup = _G.IsInGroup
local IsInRaid = _G.IsInRaid
local GetNumGroupMembers = _G.GetNumGroupMembers

local GetPlayerInfoByGUID = _G.GetPlayerInfoByGUID
local GetSpecialization = _G.GetSpecialization
local GetSpecializationInfo = _G.GetSpecializationInfo
local GetInspectSpecialization = _G.GetInspectSpecialization
local GetSpecializationInfoByID = _G.GetSpecializationInfoByID
local GetActiveSpecGroup = _G.GetActiveSpecGroup
local GetTalentInfo = _G.GetTalentInfo
local GetSpellInfo = _G.GetSpellInfo
local GetSpellBaseCooldown = _G.GetSpellBaseCooldown

----------------------------------------------------------------
-- Raid Cooldowns
----------------------------------------------------------------
if (not C.RaidCD.Enable) then return end

local cache = {}
function RaidCooldowns:ScanGroup()
    local isGrupo, isRaid = IsInGroup(), IsInRaid()
    local size = GetNumGroupMembers()

    -- look for new group members
    for index = 1, size do
        local unit = self:GetGroupUnit(index, size, isGrupo, isRaid)

        local guid = UnitGUID(unit)
        if (guid) then
            cache[guid] = true
            if (not self.group[guid]) then
                self.group[guid] = { unit = unit }
                self:Queue(unit, guid)
            else
                self.group[guid].unit = unit
                local elapsed = GetTime() - (self.group[guid].last_inspect or 0)
                if (elapsed > 300) then
                    self:Queue(unit, guid)
                end
            end
        end
    end

    -- look for members who left
    for guid, _ in pairs(self.group) do
        if (not cache[guid]) then
            self:DequeueByGUID(guid)
            
            self.group[guid] = nil

            for index = #self.bars, 1, -1 do
                if (self.bars[index].guid == guid) then
                    local bar = table.remove(self.bars, index)
                    -- table.insert(self.useless, #self.useless + 1, bar)
                end
            end
        end
    end

    table.wipe(cache)
end

local HasRequiredSpec = function(data, spec_id)
    -- if (not data.specs) then return true end
    -- if (not spec_id) then return false end
    -- return data.specs[spec_id] or false
    return (not data.specs) or (spec_id and data.specs[spec_id]) or false
end

local HasRequiredTalent = function(data, talents)
    if (not data.talentID) then return true end
    if (not talents) then return false end
    local talent = talents[data.talentID]
    return (talent and talent.selected)
end

function RaidCooldowns:FindCooldownIndex(guid, spellID)
    for index, f in ipairs(self.bars) do
        if (f.guid == guid and f.spellID == spellID) then
            return index
        end
    end
    return nil
end

function RaidCooldowns:UpdatePositions()
    local Spacing = C.RaidCD.BarSpacing
    local Height = C.RaidCD.BarHeight

    -- table.sort(self, function(a, b)
    --     if (a.class == b.class) then
    --         return a.cooldown > b.cooldown
    --     end
    --     return a.class < b.class
    -- end)

    for index, bar in ipairs(self.bars) do
        bar:ClearAllPoints()
        if (index == 1) then
            bar:SetPoint("TOPLEFT", self, "TOPLEFT", 0, 0)
        else
            local previous = self.bars[index - 1]
            bar:SetPoint("TOP", previous, "BOTTOM", 0, -Spacing)
        end
    end

    for index, bar in ipairs(self.useless) do
        bar:ClearAllPoints()
        if (index == 1) then
            bar:SetPoint("TOPLEFT", self, "TOPRIGHT", Height + (2 * Spacing), 0)
        else
            local previous = self.useless[index - 1]
            bar:SetPoint("TOP", previous, "BOTTOM", 0, -Spacing)
        end
    end
end

function RaidCooldowns:Spawn(guid)
    local member = self.group[guid]
    if (not member) then return end

    local spells = SpellTable[member.class]
    if (not spells) then return end

    local spec_id = member.spec_id or 0

    for _, data in ipairs(spells) do
        if (data.enabled and HasRequiredSpec(data, spec_id) and HasRequiredTalent(data, member.talents)) then
            local spellName, _, spellIcon, _, _, _, _ = GetSpellInfo(data.spellID)
            if (spellName) then
                
                local index = self:FindCooldownIndex(guid, data.spellID);

                -- if spell do not have a cooldown bar, we need to add a new one
                if (not index) then
                    index = (#self or 0) + 1

                    local spellCooldownMs, _ = GetSpellBaseCooldown(data.spellID)
                    local spellCooldown = (spellCooldownMs or 0) / 1000

                    local bar = nil
                    if (#self.useless > 0) then
                        bar = table.remove(self.useless)
                    else
                        bar = self:SpawnBar(index, member.name, member.realm, member.class, spellName, spellIcon)
                    end
                    -- check if where a bar in the useless table
                    -- else, create a new one

                    bar.sourceName = member.name
                    bar.class = member.class
                    bar.spellID = data.spellID
                    bar.spellName = spellName
                    bar.spellIcon = spellIcon
                    bar.cooldownMs = spellCooldownMs
                    bar.cooldown = spellCooldown
                    bar.guid = guid
                    
                    self.CooldownReady(bar)

                    table.insert(self.bars, bar)
                else
                    -- update information
                    T.Print("spell " .. data.spellID .. " already tracked.")
                end

                -- if (not index) then
                --     index = (#self or 0) + 1

                --     local spellCooldownMs, _ = GetSpellBaseCooldown(data.spellID)
                --     local spellCooldown = (spellCooldownMs or 0) / 1000

                --     local frame = self:SpawnBar(index, member.name, member.realm, member.class, spellName, spellIcon)
                --     frame.sourceName = member.name
                --     frame.class = member.class
                --     frame.spellID = data.spellID
                --     frame.spellName = spellName
                --     frame.spellIcon = spellIcon
                --     frame.cooldownMs = spellCooldownMs
                --     frame.cooldown = spellCooldown
                --     frame.guid = guid

                --     self.CooldownReady(frame)

                --     -- self[index] = frame
                --     table.insert(self, frame)
                -- else
                --     T.Print("spell " .. data.spellID .. " already tracked.")
                -- end
            else
                T.Debug("spell " .. data.spellID .. " is invalid.")
            end
        end
    end
end

RaidCooldowns:RegisterEvent("PLAYER_LOGIN")
RaidCooldowns:RegisterEvent("PLAYER_ENTERING_WORLD")
-- RaidCooldowns:RegisterEvent("GROUP_JOINED")
-- RaidCooldowns:RegisterEvent("GROUP_LEFT")
RaidCooldowns:RegisterEvent("INSPECT_READY")
RaidCooldowns:SetScript("OnEvent", function(self, event, ...)
    -- call one of the event handlers.
    self[event](self, ...)
end)

function RaidCooldowns:PLAYER_LOGIN()
    self:SetPoint(unpack(C.RaidCD.Anchor))
    self:SetSize(C.RaidCD.BarWidth, C.RaidCD.BarHeight)
    -- self:CreateBackdrop()
    self.unit = "player"
    self.guid = UnitGUID(self.unit)
    self.class = select(2, UnitClass(self.unit))
    self.group = {}
    self.bars = {}
    self.queue = {}
end

function RaidCooldowns:PLAYER_ENTERING_WORLD(isLogin, isReload)
    if (isLogin or isReload) then
        -- loading ui
        print("login")
        self:RegisterEvent("GROUP_ROSTER_UPDATE")
        self:RegisterEvent("UNIT_SPELLCAST_SUCCEEDED")
        self:RegisterEvent("UNIT_SPELLCAST_FAILED")
    else
        -- zoned between map instances
        print("zone changed")
    end

    self:ScanGroup()
    self:Spawn(self.guid)
    self:UpdatePositions()
end

function RaidCooldowns:GROUP_ROSTER_UPDATE()
    self:ScanGroup()
    self:UpdatePositions()
end

function RaidCooldowns:GROUP_JOINED(category, partyGUID)
    print("GROUP_JOINED", category, partyGUID)
end

function RaidCooldowns:GROUP_LEFT(category, partyGUID)
    print("GROUP_LEFT", category, partyGUID)
end

function RaidCooldowns:UNIT_SPELLCAST_SUCCEEDED(unit, _, spellID)
    local guid = UnitGUID(unit)
    
    -- 200749 = 'Activating Specialization'
    -- 384255 = 'Changing Talents'
    if (spellID == 200749 or spellID == 384255) then
        -- if a unit changes specialization, we need to inspect it again
        -- and update its cooldowns
        self:Queue(unit, guid)
    else
        self:UpdateCooldown(unit, spellID)
    end
end

function RaidCooldowns:UNIT_SPELLCAST_FAILED(unit, _, spellID)
    self:UpdateCooldown(unit, spellID)
end

function RaidCooldowns:INSPECT_READY(guid)
    self:Inspect(guid)
    self:DequeueByGUID(guid)
end

function RaidCooldowns:GetTalentBoA(unit, guid)
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

function RaidCooldowns:GetTalentDF(unit, guid)
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

RaidCooldowns.GetTalent = (T.Dragonflight and RaidCooldowns.GetTalentDF or RaidCooldowns.GetTalentBoA)

function RaidCooldowns:Inspect(guid)
    local unit = self:GuidToUnit(guid) or self.unit
    local _, class, _, race, sex, name, realm = GetPlayerInfoByGUID(guid)
    local isPlayer = UnitIsUnit(unit, "player")
    local isInspect = not isPlayer

    realm = self:GetRealm(realm)
    
    local spec = (isPlayer) and GetSpecialization() or nil
    local spec_id = (isPlayer) and GetSpecializationInfo(spec) or GetInspectSpecialization(unit)
    if ((not spec_id) or (spec_id == 0)) then return end

    local _, spec_name, spec_description, _, role, _ = GetSpecializationInfoByID(spec_id)
    local activeSpec = GetActiveSpecGroup(isInspect)

    local member = self.group[guid]
    if (not member) then return end
    
    member.name = name
    member.realm = realm
    member.class = class
    member.race = race
    member.sex = sex
    member.spec = spec
    member.spec_id = spec_id
    member.spec_name = spec_name
    member.spec_description = spec_description
    member.role = role
    
    member.talents = self:GetTalent(unit, guid)

    -- inspect done, remove it from the queue
    self:DequeueByGUID(guid)

    -- spawn unit tackers
    self:Spawn(guid)

    -- update all trackers
    self:UpdatePositions()
end
