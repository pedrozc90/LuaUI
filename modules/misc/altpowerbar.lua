local T, C, L = Tukui:unpack()
local AltPowerBar = T.Miscellaneous.AltPowerBar
local DataTexts = T.DataTexts
local ActionBars = T.ActionBars

----------------------------------------------------------------
-- Alternative Power Bar
----------------------------------------------------------------
local baseUpdate = AltPowerBar.Update
local baseCreate = AltPowerBar.Create

function AltPowerBar:Update()
    -- first, call the base function
    baseUpdate(self)

    -- second, we edit it
    if (C.General.OverDataTextLeft) then return end

    local Status = self.Status
    local Percent = self.Percent

    local ActionBar3 = ActionBars.Bars.Bar3

    self:ClearAllPoints()
    if (ActionBar3 and ActionBar3:IsShown()) then
        self:SetPoint("TOP", ActionBar3, "BOTTOM", 0, -3)
    else
        self:SetPoint("TOP", UIParent, "TOP", 0, -C.Lua.ScreenMargin)
    end
end

function AltPowerBar:Create()
    -- first, call the base function
    baseCreate(self)

    -- second, we edit it
    local DataTextLeft = DataTexts.Panels.Left
    local Status = self.Status
    local Text = self.Status.Text

    if (C.General.OverDataTextLeft) then
        self:ClearAllPoints()
        self:SetInside(DataTextLeft, 0, 0)
    else
        self:ClearAllPoints()
        self:SetSize(275, 18)
        self:SetPoint("TOP", UIParent, "TOP", 0, -C.Lua.ScreenMargin)
    end

    Status:SetStatusBarTexture(C.Medias.Blank)

    Status.Text:ClearAllPoints()
    Status.Text:SetPoint("LEFT", Status, "LEFT", 5, 0)
    Status.Text:SetFont(C.Medias.Font, 12)
    Status.Text:SetJustifyH("CENTER")

    Status.Percent:ClearAllPoints()
    Status.Percent:SetPoint("RIGHT", Status, "RIGHT", -5, 0)
    Status.Percent:SetFont(C.Medias.Font, 12)
    Status.Percent:SetJustifyH("CENTER")
end
