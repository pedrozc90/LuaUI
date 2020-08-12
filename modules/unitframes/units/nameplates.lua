local T, C, L = Tukui:unpack()
local UnitFrames = T.UnitFrames

----------------------------------------------------------------
-- NamePlates
----------------------------------------------------------------
local baseNameplates = UnitFrames.Nameplates

function UnitFrames:Nameplates()

    -- first, call the base function
    baseNameplates(self)

    -- second, we edit it
    local Health = self.Health
    local Power = self.Power
    local Name = self.Name
    local Debuffs = self.Debuffs
    local CastBar = self.Castbar
    local RaidIcon = self.RaidTargetIndicator

    local FrameWidth = C["NamePlates"].Width
    local FrameHeight = C["NamePlates"].Height
    local HealthTexture = T.GetTexture(C["Textures"].NPHealthTexture)
	local PowerTexture = T.GetTexture(C["Textures"].NPPowerTexture)
    local CastTexture = T.GetTexture(C["Textures"].NPCastTexture)
    local Font, FontSize, FontStyle = C["Medias"].PixelFont, 14, "MONOCHROMEOUTLINE"

	self:Size(FrameWidth, FrameHeight)
    self:SetBackdrop(nil)
    self.Shadow:Kill()
    -- self:CreateBackdrop()

    -- Health
	Health:ClearAllPoints()
    Health:Point("TOPLEFT", self, "TOPLEFT", 0, 0)
    Health:Point("TOPRIGHT", self, "TOPRIGHT", 0, 0)
    Health:Height(FrameHeight)
    Health:CreateBackdrop()
    Health.Backdrop:SetTripleBorder()
    Health.Backdrop:SetOutside(nil, 2, 2)

	Health.Background:SetAllPoints()
	Health.Background:SetColorTexture(.05, .05, .05)

    Health.frequentUpdates = true
    Health.colorTapping = true
	Health.colorReaction = true
	Health.colorDisconnected = true
	Health.colorClass = true
	Health.Smooth = true
    
    -- Power
    if (C.NamePlates.PowerBar) then   
        Health:Height(FrameHeight - 4)

        Power:ClearAllPoints()
        Power:Point("TOPLEFT", Health, "BOTTOMLEFT", 0, -3)
        Power:Point("TOPRIGHT", Health, "BOTTOMRIGHT", 0, -3)
        Power:Height(1)
        Power:SetFrameLevel(Health:GetFrameLevel())
        Power:CreateBackdrop()
        
        Power.Background:SetAllPoints()
        Power.Background:SetColorTexture(.05, .05, .05)

        Power.frequentUpdates = true
        Power.IsHidden = false
        Power.colorPower = true
        Power.Smooth = true
    else
        Power:Kill()
    end
    
    -- Name
    Name:ClearAllPoints()
    Name:Point("BOTTOM", Health, "TOP", 0, 4)
    Name:SetFont(Font, FontSize, FontStyle)
	Name:SetJustifyH("LEFT")

	self:Tag(Name, "[Tukui:GetNameHostilityColor][Tukui:NameLong] [Tukui:Classification][Tukui:DiffColor][level]")

    -- Debuffs
    Debuffs:ClearAllPoints()
    Debuffs:Point("BOTTOMLEFT", self, "TOPLEFT", 0, 18)
    Debuffs.size = C["NamePlates"].DebuffSize
	Debuffs.num = 7
	Debuffs.numRow = 1
	Debuffs.spacing = C["NamePlates"].DebuffSpacing
	Debuffs.initialAnchor = "BOTTOMLEFT"
	Debuffs["growth-y"] = "UP"
	Debuffs["growth-x"] = "RIGHT"
    Debuffs:Height(Debuffs.size)
    Debuffs:Width(Debuffs.num * Debuffs.size + (Debuffs.num - 1) * Debuffs.spacing)
    
    Debuffs.PostCreateIcon = UnitFrames.PostCreateAura
    Debuffs.PostUpdateIcon = UnitFrames.PostUpdateAura

    -- CastBar
    if (C.NamePlates.NameplateCastBar) then
        CastBar:ClearAllPoints()
        CastBar:Point("TOPRIGHT", self, "BOTTOMRIGHT", 0, -7)
        CastBar:Width(self:GetWidth() - C.NamePlates.CastHeight - 7)
        CastBar:Height(C.NamePlates.CastHeight)
        CastBar:SetStatusBarTexture(CastTexture)
        CastBar:CreateBackdrop()
        CastBar.Backdrop:SetTripleBorder()
        CastBar.Backdrop:SetOutside(nil, 2, 2)

        CastBar.Background:SetAllPoints(CastBar)
        CastBar.Background:SetVertexColor(0.05, 0.05, 0.05)

        CastBar.Button:ClearAllPoints()
        CastBar.Button:Point("RIGHT", CastBar, "LEFT", -5, 0)
        CastBar.Button:Size(CastBar:GetHeight() + 4)
        CastBar.Button:SetTemplate()
        CastBar.Button.Shadow:Kill()

        CastBar.Text:ClearAllPoints()
        CastBar.Text:Point("CENTER", CastBar, "CENTER", 0, 1)
        CastBar.Text:Width(CastBar:GetWidth())
        CastBar.Text:SetJustifyH("CENTER")
    end

    -- Raid Icon
    RaidIcon:ClearAllPoints()
    RaidIcon:Point("RIGHT", Name, "LEFT", -5, -1)
    RaidIcon:Size(18, 18)
    
end
