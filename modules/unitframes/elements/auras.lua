local T, C, L = Tukui:unpack()
local UnitFrames = T.UnitFrames

function UnitFrames:SetupPlayerAuras(Width)
    local AuraBars = self.AuraBars
    local Debuffs = self.Debuffs
    local Buffs = self.Buffs

    --local Width = C.UnitFrames.PlayerWidth

    if (AuraBars) then
		AuraBars:ClearAllPoints()
		AuraBars:SetPoint("BOTTOMLEFT", self.Health, "TOPLEFT", 0, 3)
		AuraBars:SetHeight(10)
		AuraBars:SetWidth(Width)

		AuraBars.gap = 3
		AuraBars.height = 17
		AuraBars.width = Width - AuraBars.height - AuraBars.gap
	end

    local AuraSize = 27
    local AuraSpacing = 3
    local AuraPerRow = math.ceil((Width + AuraSpacing) / (AuraSize + AuraSpacing))
    -- local AuraWidth = (AuraPerRow * AuraSize) + ((AuraPerRow - 1) * AuraSpacing)

    if (Buffs) then
        Buffs:ClearAllPoints()
        Buffs:SetPoint("BOTTOMLEFT", self, "TOPLEFT", -1, AuraSpacing)
        Buffs:SetHeight(AuraSize)
        Buffs:SetWidth(Width)

        Buffs.size = AuraSize
        Buffs.spacing = AuraSpacing
        Buffs.num = 2 * AuraPerRow
        Buffs.numRow = AuraPerRow
        Buffs.initialAnchor = "TOPLEFT"
        Buffs.onlyShowPlayer = C.UnitFrames.OnlySelfBuffs
        Buffs.isCancellable = true

        -- Buffs.PostCreateIcon = UnitFrames.PostCreateAura
        -- Buffs.PostUpdateIcon = UnitFrames.PostUpdateAura
        -- Buffs.PostUpdate = C.UnitFrames.PlayerDebuffs and UnitFrames.UpdateDebuffsHeaderPosition

        if (C.UnitFrames.AurasBelow) then
            Buffs:SetPoint("BOTTOMLEFT", self, "BOTTOMLEFT", 0, -32)
        end
    end

    if (Debuffs) then
        Debuffs:ClearAllPoints()
        Debuffs:SetHeight(AuraSize)
        Debuffs:SetWidth(Width)

        if (self.Buffs) then
            Debuffs:SetPoint("BOTTOMLEFT", self.Buffs, "TOPLEFT", 0, 18)
        else
            Debuffs:SetPoint("BOTTOMRIGHT", self, "TOPRIGHT", 0, AuraSpacing)
        end

        Debuffs.size = AuraSize
        Debuffs.spacing = AuraSpacing
        Debuffs.num = AuraPerRow
        Debuffs.numRow = AuraPerRow
        Debuffs.initialAnchor = "TOPRIGHT"
        Debuffs["growth-y"] = "UP"
        Debuffs["growth-x"] = "LEFT"
        -- Debuffs.PostCreateIcon = UnitFrames.PostCreateAura
        -- Debuffs.PostUpdateIcon = UnitFrames.PostUpdateAura

        if (C.UnitFrames.AurasBelow) then
            if (not C.UnitFrames.PlayerBuffs) then
                Debuffs:SetPoint("BOTTOMLEFT", self, "BOTTOMLEFT", 0, -32)
            end
            Debuffs["growth-y"] = "DOWN"
        end
    end
end

function UnitFrames:SetupFocusAuras() 
    
    local Width, Height = T.GetSize(self.unit)
    
    local AuraSize = 20
    local AuraSpacing = 3
    -- local AuraPerRow = 3
    -- local AuraWidth = (AuraSize * AuraPerRow) + (AuraSpacing * (AuraPerRow + 1))
    
    local Buffs = self.Buffs
    Buffs:ClearAllPoints()
    if (C.UnitFrames.AurasBelow) then
        Buffs:SetPoint("TOPLEFT", self, "BOTTOMLEFT", -1, -3)
    else
        Buffs:SetPoint("BOTTOMLEFT", self, "TOPLEFT", -1, 3)
    end

    Buffs:SetHeight(AuraSize)
    Buffs:SetWidth(Width)
    Buffs.size = AuraSize
    Buffs.spacing = AuraSpacing
    Buffs.num = 3
    Buffs.numRow = 1
    Buffs.spacing = AuraSpacing
    Buffs.initialAnchor = "TOPLEFT"
    Buffs["growth-x"] = "RIGHT"
    
    local Debuffs = self.Debuffs
    Debuffs:ClearAllPoints()
    if (C.UnitFrames.AurasBelow) then
        Debuffs:SetPoint("TOPRIGHT", self, "BOTTOMRIGHT", -1, -3)
    else
        Debuffs:SetPoint("BOTTOMRIGHT", self, "TOPRIGHT", -1, 3)
    end
    Debuffs:SetHeight(AuraSize)
    Debuffs:SetWidth(Width)
    Debuffs.size = AuraSize
    Debuffs.spacing = AuraSpacing
    Debuffs.num = 4
    Debuffs.numRow = 1
    Debuffs.initialAnchor = "TOPRIGHT"
    Debuffs["growth-x"] = "LEFT"
end
