local T, C, L = Tukui:unpack()
local UnitFrames = T.UnitFrames
local Class = select(2, UnitClass("player"))

----------------------------------------------------------------
-- Priest Class Resources
----------------------------------------------------------------
if (Class ~= "PRIEST") then return end
