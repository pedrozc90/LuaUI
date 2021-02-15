local T, C, L = Tukui:unpack()
local UnitFrames = T.UnitFrames
local ceil = math.ceil

----------------------------------------------------------------
-- Pet
----------------------------------------------------------------
local basePet = UnitFrames.Pet

function UnitFrames:Pet()

    -- first, we call the base function
    basePet(self)

    -- second, we edit it
    local Health = self.Health
	local Power = self.Power
	local Name = self.Name
    local RaidIcon = self.RaidTargetIndicator

    local FrameWidth, FrameHeight = unpack(C.Units.Pet)
    local PowerHeight = 3

    local HealthTexture = T.GetTexture(C.Textures.UFHealthTexture)
    local PowerTexture = T.GetTexture(C.Textures.UFPowerTexture)
    local CastTexture = T.GetTexture(C.Textures.UFCastTexture)
    local Font, FontSize, FontStyle = C.Medias.PixelFont, 12, "MONOCHROMEOUTLINE"

	-- self.Backdrop:SetBackdropColor(unpack(C.General.BackdropColor))
	-- self.Backdrop:Kill()
	self.Shadow:Kill()
	self.Panel:Kill()
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
    
    Health.frequentUpdate = true
    if (C.Lua.UniColor) then
        Health.colorTapping = false
        Health.colorDisconnected = false
        Health.colorClass = false
        Health.colorReaction = false
        Health:SetStatusBarColor(unpack(C.General.BackdropColor))
        Health.Background:SetVertexColor(unpack(C.General.BorderColor))
    else
        Health.colorTapping = true
        Health.colorDisconnected = true
        Health.colorClass = true
        Health.colorReaction = true
    end

    if (C.UnitFrames.Smooth) then
		Health.Smooth = true
	end

	-- Power
    Power:ClearAllPoints()
    Power:SetPoint("TOPLEFT", Health, "BOTTOMLEFT", 0, -1)
    Power:SetPoint("TOPRIGHT", Health, "BOTTOMRIGHT", 0, -1)
    Power:SetHeight(PowerHeight)

    Power.Background:SetAllPoints()
    Power.Background:SetColorTexture(unpack(C.General.BackgroundColor))
    Power.Background.multiplier = .3

    Power.Value:ClearAllPoints()
    Power.Value:SetParent(Health)
    Power.Value:SetPoint("LEFT", Health, "LEFT", 5, 0)
    
    Power.frequentUpdates = true
    if (C.Lua.UniColor) then
        Power.colorClass = false
        Power.colorPower = true
        Power.colorReaction = false
        Power.Background.multiplier = 0.1
    else
        Power.colorPower = true
    end

	-- Name
    Name:ClearAllPoints()
    Name:SetParent(Health)
	Name:SetPoint("CENTER", Health, "CENTER", 0, 0)
    Name:SetJustifyH("CENTER")

    -- self:Tag(Name, "[Tukui:GetNameColor][Tukui:NameMedium] [Tukui:DiffColor][level]")

	-- Raid Icon
    RaidIcon:ClearAllPoints()
    RaidIcon:SetPoint("CENTER", self, "TOP", 0, 3)
    RaidIcon:SetSize(16, 16)

    if (C.UnitFrames.PetAuras) then
		local Buffs = self.Buffs
        local Debuffs = self.Debuffs
        
        local AuraSize = 21
        local AuraSpacing = 1
        local AuraPerRow = 4
        local AuraWidth = (AuraSize * AuraPerRow) + (AuraSpacing * (AuraPerRow + 1))

		Buffs:ClearAllPoints()
		Buffs:SetPoint("BOTTOMLEFT", self, "TOPLEFT", -1, 2)
		Buffs:SetHeight(AuraSize)
        Buffs:SetWidth(AuraWidth)
        
		Buffs.size = AuraSize
        Buffs.spacing = AuraSpacing
        Buffs.num = 3
        Buffs.numRow = ceil(Buffs.num / AuraPerRow)
		Buffs.initialAnchor = "TOPLEFT"
        Buffs.onlyShowPlayer = C.UnitFrames.OnlySelfBuffs
        -- Buffs.PostCreateIcon = UnitFrames.PostCreateAura
		-- Buffs.PostUpdateIcon = UnitFrames.PostUpdateAura

		Debuffs:SetFrameStrata(self:GetFrameStrata())
		Debuffs:SetHeight(AuraSize)
		Debuffs:SetWidth(129)
        Debuffs:SetPoint("BOTTOMRIGHT", self, "TOPRIGHT", 1, 2)
        
		Debuffs.size = AuraSize
        Debuffs.spacing = AuraSpacing
        Debuffs.num = 3
        Debuffs.numRow = ceil(Debuffs.num / AuraPerRow)
		Debuffs.initialAnchor = "TOPRIGHT"
		Debuffs["growth-x"] = "LEFT"
        Debuffs.onlyShowPlayer = C.UnitFrames.OnlySelfDebuffs
        -- Debuffs.PostCreateIcon = UnitFrames.PostCreateAura
		-- Debuffs.PostUpdateIcon = UnitFrames.PostUpdateAura

		if (C.UnitFrames.AurasBelow) then
			Buffs:ClearAllPoints()
			Buffs:SetPoint("TOPLEFT", Power, "BOTTOMLEFT", -1, -2)
			
			Debuffs:ClearAllPoints()
			Debuffs:SetPoint("TOPRIGHT", Power, "BOTTOMRIGHT", 1, -2)
		end
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
	
    if (C.UnitFrames.CastBar) then
        local CastBar = self.Castbar

        if (C.UnitFrames.UnlinkPetCastBar) then
            CastBar:ClearAllPoints()
            CastBar:SetPoint("BOTTOMLEFT", Health, "TOPLEFT", 0, 3)
            CastBar:SetPoint("BOTTOMRIGHT", Health, "TOPRIGHT", 0, 3)
            CastBar:SetHeight(20)
            CastBar:SetStatusBarTexture(CastTexture)
            CastBar:CreateBackdrop()
            CastBar.Backdrop:SetOutside()

            CastBar.Background:SetAllPoints(CastBar)
            CastBar.Background:SetTexture(CastTexture)
            CastBar.Background:SetVertexColor(unpack(C.General.BackgroundColor))

            CastBar.Time:ClearAllPoints()
            CastBar.Time:SetPoint("RIGHT", CastBar, "RIGHT", -5, 0)
            CastBar.Time:SetJustifyH("RIGHT")

            CastBar.Text:ClearAllPoints()
            CastBar.Text:SetPoint("LEFT", CastBar, "LEFT", 5, 0)
            CastBar.Text:SetJustifyH("LEFT")
            
            CastBar.Spark:Kill()
        else
            CastBar:ClearAllPoints()
            CastBar:SetAllPoints(Power)
            CastBar:SetHeight(PowerHeight)
            CastBar:SetStatusBarTexture(CastTexture)

            CastBar.Background:ClearAllPoints()
            CastBar.Background:SetPoint("LEFT")
            CastBar.Background:SetPoint("BOTTOM")
            CastBar.Background:SetPoint("RIGHT")
            CastBar.Background:SetPoint("TOP", 0, 1)
            CastBar.Background:SetTexture(CastTexture)
            CastBar.Background:SetVertexColor(unpack(C.General.BackgroundColor))
            
            CastBar.Time:ClearAllPoints()
            CastBar.Time:SetPoint("RIGHT", CastBar, "RIGHT", -5, 0)
            CastBar.Time:SetJustifyH("RIGHT")

            CastBar.Text:ClearAllPoints()
            CastBar.Text:SetPoint("LEFT", CastBar, "LEFT", 5, 0)
            CastBar.Text:SetJustifyH("LEFT")
        end
	end
end
