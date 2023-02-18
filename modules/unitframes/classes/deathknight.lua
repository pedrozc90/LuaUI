local T, C, L = Tukui:unpack()
local UnitFrames = T.UnitFrames
local Class = select(2, UnitClass("player"))

----------------------------------------------------------------
-- DeathKnight Class Resources
----------------------------------------------------------------
if (Class ~= "DEATHKNIGHT") then return end

local basePlayer = UnitFrames.Player

function UnitFrames:Player()
	-- first, we call the base function
	basePlayer(self)

	-- second, we edit it
	local Runes = self.Runes

	local PlayerWidth, _ = unpack(C.Units.Player)

	-- Runes
	Runes:ClearAllPoints()
	Runes:SetPoint("BOTTOMLEFT", self, "TOPLEFT", 0, 3)
	Runes:SetWidth(PlayerWidth)
	Runes:SetHeight(5)
	Runes.Backdrop:Kill()

	local Max = 6
	local Spacing = 3
	local Size, Delta = T.EqualSizes(Runes:GetWidth(), Max, Spacing)

	for i = 1, Max do
		Runes[i]:ClearAllPoints()
		Runes[i]:SetHeight(Runes:GetHeight())
		Runes[i]:SetStatusBarColor(unpack(T.Colors.power["RUNES"]))
		Runes[i]:CreateBackdrop()
		Runes[i].Backdrop:SetOutside()

		-- Runes[i].bg:SetAlpha(0.1)

		if ((Delta > 0) and (i <= Delta)) then
			Runes[i]:SetWidth(Size + 1)
		else
			Runes[i]:SetWidth(Size)
		end

		if (i == 1) then
			Runes[i]:SetPoint("TOPLEFT", Runes, "TOPLEFT", 0, 0)
		else
			Runes[i]:SetPoint("LEFT", Runes[i-1], "RIGHT", Spacing, 0)
		end
	end

	-- Runes.PostUpdate = UnitFrames.RunesPostUpdate
	Runes.colorSpec = true
end
