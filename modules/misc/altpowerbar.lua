local T, C, L = Tukui:unpack()
local AltPowerBar = T.Miscellaneous.AltPowerBar
local DataTexts = T.DataTexts

----------------------------------------------------------------
-- Alternative Power Bar
----------------------------------------------------------------
local baseCreate = AltPowerBar.Create

function AltPowerBar:Create()

    -- first, call the base function
    baseCreate(self)

    -- second, we edit it
    local DataTextLeft = DataTexts.Panels.Left
    local Status = self.Status
    local Text = self.Status.Text

    -- local Font, FontSize, FontStyle = C["Medias"].PixelFont, 12, "MONOCHROMEOUTLINE"

    Status:ClearAllPoints()
    Status:SetInside(DataTextLeft)
    Status:SetStatusBarTexture(C.Medias.Blank)

    Status.Text:ClearAllPoints()
    Status.Text:SetPoint("CENTER", self, "CENTER", 0, -23)
    Status.Text:SetFont(C.Medias.Font, 12)
    Status.Text:SetJustifyH("CENTER")

    Status.Percent:ClearAllPoints()
    Status.Percent:SetPoint("CENTER", self, "CENTER", 0, 0)
    Status.Percent:SetFont(C.Medias.Font, 12)
    Status.Percent:SetJustifyH("CENTER")
end
