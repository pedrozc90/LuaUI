local T, C, L = Tukui:unpack()

----------------------------------------------------------------
-- Interrupt Announce bt Elv22
----------------------------------------------------------------
if (not C.Interrupts.Enable) then return end

local CHANNELS = {
    ["SAY"] = true,
    ["PARTY"] = true,
    ["RAID"] = true,
    ["RAID_WARNNING"] = false,
    ["INSTANCE_CHAT"] = true
}

local function Interrupt_OnEvent(self, event)
    local timestamp, eventType, hideCaster, sourceGUID, sourceName,
    sourceFlags, sourceRaidFlags, destGUID, destName, destFlags,
    destRaidFlags = CombatLogGetCurrentEventInfo()

    local chatType
    if (IsInGroup(LE_PARTY_CATEGORY_INSTANCE)) then
        chatType = "INSTANCE_CHAT"
    elseif (IsInRaid()) then
        chatType = "RAID"
    elseif (IsInGroup()) then
        chatType = "PARTY"
    else
        chatType = "SAY"
    end

    -- check if event is interrupt
    if ((eventType == "SPELL_INTERRUPT") and (sourceGUID == UnitGUID("player"))) then
        local spellID, spellName, spellSchool,
        extraSpellID, extraSpellName, extraSchool = select(12, CombatLogGetCurrentEventInfo())

        -- check if channel is enable for announcing
        if (not CHANNELS[chatType]) then
            chatType = "SAY"
        end

        if (C.Interrupts.SpellLink) then
            local extraSpellLink = GetSpellLink(extraSpellID)
            SendChatMessage("Interrupted " .. destName .. " " .. extraSpellLink .. "!", chatType)
        else
            SendChatMessage("Interrupted " .. destName .. " " .. extraSpellName .. "!", chatType)
        end
    end
end

local f = CreateFrame("Frame")
f:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
f:SetScript("OnEvent", Interrupt_OnEvent)