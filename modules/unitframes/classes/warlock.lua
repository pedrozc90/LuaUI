local T, C, L = Tukui:unpack()
local UnitFrames = T.UnitFrames
local Class = select(2, UnitClass("player"))

local SOUL_SHARDS = 5

----------------------------------------------------------------
-- Warlock Class Resources
----------------------------------------------------------------
if (Class ~= "WARLOCK") then return end

local basePlayer = UnitFrames.Player

function UnitFrames:Player()
	-- first, we call the base function
    basePlayer(self)

    -- second, we edit it
	local SoulShards = self.SoulShards

	local PlayerWidth, PlayerHeight = unpack(C.Units.Player)

	-- Warlock Class Bar
	SoulShards:ClearAllPoints()
	SoulShards:SetPoint("BOTTOMLEFT", self, "TOPLEFT", 0, 3)
	SoulShards:SetWidth(PlayerWidth)
	SoulShards:SetHeight(5)

	local Spacing = 1
	local Size, Delta = T.EqualSizes(SoulShards:GetWidth(), SOUL_SHARDS, Spacing)

	for i = 1, SOUL_SHARDS do
		SoulShards[i]:ClearAllPoints()
		SoulShards[i]:SetHeight(SoulShards:GetHeight())

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
