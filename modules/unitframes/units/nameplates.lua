local T, C, L = Tukui:unpack()
local Toolkit = T00LKIT
local UnitFrames = T.UnitFrames
local ceil = math.ceil
local Scale = Toolkit.Functions.Scale
----------------------------------------------------------------
-- NamePlates
----------------------------------------------------------------
local baseNameplates = UnitFrames.Nameplates

function UnitFrames:Nameplates()

    -- first, we call the base function
    baseNameplates(self)

    -- second, we edit it
    local Health = self.Health
    local Power = self.Power
    local Name = self.Name
    local Buffs = self.Buffs
    local Debuffs = self.Debuffs
    local CastBar = self.Castbar
    local RaidIcon = self.RaidTargetIndicator
    local Highlight = self.Highlight

    local FrameWidth = C.NamePlates.Width
    local FrameHeight = C.NamePlates.Height
    local HealthTexture = T.GetTexture(C.Textures.NPHealthTexture)
    local PowerTexture = T.GetTexture(C.Textures.NPPowerTexture)
    local CastTexture = T.GetTexture(C.Textures.NPCastTexture)
    -- local Font, FontSize, FontStyle = C.Medias.PixelFont, 14, "MONOCHROMEOUTLINE"

    local PowerHeight = 3
    local NameLength = C.NamePlates.HealthTag.Value == "" and "[Tukui:NameMedium]" or "[Tukui:NameShort]"

    self.Backdrop:SetBackdropColor(unpack(C.General.BackdropColor))
    self.Shadow:Kill()

    -- Health
    Health:ClearAllPoints()
    Health:SetPoint("TOPLEFT", self, "TOPLEFT", 0, 0)
    Health:SetPoint("TOPRIGHT", self, "TOPRIGHT", 0, 0)
    Health:SetHeight(FrameHeight - PowerHeight - 1)

    Health.Background:SetAllPoints()
    Health.Background:SetColorTexture(unpack(C.General.BackgroundColor))

    Health.Value:ClearAllPoints()
    Health.Value:SetPoint("BOTTOMRIGHT", self, "TOPRIGHT", 2, 3)

    self:Tag(Health.Value, C.NamePlates.HealthTag.Value)

    Health.frequentUpdates = true
    Health.colorTapping = true
    Health.colorReaction = true
    Health.colorDisconnected = true
    Health.colorClass = true
    Health.Smooth = true
    Health.colorThreat = C.NamePlates.ColorThreat

    -- Power
    Power:ClearAllPoints()
    Power:SetPoint("TOPLEFT", Health, "BOTTOMLEFT", 0, -1)
    Power:SetPoint("TOPRIGHT", Health, "BOTTOMRIGHT", 0, -1)
    Power:SetHeight(PowerHeight)

    Power.Background:SetAllPoints()
    Power.Background:SetColorTexture(unpack(C.General.BackgroundColor))

    Power.frequentUpdates = true
    Power.IsHidden = false
    Power.colorPower = true
    Power.Smooth = true

    -- Power.PostUpdate = UnitFrames.DisplayNameplatePowerAndCastBar

    -- Name
    Name:ClearAllPoints()
    Name:SetPoint("BOTTOMLEFT", Health, "TOPLEFT", -2, 3)
    Name:SetJustifyH("LEFT")

    self:Tag(Name, "[Tukui:Classification][Tukui:DiffColor][level] [Tukui:GetNameHostilityColor]" .. NameLength)

    -- Debuffs
    Debuffs:ClearAllPoints()
    Debuffs:SetPoint("BOTTOMLEFT", self, "TOPLEFT", 0, 18)
    Debuffs.size = C["NamePlates"].DebuffSize
    Debuffs.num = 7
    Debuffs.numRow = 1
    Debuffs.spacing = C["NamePlates"].DebuffSpacing
    Debuffs.initialAnchor = "BOTTOMLEFT"
    Debuffs["growth-y"] = "UP"
    Debuffs["growth-x"] = "RIGHT"
    Debuffs:SetHeight(Debuffs.size)
    Debuffs:SetWidth(Debuffs.num * Debuffs.size + (Debuffs.num - 1) * Debuffs.spacing)

    -- Buffs
    local BuffSize = self:GetHeight()
    local BuffSpacing = 1
    local BuffPerRow = 3
    local BuffWidth = (BuffSize * BuffPerRow) + (BuffSpacing * (BuffPerRow + 1))

    Buffs:ClearAllPoints()
    Buffs:SetHeight(BuffSize, BuffSize)
    Buffs:SetWidth(BuffWidth)
    Buffs:SetPoint("LEFT", self, "RIGHT", 3, 0)

    Buffs.size = BuffSize
    Buffs.spacing = BuffSpacing
    Buffs.num = 3
    Buffs.numRow = ceil(Buffs.num / BuffPerRow)
    Buffs.disableMouse = true	
    Buffs.initialAnchor = "BOTTOMLEFT"
    Buffs["growth-y"] = "DOWN"
    Buffs["growth-x"] = "RIGHT"
    Buffs.CustomFilter = UnitFrames.BuffIsStealable
    -- Buffs.PostCreateIcon = UnitFrames.PostCreateAura
    -- Buffs.PostUpdateIcon = UnitFrames.PostUpdateAura

    -- Debuffs
    local DebuffSize = 24
    local DebuffSpacing = 1
    local DebuffPerRow = math.ceil(C.NamePlates.Width / 26)
    local DebuffWidth = (DebuffSize * DebuffPerRow) + (DebuffSpacing * (DebuffPerRow + 1))

    Debuffs:ClearAllPoints()
    Debuffs:SetPoint("TOPLEFT", self, "BOTTOMLEFT", 0, -3)
    Debuffs:SetHeight(DebuffSize)
    Debuffs:SetWidth(DebuffWidth)

    Debuffs.size = DebuffSize
    Debuffs.spacing = DebuffSpacing
    Debuffs.num = DebuffPerRow
    Debuffs.numRow = ceil(Debuffs.num / DebuffPerRow)
    Debuffs.disableMouse = true
    Debuffs.initialAnchor = "BOTTOMLEFT"
    Debuffs["growth-y"] = "DOWN"
    Debuffs["growth-x"] = "RIGHT"
    Debuffs.onlyShowPlayer = C.NamePlates.OnlySelfDebuffs
    -- Debuffs.PostCreateIcon = UnitFrames.PostCreateAura
    -- Debuffs.PostUpdateIcon = UnitFrames.PostUpdateAura

    -- CastBar
    if (C.NamePlates.NameplateCastBar) then
        CastBar:ClearAllPoints()
        CastBar:SetAllPoints(Power)
        CastBar:SetHeight(PowerHeight)
        CastBar:SetStatusBarTexture(CastTexture)
        CastBar:CreateBackdrop()

        CastBar.Background:SetVertexColor(unpack(C.General.BackgroundColor))

        CastBar.Button:ClearAllPoints()
        CastBar.Button:SetPoint("TOPRIGHT", self, "TOPLEFT", -2, 0)
        CastBar.Button:SetSize(FrameHeight + 1, FrameHeight + 1)
    end

    -- Raid Icon
    RaidIcon:ClearAllPoints()
    RaidIcon:SetPoint("RIGHT", Name, "LEFT", -5, -1)
    RaidIcon:SetSize(18, 18)

    if (C.NamePlates.QuestIcon) then
        local QuestIcon = self.QuestIcon

        QuestIcon:ClearAllPoints()
        QuestIcon:SetPoint("LEFT", self, "RIGHT", 4, 0)
        QuestIcon:SetSize(C.NamePlates.Height, C.NamePlates.Height)
    end

    if (C.NamePlates.ClassIcon) then
        local ClassIcon = self.ClassIcon

        -- ClassIcon:ClearAllPoints()
        -- ClassIcon:SetSize(self:GetHeight() + 14, self:GetHeight() + 14)
        -- ClassIcon:SetPoint("BOTTOMRIGHT", self, "BOTTOMLEFT", -3, 0)
        -- ClassIcon:CreateBackdrop()
        -- ClassIcon:SetAlpha(0)
        -- ClassIcon.Backdrop.Shadow:Kill()

        -- ClassIcon.Texture = ClassIcon:CreateTexture(nil, "OVERLAY")
        -- ClassIcon.Texture:SetAllPoints(ClassIcon)
        -- ClassIcon.Texture:SetTexture("Interface\\Glues\\CharacterCreate\\UI-CharacterCreate-Classes")

        -- Reposition castbar icon to cover class icon
        -- self.Castbar.Button:ClearAllPoints()
        -- self.Castbar.Button:SetAllPoints(ClassIcon)

        -- self.Castbar.Button.Shadow:ClearAllPoints()
        -- self.Castbar.Button.Shadow:SetOutside(self.Castbar.Button, 4, 4)
        -- self.Castbar.Button.Shadow:SetFrameLevel(ClassIcon:GetFrameLevel() + 1)
        -- self.Castbar.Button.Shadow:SetFrameStrata(ClassIcon:GetFrameStrata())

        -- self:RegisterEvent("NAME_PLATE_UNIT_ADDED", UnitFrames.UpdateNameplateClassIcon, true)
    end

    -- Highlight
    -- Highlight:Kill()
    -- self:RegisterEvent("PLAYER_TARGET_CHANGED", UnitFrames.Highlight, true)
    -- self:RegisterEvent("NAME_PLATE_UNIT_ADDED", UnitFrames.Highlight, true)
    -- self:RegisterEvent("NAME_PLATE_UNIT_REMOVED", UnitFrames.Highlight, true)
end
