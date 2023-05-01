local T, C, L = Tukui:unpack()
local UnitFrames = T.UnitFrames

local class = select(2, UnitClass("player"))

----------------------------------------------------------------
-- Shaman Class Resources
----------------------------------------------------------------
if (Class ~= "SHAMAN" or not C.UnitFrames.ClassBar) then return end
