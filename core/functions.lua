local T, C, L = Tukui:unpack()

local format = string.format
local floor = math.floor
local pow = math.pow
local gsub = string.gsub
local ceil = math.ceil

----------------------------------------------------------------
-- Utilities
----------------------------------------------------------------

-- override Tukui print function
T.Print = function(...)
    print("|cff00FF96LuaUI|r: ", ...)
end

T.Debug = function(...)
    print("|cffB04F4FLuaUI WARNING: |r", ...)
end

-- returns a round number
T.RoundValue = function(number, decimals)
    if (not decimals) then decimals = 0 end
    local mult = pow(10, decimals)
    return floor(mult * number) / mult
end

-- returns the size of frames such as combo-points/runes/chi, where
-- n-equal elements with a spacing between each one needs to match a given size.
T.EqualSizes = function(width, number, spacing)
    -- calculate size of n-equal elements
    local size = (width - (number - 1) * spacing) / number
    -- calculate total difference between the specific size and it's integer.
    local delta = (size - floor(size)) * number
    return floor(size), floor(delta)
end

T.GetSize = function(unit)
    if (unit) then
        if (unit == "player") then
            return C.UnitFrames.PlayerWidth, C.UnitFrames.PlayerHeight
        elseif (unit == "target") then
            return C.UnitFrames.TargetWidth, C.UnitFrames.TargetHeight
        elseif (unit == "targettarget") then
            return C.UnitFrames.TargetOfTargetWidth, C.UnitFrames.TargetOfTargetHeight
        elseif (unit == "pet") then
            return C.UnitFrames.PetWidth, C.UnitFrames.PetHeight
        elseif (unit == "focus") then
            return C.UnitFrames.FocusWidth, C.UnitFrames.FocusHeight
        elseif (unit == "focustarget") then
            return C.UnitFrames.FocusTargetWidth, C.UnitFrames.FocusTargetHeight
        elseif (unit:find("arena%d")) then
            return C.UnitFrames.ArenaWidth, C.UnitFrames.ArenaHeight
        elseif (unit:find("boss%d")) then
            return C.UnitFrames.BossWidth, C.UnitFrames.BossHeight
        end
    end
end
