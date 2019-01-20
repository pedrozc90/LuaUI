local T, C, L = Tukui:unpack()
local UnitFrames = T.UnitFrames
local Class = select(2, UnitClass("player"))

----------------------------------------------------------------
-- Mage Class Resources
----------------------------------------------------------------
if (Class ~= "MAGE") then return end

local function Player(self)
	local ArcaneChargeBar = self.ArcaneChargeBar
	local Shadow = self.Shadow

	local PlayerWidth, PlayerHeight = unpack(C.Units.Player)
	
	-- Arcane Charges
	ArcaneChargeBar:ClearAllPoints()
	ArcaneChargeBar:Point("BOTTOMLEFT", self, "TOPLEFT", 0, 7)
	ArcaneChargeBar:Width(PlayerWidth)
	ArcaneChargeBar:Height(3)
	ArcaneChargeBar:SetBackdrop(nil)
	-- ArcaneChargeBar:CreateBackdrop()

	local Max = 4
	local Spacing = 7
	local Size, Delta = T.EqualSizes(ArcaneChargeBar:GetWidth(), Max, Spacing)

	for i = 1, Max do
		ArcaneChargeBar[i]:ClearAllPoints()
		ArcaneChargeBar[i]:Height(ArcaneChargeBar:GetHeight())
		ArcaneChargeBar[i]:CreateBackdrop()

		if ((Delta > 0) and (i <= Delta)) then
			ArcaneChargeBar[i]:Width(Size + 1)
		else
			ArcaneChargeBar[i]:Width(Size)
		end

		if i == 1 then
			ArcaneChargeBar[i]:Point("TOPLEFT", ArcaneChargeBar, "TOPLEFT", 0, 0)
		else
			ArcaneChargeBar[i]:Point("LEFT", ArcaneChargeBar[i-1], "RIGHT", Spacing, 0)
		end
	end

	-- Remove Shadows
	Shadow:Kill()
end
hooksecurefunc(UnitFrames, "Player", Player)