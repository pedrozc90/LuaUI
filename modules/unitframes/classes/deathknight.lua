local T, C, L = Tukui:unpack()
local UnitFrames = T.UnitFrames
local Class = select(2, UnitClass("player"))

----------------------------------------------------------------
-- DeathKnight Class Resources
----------------------------------------------------------------
if (Class ~= "DEATHKNIGHT") then return end

local function Player(self)
	local Runes = self.Runes
	local Shadow = self.Shadow
	
	local PlayerWidth, PlayerHeight = unpack(C.Units.Player)

	-- Runes
	Runes:ClearAllPoints()
	Runes:Point("BOTTOMLEFT", self, "TOPLEFT", 0, 7)
	Runes:Width(PlayerWidth)
	Runes:Height(3)
	Runes:SetBackdrop(nil)
	-- Runes:CreateBackdrop()

	local Max = 6
	local Spacing = 7
	local Size, Delta = T.EqualSizes(Runes:GetWidth(), Max, Spacing)

	for i = 1, Max do
		Runes[i]:ClearAllPoints()
		Runes[i]:SetHeight(Runes:GetHeight())
		Runes[i]:SetStatusBarColor(unpack(T.Colors.power["RUNES"]))
		Runes[i]:CreateBackdrop()

		Runes[i].bg:SetAlpha(0.1)

		if ((Delta > 0) and (i <= Delta)) then
			Runes[i]:Width(Size + 1)
		else
			Runes[i]:Width(Size)
		end

		if i == 1 then
			Runes[i]:Point("TOPLEFT", Runes, "TOPLEFT", 0, 0)
		else
			Runes[i]:Point("LEFT", Runes[i-1], "RIGHT", Spacing, 0)
		end
	end

	-- Runes.PostUpdate = UnitFrames.RunesPostUpdate
	Runes.PostUpdate = function() end
	Runes.colorSpec = true

	-- Remove Shadows
	Shadow:Kill()
end
hooksecurefunc(UnitFrames, "Player", Player)