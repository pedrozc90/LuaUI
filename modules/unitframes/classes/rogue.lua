local T, C, L = Tukui:unpack()
local UnitFrames = T.UnitFrames
local Class = select(2, UnitClass("player"))

----------------------------------------------------------------
-- Rogue Class Resources
----------------------------------------------------------------
if (Class ~= "ROGUE") then return end
