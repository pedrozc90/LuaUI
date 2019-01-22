local T, C, L = Tukui:unpack()

----------------------------------------------------------------
-- Spell Announce
----------------------------------------------------------------
if (not C.SpellAnnounce.Enable) then return end

local playerGUID
local playerName
local chatType = "SAY"
local format = string.format
local tremove = table.remove
local tinsert = table.insert
local tsort = table.sort

--[[
    AURAS   - announce spells that apply an aura (buff) on the target.
    RAID    - announce spells that apply an aura in area.
    CAST    - announce spells casted by the player only, that don't necessary
            apply any aura. (e.g: Power Word: Barrier, Healing Rain, ...)
    CHANNEL - annnounce chanelling spells casted by the player only.
    (e.g: Divine Hymn, Tranquility, ...)
    SUMMON  - announce spells casted by the player only that summon an unit. (e.g: Totems, ...)
    CC      - announce crowd control or debuffs casted on player.
--]]
local SPELL_ANNOUNCE = {
    ["AURAS"] = {
    -- Priest
        -- Discipline
        [33206] = true,                         -- Pain Suppression
        [47536] = false,                        -- Rapture
        -- Holy
		[27827] = true,		                    -- Spirit of Redemption
		[47788] = true,		                    -- Guardian Spirit
        [64901] = true,		                    -- Symbol of Hope
        [200183] = true,                        -- Apotheosis
		-- Shadow
		[15286] = true,		                    -- Vampiric Embrace
		[47585] = true,		                    -- Dispersion

    -- Druid
        [22812] = false,                        -- Barkskin
        [29166] = true,                         -- Innervate
        -- Feral
        [61336] = false,                        -- Survival Instincts
        -- Guardian
        -- Restoration
        [33891] = false,                        -- Incarnation: Tree of Life
        [117679] = true,                        -- Incarnation
        [102342] = true,                        -- Ironbark
        [102351] = true,                        -- Cenarion Ward
        [197721] = false,                       -- Flourish

    -- Shaman
        [108271] = false,                       -- Astral Shift
        -- Elemental
        [108281] = true,                        -- Ancestral Guidance
        -- Restoration
        [114052] = false,                       -- Ascendance
    },
    ["RAID"] = {
        [2825] = true,			                -- Bloodlust (Shaman Horde)
		[32182] = true,			                -- Heroism (Shaman Alliance)
		[80353] = true,			                -- Time Warp (Mage)
		[90355] = true,			                -- Ancient Hysteria	(Core Hound)
        [160452] = true,		                -- Netherwinds (Nether Ray)
        
        -- Druid
        [77764] = true,                         -- Stampeding Roar (Feral)
    },
    ["CAST"] = {
        -- Priest Discipline
        [62618] = 10,                           -- Power Word: Barrier

        -- Shaman Restoration
        [73920] = 10,                           -- Healing Rain
    },
    ["CHANNEL"] = {
        -- Priest Holy
        [64843] = true,		                    -- Divine Hymn

        -- Druid Restoration
		[740] = true,		                    -- Tranquility
    },
    ["SUMMON"] = {
        -- Druid Restoration
        [145205] = true,                        -- Efflorescence

        -- Shaman Restoration
        [5394] = false,                         -- Healing Stream Totem
        [98008] = true,                         -- Spirit Link Totem
        [108280] = true,                        -- Healing Tide Totem
        [157153] = true,                        -- Cloudburst Totem
        [192077] = false,                       -- Wind Rush Totem
        [198838] = true,                        -- Earthen Wall Totem
        [207399] = true,                        -- Ancestral Protection Totem
        
    },
    ["DEBUFF"] = {
        -- Priest
		[605] = true,                           -- Mind Control
        [8122] = true,                          -- Psychic Scream
        [15487] = true,                         -- Silence
        [64044] = true,                         -- Psychic Horror
		[205364] = true,                        -- Mind Control (Talent)
    },
}
local SUMMONED_UNITS = {}
local COMBAT_EVENTS = {
    -- Healing
    SPELL_HEAL = true,
    -- Auras
    SPELL_AURA_APPLIED = true,
    SPELL_AURA_REMOVED = true,
    -- Cast
    SPELL_CAST_STARTED = false,
    SPELL_CAST_SUCCESS = true,
    SPELL_CAST_FAILED = false,
    -- Others
    SPELL_SUMMON = true,
    UNIT_DESTROYED = true,
    UNIT_DIED = true
}

