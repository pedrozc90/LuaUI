local T, C, L = Tukui:unpack()
local AltPowerBar = T.Miscellaneous.AltPowerBar
local Panels = T.Panels

----------------------------------------------------------------
-- Alternative Power Bar
----------------------------------------------------------------
local function Create(self)
    local DataTextLeft = Panels.DataTextLeft
    local Status = self.Status
    local Text = self.Status.Text

    local Font, FontSize, FontStyle = C["Medias"].PixelFont, 12, "MONOCHROMEOUTLINE"

    Status:ClearAllPoints()
    Status:SetInside(DataTextLeft)
    Status:SetStatusBarTexture(C.Medias.Blank)

    Text:ClearAllPoints()
    Text:Point("CENTER", self, "CENTER", 0, 1)
    Text:SetFont(Font, FontSize, FontStyle)
    Text:SetJustifyH("CENTER")
end
hooksecurefunc(AltPowerBar, "Create", Create)
