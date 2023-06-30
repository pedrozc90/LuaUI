local T, C, L = Tukui:unpack()

if (true) then return end

local band = bit.band

local UnitName = _G.UnitName
local UnitGUID = _G.UnitGUID
local UnitIsPlayer = _G.UnitIsPlayer
local GetSpellInfo = _G.GetSpellInfo
local GetSpellDescription = _G.GetSpellDescription
local CombatLogGetCurrentEventInfo = _G.CombatLogGetCurrentEventInfo
local IsInGroup = _G.IsInGroup
local IsInRaid = _G.IsInRaid
local GetNumGroupMembers = _G.GetNumGroupMembers

-- flags
local CombatLog_Object_IsA = _G.CombatLog_Object_IsA
local COMBATLOG_OBJECT_AFFILIATION_MINE = _G.COMBATLOG_OBJECT_AFFILIATION_MINE
local COMBATLOG_OBJECT_AFFILIATION_PARTY = _G.COMBATLOG_OBJECT_AFFILIATION_PARTY
local COMBATLOG_OBJECT_AFFILIATION_RAID = _G.COMBATLOG_OBJECT_AFFILIATION_RAID
local COMBATLOG_OBJECT_REACTION_FRIENDLY = _G.COMBATLOG_OBJECT_REACTION_FRIENDLY
local COMBATLOG_OBJECT_REACTION_HOSTILE = _G.COMBATLOG_OBJECT_REACTION_HOSTILE
local COMBATLOG_OBJECT_CONTROL_PLAYER = _G.COMBATLOG_OBJECT_CONTROL_PLAYER
local COMBATLOG_OBJECT_TYPE_PLAYER = _G.COMBATLOG_OBJECT_TYPE_PLAYER
local COMBATLOG_OBJECT_TYPE_PET = _G.COMBATLOG_OBJECT_TYPE_PET
local COMBATLOG_OBJECT_TYPE_GUARDIAN = _G.COMBATLOG_OBJECT_TYPE_GUARDIAN

local COMBATLOG_FILTER_FRIENDLY_PLAYER = bit.bor(COMBATLOG_OBJECT_REACTION_FRIENDLY, COMBATLOG_OBJECT_CONTROL_PLAYER, COMBATLOG_OBJECT_TYPE_PLAYER)
local COMBATLOG_FILTER_FRIENDLY_PLAYER_PET = bit.bor(COMBATLOG_OBJECT_CONTROL_PLAYER, COMBATLOG_OBJECT_TYPE_PET)
local COMBATLOG_FILTER_FRIENDLY_PLAYER_GUARDIAN = bit.bor(COMBATLOG_OBJECT_CONTROL_PLAYER, COMBATLOG_OBJECT_TYPE_GUARDIAN)

local NUM_BOSS = 8
local NUM_RAID = 40
local NUM_PARTY = 5

local f = CreateFrame("Frame")
f:RegisterEvent("ADDON_LOADED")
f:RegisterEvent("PLAYER_LOGIN")
f:SetScript("OnEvent", function(self, event, ...)
    self[event](self, ...)
end)

function f:ADDON_LOADED()
    if not LuaUIData then
        LuaUIData = {}
    end
end

function f:PLAYER_LOGIN()
    self.unit = "player"
    self.name = UnitName(self.unit)
    self.guid = UnitGUID(self.unit)
    self.units = {}
    self.names = {}
    self.guids = {}
    self:RegisterEvent("PLAYER_ENTERING_WORLD")
    self:RegisterEvent("GROUP_ROSTER_UPDATE")
    self:RegisterEvent("ENCOUNTER_START")
end

function f:PLAYER_ENTERING_WORLD()
    local _, instanceType = IsInInstance()
    local instanceName, instanceType, difficultyID, difficultyName, maxPlayers, dynamicDifficulty, isDynamic, instanceID, instanceGroupSize, LfgDungeonID = GetInstanceInfo()
    local _, groupType, isHeroic, isChallengeMode, displayHeroic, displayMythic, toggleDifficultyID = GetDifficultyInfo(difficultyID)
    
    self.instanceID = instanceID
    self.instanceName = instanceName
    self.instanceType = instanceType
    self.instanceDifficulty = dynamicDifficulty
    self.isHeroic = displayHeroic
    self.isMythic = displayMythic
    
    if (instanceType == "raid") or (instanceType == "party") then
        self.tracking = true
        self:RegisterEvent("UNIT_AURA")
        self:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")

        -- init saved variables
        if not LuaUIData[self.instanceID] then
            LuaUIData[self.instanceID] = {}
        end
    else
        if (self.tracking) then
            self.tracking = false
            self:UnregisterEvent("UNIT_AURA")
            self:UnregisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
        end
    end
end

function f:ENCOUNTER_START(encounterID, encounterName, difficultyID, groupSize)
    self.encounterID = encounterID
    self.encounterName = encounterName
end

function f:findIndex(sourceName, spellID)
    for i, v in ipairs(LuaUIData[self.instanceID]) do
        if (v.sourceName == sourceName and v.spellID == spellID) then
            return i
        end
    end
    return nil
