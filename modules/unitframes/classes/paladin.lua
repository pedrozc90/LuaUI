local T, C, L = Tukui:unpack()
local UnitFrames = T.UnitFrames
local Class = select(2, UnitClass("player"))

----------------------------------------------------------------
-- Paladin Class Resources
----------------------------------------------------------------
if (Class ~= "PALADIN") then return end
