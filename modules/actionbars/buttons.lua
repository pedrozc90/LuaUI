local T, C, L = Tukui:unpack()
local ActionBars = T.ActionBars
local Panels = T.Panels

----------------------------------------------------------------
-- ActionBars Buttons
----------------------------------------------------------------
local BarButtons = {}

local OnEnter = function(self)
	self:SetAlpha(1)
end

local OnLeave = function(self)
	self:SetAlpha(0)
end

local OnClick = function(self, button)
    if InCombatLockdown() then
		return T.Print(ERR_NOT_IN_COMBAT)
    end
    
    local ShiftClick = IsShiftKeyDown()
    local ID = self.ID
    local Bar = self.Bar
    local Anchor = self.Anchor

    if (Bar:IsVisible() or (ShiftClick and ID == 1)) then
        -- Visibility
        UnregisterStateDriver(Bar, "visibility")
        Bar:Hide()

        if (ShiftClick) then
            -- hide anchor as well
            UnregisterStateDriver(Anchor, "visibility")
            Anchor:Hide()
        end

        -- Move the button
        self:ClearAllPoints()

        if (ID == 1) then
            if (Anchor:IsVisible()) then
                self:Point("TOP", Anchor, "BOTTOM", 0, -7)
                self:Size(Anchor:GetWidth(), 16)
            else
                self:Point("RIGHT", Anchor, "RIGHT", 0, 0)
                self:Size(16, Anchor:GetHeight() / 2)
            end
            self.Text:Point("CENTER", self, "CENTER", 2, 1)
            self.Text:SetText("<")
        elseif (ID == 2) then
            self:Point("LEFT", Anchor, "LEFT", 0, 0)
            self:Size(16, Anchor:GetHeight() / 2)
            self.Text:Point("CENTER", self, "CENTER", 1, 1)
            self.Text:SetText(">")
        end
    else
        -- Visibility
		RegisterStateDriver(Bar, "visibility", "[vehicleui][petbattle][overridebar] hide; show")
        Bar:Show()

        if (not Anchor:IsVisible()) then
            RegisterStateDriver(Anchor, "visibility", "[vehicleui][petbattle][overridebar] hide; show")
            Anchor:Show()
        end
        
        -- Move the button
        self:ClearAllPoints()

        if (ID == 1) then
            self:Point("TOP", Anchor, "BOTTOM", 0, -7)
            self:Size(Anchor:GetWidth(), 16)
            self.Text:Point("CENTER", self, "CENTER", 1, 1)
            self.Text:SetText(">")
        elseif (ID == 2) then
            self:Point("TOP", Anchor, "BOTTOM", 0, -7)
            self:Size(Anchor:GetWidth(), 16)
            self.Text:Point("CENTER", self, "CENTER", 2, 1)
            self.Text:SetText("<")
        end
    end
end

function ActionBars:CreateToggleButtons()
    local Font, FontSize, FontStyle = C.Medias.PixelFont, 12, "MONOCHROMEOUTLINE"

    -- remove existing buttons
    for i = 1, 2 do
        -- local Bar = Panels["ActionBar" .. i]
        -- local Width = Bar:GetWidth()
        -- local Height = Bar:GetHeight()

        -- toggle button to show/hide actionbar5 (RightBar)
        local Button = CreateFrame("Button", nil, UIParent)
        Button:SetFrameStrata("BACKGROUND")
        Button:SetFrameLevel(4)
        Button:CreateBackdrop("Transparent")
        Button:RegisterForClicks("AnyUp")
        Button:SetAlpha(0)

        Button.ID = i
        
        Button:SetScript("OnClick", OnClick)
        Button:SetScript("OnEnter", OnEnter)
        Button:SetScript("OnLeave", OnLeave)

        Button.Text = Button:CreateFontString(nil, "OVERLAY")
        Button.Text:SetFont(Font, FontSize, FontStyle)
        

        if (i == 1) then
            Button.Bar = Panels.ActionBar5
            Button.Anchor = Panels.ActionBar4
            Button:Point("TOP", Button.Anchor, "BOTTOM", 0, -7)
            Button:Size(Button.Anchor:GetWidth(), 16)
            Button.Text:Point("CENTER", Button, "CENTER", 1, 1)
            Button.Text:SetText(">")
        elseif (i == 2) then
            Button.Bar = Panels.ActionBar6
            Button.Anchor = Panels.ActionBar6
            Button:Point("TOP", Button.Anchor, "BOTTOM", 0, -7)
            Button:Size(Button.Anchor:GetWidth(), 16)
            Button.Text:Point("CENTER", Button, "CENTER", 2, 1)
            Button.Text:SetText("<")
        end

        BarButtons[i] = Button

		Panels["ActionBar" .. i .. "ToggleButton"] = Button
    end
end
-- hooksecurefunc(ActionBars, "CreateToggleButtons", CreateToggleButtons)