local T, C, L = Tukui:unpack()
local Panels = T.Panels
local ThreatBar = T.Miscellaneous.ThreatBar

----------------------------------------------------------------
-- Threat Bar
----------------------------------------------------------------
local baseCreate = ThreatBar.Create

function ThreatBar:Create()

	-- first, call the base function
	baseCreate(self)

	-- second, we edit it
	local DataTextRight = Panels.DataTextRight

	local Texture = T.GetTexture(C.Lua.Texture or "Blank")

	self:SetPoint("TOPLEFT", DataTextRight, "TOPLEFT", 2, -2)
	self:SetPoint("BOTTOMRIGHT", DataTextRight, "BOTTOMRIGHT", -2, 2)
	self:SetFrameLevel(DataTextRight:GetFrameLevel() + 2)
	self:SetFrameStrata("HIGH")
	self:SetStatusBarTexture(Texture)
	self:SetMinMaxValues(0, 100)
	self:SetAlpha(0)
	
	self.Backdrop:SetFrameLevel(self:GetFrameLevel() - 1)
	self.Backdrop:SetOutside()
	self.Backdrop:SetTemplate()
	self.Backdrop:CreateShadow()

	self.Text:SetFont(C.Medias.Font, 12)
	self.Text:Point("RIGHT", self, -30, 0)
	self.Text:SetShadowColor(0, 0, 0)
	self.Text:SetShadowOffset(1.25, -1.25)

	self.Title:SetFont(C.Medias.Font, 12)
	self.Title:Point("LEFT", self, 30, 0)
	self.Title:SetShadowColor(0, 0, 0)
	self.Title:SetShadowOffset(1.25, -1.25)

	self.Background:Point("TOPLEFT", self, 0, 0)
	self.Background:Point("BOTTOMRIGHT", self, 0, 0)
	self.Background:SetColorTexture(unpack(C.General.BackdropColor))
end
