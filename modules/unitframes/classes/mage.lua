local T, C, L = Tukui:unpack()
local UnitFrames = T.UnitFrames
local Class = select(2, UnitClass("player"))

----------------------------------------------------------------
-- Mage Class Resources
----------------------------------------------------------------
if (Class ~= "MAGE") then return end
