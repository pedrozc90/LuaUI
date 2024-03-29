local T, C, L = Tukui:unpack()
local UnitFrames = T.UnitFrames

local class = select(2, UnitClass("player"))

-- percentages at which bar should change color
local STAGGER_YELLOW_TRANSITION =  _G.STAGGER_YELLOW_TRANSITION or 0.3
local STAGGER_RED_TRANSITION = _G.STAGGER_RED_TRANSITION or 0.6

-- table indices of bar colors
local STAGGER_GREEN_INDEX = _G.STAGGER_GREEN_INDEX or 1
local STAGGER_YELLOW_INDEX = _G.STAGGER_YELLOW_INDEX or 2
local STAGGER_RED_INDEX = _G.STAGGER_RED_INDEX or 3

local HARMONY_ASCENSION = 6
local HARMONY_NO_TALENT = 5

----------------------------------------------------------------
-- Monk Class Resources
----------------------------------------------------------------
if (class ~= "MONK" or not C.UnitFrames.ClassBar) then return end

-- post update stagger bar
local PostUpdateStagger = function(self, cur, max)
	local perc = cur / max
	local colors = T.Colors.power["STAGGER"]

	local r, g, b
	if (perc >= STAGGER_RED_TRANSITION) then
		r, g, b = unpack(colors[STAGGER_RED_INDEX or 3])	-- red
	elseif (perc > STAGGER_YELLOW_TRANSITION) then
		r, g, b = unpack(colors[STAGGER_YELLOW_INDEX or 2])	-- yellow
	else
		r, g, b = unpack(colors[STAGGER_GREEN_INDEX or 1])	-- green
	end

	self:SetStatusBarColor(r, g, b)
	self.Value:SetFormattedText("%s / %s - %.1f%%", T.ShortValue(cur), T.ShortValue(max), 100 * (cur / max))

	if (cur ~= 0) then
		self:Show()
	else
		self:Hide()
	end
end

local basePlayer = UnitFrames.Player

function UnitFrames:Player()
	-- first, we call the base function
	basePlayer(self)

	-- second, we edit it
	local Harmony = self.HarmonyBar

	local Width, Height = C.UnitFrames.ClassBarWidth, C.UnitFrames.ClassBarHeight

	local PowerTexture = T.GetTexture(C.Textures.UFPowerTexture)
	local Font, FontSize, FontStyle = C.Medias.PixelFont, 12, "MONOCHROMEOUTLINE"

	-- Harmony Bar
	Harmony:ClearAllPoints()
	-- Harmony:SetPoint("BOTTOMLEFT", self, "TOPLEFT", 0, 3)
	-- Harmony:SetWidth(PlayerWidth)
	-- Harmony:SetHeight(5)
	Harmony:SetPoint(unpack(C.UnitFrames.ClassBarAnchor))
	Harmony:SetWidth(Width)
	Harmony:SetHeight(Height)

	local Spacing = 1
	local SizeAscension, DeltaAscension = T.EqualSizes(Width, HARMONY_ASCENSION, Spacing)
	local SizeNoTalent, DeltaNoTalent = T.EqualSizes(Width, HARMONY_NO_TALENT, Spacing)

	for i = 1, HARMONY_ASCENSION do
		Harmony[i]:ClearAllPoints()
		Harmony[i]:SetHeight(Height)
		Harmony[i]:SetWidth(SizeAscension)
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

		if (i == 1) then
			Harmony[i]:SetPoint("TOPLEFT", Harmony, "TOPLEFT", 0, 0)
		else
			Harmony[i]:SetPoint("LEFT", Harmony[i-1], "RIGHT", Spacing, 0)
		end
	end

	-- Stagger Bar
	local Stagger = CreateFrame("StatusBar", self:GetName() .. "StaggerBar", self)
	Stagger:SetPoint(unpack(C.UnitFrames.ClassBarAnchor))
	Stagger:SetWidth(Width)
	Stagger:SetHeight(Height)
	Stagger:SetStatusBarTexture(PowerTexture)
	Stagger:CreateBackdrop()
	Stagger.Backdrop:SetOutside()

	Stagger.Background = Stagger:CreateTexture(nil, "BORDER")
	Stagger.Background:SetAllPoints()
	Stagger.Background:SetColorTexture(unpack(C.General.BackgroundColor))

	Stagger.Value = Stagger:CreateFontString(nil, "OVERLAY")
	Stagger.Value:SetPoint("CENTER", Stagger, "CENTER", 0, 0)
	Stagger.Value:SetFont(C.Medias.Font, 12)
	Stagger.Value:SetJustifyH("CENTER")
	Stagger.Value:SetTextColor(.84,.75,.65)

	Stagger.PostUpdate = PostUpdateStagger

	-- Register with oUF
	self.Stagger = Stagger
end
