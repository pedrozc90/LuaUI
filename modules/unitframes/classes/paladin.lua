local T, C, L = Tukui:unpack()
local UnitFrames = T.UnitFrames
local Class = select(2, UnitClass("player"))

----------------------------------------------------------------
-- Paladin Class Resources
----------------------------------------------------------------
if (Class ~= "PALADIN") then return end

local function Player(self)
	local HolyPower = self.HolyPower
	local Shadow = self.Shadow

	local PlayerWidth, PlayerHeight = unpack(C.Units.Player)
	local PowerTexture = T.GetTexture(C["Textures"].UFPowerTexture)

	-- Holy Power
	HolyPower:ClearAllPoints()
	HolyPower:Point("BOTTOMLEFT", self, "TOPLEFT", 0, 7)
	HolyPower:Width(PlayerWidth)
	HolyPower:Height(3)
	HolyPower:SetBackdrop(nil)
	-- HolyPower:CreateBackdrop()
	
	local Max = 5
	local Spacing = 7
	local Size, Delta = T.EqualSizes(HolyPower:GetWidth(), Max, Spacing)

	for i = 1, Max do
		HolyPower[i]:ClearAllPoints()
		HolyPower[i]:Height(HolyPower:GetHeight())
		HolyPower[i]:SetStatusBarColor(unpack(T.Colors.power["HOLY_POWER"]))
		-- HolyPower[i]:SetStatusBarColor(0.89, 0.88, 0.06)
		HolyPower[i]:CreateBackdrop()

		if ((Delta > 0) and (i <= Delta)) then
			HolyPower[i]:Width(Size + 1)
		else
			HolyPower[i]:Width(Size)
		end

		if i == 1 then
			HolyPower[i]:Point("TOPLEFT", HolyPower, "TOPLEFT", 0, 0)
		else
			HolyPower[i]:Point("LEFT", HolyPower[i-1], "RIGHT", Spacing, 0)
		end
	end

	-- Remove Shadows
	Shadow:Kill()
end
hooksecurefunc(UnitFrames, "Player", Player)
