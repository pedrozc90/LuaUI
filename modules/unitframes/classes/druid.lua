local T, C, L = Tukui:unpack()
local UnitFrames = T.UnitFrames
local Class = select(2, UnitClass("player"))

----------------------------------------------------------------
-- Druid Class Resources
----------------------------------------------------------------
if (Class ~= "DRUID") then return end