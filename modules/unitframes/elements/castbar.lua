local T, C, L = Tukui:unpack()
local UnitFrames = T.UnitFrames

function UnitFrames:SetupCastBar()
    local CastBar = self.Castbar
    if (not CastBar) then return end

    local Width, Height = T.GetSize(self.unit)
    local PowerHeight = C.UnitFrames.PowerHeight
    local Texture = T.GetTexture(C.Textures.UFCastTexture)
    
    -- Castbar
    CastBar:ClearAllPoints()
    CastBar:SetPoint("TOPLEFT", self, "BOTTOMLEFT", 0, -3)
    CastBar:SetWidth(Width)
    CastBar:SetHeight(20)
    CastBar:SetStatusBarTexture(Texture)
    CastBar:SetStatusBarColor(1, 1, 1)
    CastBar:SetFrameLevel(self.Health:GetFrameLevel())
    CastBar:CreateBackdrop()
    CastBar.Backdrop:SetOutside()

    if (CastBar.Background) then
        CastBar.Background:SetAllPoints(CastBar)
        CastBar.Background:SetTexture(Texture)
        CastBar.Background:SetVertexColor(unpack(C.General.BackgroundColor))
    end

    if (CastBar.Time) then
        CastBar.Time:ClearAllPoints()
        CastBar.Time:SetPoint("RIGHT", CastBar, "RIGHT", -5, 0)
        CastBar.Time:SetTextColor(0.84, 0.75, 0.65)
        CastBar.Time:SetJustifyH("RIGHT")
    end

    if (CastBar.Text) then
        CastBar.Text:ClearAllPoints()
        CastBar.Text:SetPoint("LEFT", CastBar, "LEFT", 5, 0)
        CastBar.Text:SetTextColor(0.84, 0.75, 0.65)
        CastBar.Text:SetWidth(Width)
        CastBar.Text:SetJustifyH("LEFT")
    end

    -- CastBar.Spark:ClearAllPoints()
    -- CastBar.Spark:SetSize(8, CastBar:GetHeight())
    -- CastBar.Spark:SetBlendMode("ADD")
    -- CastBar.Spark:SetPoint("CENTER", CastBar:GetStatusBarTexture(), "RIGHT", 0, 0)

    if (C.UnitFrames.CastBarIcon) then
        local IconSize = Height
        CastBar.Icon:ClearAllPoints()
        CastBar.Icon:SetPoint("TOPRIGHT", self.Health, "TOPLEFT", -3, 0)
        CastBar.Icon:SetSize(IconSize, IconSize)
        CastBar.Icon:SetTexCoord(unpack(T.IconCoord))

        CastBar.Button:ClearAllPoints()
        CastBar.Button:SetOutside(CastBar.Icon)
        CastBar.Button.Shadow:Kill()
    end

    if (CastBar.SafeZone) then
        CastBar.SafeZone:ClearAllPoints()
        CastBar.SafeZone:SetTexture(Texture)
    end

    if (C.UnitFrames.UnlinkCastBar) then
        local ButtonSize = C.ActionBars.NormalButtonSize
        local ButtonSpacing = C.ActionBars.ButtonSpacing
        local ButtonsPerRow = C.ActionBars.Bar1ButtonsPerRow
        local NumRow = ceil(12 / ButtonsPerRow)
        local IconSize = (CastBar.Button) and CastBar.Button:GetWidth() or 0
        local Width = (ButtonsPerRow * ButtonSize) + ((ButtonsPerRow + 1) * ButtonSpacing) - IconSize

        CastBar:ClearAllPoints()
        if (self.unit == "player") then
            CastBar:SetPoint("BOTTOM", UIParent, "BOTTOM", 12, 50)
        elseif (self.unit == "target") then
            CastBar:SetPoint("CENTER", UIParent, "CENTER", 0, 300)
        end
        CastBar:SetWidth(Width)
        CastBar:SetHeight(20)
        CastBar.Shadow:Kill()

        if (C.UnitFrames.CastBarIcon) then
            CastBar.Icon:ClearAllPoints()
            CastBar.Icon:SetPoint("RIGHT", CastBar, "LEFT", -3, 0)
            CastBar.Icon:SetSize(CastBar:GetHeight(), CastBar:GetHeight())
        end
    end
end

