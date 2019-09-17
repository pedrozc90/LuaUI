local T, C, L = Tukui:unpack()
local UnitFrames = T.UnitFrames

----------------------------------------------------------------
-- TargetOfTarget
----------------------------------------------------------------
local baseTargetOfTarget = UnitFrames.TargetOfTarget

function UnitFrames:TargetOfTarget()

    -- first, call the base function
    baseTargetOfTarget(self)

    -- second, we edit it
    local Health = self.Health
	local Name =  self.Name
    local RaidIcon = self.RaidTargetIndicator
    
    local FrameWidth, FrameHeight = unpack(C["Units"].TargetOfTarget)
    local HealthTexture = T.GetTexture(C["Textures"].UFHealthTexture)
    local PowerTexture = T.GetTexture(C["Textures"].UFPowerTexture)
    local Font, FontSize, FontStyle = C["Medias"].PixelFont, 12, "MONOCHROMEOUTLINE"

	self:SetBackdrop(nil)
    self.Shadow:Kill()
    self.Panel:Kill()

	-- Health
    Health:ClearAllPoints()
    Health:Point("TOPLEFT", self, "TOPLEFT", 0, 0)
    Health:Point("TOPRIGHT", self, "TOPRIGHT", 0, 0)
    Health:Height(FrameHeight - 6)
    Health:SetFrameLevel(3)
    Health:CreateBackdrop()
    Health.Backdrop:SetBorder()
    Health.Backdrop:SetOutside(nil, 2, 2)

    Health.Background:SetAllPoints()
    Health.Background:SetColorTexture(.05, .05, .05)
    
    Health.frequentUpdate = true
    if (C.Lua.UniColor) then
        Health.colorTapping = false
        Health.colorDisconnected = false
        Health.colorClass = false
        Health.colorReaction = false
        Health:SetStatusBarColor(unpack(C.General.BorderColor))
        Health.Background:SetVertexColor(unpack(C.General.BackdropColor))
    else
        Health.colorTapping = true
        Health.colorDisconnected = true
        Health.colorClass = true
        Health.colorReaction = true
    end

    -- Power
    local Power = CreateFrame("StatusBar", nil, self)
    Power:Point("TOPLEFT", Health, "BOTTOMLEFT", 0, -3)
    Power:Point("TOPRIGHT", Health, "BOTTOMRIGHT", 0, -3)
    Power:Height(3)
    Power:SetFrameStrata(self:GetFrameStrata())
    Power:SetStatusBarTexture(PowerTexture)
    Power:CreateBackdrop()
    Power.Backdrop:SetBorder()
    Power.Backdrop:SetOutside(nil, 2, 2)

	Power.Background = Power:CreateTexture(nil, "BORDER")
	Power.Background:SetAllPoints()
    Power.Background:SetColorTexture(.05, .05, .05)
	Power.Background.multiplier = 0.3

	Power.frequentUpdates = true
    Power.colorDisconnected = true
    if (C.Lua.UniColor) then
        Power.colorPower = false
        Power.colorClass = true
        Power.Background.multiplier = 0.1
    else
        Power.colorPower = true
        Power.colorClass = false
    end

    -- Name
    Name:ClearAllPoints()
    Name:SetParent(Health)
	Name:Point("CENTER", Health, "CENTER", 0, 1)
    Name:SetJustifyH("CENTER")

    self:Tag(Name, "[Tukui:GetNameColor][Tukui:NameMedium] [Tukui:DiffColor][level]")

	-- Raid Icon
    RaidIcon:ClearAllPoints()
    RaidIcon:Point("CENTER", self, "TOP", 0, 3)
    RaidIcon:Size(16, 16)

    self.Power = Power
end
