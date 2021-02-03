local T, C, L = Tukui:unpack()
local UnitFrames = T.UnitFrames
local Class = select(2, UnitClass("player"))

----------------------------------------------------------------
-- Paladin Class Resources
----------------------------------------------------------------
if (Class ~= "PALADIN") then return end

local basePlayer = UnitFrames.Player

function UnitFrames:Player()

	-- first, we call the base function
    basePlayer(self)

    -- second, we edit it
	local HolyPower = self.HolyPower

	local PlayerWidth, _ = unpack(C.Units.Player)
	local PowerTexture = T.GetTexture(C["Textures"].UFPowerTexture)

	-- Holy Power
	HolyPower:ClearAllPoints()
	HolyPower:SetPoint("BOTTOMLEFT", self, "TOPLEFT", 0, 3)
	HolyPower:SetWidth(PlayerWidth)
	HolyPower:SetHeight(5)

	local Max = 5
	local Spacing = 3
	local Size, Delta = T.EqualSizes(HolyPower:GetWidth(), Max, Spacing)

	for i = 1, Max do
		HolyPower[i]:ClearAllPoints()
		HolyPower[i]:SetHeight(HolyPower:GetHeight())
		HolyPower[i]:SetStatusBarColor(unpack(T.Colors.power["HOLY_POWER"]))
		-- HolyPower[i]:SetStatusBarColor(0.89, 0.88, 0.06)
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
