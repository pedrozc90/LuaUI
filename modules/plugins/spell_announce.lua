local T, C, L = Tukui:unpack()

----------------------------------------------------------------
-- LSA (Lua Spell Announce)
-- Author: Luaerror
----------------------------------------------------------------
if (not C.SpellAnnounce.Enable) then return end

local SpellList = {
    ["DEATHKNIGHT"] = {
        { spellID = 61999, type = "resurrect", announce = true },                   -- Raise Ally

        -- Blood
        { spellID = 48707, type = "defensive", announce = true },                   -- Anti-Magic Shell
        { spellID = 48792, type = "defensive", announce = true },                   -- Icebound Fortitude
        { spellID = 55233, type = "defensive", announce = true },                   -- Vampiric Blood
    },
    ["DEMONHUNTER"] = {
        -- Havoc
        { spellID = 196718, type = "raid", announce = true, duration = 8 },         -- Darkness
    },
    ["DRUID"] = {
        { spellID = 20484, type = "resurrect", announce = true },                   -- Rebirth

        -- Balance
        { spellID = 29166, type = "external", announce = true },                    -- Innervate

        -- Guardian
        { spellID = 61336, type = "defensive", announce = true },                   -- Survival Instincts

        -- Restoration
        { spellID = 740   , type = "raid,channeled", announce = true },             -- Tranquility
        { spellID = 102342, type = "external", announce = true },                   -- Ironbark
        { spellID = 102351, type = "external", announce = false },                  -- Cenarion Ward
    },
    ["EVOKER"] = {},
    ["HUNTER"] = {
        { spellID = 264667, type = "raid", announce = true },                       -- Primal Rage
    },
    ["MAGE"] = {
        { spellID = 45438 , type = "defensive", announce = true },                  -- Ice Block
        { spellID = 80353 , type = "raid", announce = true },                       -- Time Warp
    },
    ["MONK"] = {
        -- Brewmaster
        { spellID = 115295, type = "defensive", announce = false },                 -- Guard
        { spellID = 120954, type = "defensive", announce = true  },                 -- Fortigying Brew
        { spellID = 122278, type = "defensive", announce = false },                 -- Dampen Harm
        { spellID = 115176, type = "raid,channeled", announce = true },             -- Zen Meditation

        -- Mistweaver
        { spellID = 122783, type = "defensive", announce = false },                 -- Diffuse Magic
        { spellID = 243435, type = "defensive", announce = false },                 -- Fortifying Brew
        { spellID = 116849, type = "external", announce = true },                   -- Life Cocoon
        { spellID = 191837, type = "raid,channeled", announce = false },            -- Essence Font
    },
    ["PALADIN"] = {
        -- All Specs
        { spellID = 642   , type = "defensive", announce = true },                  -- Divine Shield
        { spellID = 1022  , type = "external", announce = true },                   -- Blessing of Protection
        { spellID = 1044  , type = "external", announce = true },                   -- Blessing of Freedom
        { spellID = 6940  , type = "external", announce = true },                   -- Blessing of Sacrifice
        { spellID = 204018, type = "external", announce = true },                   -- Blessing of Spellwarding

        -- Holy
        { spellID = 498   , type = "defensive", announce = true },                  -- Divine Protection
        { spellID = 31821 , type = "raid", announce = true },                       -- Aura Mastery
        { spellID = 114158, type = "raid,cast", announce = true, duration = 14 },   -- Light's Hammer (Holy)

        -- Protection
        { spellID = 31850 , type = "defensive", announce = true },                  -- Ardent Defender
        { spellID = 86659 , type = "defensive", announce = true },                  -- Guardian of Ancient Kings
        { spellID = 204150, type = "raid,channeled", announce = true },             -- Aegis of Light (Protection)
    },
    ["PRIEST"] = {
        { spellID = 586   , type = "defensive", announce = false },                 -- Fade
        { spellID = 10060 , type = "external", announce = false },                  -- Power Infusion

        -- Discipline
        { spellID = 33206 , type = "external", announce = true },                   -- Pain Suppresion
        { spellID = 62618 , type = "raid,cast", announce = true, duration =  10 },  -- Power Word: Barrier
        { spellID = 271466, type = "raid", announce = true },                       -- Luminous Barrier
        
        -- Holy
        { spellID = 47788 , type = "external" , announce = true },                  -- Guardian Spirit
        { spellID = 27827 , type = "defensive", announce = true },                  -- Spirit of Redemption
        { spellID = 64843 , type = "raid,channeled", announce = true },             -- Divine Hymn
		{ spellID = 64901 , type = "raid,channeled", announce = true },             -- Symbol of Hope
        { spellID = 265202, type = "raid,cast", announce = false },                 -- Holy Word: Salvation
        
        -- Shadow
        { spellID = 15286 , type = "raid", announce = true },                       -- Vampiric Embrace
		{ spellID = 47585 , type = "defensive", announce = false },                 -- Dispersion
    },
    ["ROGUE"] = {},
    ["SHAMAN"] = {
        { spellID = 2825  , type = "raid", announce = true },                       -- Bloodlust (Horde)
        { spellID = 32182 , type = "raid", announce = true },                       -- Heroism (Alliance)
        { spellID = 108271, type = "defensive", announce = false },                 -- Astral Shift

        -- Elemental
        { spellID = 108281, type = "raid", announce = true },                       -- Ancestral Guidance
        
        -- Restoration
        { spellID = 98008 , type = "raid,summon", announce = true },                -- Spirit Link Totem
        { spellID = 108280, type = "raid,summon", announce = true },                -- Healing Tide Totem
        { spellID = 157153, type = "raid,summon", announce = true },                -- Cloudburst Totem
        { spellID = 198838, type = "raid,summon", announce = true },                -- Earthen Wall Totem
        { spellID = 207399, type = "raid,summon", announce = true },                -- Ancestral Protection Totem
    },
    ["WARLOCK"] = {
        { spellID = 20707 , type = "resurrect", announce = true },                  -- Soulstone
    },
    ["WARRIOR"] = {
        { spellID = 97463 , type = "raid", announce = true },                       -- Rallying Cry

        -- Protection
        { spellID = 871   , type = "defensive", announce = true },                  -- Shield Wall
        { spellID = 12975 , type = "defensive", announce = true },                  -- Last Stand
    },
    ["ALL"] = {}
}

