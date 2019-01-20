local T, C, L = Tukui:unpack()
local UnitFrames = T.UnitFrames
local Class = select(2, UnitClass("player"))

----------------------------------------------------------------
-- Shaman Class Resources
----------------------------------------------------------------
if (Class ~= "SHAMAN") then return end