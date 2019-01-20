local T, C, L = Tukui:unpack()
local UnitFrames = T.UnitFrames
local Class = select(2, UnitClass("player"))

----------------------------------------------------------------
-- Hunter Class Resources
----------------------------------------------------------------
if (Class ~= "HUNTER") then return end