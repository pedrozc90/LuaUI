local T, C, L = Tukui:unpack()
local UnitFrames = T.UnitFrames
local Class = select(2, UnitClass("player"))

----------------------------------------------------------------
-- Warlock Class Resources
----------------------------------------------------------------
if (Class ~= "WARLOCK") then return end