end

function f:UNIT_AURA(unit, updateInfo)
    if (not updateInfo) then return end
    if (not updateInfo.addedAuras) then return end
    
    local destUnit = unit or "none"
    local destName = UnitName(destUnit)

    for _, data in next, updateInfo.addedAuras do
        if (not data.isFromPlayerOrPlayerPet) then
            local spellID = data.spellId
            local spellName = data.name or GetSpellInfo(spellID)

            local sourceUnit = data.sourceUnit or "none"
            local sourceName = UnitName(sourceUnit)
            if UnitIsPlayer(sourceUnit) then return end

            local index = self:findIndex(sourceName, spellID)
            if (not index) then
                local spellDescription = string.gsub(GetSpellDescription(spellID), "\n", " ")

                table.insert(
                    LuaUIData[self.instanceID],
                    {
                        -- instance
                        instanceID = self.instanceID,
                        instanceName = self.instanceName,
                        -- encounter
                        encounterID = self.encounterID,
                        encounterName = self.encounterName,
                        -- target
                        destUnit = destUnit,
                        destName = destName,
                        -- source
                        sourceUnit = sourceUnit,
                        sourceName = sourceName,
                        -- spell
                        spellID = spellID,
                        spellName = spellName,
                        spellDescription = spellDescription,
                        canApplyAura = data.canApplyAura,
                        dispelName = data.dispelName,
                        isBossAura = data.isBossAura,
                        isHarmful = data.isHarmful,
                        isHelpful = data.isHelpful,
                        isNameplateOnly = data.isNameplateOnly,
                        isRaid = data.isRaid,
                        isStealable = data.isStealable,
                        event = "UNIT_AURA"
                    }
                )
            end
        end
    end
end

function f:COMBAT_LOG_EVENT_UNFILTERED()
    local timestamp, event, hideCaster, sourceGUID, sourceName, sourceFlags, sourceRaidFlags, sourceGUID, destName, destFlags, destRaidFlags = CombatLogGetCurrentEventInfo()
    
    if (event ~= "SPELL_AURA_APPLIED") then return end
    
    -- if CombatLog_Object_IsA(sourceFlags, COMBATLOG_OBJECT_TYPE_PLAYER) then return end
    -- if (CombatLog_Object_IsA(sourceFlags, COMBATLOG_FILTER_FRIENDLY_PLAYER_PET) or
    --     CombatLog_Object_IsA(sourceFlags, COMBATLOG_FILTER_FRIENDLY_PLAYER_GUARDIAN)) then return end

    local sourceUnit = self.guids[sourceGUID]
    if (sourceUnit) then return end

    local destUnit = self.guids[sourceGUID] or "none"

    local spellID, spellName, spellScholl, auraType, amount = select(12, CombatLogGetCurrentEventInfo())
    if (not spellID) then return end

    local index = self:findIndex(sourceName, spellID)
    if (not index) then
        local spellDescription = string.gsub(GetSpellDescription(spellID), "\n", " ")

        table.insert(
            LuaUIData[self.instanceID],
            {
                -- instance
                instanceID = self.instanceID,
                instanceName = self.instanceName,
                -- encounter
                encounterID = self.encounterID,
                encounterName = self.encounterName,
                -- target
                destUnit = destUnit,
                destName = destName,
                destFlags = destFlags,
                -- source
                sourceUnit = sourceUnit,
                sourceName = sourceName,
                sourceFlags = sourceFlags,
                -- spell
                spellID = spellID,
                spellName = spellName,
                spellDescription = spellDescription,
                canApplyAura = nil,
                dispelName = nil,
                isBossAura = nil,
                isHarmful = (auraType == "DEBUFF"),
                isHelpful = (auraType == "BUFF"),
                isNameplateOnly = nil,
                isRaid = nil,
                isStealable = nil,
                event = "COMBAT_LOG_EVENT_UNFILTERED"
            }
        )
    end
end

function f:ResetGroup()
    if (self.units) then table.wipe(self.units) end
    if (self.names) then table.wipe(self.names) end
    if (self.guids) then table.wipe(self.guids) end
end

function f:MapGroup(unitType, index)
    local unit = unitType  .. index
    local name = UnitName(unit)
    local GUID = UnitGUID(unit)
    if (name) then
        self.units[unit] = { name = name, GUID = GUID }
        self.names[name] = raidUnit
        self.guids[GUID] = raidUnit
    end

    local petUnit = unitType .. "pet"  .. index
    local petName = UnitName(petUnit)
    local petGUID = UnitGUID(petUnit)
    if (petName) then
        self.units[petUnit] = { name = petName , GUID = petGUID }
        self.names[petName] = petUnit
        self.guids[petGUID] = petUnit
    end
end

function f:GROUP_ROSTER_UPDATE()
    self.isParty = IsInGroup()
    self.isRaid = IsInRaid()
    self.groupSize = GetNumGroupMembers() or 0
    
    self:ResetGroup()

    for index = 1, self.groupSize do
        self:MapGroup(self.isRaid and "raid" or "party", index)
    end
end
