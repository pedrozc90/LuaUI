local T, C, L = Tukui:unpack()
local UnitFrames = T.UnitFrames
local Class = select(2, UnitClass("player"))

local ESSENCES = 6

----------------------------------------------------------------
-- Evoker Class Resources
----------------------------------------------------------------
if (Class ~= "EVOKER") then return end
if (not T.Retail or not C.UnitFrames.ClassBar) then return end

local basePlayer = UnitFrames.Player

function UnitFrames:Player()
	-- first, we call the base function
	basePlayer(self)

	-- second, we edit it
	local ClassPower = self.ClassPower
	local Essence = _G[self:GetName().."Essence"]

	local Width, Height = C.UnitFrames.ClassBarWidth, C.UnitFrames.ClassBarHeight
	local PowerTexture = T.GetTexture(C["Textures"].UFPowerTexture)

	-- Holy Power
	Essence:ClearAllPoints()
	Essence:SetPoint(unpack(C.UnitFrames.ClassBarAnchor))
	Essence:SetWidth(Width)
	Essence:SetHeight(Height)

	local Spacing = 1
	local Size, Delta = T.EqualSizes(Width, ESSENCES, Spacing)

	for i = 1, ESSENCES do
		ClassPower[i]:ClearAllPoints()
		ClassPower[i]:SetHeight(Height)
		ClassPower[i]:SetStatusBarColor(unpack(T.Colors.power["ESSENCE"]))
		ClassPower[i]:SetStatusBarTexture(PowerTexture)
		ClassPower[i]:CreateBackdrop()
		ClassPower[i].Backdrop:SetOutside()

		if ((Delta > 0) and (i <= Delta)) then
			ClassPower[i]:SetWidth(Size + 1)
		else
			ClassPower[i]:SetWidth(Size)
		end

		if (i == 1) then
			ClassPower[i]:SetPoint("TOPLEFT", Essence, "TOPLEFT", 0, 0)
		else
			ClassPower[i]:SetPoint("LEFT", ClassPower[i-1], "RIGHT", Spacing, 0)
		end
	end
end
