local T, C, L = Tukui:unpack()
local UnitFrames = T.UnitFrames
local Class = select(2, UnitClass("player"))

----------------------------------------------------------------
-- DemonHunter Class Resources
----------------------------------------------------------------
if (Class ~= "DEMONHUNTER") then return end
