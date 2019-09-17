local T, C, L = Tukui:unpack()
local ObjectiveTracker = T.Miscellaneous.ObjectiveTracker

if (not C.Lua.Enable) then return end
----------------------------------------------------------------
-- Objective Tracker
----------------------------------------------------------------
-- make sure objective track is hidden after reload
function ObjectiveTracker:LoadVariables()
    if (not LuaUIData[T.MyRealm][T.MyName]) then
        LuaUIData[T.MyRealm][T.MyName] = {}
    end

    local Data = LuaUIData[T.MyRealm][T.MyName]

    if (Data["HideObjectiveTracker"]) then
        self:OnClick()
    end
end

local function OnClick(self)
    local Data = LuaUIData[T.MyRealm][T.MyName]
    
    if (ObjectiveTrackerFrame:IsVisible()) then
        Data["HideObjectiveTracker"] = false
    else
        Data["HideObjectiveTracker"] = true
    end
end
hooksecurefunc(ObjectiveTracker, "OnClick", OnClick)

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
    
    self.Button = Button
    self.Toggle = Button.Toggle
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

local function Enable(self)
    self:LoadVariables()
end
hooksecurefunc(ObjectiveTracker, "Enable", Enable)