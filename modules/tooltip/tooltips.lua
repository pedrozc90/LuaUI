local T, C, L = Tukui:unpack()
local Tooltips = T.Tooltips

----------------------------------------------------------------
-- Tooltips
----------------------------------------------------------------
local baseCreateAnchor = Tooltips.CreateAnchor
local baseSetTooltipDefaultAnchor = Tooltips.SetTooltipDefaultAnchor
local baseSkinHealthBar = Tooltips.SkinHealthBar
local baseEnable = Tooltips.Enable

function Tooltips:CreateAnchor()
	-- first, we call the base function
	baseCreateAnchor(self)

	-- second, we edit it
	local Anchor = self.Anchor

	Anchor:ClearAllPoints()
	Anchor:SetPoint("BOTTOMRIGHT", UIParent, "BOTTOMRIGHT", -C.Lua.ScreenMargin, 177)
	Anchor:SetSize(200, 21)
end

function Tooltips:SetTooltipDefaultAnchor(parent)
	-- first, we call the base function
	baseSetTooltipDefaultAnchor(self, parent)

	-- second, we edit it
	local Anchor = Tooltips.Anchor

	if (C.Tooltips.MouseOver) then
		if (parent ~= UIParent) then
			self:ClearAllPoints()
			self:SetPoint("BOTTOMRIGHT", Anchor, "TOPRIGHT", 0, 9)
		else
			self:SetOwner(parent, "ANCHOR_CURSOR")
		end
	else
		self:ClearAllPoints()
		self:SetPoint("BOTTOMRIGHT", Anchor, "TOPRIGHT", 0, 9)
	end
end

function Tooltips:SkinHealthBar()
	-- first, we call the base function
	baseSkinHealthBar(self)

	-- second, we edit it
	local HealthBar = GameTooltipStatusBar

	HealthBar:ClearAllPoints()
	HealthBar:SetPoint("BOTTOMLEFT", HealthBar:GetParent(), "TOPLEFT", 0, 2)
	HealthBar:SetPoint("BOTTOMRIGHT", HealthBar:GetParent(), "TOPRIGHT", 0, 2)
	HealthBar:SetStatusBarTexture(T.GetTexture(C.Textures.TTHealthTexture))
	HealthBar.Backdrop:CreateShadow()

	if (HealthBar.Backdrop.Shadow) then
		HealthBar.Backdrop.Shadow:Kill()
	end

	if (C.Tooltips.UnitHealthText) then
		HealthBar.Text:SetFontObject(T.GetFont(C.Tooltips.HealthFont))
		HealthBar.Text:SetPoint("CENTER", HealthBar, "CENTER", 0, 6)
	end
end

function Tooltips:Enable()
	-- first, we call the base function
	baseEnable(self)

	if (C.Tooltips.ShowSpellID) then
		self:AddSpellID()
	end
end
