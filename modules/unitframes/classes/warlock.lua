local T, C, L = Tukui:unpack()
local UnitFrames = T.UnitFrames
local Class = select(2, UnitClass("player"))

----------------------------------------------------------------
-- Warlock Class Resources
----------------------------------------------------------------
if (Class ~= "WARLOCK") then return end

local function Player(self)
	local SoulShards = self.SoulShards
	local Shadow = self.Shadow

	local PlayerWidth, PlayerHeight = unpack(C.Units.Player)

	-- Warlock Class Bar
	SoulShards:ClearAllPoints()
	SoulShards:Point("BOTTOMLEFT", self, "TOPLEFT", 0, 7)
	SoulShards:Width(PlayerWidth)
	SoulShards:Height(3)
	SoulShards:SetBackdrop(nil)

	local Max = 5
	local Spacing = 7
	local Size, Delta = T.EqualSizes(SoulShards:GetWidth(), Max, Spacing)

	for i = 1, Max do
		SoulShards[i]:ClearAllPoints()
		SoulShards[i]:SetHeight(SoulShards:GetHeight())
		SoulShards[i]:CreateBackdrop()

		if ((Delta > 0) and (i <= Delta)) then
			SoulShards[i]:Width(Size + 1)
		else
			SoulShards[i]:Width(Size)
		end

		if i == 1 then
			SoulShards[i]:SetPoint("TOPLEFT", SoulShards, "TOPLEFT", 0, 0)
		else
			SoulShards[i]:SetPoint("LEFT", SoulShards[i-1], "RIGHT", Spacing, 0)
		end
	end

	-- Remove Shadows
	Shadow:Kill()
end
hooksecurefunc(UnitFrames, "Player", Player)