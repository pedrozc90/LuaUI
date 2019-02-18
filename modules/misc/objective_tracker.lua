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
    local ObjectiveFrameHolder = TukuiObjectiveTracker
    local Data = TukuiData[T.MyRealm][T.MyName]

    ObjectiveFrameHolder:ClearAllPoints()
    ObjectiveFrameHolder:Point("TOPRIGHT", UIParent, "TOPRIGHT", -228, -190)

    ObjectiveTrackerFrame:ClearAllPoints()
    ObjectiveTrackerFrame:SetPoint("TOP", ObjectiveFrameHolder)
end
hooksecurefunc(ObjectiveTracker, "SetDefaultPosition", SetDefaultPosition)

local function UpdateProgressBar(self, _, line)
    local Progress = line.ProgressBar
    local Bar = Progress.Bar

    if (Bar) then
        local Label = Bar.Label
        local Icon = Bar.Icon

        local Font, FontSize, FontStyle = C["Medias"].Font, 12, nil

        if (Bar.IsSkinned) then
            Bar:Height(16)

            if (Label) then
                Label:ClearAllPoints()
                Label:SetPoint("CENTER", Bar, "CENTER", 0, -1)
                Label:SetFont(Font, FontSize, FontStyle)
            end

            if (Icon) then
                Icon:ClearAllPoints()
                Icon:Point("LEFT", Bar, "RIGHT", 7, 0)
                Icon:Size(Bar:GetHeight())
                Icon:SetTexCoord(unpack(T.IconCoord))
            end
        end
    end
end
hooksecurefunc(ObjectiveTracker, "UpdateProgressBar", UpdateProgressBar)