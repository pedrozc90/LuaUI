local T, C, L = Tukui:unpack()
local UnitFrames = T.UnitFrames
local Class = select(2, UnitClass("player"))

----------------------------------------------------------------
-- Monk Class Resources
----------------------------------------------------------------
if (Class ~= "MONK") then return end

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

local function Player(self)
	local Harmony = self.HarmonyBar
	local Shadow = self.Shadow
	
	local PlayerWidth, PlayerHeight = unpack(C.Units.Player)
	local PowerTexture = T.GetTexture(C["Textures"].UFPowerTexture)
	local Font, FontSize, FontStyle = C["Medias"].PixelFont, 12, "MONOCHROMEOUTLINE"

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

	-- Stagger Bar
	local Stagger = CreateFrame("StatusBar", self:GetName() .. "StaggerBar", self)
	Stagger:Point("CENTER", UIParent, "BOTTOM", 0, 288)
	Stagger:Width(225)
	Stagger:Height(10)
	Stagger:SetStatusBarTexture(PowerTexture)
	Stagger:CreateBackdrop("Default")

	Stagger.Background = Stagger:CreateTexture(nil, "BORDER")
	Stagger.Background:SetAllPoints()
	Stagger.Background:SetColorTexture(.05, .05, .05)

	Stagger.Value = Stagger:CreateFontString(nil, "OVERLAY")
	Stagger.Value:Point("CENTER", Stagger, "CENTER", 0, 2)
	Stagger.Value:SetFont(Font, FontSize, FontStyle)
	Stagger.Value:SetJustifyH("CENTER")
	Stagger.Value:SetTextColor(.84,.75,.65)
	
	Stagger.PostUpdate = PostUpdateStagger

	-- Register with oUF
	self.Stagger = Stagger
	self.Stagger.bg = Stagger.Background
end
hooksecurefunc(UnitFrames, "Player", Player)
