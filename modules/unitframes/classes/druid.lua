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
	local DruidMana = self.DruidMana
	
    local Texture = T.GetTexture(C.Textures.UFPowerTexture)

	-- DruidMana:ClearAllPoints()
    -- DruidMana:SetFrameStrata(self.Health:GetFrameStrata())
	-- DruidMana:SetHeight(self.Power:GetHeight())
	-- DruidMana:SetPoint("LEFT")
	-- DruidMana:SetPoint("RIGHT")
	-- DruidMana:SetPoint("BOTTOM")
	-- DruidMana:SetStatusBarTexture(Texture)
	-- DruidMana:SetStatusBarColor(T.Colors.power["MANA"][1], T.Colors.power["MANA"][2], T.Colors.power["MANA"][3])

	-- DruidMana.bg = DruidMana:CreateTexture(nil, "BACKGROUND")
	-- DruidMana.bg:SetPoint("LEFT")
	-- DruidMana.bg:SetPoint("RIGHT")
	-- DruidMana.bg:SetPoint("BOTTOM")
	-- DruidMana.bg:SetPoint("TOP", 0, 1)
	-- DruidMana.bg:SetColorTexture(T.Colors.power["MANA"][1] * .2, T.Colors.power["MANA"][2] * .2, T.Colors.power["MANA"][3] * .2)
end