-- scan unit auras to fint spell that matches spellID.
local function GetAuraInfo(spell, unit, filter)
    if ((not spell) or (not unit) or (not filter)) then return end
    -- run though all unit auras
    for index = 1, 40 do
        -- UnitAura(unit, index, filter)
        -- unit = unitID string (e.g: "player", "target", "focus", ...)
        -- index = from 1 to 40
        -- filter = string combination ("HELPFUL", "HARMFUL", "PLAYER", "RAID", "CANCELABLE", "NOT_CANCELABLE")
        local spellName, _, _, _, _, _, _, _, _, spellID = UnitAura(unit, index, filter)

        if (not spellID) then
            -- no auras left
            break
        elseif ((type(spell) == "number" and spell == spellID) or
                (type(spell) == "string" and spell == spellName)) then
            -- return all
            return UnitAura(unit, index, filter)
        end
    end
end

----------------------------------------------------------------
-- OnUpdate
-- Reference: http://wowwiki.wikia.com/wiki/Using_OnUpdate_correctly on January 21th, 2019
----------------------------------------------------------------
local UpdateInterval = 1.0              -- how often the OnUpdate code will run.
local WaitTable = {}
local function OnUpdate(self, elapsed)
    self.LastUpdate = (self.LastUpdate or 0) + elapsed

    while (self.LastUpdate > UpdateInterval) do
        
        -- run though wait table
        for index, item in ipairs(WaitTable) do
            item.duration = item.duration - self.LastUpdate

            -- if duration expires, then remove from wait table
            if (item.duration <= 0) then
                SendChatMessage(format(item.fmt, unpack(item.args)), chatType)
                tremove(WaitTable, index)
            end
        end

        self.LastUpdate = self.LastUpdate - UpdateInterval;
    end
end

