local T, C, L = Tukui:unpack()
local UnitFrames = T.UnitFrames

local class = select(2, UnitClass("player"))

----------------------------------------------------------------
-- Druid Class Resources
----------------------------------------------------------------
if (class ~= "DRUID" or T.Retail) then return end

local basePlayer = UnitFrames.Player

function UnitFrames:Player()
	-- first, we call the base function
	basePlayer(self)

	-- second, we edit it
	local Health = self.Health
	local DruidMana = self.DruidMana
	if (DruidMana) then
		DruidMana:ClearAllPoints()
		DruidMana:SetPoint("BOTTOMLEFT", Health, "BOTTOMLEFT", 0, 0)
		DruidMana:SetPoint("BOTTOMRIGHT", Health, "BOTTOMRIGHT", 0, 0)
		DruidMana:SetHeight(2)
		DruidMana:CreateBackdrop()
    	DruidMana.Backdrop:SetOutside()
	end
end
