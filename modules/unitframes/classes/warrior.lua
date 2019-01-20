local T, C, L = Tukui:unpack()
local UnitFrames = T.UnitFrames
local Class = select(2, UnitClass("player"))

----------------------------------------------------------------
-- Warrior Class Resources
----------------------------------------------------------------
if (Class ~= "WARRIOR") then return end