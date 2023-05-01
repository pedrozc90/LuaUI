local T, C, L = Tukui:unpack()
local UnitFrames = T.UnitFrames

local class = select(2, UnitClass("player"))

----------------------------------------------------------------
-- DemonHunter Class Resources
----------------------------------------------------------------
if (class ~= "DEMONHUNTER") then return end
