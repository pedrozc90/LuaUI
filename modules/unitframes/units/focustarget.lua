local T, C, L = Tukui:unpack()
local UnitFrames = T.UnitFrames

----------------------------------------------------------------
-- FocusTarget
----------------------------------------------------------------
local function FocusTarget(self)
    local Health = self.Health
    local Power = self.Power
    local Name = self.Name
    local RaidIcon = self.RaidTargetIndicator
    
    local FrameWidth, FrameHeight = unpack(C.Units.FocusTarget)
    local HealthTexture = T.GetTexture(C["Textures"].UFHealthTexture)
	local PowerTexture = T.GetTexture(C["Textures"].UFPowerTexture)
    local CastTexture = T.GetTexture(C["Textures"].UFCastTexture)

    self:SetBackdrop(nil)
    self.Shadow:Kill()

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
	Name:Point("CENTER", Health, "CENTER", 0, 1)
    Name:SetJustifyH("CENTER")
    
    self:Tag(Name, "[Tukui:GetNameColor][Tukui:NameLong] [Tukui:Classification][Tukui:DiffColor][level]")

    if (C.UnitFrames.FocusAuras) then
        local Buffs = self.Buffs
        local Debuffs = self.Debuffs
        
		Buffs:ClearAllPoints()
		Buffs:Point("TOPRIGHT", self, "TOPLEFT", -7, 0)
		Buffs.size = FrameHeight
		Buffs.num = 3
		Buffs.spacing = 7
		Buffs.initialAnchor = "RIGHT"
        Buffs["growth-x"] = "LEFT"
        
        Buffs:Width(Buffs.num * Buffs.size + (Buffs.num - 1) * Buffs.spacing)
        Buffs:Height(Buffs.size)

		Debuffs:ClearAllPoints()
		Debuffs:Point("TOPLEFT", self, "TOPRIGHT", 7, 0)
		Debuffs.size = Buffs.size
		Debuffs.num = 5
		Debuffs.spacing = Buffs.spacing
		Debuffs.initialAnchor = "LEFT"
		Debuffs["growth-x"] = "RIGHT"
        Debuffs:Width(Debuffs.num * Debuffs.size + (Debuffs.num - 1) * Debuffs.spacing)
        Debuffs:Height(Debuffs.size)
	end

	if (C.UnitFrames.CastBar) then
		local CastBar = self.Castbar

        CastBar:ClearAllPoints()
		CastBar:Point("TOPLEFT", self, "BOTTOMLEFT", 0, -7)
        CastBar:Width(FrameWidth)
        CastBar:Height(20)
		CastBar:SetBackdrop(nil)
        CastBar.Shadow:Kill()
        CastBar:CreateBackdrop()

		CastBar.Time:ClearAllPoints()
		CastBar.Time:Point("RIGHT", CastBar, "RIGHT", -5, 1)
		CastBar.Time:SetJustifyH("RIGHT")

		CastBar.Text:ClearAllPoints()
		CastBar.Text:Point("LEFT", CastBar, "LEFT", 5, 1)
        CastBar.Text:SetJustifyH("LEFT")
        CastBar.Text:Width(CastBar:GetWidth())

		CastBar.Button:ClearAllPoints()
		CastBar.Button:Size(CastBar:GetHeight())
		CastBar.Button:SetPoint("TOPLEFT", CastBar, "TOPRIGHT", 7, 0)
		CastBar.Button:SetBackdrop(nil)
        CastBar.Button.Shadow:Kill()
        CastBar.Button:CreateBackdrop()
	end

    -- Raid Icon
    RaidIcon:ClearAllPoints()
    RaidIcon:SetPoint("CENTER", self, "TOP", 0, 3)
    RaidIcon:Size(16, 16)
end
hooksecurefunc(UnitFrames, "FocusTarget", FocusTarget)