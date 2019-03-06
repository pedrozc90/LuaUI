local T, C, L = Tukui:unpack()
local UnitFrames = T.UnitFrames
local Panels = T.Panels

----------------------------------------------------------------
-- Target
----------------------------------------------------------------
local function Target(self)
    local Health = self.Health
    local Power = self.Power
    local Name = self.Name
    local AltPowerBar = self.AlternativePower
	local RaidIcon = self.RaidTargetIndicator
    local Threat = self.ThreatIndicator
    
    local FrameWidth, FrameHeight = unpack(C["Units"].Target)
    local HealthTexture = T.GetTexture(C["Textures"].UFHealthTexture)
	local PowerTexture = T.GetTexture(C["Textures"].UFPowerTexture)
    local CastTexture = T.GetTexture(C["Textures"].UFCastTexture)
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

    Health.Background:SetAllPoints()
    Health.Background:SetColorTexture(.05, .05, .05)

    Health.Value:ClearAllPoints()
    Health.Value:SetParent(Health)
    Health.Value:Point("RIGHT", Health, "RIGHT", -5, 1)
    Health.Value:SetJustifyH("LEFT")
    
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

    -- fix target status bar color
    Health.PreUpdate = UnitFrames.PreUpdateHealth

    -- Power
    Power:ClearAllPoints()
    Power:Point("TOPLEFT", Health, "BOTTOMLEFT", 0, -3)
    Power:Point("TOPRIGHT", Health, "BOTTOMRIGHT", 0, -3)
    Power:Height(3)
    Power:SetFrameLevel(Health:GetFrameLevel())
    Power:CreateBackdrop()

    Power.Background:SetAllPoints()
    Power.Background:SetColorTexture(.05, .05, .05)

    Power.Value:ClearAllPoints()
    Power.Value:SetParent(Health)
    Power.Value:Point("LEFT", Health, "LEFT", 5, 1)
    Power.Value:SetJustifyH("LEFT")

    Power.frequentUpdates = true
    Power.colorDisconnected = true
    if (C.Lua.UniColor) then
        Power.colorClass = not C.Lua.ColorPower
        Power.colorPower = C.Lua.ColorPower
        Power.Background.multiplier = 0.1
    else
        Power.colorClass = false
        Power.colorPower = true
    end

    -- Name
    Name:ClearAllPoints()
    Name:SetParent(Health)
	Name:Point("LEFT", Health, "LEFT", 5, 1)
    Name:SetJustifyH("LEFT")
    
    self:Tag(Name, "[Tukui:GetNameColor][Tukui:NameLong] [Tukui:Classification][Tukui:DiffColor][level]")

    -- Alternative Power Bar
    AltPowerBar:ClearAllPoints()
    AltPowerBar:Point("BOTTOMLEFT", self, "TOPLEFT", 0, 7)
	AltPowerBar:Point("BOTTOMRIGHT", self, "TOPRIGHT", 0, 7)
	AltPowerBar:Height(5)
    AltPowerBar:SetStatusBarColor(.0, .0, .0)
    AltPowerBar:SetFrameLevel(Health:GetFrameLevel())
	AltPowerBar:SetBackdrop(nil)
	AltPowerBar:CreateBackdrop()

	if (AltPowerBar.Value) then
		AltPowerBar.Value:ClearAllPoints()
		AltPowerBar.Value:Point("CENTER", AltPowerBar, "CENTER", 0, 1)
    end
    
    -- Portrait
    if (C.UnitFrames.Portrait) then
        local Portrait = self.Portrait

        Portrait:ClearAllPoints()
        Portrait:SetInside(Health, 1, 1)
        Portrait:SetAlpha(.3)
    end

    if (C.UnitFrames.CastBar) then
        local CastBar = self.Castbar
        
        CastBar:ClearAllPoints()
        CastBar:Point("TOPLEFT", Power, "BOTTOMLEFT", 0, -7)
        CastBar:Width(FrameWidth)
        CastBar:Height(20)
        CastBar:SetStatusBarTexture(CastTexture)
        CastBar:SetFrameLevel(Health:GetFrameLevel())
        CastBar:CreateBackdrop()

		CastBar.Background:SetAllPoints()
		CastBar.Background:SetTexture(CastTexture)
		CastBar.Background:SetVertexColor(0.05, 0.05, 0.05)

		CastBar.Time:ClearAllPoints()
		CastBar.Time:Point("RIGHT", CastBar, "RIGHT", -5, 1)
		CastBar.Time:SetTextColor(0.84, 0.75, 0.65)
		CastBar.Time:SetJustifyH("RIGHT")

		CastBar.Text:ClearAllPoints()
		CastBar.Text:Point("LEFT", CastBar, "LEFT", 5, 1)
		CastBar.Text:SetTextColor(0.84, 0.75, 0.65)
		CastBar.Text:Width(CastBar:GetWidth())
		CastBar.Text:SetJustifyH("LEFT")

        if (C.UnitFrames.CastBarIcon) then
            CastBar.Icon:ClearAllPoints()
            CastBar.Icon:Point("TOPLEFT", Health, "TOPRIGHT", 7, 0)
            CastBar.Icon:Size(FrameHeight + Power:GetHeight() + 3)
            CastBar.Icon:SetTexCoord(unpack(T.IconCoord))

            CastBar.Button:ClearAllPoints()
            CastBar.Button:SetOutside(CastBar.Icon)
		end

		if (C.UnitFrames.UnlinkCastBar) then
			CastBar:ClearAllPoints()
            CastBar:Point("CENTER", UIParent, "CENTER", 0, 300)
            CastBar:Width(Panels.ActionBar1:GetWidth())
            CastBar:Height(20)
            CastBar.Shadow:Kill()

			if (C.UnitFrames.CastBarIcon) then
				CastBar.Icon:ClearAllPoints()
				CastBar.Icon:Point("LEFT", CastBar, "RIGHT", 7, 0)
				CastBar.Icon:Size(CastBar:GetHeight())
			end
		end
    end

    -- CombatLog
	if (C.UnitFrames.CombatLog) then
        local CombatFeedbackText = self.CombatFeedbackText
        
		CombatFeedbackText:ClearAllPoints()
        CombatFeedbackText:Point("CENTER", Health, "CENTER", 0, 1)
        CombatFeedbackText:SetFont(Font, 13, FontStyle)
    end

    -- Health Prediction
	if (C.UnitFrames.HealBar) then
        local FirstBar = self.HealthPrediction.myBar
        local SecondBar = self.HealthPrediction.otherBar
        local ThirdBar = self.HealthPrediction.absorbBar

        local HealBarColor = { .31, .45, .63, .4 }
        
        FirstBar:Width(FrameWidth)
        FirstBar:Height(Health:GetHeight())
		FirstBar:SetStatusBarTexture(HealthTexture)
        FirstBar:SetStatusBarColor(unpack(HealBarColor))
		
        SecondBar:Width(FrameWidth)
        SecondBar:Height(Health:GetHeight())
		SecondBar:SetStatusBarTexture(HealthTexture)
		SecondBar:SetStatusBarColor(unpack(HealBarColor))
		
        ThirdBar:Width(FrameWidth)
        ThirdBar:Height(Health:GetHeight())
		ThirdBar:SetStatusBarTexture(HealthTexture)
		ThirdBar:SetStatusBarColor(unpack(HealBarColor))
    end

    if (C.UnitFrames.TargetAuras) then
		local Buffs = self.Buffs
        local Debuffs = self.Debuffs
        
        local yOffset = 0
        if (self.AlternativePower.IsEnable) then yOffset = 10 end

		Buffs:ClearAllPoints()
        Buffs:Point("BOTTOMLEFT", self, "TOPLEFT", 0, 7 + yOffset)
        Buffs.initialAnchor = "TOPLEFT"
        Buffs["growth-y"] = "UP"
        Buffs["growth-x"] = "RIGHT"
        Buffs.size = 22
        Buffs.spacing = 7
        Buffs.num = 9
        Buffs.numRow = 9
        Buffs:Width(Buffs.numRow * Buffs.size + (Buffs.numRow - 1) * Buffs.spacing)
        Buffs:Height(Buffs.size)

        Buffs.PostUpdate = UnitFrames.UpdateDebuffsHeaderPosition

        Debuffs:ClearAllPoints()
        Debuffs:Point("BOTTOMRIGHT", self, "TOPRIGHT", 0, Buffs.size + 2 * Buffs.spacing)
        Debuffs.initialAnchor = "TOPRIGHT"
        Debuffs["growth-y"] = "UP"
        Debuffs["growth-x"] = "LEFT"
        Debuffs.size = Buffs.size
        Debuffs.spacing = Buffs.spacing
        Debuffs.num = Buffs.num
        Debuffs.numRow = Buffs.numRow
        Debuffs:Width(Debuffs.numRow * Debuffs.size + (Debuffs.numRow - 1) * Debuffs.spacing)
        Debuffs:Height(Debuffs.size)
    end

    -- Raid Icon
    RaidIcon:ClearAllPoints()
    RaidIcon:Point("CENTER", self, "TOP", 0, 3)
    RaidIcon:Size(16, 16)
end
hooksecurefunc(UnitFrames, "Target", Target)