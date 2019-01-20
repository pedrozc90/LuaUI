local T, C, L = Tukui:unpack()
local UnitFrames = T.UnitFrames
local Class = select(2, UnitClass("player"))

----------------------------------------------------------------
-- Monk Class Resources
----------------------------------------------------------------
if (Class ~= "MONK") then return end

local function Player(self)
	local Harmony = self.HarmonyBar
	local Shadow = self.Shadow
	
	local PlayerWidth, PlayerHeight = unpack(C.Units.Player)

	-- Harmony Bar
	Harmony:ClearAllPoints()
	Harmony:Point("BOTTOMLEFT", self, "TOPLEFT", 0, 7)
	Harmony:Width(PlayerWidth)
	Harmony:Height(3)
	Harmony:SetBackdrop(nil)
	-- Harmony:CreateBackdrop()

	local Spacing = 7
	local SizeAscension, DeltaAscension = T.EqualSizes(Harmony:GetWidth(), 6, Spacing)
	local SizeNoTalent, DeltaNoTalent = T.EqualSizes(Harmony:GetWidth(), 5, Spacing)

	for i = 1, 6 do
		Harmony[i]:ClearAllPoints()
		Harmony[i]:Height(Harmony:GetHeight())
		Harmony[i]:Width(SizeAscension)
		Harmony[i]:CreateBackdrop()

		if ((DeltaNoTalent > 0) and (i <= DeltaNoTalent)) then
			Harmony[i].NoTalent = SizeNoTalent + 1
		else
			Harmony[i].NoTalent = SizeNoTalent
		end

		if ((DeltaAscension > 0) and (i <= DeltaAscension)) then
			Harmony[i].Ascension = SizeAscension + 1
		else
			Harmony[i].Ascension = SizeAscension
		end

		if i == 1 then
			Harmony[i]:Point("TOPLEFT", Harmony, "TOPLEFT", 0, 0)
		else
			Harmony[i]:Point("LEFT", Harmony[i-1], "RIGHT", Spacing, 0)
		end
	end

	-- Remove Shadows
	Shadow:Kill()
end
hooksecurefunc(UnitFrames, "Player", Player)