local T, C, L = Tukui:unpack()
local UnitFrames = T.UnitFrames
local Class = select(2, UnitClass("player"))

local ARCANE_CHARGES = 4

----------------------------------------------------------------
-- Mage Class Resources
----------------------------------------------------------------
if (Class ~= "MAGE") then return end

local basePlayer = UnitFrames.Player

function UnitFrames:Player()
	-- first, we call the base function
	basePlayer(self)

	-- second, we edit it
	local ArcaneChargeBar = self.ArcaneChargeBar

	local Width, Height = C.UnitFrames.ClassBarWidth, C.UnitFrames.ClassBarHeight

	-- Arcane Charges
	ArcaneChargeBar:ClearAllPoints()
	-- ArcaneChargeBar:SetPoint("BOTTOMLEFT", self, "TOPLEFT", 0, 3)
	-- ArcaneChargeBar:SetWidth(PlayerWidth)
	-- ArcaneChargeBar:SetHeight(5)
	ArcaneChargeBar:SetPoint(unpack(C.UnitFrames.ClassBarAnchor))
	ArcaneChargeBar:SetWidth(Width)
	ArcaneChargeBar:SetHeight(Height)

	local Spacing = 3
	local Size, Delta = T.EqualSizes(Width, ARCANE_CHARGES, Spacing)

	for i = 1, ARCANE_CHARGES do
		ArcaneChargeBar[i]:ClearAllPoints()
		ArcaneChargeBar[i]:SetHeight(Height)
		ArcaneChargeBar[i]:CreateBackdrop()
		ArcaneChargeBar[i].Backdrop:SetOutside()

		if ((Delta > 0) and (i <= Delta)) then
			ArcaneChargeBar[i]:SetWidth(Size + 1)
		else
			ArcaneChargeBar[i]:SetWidth(Size)
		end

		if (i == 1) then
			ArcaneChargeBar[i]:SetPoint("TOPLEFT", ArcaneChargeBar, "TOPLEFT", 0, 0)
		else
			ArcaneChargeBar[i]:SetPoint("LEFT", ArcaneChargeBar[i-1], "RIGHT", Spacing, 0)
		end
	end
end