local CombatEvents = {
    -- Healing
    SPELL_HEAL = true,
    -- Auras
    SPELL_AURA_APPLIED = true,
    SPELL_AURA_REMOVED = true,
    -- Cast
    SPELL_CAST_START = true,
    SPELL_CAST_SUCCESS = true,
    SPELL_CAST_FAILED = false,
    -- Others
    SPELL_SUMMON = true,
    SPELL_RESURRECT = true,
    UNIT_DESTROYED = true,
    UNIT_DIED = true,
    -- UNIT_DISSIPATES = true,
}

local band = bit.band
local bor = bit.bor
local format = string.format
local tremove = table.remove
local tinsert = table.insert
local tsort = table.sort

local COMBATLOG_FILTER_TOTEM = bor(COMBATLOG_OBJECT_TYPE_GUARDIAN, COMBATLOG_OBJECT_AFFILIATION_MINE)
local COMBATLOG_FILTER_PLAYER = _G.COMBATLOG_OBJECT_TYPE_PLAYER
----------------------------------------------------------------
-- OnUpdate
-- Reference: http://wowwiki.wikia.com/wiki/Using_OnUpdate_correctly on January 21th, 2019
----------------------------------------------------------------
local SummonedUnits = {}
local SummonThreshold = 30                          -- threshold time to clear summons table.
local UpdateInterval = 1.0                          -- how often the OnUpdate code will run.
local WaitTable = {}
local function OnUpdate(self, elapsed)
    self.LastUpdate = (self.LastUpdate or 0) + elapsed

    while (self.LastUpdate > UpdateInterval) do
        
        -- updates spell remaining duration.
        for index, spell in ipairs(WaitTable) do
            spell.duration = spell.duration - self.LastUpdate

            -- checks if spell duration has expired
            if (spell.duration <= 0) then
                SendChatMessage(format(spell.fmt, unpack(spell.args)), chatType)
                tremove(WaitTable, index)
            end
        end

        -- stupid totems do not fire combat log event UNIT_DIED
        -- so delete from table, if this unit was summoned 30 or more secongs ago.
        for index, unit in ipairs(SummonedUnits) do
            if (unit.duration <= 0) then
                tremove(SummonedUnits, index)
            end
            unit.duration = unit.duration - self.LastUpdate
        end

        self.LastUpdate = self.LastUpdate - UpdateInterval;
    end
end
----------------------------------------------------------------
-- Funtions
----------------------------------------------------------------

-- search spell in the class spell list
local function GetSpellListInfo(spellID, class)
    if (not spellID) then return end

    for _, v in pairs(SpellList[class or "ALL"]) do
        if (v.spellID == spellID) then
            return v.spellID, v.type, v.announce, v.duration
        end
    end
end

local function SearchUnitAura(spell, unit, filter)
    for index = 1, 40 do
        local spellName, _, _, _, _, _, _, _, _, spellID = UnitAura(unit, index, filter)

        if (not spellID) then
            -- no auras left
        elseif (type(spell) == "number" and spell == spellID) or
                (type(spell) == "string"and spell == spellName) then
            return UnitAura(unit, index, filter)
        end
    end
