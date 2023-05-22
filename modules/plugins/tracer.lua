local T, C, L = Tukui:unpack()

-- if (true) then return end

local band = bit.band

local UnitName = _G.UnitName
local UnitGUID = _G.UnitGUID
local UnitIsPlayer = _G.UnitIsPlayer
local GetSpellInfo = _G.GetSpellInfo
local GetSpellDescription = _G.GetSpellDescription
local CombatLogGetCurrentEventInfo = _G.CombatLogGetCurrentEventInfo

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

local NUM_PARTY = 4
local NUM_BOSS = 5

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
    self:RegisterEvent("PLAYER_ENTERING_WORLD")
end

function f:PLAYER_ENTERING_WORLD()
    local _, instanceType = IsInInstance()
    -- if (instanceType == "raid") or (instanceType == "party") then
        local instanceName, instanceType, difficultyID, difficultyName, maxPlayers, dynamicDifficulty, isDynamic, instanceID, instanceGroupSize, LfgDungeonID = GetInstanceInfo()
        local _, groupType, isHeroic, isChallengeMode, displayHeroic, displayMythic, toggleDifficultyID = GetDifficultyInfo(difficultyID)
        self.instanceID = instanceID
        self.instanceName = instanceName
        self.instanceType = instanceType
        self.instanceDifficulty = dynamicDifficulty
        self.isMythic = displayMythic
        -- if (instanceType == "raid" or self.isMythic) then
            self.tracking = true
            self:RegisterEvent("UNIT_AURA")
            self:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
            if not LuaUIData[self.instanceID] then
                LuaUIData[self.instanceID] = {}
            end
        -- end
    -- else
    --     if (self.tracking) then
    --         self.tracking = false
    --         self:UnregisterEvent("UNIT_AURA")
    --         self:UnregisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
    --     end
    -- end
end

function f:findIndex(tbl, spellID, sourceName)
    for i, v in ipairs(tbl) do
        if (v.spellID == spellID and v.sourceName == sourceName) then
            return i
        end
    end
    return -1
end

function f:GetUnitByName(name)
    if (not name) then return end
    if (self.name == name) then
        return "player"
    end
    for i = 1, NUM_PARTY do
        local unit = "party" .. i
        if (UnitName(unit) == name) then
            return unit
        end
        local pet_unit = "partypet" .. i
        if (UnitName(pet_unit) == name) then
            return pet_unit
        end
    end
    for i = 1, NUM_BOSS do
        local unit = "boss" .. i
        if (UnitName(unit) == name) then
            return unit
        end
    end
end

function f:GetUnitByGUID(guid)
    if (not guid) then return end
    if (self.guid == guid) then
        return "player"
    end
    for i = 1, NUM_PARTY do
        local unit = "party" .. i
        if (UnitGUID(unit) == guid) then
            return unit
        end
        local pet_unit = "partypet" .. i
        if (UnitGUID(pet_unit) == guid) then
            return pet_unit
        end
    end
    for i = 1, NUM_BOSS do
        local unit = "boss" .. i
        if (UnitGUID(unit) == guid) then
            return unit
        end
    end
end

function f:UNIT_AURA(destUnit, updateInfo)
    if (not updateInfo) then return end
    if (not updateInfo.addedAuras) then return end
    
    for _, data in next, updateInfo.addedAuras do
        if (not data.isFromPlayerOrPlayerPet) then
            local spellID = data.spellId
            local spellName = data.name or GetSpellInfo(spellID)

            local sourceUnit = data.sourceUnit
            local sourceName = (sourceUnit) and UnitName(sourceUnit) or nil
            
            local isPlayer = (destUnit) and UnitIsPlayer(destUnit) or false

            local index = self:findIndex(LuaUIData[self.instanceID], spellID, sourceName)
            if (index < 0 and spellID) then
                local spellDescription = string.gsub(GetSpellDescription(spellID), "\n", " ")

                table.insert(
                    LuaUIData[self.instanceID],
                    {
                        -- target
                        destUnit = destUnit,
                        destName = (destUnit and UnitName(destUnit) or nil),
                        -- source
                        sourceUnit = sourceUnit,
                        sourceName = sourceName,
                        -- sourceIsPlayer = isPlayer,
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
                        isStealable = data.isStealable
                    }
                )
            end
        end
    end
end

function f:COMBAT_LOG_EVENT_UNFILTERED()
    local timestamp, event, hideCaster, sourceGUID, sourceName, sourceFlags, sourceRaidFlags, sourceGUID, destName, destFlags, destRaidFlags = CombatLogGetCurrentEventInfo()
    
    local isPlayer = CombatLog_Object_IsA(sourceFlags, COMBATLOG_FILTER_FRIENDLY_PLAYER)
    local isPlayerPet = CombatLog_Object_IsA(sourceFlags, COMBATLOG_FILTER_FRIENDLY_PLAYER_PET)
    local isPlayerGuardian = CombatLog_Object_IsA(sourceFlags, COMBATLOG_FILTER_FRIENDLY_PLAYER_GUARDIAN)

    local isValid = (not isPlayer) and (not isPlayerPet) and (not isPlayerGuardian)

    if (event == "SPELL_AURA_APPLIED" and isValid) then
        local spellID, spellName, spellScholl, auraType, amount = select(12, CombatLogGetCurrentEventInfo())
        
        local index = self:findIndex(LuaUIData[self.instanceID], spellID, sourceName)
        if (index < 0 and spellID) then
            local spellDescription = string.gsub(GetSpellDescription(spellID), "\n", " ")

            table.insert(
                LuaUIData[self.instanceID],
                {
                    -- target
                    destUnit = self:GetUnitByGUID(destGUID) or self:GetUnitByName(destName),
                    destName = destName,
                    -- source
                    sourceUnit = self:GetUnitByGUID(sourceGUID) or self:GetUnitByName(sourceName),
                    sourceName = sourceName,
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
                    isStealable = nil
                }
            )
        end
    end
end
