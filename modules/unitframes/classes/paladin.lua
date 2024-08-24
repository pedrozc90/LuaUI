local T, C, L = Tukui:unpack()
local UnitFrames = T.UnitFrames

local HOLY_POWERS = _G.HOLY_POWERS or 5

local class = select(2, UnitClass("player"))

----------------------------------------------------------------
-- Paladin Class Resources
----------------------------------------------------------------
if (class ~= "PALADIN" or not T.Retail or not C.UnitFrames.ClassBar) then return end

local HOLY_POWERS = 5

local basePlayer = UnitFrames.Player

function UnitFrames:Player()
	-- first, we call the base function
	basePlayer(self)

	-- second, we edit it
	local HolyPower = self.HolyPower

	local Width, Height = C.UnitFrames.ClassBarWidth, C.UnitFrames.ClassBarHeight
	local PowerTexture = T.GetTexture(C["Textures"].UFPowerTexture)

	-- Holy Power
	HolyPower:ClearAllPoints()
	-- HolyPower:SetPoint("BOTTOMLEFT", self, "TOPLEFT", 0, 3)
	-- HolyPower:SetWidth(PlayerWidth)
	-- HolyPower:SetHeight(5)
	HolyPower:SetPoint(unpack(C.UnitFrames.ClassBarAnchor))
	HolyPower:SetWidth(Width)
	HolyPower:SetHeight(Height)

	local MAX = UnitPowerMax('player', Enum.PowerType.HolyPower)
	local Spacing = 1
	local Size, Delta = T.EqualSizes(Width, HOLY_POWERS, Spacing)

	for i = 1, MAX do
		HolyPower[i]:ClearAllPoints()
		HolyPower[i]:SetHeight(Height)
		HolyPower[i]:SetStatusBarColor(unpack(T.Colors.power["HOLY_POWER"]))
		HolyPower[i]:SetStatusBarTexture(PowerTexture)
		HolyPower[i]:CreateBackdrop()
		HolyPower[i].Backdrop:SetOutside()

		if ((Delta > 0) and (i <= Delta)) then
			HolyPower[i]:SetWidth(Size + 1)
		else
			HolyPower[i]:SetWidth(Size)
		end

		if (i == 1) then
			HolyPower[i]:SetPoint("TOPLEFT", HolyPower, "TOPLEFT", 0, 0)
		else
			HolyPower[i]:SetPoint("LEFT", HolyPower[i-1], "RIGHT", Spacing, 0)
		end
	end
end