end

local COMBATLOG_FILTER_PLAYER = bor(COMBATLOG_OBJECT_TYPE_PLAYER, COMBATLOG_OBJECT_CONTROL_PLAYER, COMBATLOG_OBJECT_AFFILIATION_MINE)

local function GetUnit(unitFlags)
    if (band(unitFlags, COMBATLOG_OBJECT_TARGET) > 0) then
        return "target"
    elseif (band(unitFlags, COMBATLOG_OBJECT_FOCUS) > 0) then
        return "focus"
    elseif (band(unitFlags, COMBATLOG_FILTER_PLAYER) > 0) then
        return "player"
    end
end

----------------------------------------------------------------
-- Frame
----------------------------------------------------------------
local f = CreateFrame("Frame")
f:RegisterEvent("PLAYER_LOGIN")
f:RegisterEvent("PLAYER_ENTERING_WORLD")
f:SetScript("OnUpdate", OnUpdate)
f:SetScript("OnEvent", function (self, event, ...)
    -- call one of the functions below
    self[event](self, ...)
end)

function f:PLAYER_LOGIN()
    self.unit = "player" 
    self.guid = UnitGUID(self.unit)
    self.class = select(2, UnitClass("player"))
    self.chatType = nil
    self:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
end

function f:PLAYER_ENTERING_WORLD()
    local inInstance, instanceType = IsInInstance()
    
    if (inInstance) and (C.SpellAnnounce.GroupChat) then
        if (instanceType == "raid") then
            if (IsInRaid()) then
                self.chatType = "RAID"
            else
                self.chatType = "SAY"
            end
        elseif (inInstance == "party") then
            if (IsInGroup(LE_PARTY_CATEGORY_INSTANCE)) then
                self.chatType = "INSTANCE_CHAT"
            elseif (IsInGroup()) then
                self.chatType = "PARTY"
            else
                self.chatType = "SAY"
            end
        end
    else
        self.chatType = "SAY"
    end
end

