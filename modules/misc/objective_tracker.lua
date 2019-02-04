local T, C, L = Tukui:unpack()
local ObjectiveTracker = T.Miscellaneous.ObjectiveTracker

----------------------------------------------------------------
-- Objective Tracker
----------------------------------------------------------------
function ObjectiveTracker:CreateToggleButtons()
    local Font, FontSize, FontStyle = C["Medias"].PixelFont, 14, "MONOCHROMEOUTLINE"

    local Button = CreateFrame("Button", nil, self)
    Button:SetPoint("TOPRIGHT", ObjectiveTrackerFrame,"TOPRIGHT", 29, -2)
    Button:Size(18)
    Button:SetAlpha(0)
    Button:CreateBackdrop("Transparent")
	Button:RegisterForClicks("AnyUp")
	Button:SetScript("OnClick", self.OnClick)
	Button:SetScript("OnEnter", self.OnEnter)
	Button:SetScript("OnLeave", self.OnLeave)

	Button.Toggle = Button:CreateFontString(nil, "OVERLAY")
    Button.Toggle:SetPoint("CENTER", Button, "CENTER", 2, 2)
    Button.Toggle:Size(Button:GetSize())
    Button.Toggle:SetFont(Font, FontSize, FontStyle)
    Button.Toggle:SetText(">")
    
    self.ToggleButon = Button
end

local function SetDefaultPosition()
    local Holder = TukuiObjectiveTracker

    Holder:ClearAllPoints()
    Holder:Point("TOPRIGHT", UIParent, "TOPRIGHT", -228, -190)
end
hooksecurefunc(ObjectiveTracker, "SetDefaultPosition", SetDefaultPosition)