function UnitFrames:SetupPetCastBar()
    local Power = self.Power
    local CastBar = self.Castbar
    if (not CastBar) then return end

    local _, Height = T.GetSize(self.unit)

    CastBar:SetAllPoints(Power)

    -- CastBar.Background = CastBar:CreateTexture(nil, "BORDER")
    -- CastBar.Background:SetAllPoints(CastBar)
    -- CastBar.Background:SetTexture(C.Medias.Normal)
    -- CastBar.Background:SetVertexColor(0.15, 0.15, 0.15)

    if (CastBar.Time) then
        CastBar.Time:ClearAllPoints()
        CastBar.Time:SetPoint("RIGHT", CastBar, "RIGHT", -5, 0)
    end

    if (CastBar.Text) then
        CastBar.Text:ClearAllPoints()
        CastBar.Text:SetPoint("CENTER", CastBar, "CENTER", 0, 0)
        -- CastBar.Text:SetTextColor(0.84, 0.75, 0.65)
        CastBar.Text:SetWidth(CastBar:GetWidth())
        CastBar.Text:SetJustifyH("CENTER")
    end

    -- CastBar.Spark = CastBar:CreateTexture(nil, "OVERLAY")
    -- CastBar.Spark:SetSize(8, CastBar:GetHeight())
    -- CastBar.Spark:SetBlendMode("ADD")
    -- CastBar.Spark:SetPoint("CENTER", CastBar:GetStatusBarTexture(), "RIGHT", 0, 0)

    -- CastBar.CustomTimeText = UnitFrames.CustomCastTimeText
    -- CastBar.CustomDelayText = UnitFrames.CustomCastDelayText
    -- CastBar.PostCastStart = UnitFrames.CheckCast
    -- CastBar.PostChannelStart = UnitFrames.CheckChannel

    CastBar.Button = CreateFrame("Frame", nil, CastBar)
    CastBar.Button:SetSize(Height, Height)
    CastBar.Button:SetPoint("RIGHT", self, "LEFT", -3, 0)
    CastBar.Button:CreateBackdrop()

    CastBar.Button.Backdrop:SetOutside()
    CastBar.Button.Backdrop:SetBackdropBorderColor(unpack(C.General.BackdropColor))
    -- CastBar.Button.Backdrop:CreateShadow()

    CastBar.Icon = CastBar.Button:CreateTexture(nil, "ARTWORK")
    CastBar.Icon:SetAllPoints()
    CastBar.Icon:SetTexCoord(unpack(T.IconCoord))

    -- self.Castbar = CastBar
end

function UnitFrames:SetupFocusCastBar()
    local Power = self.Power
    local CastBar = self.Castbar
    if (not CastBar) then return end

    local _, Height = T.GetSize(self.unit)

    CastBar:SetAllPoints(Power)
    -- CastBar:SetStatusBarTexture(CastTexture)
    -- CastBar:SetFrameLevel(6)

    -- CastBar.Backdrop = CreateFrame("Frame", nil, CastBar, "BackdropTemplate")
    -- CastBar.Backdrop:SetAllPoints()
    -- CastBar.Backdrop:SetFrameLevel(CastBar:GetFrameLevel() - 1)
    -- CastBar.Backdrop:SetBackdrop(UnitFrames.Backdrop)
    -- CastBar.Backdrop:SetBackdropColor(unpack(C.General.BackdropColor))

    -- CastBar.Text = CastBar:CreateFontString(nil, "OVERLAY")
    -- CastBar.Text:SetFontObject(Font)
    -- CastBar.Text:SetPoint("CENTER", CastBar)
    -- CastBar.Text:SetTextColor(0.84, 0.75, 0.65)
    -- CastBar.Text:SetWidth(CastBar:GetWidth())
    -- CastBar.Text:SetJustifyH("CENTER")

    -- CastBar.Spark = CastBar:CreateTexture(nil, "OVERLAY")
    -- CastBar.Spark:SetSize(8, CastBar:GetHeight())
    -- CastBar.Spark:SetBlendMode("ADD")
    -- CastBar.Spark:SetPoint("CENTER", CastBar:GetStatusBarTexture(), "RIGHT", 0, 0)

    if (CastBar.Button) then
        CastBar.Button:ClearAllPoints()
        CastBar.Button:SetSize(Height, Height)
        CastBar.Button:SetPoint("RIGHT", self, "LEFT", -3, 0)
        CastBar.Button:CreateBackdrop()
        CastBar.Button.Backdrop:SetOutside()
        CastBar.Button.Backdrop.Shadow:Kill()
    end

    -- CastBar.Button.Backdrop:SetOutside()
    -- CastBar.Button.Backdrop:SetBackdropBorderColor(unpack(C.General.BackdropColor))
    -- CastBar.Button.Backdrop:CreateShadow()

    -- CastBar.Icon = CastBar.Button:CreateTexture(nil, "ARTWORK")
    -- CastBar.Icon:SetAllPoints()
    -- CastBar.Icon:SetTexCoord(unpack(T.IconCoord))

    -- CastBar.CustomTimeText = UnitFrames.CustomCastTimeText
    -- CastBar.CustomDelayText = UnitFrames.CustomCastDelayText
    -- CastBar.PostCastStart = UnitFrames.CheckCast
    -- CastBar.PostChannelStart = UnitFrames.CheckChannel
end