function f:COMBAT_LOG_EVENT_UNFILTERED()
    local timestamp, eventType, hideCaster, sourceGUID, sourceName, sourceFlags, sourceRaidFlags, destGUID, destName, destFlags, destRaidFlags = CombatLogGetCurrentEventInfo()

    if (eventType:find("SPELL")) then

        -- some spells return nil destination if casted with out a locked target
        if (not destName) then
            destGUID = sourceGUID
            destName = sourceName
            destFlags = sourceFlags
            destRaidFlags = sourceRaidFlags
        end

        -- ignore spell casted by others and aren't targeting the player
        if (sourceGUID ~= self.guid and destGUID ~= self.guid) then return end

        -- get caster class
        -- local isPlayer = sourceGUID:find("Player") 
        local isPlayer = (sourceGUID ~= nil) and string.find(sourceGUID, "Player")
        local class = isPlayer and select(2, GetPlayerInfoByGUID(sourceGUID)) or "ALL"

        -- get extra combatlog info
        local spellID, spellName, spellSchool = select(12, CombatLogGetCurrentEventInfo())

        -- check spell list
        local _, types, announce, uptime = GetSpellListInfo(spellID, class)

        if (announce) then
            -- split spell types
            local type, arg1 = strsplit(",", types)

            -- set which spell text will be displayed
            local spellLink = GetSpellLink(spellID)
            local spellText = (C.SpellAnnounce.SpellLink) and spellLink or spellName
            
            -- raid cooldowns
            if (type == "raid") then
                if (eventType == "SPELL_CAST_SUCCESS") then
                    -- announce only spell casted by the player
                    if  (sourceGUID == self.guid) then
                        if (arg1 == "channeled") then
                            self:SendChatMessage("Channeling %s!", spellText)
                        elseif (arg1 == "cast") then
                            local duration = uptime
                            self:SendChatMessage("%s (%ds) up!", spellText, duration)

                            if (duration and duration > 0) then
                                tinsert(WaitTable, { duration = duration, fmt = "%s over!", args = { spellName } })
                            end
                        end
                    end
                elseif (eventType == "SPELL_AURA_APPLIED") and (not arg1) then
                    -- announce spells that apply affects to a large group of people
                    local unit = GetUnit(destFlags)
                    local filter = (sourceGUID == self.guid) and "HELPFUL|PLAYER" or "HELPFUL"
                    local duration = select(5, SearchUnitAura(spellID, unit, filter))
                    if (destGUID == self.guid) then
                        self:SendChatMessage("%s (%ds) up!", spellText, duration)
                    end
                elseif (eventType == "SPELL_AURA_REMOVED") and (arg1 ~= "summon") then
                    -- announce only when the unit is the player
                    if (destGUID == self.guid) then
                        self:SendChatMessage("%s over!", spellText)
                    end
                elseif (eventType == "SPELL_SUMMON") then
                    if (sourceGUID == self.guid) then
                        self:SendChatMessage("%s up!", spellText)

                        -- define a limit
                        local duration = SummonThreshold
                        -- get duration of the last totem summoned
                        for i = 1, MAX_TOTEMS do
                            local haveTotem, totemName, startTime, totemDuration = GetTotemInfo(i)
                            if (not haveTotem) then
                                break
                            else
                                duration = totemDuration + 3
                            end
                        end

                        -- save summoned unit GUID and Name
                        tinsert(SummonedUnits, { timestamp = timestamp, GUID = destGUID, name = destName, duration = duration })

                        -- sort table by timestamp
                        if (#SummonedUnits > 1) then
                            tsort(SummonedUnits, function(a, b)
                                if (a.timestamp == b.timestamp) then
                                    return a.name < b.name
                                end
                                return a.timestamp < b.timestamp
                            end)
                        end
                    end
                end
            
            -- external cooldowns
            elseif (type == "external") then
                if (eventType == "SPELL_AURA_APPLIED") then
                    local unit = GetUnit(destFlags)
                    local filter = (sourceGUID == self.guid) and "HELPFUL|PLAYER" or "HELPFUL"
                    local duration = select(5, SearchUnitAura(spellID, unit, filter))
                    if (sourceGUID == self.guid) then
                        if (destGUID == self.guid) then
                            self:SendChatMessage("%s (%ds) up!", spellText, duration)
                        else
                            self:SendChatMessage("%s (%ds) casted on %s!", spellText, duration, destName)
                        end
                    else
                        if (destGUID == self.guid) then
                            self:SendChatMessage("%s (%s) on me!", spellText, duration)
                        end
                    end
                elseif (eventType == "SPELL_AURA_REMOVED") then
                    if (sourceGUID == self.guid) then
                        if (destGUID == self.guid) then
                            self:SendChatMessage("%s over!", spellText)
                        else
                            self:SendChatMessage("%s on %s is over!", spellText, destName)
                        end
                    else
                        if (destGUID == self.guid) then
                            self:SendChatMessage("%s on me is over!", spellText)
                        end
                    end
                elseif (eventType == "SPELL_HEAL") then
                    if (sourceGUID == self.guid) then
                        local amount, overhealing, absorbed, critical = select(15, CombatLogGetCurrentEventInfo())
                        self:SendChatMessage("%s healed %s for %d!", spellText, destName, amount)
                    end
                end

            -- defensive cooldowns
            elseif (type == "defensive") or (type == "buff") then
                if (sourceGUID == self.guid) and (destGUID == self.guid) then
                    if (eventType == "SPELL_AURA_APPLIED") then
                        local duration = select(5, SearchUnitAura(spellID, "player", "HELPFUL"))
                        self:SendChatMessage("%s (%ds) up!", spellText, duration)
                    elseif (eventType == "SPELL_AURA_REMOVED") then
                        self:SendChatMessage("%s over!", spellText)
                    end
                end
            
            -- resurrect
            elseif (type == "resurrect") then
                if (sourceGUID == self.guid) then
                    if (eventType == "SPELL_RESURRECT") then
                        self:SendChatMessage("Casting %s on %s!", spellText, destName)
                    end
                end

            -- debuffs
            elseif (type == "debuff") then
                if (sourceGUID ~= self.guid) and (destGUID == self.guid) then
                    if (eventType == "SPELL_AURA_APPLIED") then
                        local duration = select(5, SearchUnitAura(spellID, "player", "HARMFUL"))
                        self:SendChatMessage("%s (%ds) up!", spellText, duration)
                    elseif (eventType == "SPELL_AURA_REMOVED") then
                        self:SendChatMessage("%s over!", spellText)
                    end
                end
            end
        end
    elseif (eventType:find("UNIT")) then
        -- filter units that belong to player
        if (band(destFlags, COMBATLOG_FILTER_TOTEM) > 0) then 

            -- check if unit was one of the summoned units
            if (eventType == "UNIT_DIED") or (eventType == "UNIT_DESTROYED") then
                for index, unit in pairs(SummonedUnits) do
                    if (unit.name == destName) then
                        self:SendChatMessage("%s is over!", destName)
                        -- remove unit from table
                        tremove(SummonedUnits, index)
                    end
                end
            end
        end
    end
end

function f:SendChatMessage(fmt, ...)
    local text = format(fmt, ...)
    SendChatMessage(text, self.chatType)
end
