local T, C, L = Tukui:unpack()
local UnitFrames = T.UnitFrames

local class = select(2, UnitClass("player"))

----------------------------------------------------------------
-- Warlock Class Resources
----------------------------------------------------------------
if (class ~= "WARLOCK" or not T.Retail or not C.UnitFrames.ClassBar) then return end

local SOUL_SHARDS = 5

local basePlayer = UnitFrames.Player

function UnitFrames:Player()
	-- first, we call the base function
	basePlayer(self)

	-- second, we edit it
	local SoulShards = self.SoulShards

	local Width, Height = C.UnitFrames.ClassBarWidth, C.UnitFrames.ClassBarHeight

	-- Warlock Class Bar
	SoulShards:ClearAllPoints()
	-- SoulShards:SetPoint("BOTTOMLEFT", self, "TOPLEFT", 0, 3)
	-- SoulShards:SetWidth(PlayerWidth)
	-- SoulShards:SetHeight(5)
	SoulShards:SetPoint(unpack(C.UnitFrames.ClassBarAnchor))
	SoulShards:SetWidth(Width)
	SoulShards:SetHeight(Height)

	local Spacing = 1
	local Size, Delta = T.EqualSizes(Width, SOUL_SHARDS, Spacing)

	for i = 1, SOUL_SHARDS do
		SoulShards[i]:ClearAllPoints()
		SoulShards[i]:SetHeight(Height)

		if ((Delta > 0) and (i <= Delta)) then
			SoulShards[i]:SetWidth(Size + 1)
		else
			SoulShards[i]:SetWidth(Size)
		end

		if i == 1 then
			SoulShards[i]:SetPoint("TOPLEFT", SoulShards, "TOPLEFT", 0, 0)
		else
			SoulShards[i]:SetPoint("LEFT", SoulShards[i-1], "RIGHT", Spacing, 0)
		end
	end
end
