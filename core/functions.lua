local T, C, L = Tukui:unpack()

local format = string.format
local floor = math.floor
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
	return ceil(mult * number) / mult
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