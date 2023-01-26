local T, C, L = Tukui:unpack()
local ThreatBar = T.Miscellaneous.ThreatBar
local DataTexts = T.DataTexts

----------------------------------------------------------------
-- Threat Bar
----------------------------------------------------------------
local baseCreate = ThreatBar.Create

function ThreatBar:Create()
    -- first, we call the base function
    baseCreate(self)

    -- second, we edit it
    local DataTextRight = DataTexts.Panels.Right
    local Texture = T.GetTexture(C.Lua.Texture)
    -- local Font, FontSize, FontStyle = C.Medias.PixelFont, 12, "MONOCHROMEOUTLINE"
    local xOffset, yOffset = 7, 1

    self:ClearAllPoints()
    self:SetPoint("BOTTOMRIGHT", DataTextRight, "BOTTOMRIGHT", 0, 0)
    self:SetSize(DataTextRight:GetSize())
    self:SetStatusBarTexture(Texture)

    if (self.Shadow) then
        self.Backdrop.Shadow:Kill()
    end

    self.Text:ClearAllPoints()
    self.Text:SetPoint("RIGHT", self, "RIGHT", -xOffset, yOffset)
    self.Text:SetFont(C.Medias.Font, 12)
    self.Text:SetJustifyH("RIGHT")

    self.Title:ClearAllPoints()
    self.Title:SetPoint("LEFT", self, "LEFT", xOffset, yOffset)
    self.Title:SetFont(C.Medias.Font, 12)
    self.Title:SetJustifyH("LEFT")

    self.Background:SetAllPoints()
    self.Background:SetColorTexture(unpack(C.General.BackdropColor))
end
