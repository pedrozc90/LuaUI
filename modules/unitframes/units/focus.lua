local T, C, L = Tukui:unpack()
local UnitFrames = T.UnitFrames
local ceil = math.ceil

----------------------------------------------------------------
-- Focus
----------------------------------------------------------------
local baseFocus = UnitFrames.Focus

function UnitFrames:Focus()
    -- first, we call the base function
    baseFocus(self)

    -- second, we edit it
    local Health = self.Health
    local Power = self.Power
    local Name = self.Name
    local RaidIcon = self.RaidTargetIndicator
    local Highlight = self.Highlight

    local FrameWidth, FrameHeight = unpack(C.Units.Focus)
    local PowerHeight = 3

    local HealthTexture = T.GetTexture(C.Textures.UFHealthTexture)
	local PowerTexture = T.GetTexture(C.Textures.UFPowerTexture)
    local CastTexture = T.GetTexture(C.Textures.UFCastTexture)

    self.Backdrop = nil
    self:CreateBackdrop()

    -- Health
    Health:ClearAllPoints()
    Health:SetPoint("TOPLEFT", self, "TOPLEFT", 0, 0)
    Health:SetPoint("TOPRIGHT", self, "TOPRIGHT", 0, 0)
    Health:SetHeight(FrameHeight - PowerHeight - 1)

    Health.Background:SetAllPoints()
    Health.Background:SetColorTexture(unpack(C.General.BackgroundColor))

    Health.Value:ClearAllPoints()
    Health.Value:SetParent(Health)
    Health.Value:SetPoint("RIGHT", Health, "RIGHT", -5, 0)
    Health.Value:SetJustifyH("LEFT")

    Health.frequentUpdate = true
    if (C.Lua.UniColor) then
        Health.colorTapping = false
        Health.colorDisconnected = false
        Health.colorClass = false
        Health.colorReaction = false
        Health:SetStatusBarColor(unpack(C.General.BackdropColor))
        Health.Background:SetVertexColor(unpack(C.General.BackgroundColor))
    else
        Health.colorTapping = true
        Health.colorDisconnected = true
        Health.colorClass = true
        Health.colorReaction = true
    end

    -- Power
    Power:ClearAllPoints()
    Power:SetPoint("TOPLEFT", Health, "BOTTOMLEFT", 0, -1)
    Power:SetPoint("TOPRIGHT", Health, "BOTTOMRIGHT", 0, -1)
    Power:SetHeight(PowerHeight)

    Power.Background:SetAllPoints()
    Power.Background:SetColorTexture(0.05, 0.05, 0.05)

    -- Power.Value:ClearAllPoints()
    -- Power.Value:SetParent(Health)
    -- Power.Value:SetPoint("LEFT", Health, "LEFT", 5, 1)
    -- Power.Value:SetJustifyH("LEFT")

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
	Name:SetPoint("LEFT", Health, "LEFT", 5, 0)
    Name:SetJustifyH("LEFT")

    -- self:Tag(Name, "[Tukui:GetNameColor][Tukui:NameLong] [Tukui:Classification][Tukui:DiffColor][level]")

    -- Raid Icon
    RaidIcon:ClearAllPoints()
    RaidIcon:SetPoint("CENTER", self, "TOP", 0, 3)
    RaidIcon:SetSize(16, 16)

    if (C.UnitFrames.FocusAuras) then
		local Buffs = self.Buffs
        local Debuffs = self.Debuffs
        
        local AuraSize = FrameHeight + PowerHeight - 1
        local AuraSpacing = 1
        local AuraPerRow = 3
        local AuraWidth = (AuraSize * AuraPerRow) + (AuraSpacing * (AuraPerRow + 1))

		Buffs:ClearAllPoints()
		Buffs:SetPoint("TOPRIGHT", self, "TOPLEFT", -3, 1)
		Buffs:SetHeight(AuraSize)
        Buffs:SetWidth(AuraWidth)
        
		Buffs.size = AuraSize
        Buffs.spacing = AuraSpacing
        Buffs.num = 3
        Buffs.numRow = ceil(Buffs.num / AuraPerRow)
		Buffs.initialAnchor = "TOPRIGHT"
		Buffs["growth-x"] = "LEFT"
        Buffs.onlyShowPlayer = C.UnitFrames.OnlySelfBuffs
        -- Buffs.PostCreateIcon = UnitFrames.PostCreateAura
		-- Buffs.PostUpdateIcon = UnitFrames.PostUpdateAura

		Debuffs:ClearAllPoints()
        Debuffs:SetPoint("TOPLEFT", self, "TOPRIGHT", 3, 1)
        Debuffs:SetHeight(AuraSize)
		Debuffs:SetWidth(AuraWidth)
        
		Debuffs.size = AuraSize
        Debuffs.spacing = AuraSpacing
        Debuffs.num = 4
        Debuffs.numRow = ceil(Debuffs.num / AuraPerRow)
		Debuffs.initialAnchor = "TOPLEFT"
		Debuffs["growth-x"] = "RIGHT"
        Debuffs.onlyShowPlayer = C.UnitFrames.OnlySelfDebuffs
        -- Debuffs.PostCreateIcon = UnitFrames.PostCreateAura
        -- Debuffs.PostUpdateIcon = UnitFrames.PostUpdateAura
	end

	if (C.UnitFrames.CastBar) then
        local CastBar = self.Castbar
        
        -- CastBar.Backdrop:Kill()

        CastBar:ClearAllPoints()
		CastBar:SetPoint("CENTER", UIParent, "CENTER", 0, 180)
        CastBar:SetWidth(250)
        CastBar:SetHeight(20)
        CastBar:SetStatusBarTexture(CastTexture)
        -- CastBar:CreateBackdrop()
        CastBar.Backdrop:SetOutside()

        CastBar.Background = CastBar:CreateTexture(nil, "BORDER")
		CastBar.Background:SetAllPoints(CastBar)
		CastBar.Background:SetTexture(CastTexture)
		CastBar.Background:SetVertexColor(unpack(C.General.BackgroundColor))

		-- CastBar.Time:ClearAllPoints()
		-- CastBar.Time:SetPoint("RIGHT", CastBar, "RIGHT", -5, 1)
		-- CastBar.Time:SetJustifyH("RIGHT")

		CastBar.Text:ClearAllPoints()
		CastBar.Text:SetPoint("CENTER", CastBar, "CENTER", 0, 0)
        CastBar.Text:SetJustifyH("CENTER")
        CastBar.Text:SetWidth(CastBar:GetWidth())

		CastBar.Button:ClearAllPoints()
		CastBar.Button:SetSize(CastBar:GetHeight(), CastBar:GetHeight())
		CastBar.Button:SetPoint("TOPLEFT", CastBar, "TOPRIGHT", 5, 0)
        CastBar.Button:CreateBackdrop()
        CastBar.Button.Backdrop.Shadow:Kill()
	end

    if (C.UnitFrames.HealComm) then
		local myBar = self.HealthPrediction.myBar
		local otherBar = self.HealthPrediction.otherBar
        local absorbBar = self.HealthPrediction.absorbBar

		myBar:SetWidth(FrameWidth)
        myBar:SetHeight(Health:GetHeight())
		myBar:SetStatusBarTexture(HealthTexture)

        otherBar:SetWidth(FrameWidth)
        otherBar:SetHeight(Health:GetHeight())
		otherBar:SetStatusBarTexture(HealthTexture)

        absorbBar:SetWidth(FrameWidth)
        absorbBar:SetHeight(Health:GetHeight())
		absorbBar:SetStatusBarTexture(HealthTexture)
    end
    
    -- Highlight
    Highlight:Kill()

    self:RegisterEvent("PLAYER_TARGET_CHANGED", UnitFrames.Highlight, true)
end
