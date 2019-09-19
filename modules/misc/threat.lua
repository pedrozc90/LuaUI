local T, C, L = Tukui:unpack()
local ThreatBar = T.Miscellaneous.ThreatBar
local DataTextRight = T.Panels.DataTextRight

----------------------------------------------------------------
-- Threat Bar
----------------------------------------------------------------
local function Enable(self)
    -- resources
    local Texture = T.GetTexture(C.Lua.Texture)
    local Font, FontSize, FontStyle = C.Medias.PixelFont, 12, "MONOCHROMEOUTLINE"
    local xOffset, yOffset = 7, 1

    self:ClearAllPoints()
    self:SetInside(DataTextRight)
    self:SetStatusBarTexture(Texture)

    self.Text:ClearAllPoints()
    self.Text:Point("RIGHT", self, "RIGHT", -xOffset, yOffset)
    self.Text:SetFont(Font, FontSize, FontStyle)
    self.Text:SetJustifyH("RIGHT")

    self.Title:ClearAllPoints()
    self.Title:Point("LEFT", self, "LEFT", xOffset, yOffset)
    self.Title:SetFont(Font, FontSize, FontStyle)
    self.Title:SetJustifyH("LEFT")

    self.Background:SetAllPoints()
    self.Background:SetColorTexture(.05, .05, .05)

end
hooksecurefunc(ThreatBar, "Enable", Enable)