----------------------------------------------------------------
-- Combat Log Handler
----------------------------------------------------------------
local CombatLogHandler = function(self)
    -- 1st to 11th parameters
    local timestamp, eventType, hideCaster, sourceGUID, sourceName, sourceFlags, sourceRaidFlags,
    destGUID, destName, destFlags, destRaidFlags = CombatLogGetCurrentEventInfo()
    
    -- check combat event filter
    if (not COMBAT_EVENTS[eventType]) then return end

    -- some spells return destName as nil if you don't have a target.
    if (not destName) then
        destGUID = sourceGUID
        destName = sourceName
        destFlags = sourceFlags
        destRaidFlags = sourceRaidFlags
    end

    -- spells casted by others are just important if destination is my character.
    if ((sourceGUID ~= playerGUID) and (destGUID ~= playerGUID)) then return end

    -- 12th to 14th parameters
    local spellID, spellName, spellSchool = select(12, CombatLogGetCurrentEventInfo())
    local spellLink = GetSpellLink(spellID)
    local spellIcon = select(3, GetSpellInfo(spellID))

    -- Buffs
    if (SPELL_ANNOUNCE.AURAS[spellID]) then
        if (eventType == "SPELL_AURA_APPLIED") then
            local auraType, amount = select(15, CombatLogGetCurrentEventInfo())

            -- need to get spell duration
            local unit = (destGUID == playerGUID) and "player" or "target"
            local filter = (sourceGUID == playerGUID) and "HELPFUL|PLAYER" or "HELPFUL"
            local duration = select(5, GetAuraInfo(spellID, unit, filter))

            if (sourceGUID == playerGUID) then
                if (destGUID ~= playerGUID) then

                    if (type(duration) == "number" and duration > 0) then
                        SendChatMessage(format("%s (%ds) casted on %s!", spellLink, duration, destName), chatType)
                    else
                        SendChatMessage(format("%s casted on %s!", spellLink, destName), chatType)
                    end
                else
                    if (type(duration) == "number" and duration > 0) then
                        SendChatMessage(format("%s (%ds) up!", spellLink, duration), chatType)
                    else
                        SendChatMessage(format("%s up!", spellLink), chatType)
                    end
                end
            else
                if (destGUID == playerGUID) then
                    if (type(duration) == "number" and duration > 0) then
                        SendChatMessage(format("%s (%ds) on me!", spellLink, duration), chatType)
                    else
                        SendChatMessage(format("%s on me!", spellLink), chatType)
                    end
                end
            end
        elseif (eventType == "SPELL_HEAL") then
            local amount, overhealing, absorbed, critical = select(15, CombatLogGetCurrentEventInfo())

            if (sourceGUID == playerGUID) then
                SendChatMessage(format("%s healed %s for %d!", spellName, destName, amount), chatType)
            end
        elseif (eventType == "SPELL_AURA_REMOVED") then
            local auraType, amount = select(15, CombatLogGetCurrentEventInfo())

            if (sourceGUID == playerGUID) then
                if (destGUID ~= playerGUID) then
                    SendChatMessage(format("%s on %s is over!", spellName, destName), chatType)
                else
                    SendChatMessage(format("%s over!", spellName), chatType)
                end
            else
                if (destGUID == playerGUID) then
                    SendChatMessage(format("%s on me is over!", spellName), chatType)
                end
            end
        end
    end

    -- Raid Spells
    if (SPELL_ANNOUNCE.RAID[spellID]) then
        if (destGUID ~= playerGUID) then return end

        if (eventType == "SPELL_AURA_APPLIED") then
            
            -- need to get spell duration
            local duration = select(5, GetAuraInfo(spellID, "player", "HELPFUL"))

            if (type(duration) == "number" and duration > 0) then
                SendChatMessage(format("%s (%ds) up!", spellLink, duration), chatType)
            else
                SendChatMessage(format("%s up!", spellLink), chatType)
            end
        elseif (eventType == "SPELL_AURA_REMOVED") then
            SendChatMessage(format("%s is over!", spellLink), chatType)
        end
    end

    -- Casted Spells
    if (SPELL_ANNOUNCE.CAST[spellID]) then
        -- filter caster
        if (not sourceGUID == playerGUID) then return end

        if (eventType == "SPELL_CAST_SUCCESS") then
            local duration = SPELL_ANNOUNCE.CAST[spellID]

            SendChatMessage(format("%s (%ds) up!", spellLink, duration), chatType)

            if (type(duration) == "number" and duration > 0) then
                -- Delay(duration, "%s over!", spellName)
                T.Debug(spellName .. ", " .. duration)
                tinsert(WaitTable, { duration = duration, fmt = "%s over!", args = { spellName } })
            end
        elseif (eventType == "SPELL_AURA_REMOVED") then
            SendChatMessage(format("%s over!", spellLink), chatType)
        end
    end

    -- Channeling Spells
    if (SPELL_ANNOUNCE.CHANNEL[spellID]) then
        if (not sourceGUID == playerGUID) then return end
        
        if (eventType == "SPELL_CAST_SUCCESS") then
            SendChatMessage(format("Channeling %s!", spellLink), chat)
        elseif (eventType == "SPELL_AURA_REMOVED") then
            if (destGUID == playerGUID) then
                SendChatMessage(format("%s over!", spellLink), chat)
            end
        end
    end

    -- Summons
    if (SPELL_ANNOUNCE.SUMMON[spellID]) then
        if (eventType == "SPELL_SUMMON") then
            SendChatMessage(format("%s up!", spellLink), chatType)

            -- save summoned unitGUID and unitName
            tinsert(SUMMONED_UNITS, { timestamp = timestamp, GUID = destGUID, Name = destName, delay = 0 })

            if (#SUMMONED_UNITS > 1) then
                -- sort by timestamp
                tsort(SUMMONED_UNITS, function(a, b)
                    if (a.timestamp == b.timestamp) then
                        return a.Name < b.Name
                    end
                end)
            end
        end
    end

    -- if an unit dies, verify if it was any of the summoned units.
	if (eventType == "UNIT_DIED") then
		for index, unit in ipairs(SUMMONED_UNITS) do
            if (unit.GUID == destGUID and unit.Name == destName) then
				SendChatMessage(format("%s over!", destName), chatType)
				-- remove unit from table.
				tremove(SUMMONED_UNITS, index)
			end
		end
	end

    -- Debuffs
    if (SPELL_ANNOUNCE.DEBUFF[spellID]) then
        if (not destGUID == playerGUID) then return end
        if (eventType == "SPELL_AURA_APPLIED") then
            local duration = select(5, GetAuraInfo(spellID, "player", "HARMFUL"))
            SendChatMessage(format("%s (%ds) on me!", spellLink, duration), chatType)
        elseif (eventType == "SPELL_AURA_REMOVED") then
            SendChatMessage(format("%s over!", spellLink), chatType)
        end
    end
end

----------------------------------------------------------------
-- OnEvent
----------------------------------------------------------------
local function OnEvent(self, event, ...)
    if (event == "COMBAT_LOG_EVENT_UNFILTERED") then
        CombatLogHandler(self)
    elseif (event == "PLAYER_LOGIN") then
        self:Initialize()
    end
end


local f = CreateFrame("Frame")
f:SetScript("OnEvent", OnEvent)
f:SetScript("OnUpdate", OnUpdate)

function f:Initialize()
    playerGUID = UnitGUID("player")
    playerName = UnitName("player")
    chatType = "SAY"
    self:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
end

if IsLoggedIn() then
    f:Initialize()
else
    f:RegisterEvent("PLAYER_LOGIN")
end