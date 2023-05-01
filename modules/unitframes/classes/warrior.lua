local T, C, L = Tukui:unpack()
local UnitFrames = T.UnitFrames

local class = select(2, UnitClass("player"))

----------------------------------------------------------------
-- Warrior Class Resources
----------------------------------------------------------------
if (class ~= "WARRIOR" or not C.UnitFrames.ClassBar) then return end
