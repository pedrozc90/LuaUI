local T, C, L = Tukui:unpack()

----------------------------------------------------------------
-- Talents
----------------------------------------------------------------
if (T.Retail) then return end

local GetTalentTree = _G.GetTalentTree
local GetTalentTabInfo = _G.GetTalentTabInfo
local GetNumTalentTabs = _G.GetNumTalentTabs

local Talents = {}

Talents.GetTalentTree = function()
    local result = {}
    local NUM_TALENT_TABS = GetNumTalentTabs()
    for tabIndex = 1, NUM_TALENT_TABS do
        local name, _, points, _ = GetTalentTabInfo(tabIndex)
        result[tabIndex] = points
    end
    return unpack(result)
end

Talents.isDruidHealer = function()
    local balance, feral_combat, restoration = Talents.GetTalentTree()
    return (restoration > balance and restoration > feral_combat)
end

Talents.isDruidTank = function()
    local balance, feral_combat, restoration = Talents.GetTalentTree()
    return (feral_combat > balance and feral_combat > restoration)
end

Talents.isPaladinHealer = function()
    local holy, protection, retribution = Talents.GetTalentTree()
    return (holy > protection and holy > retribution)
end

Talents.isPaladinTank = function()
    local holy, protection, retribution = Talents.GetTalentTree()
    return (protection > holy and protection > retribution)
end

Talents.isPriestHealer = function()
    local disc, holy, shadow = Talents.GetTalentTree()
    return (disc + holy > shadow)
end

Talents.isShamanHealer = function()
    local elemental, enhancement, restoration = Talents.GetTalentTree()
    return (restoration > elemental and restoration > enhancement)
end

Talents.isWarriorTank = function()
    local arms, fury, protection = Talents.GetTalentTree()
    return (protection > arms and protection > fury)
end

Talents.isHealer = function(class)
    if (class == "DRUID") then
        return Talents.isDruidHealer()
    elseif (class == "PALADIN") then
        return Talents.isPaladinHealer()
    elseif (class == "PRIEST") then
        return Talents.isPriestHealer()
    elseif (class == "SHAMAN") then
        return Talents.isShamanHealer()
    end
    return false;
end

Talents.isTank = function(class)
    if (class == "DRUID") then
        return Talents.isDruidTank()
    elseif (class == "PALADIN") then
        return Talents.isPaladinTank()
    elseif (class == "WARRIOR") then
        return Talents.isWarriorTank()
    end
    return false
end

Talents.GetPlayerRole = function(class)
    if (Talents.isHealer(class)) then
        return "HEALER"
    elseif (Talents.isTank(class)) then
        return "TANK"
    end
    return "DPS"
end

T.Talents = Talents
