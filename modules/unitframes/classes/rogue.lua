local T, C, L = Tukui:unpack()
local UnitFrames = T.UnitFrames

local class = select(2, UnitClass("player"))

----------------------------------------------------------------
-- Rogue Class Resources
----------------------------------------------------------------
if (class ~= "ROGUE" or not C.UnitFrames.ClassBar) then return end
