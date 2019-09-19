local T, C, L = Tukui:unpack()
local ActionBars = T.ActionBars
local Panels = T.Panels

----------------------------------------------------------------
-- ActionBars Buttons
----------------------------------------------------------------
local IsShiftKeyDown = IsShiftKeyDown
local InCombatLockdown = InCombatLockdown
local error = ERR_NOT_IN_COMBAT
local BarButtons = {}

local OnEnter = function(self)
	self:SetAlpha(1)
end

local OnLeave = function(self)
	self:SetAlpha(0)
end

local OnClick = function(self, button)
    if (InCombatLockdown()) then
        return T.Print(error)
    end

    local Data = LuaUIData[GetRealmName()][UnitName("player")]

    local ShiftClick = IsShiftKeyDown()
    local Num = self.Num
    local Bar = self.Bar
    local Anchor = self.Anchor
    local Text = self.Text

    local Offset = 7

    if (Bar:IsVisible()) then
        if (ShiftClick) then
            if (Num == 5) then
                -- Visibility
                UnregisterStateDriver(Panels.ActionBar4, "visibility")
                UnregisterStateDriver(Panels.ActionBar5, "visibility")
                Panels.ActionBar4:Hide()
                Panels.ActionBar5:Hide()

                -- Move the button
                self:ClearAllPoints()
                self:Point("RIGHT", Anchor, "RIGHT", 0, 0)
                self:Size(16, Anchor:GetHeight() / 3)
                Text:SetText("<<")

                -- Set value
			    Data["HideBar5"] = true
            end
        else
            -- Visibility
			UnregisterStateDriver(Bar, "visibility")
            Bar:Hide()
            
            -- Move the button
            self:ClearAllPoints()
            
            if (Num == 5) then
                self:Point("TOP", Anchor, "BOTTOM", 0, -Offset)
                self:Size(Anchor:GetWidth(), 16)
                Text:SetText("<")
            elseif (Num == 6) then
                self:Point("LEFT", Anchor, "LEFT", 0, 0)
                self:Size(16, Anchor:GetHeight() / 3)
                Text:SetText(">")
            end

            -- Set value
			Data["HideBar"..Num] = true
        end
    else
        -- Visibility
		RegisterStateDriver(Bar, "visibility", "[vehicleui][petbattle][overridebar] hide; show")
        Bar:Show()

        if (not Anchor:IsVisible()) then
            -- Visibility
            RegisterStateDriver(Anchor, "visibility", "[vehicleui][petbattle][overridebar] hide; show")
            Anchor:Show()
        end
        
        -- Move the button
        self:ClearAllPoints()
        
        if (Num == 5) then
            self:Point("TOP", Anchor, "BOTTOM", 0, -Offset)
            self:Size(Anchor:GetWidth(), 16)
            Text:SetText(">")
        elseif (Num == 6) then
            self:Point("TOP", Anchor, "BOTTOM", 0, -Offset)
            self:Size(Anchor:GetWidth(), 16)
            Text:SetText("<")
        end

        -- Set value
		Data["HideBar"..Num] = false
    end
end

local function CreateToggleButtons()
    local Font, FontSize, FontStyle = C.Medias.PixelFont, 12, "MONOCHROMEOUTLINE"

    for i = 2, 5 do
        local Button = Panels["ActionBar" .. i .. "ToggleButton"]
        Button:SetScript("OnClick", nil)
		Button:SetScript("OnEnter", nil)
		Button:SetScript("OnLeave", nil)
        Button:Kill()
    end

    for i = 5, 6 do
        local Bar = Panels["ActionBar" .. i]
        local Width = Bar:GetWidth()
        local Height = Bar:GetHeight()

        local Button = CreateFrame("Button", nil, UIParent)
		Button:SetFrameStrata("BACKGROUND")
		Button:SetFrameLevel(4)
		Button:CreateBackdrop("Transparent")
		Button:RegisterForClicks("AnyUp")
        Button:SetAlpha(0)
        
        Button.Num = i
        Button.Bar = Bar

		Button:SetScript("OnClick", OnClick)
		Button:SetScript("OnEnter", OnEnter)
		Button:SetScript("OnLeave", OnLeave)

        Button.Text = Button:CreateFontString(nil, "OVERLAY")
        Button.Text:Point("CENTER", Button, "CENTER", 1, 1)
		Button.Text:SetFont(Font, FontSize, FontStyle)
        
        local Offset = 7

        if (i == 5) then
            Button.Anchor = Panels.ActionBar4

            Button:Point("TOP", Button.Anchor, "BOTTOM", 0, -Offset)
            Button:Size(Bar:GetWidth(), 16)
            Button.Text:SetText(">")
        elseif (i == 6) then
            Button.Anchor = Panels.ActionBar6

            Button:Point("TOP", Bar, "BOTTOM", 0, -Offset)
            Button:Size(Bar:GetWidth(), 16)
            Button.Text:SetText("<")
        end

        BarButtons[i] = Button

        Panels["ActionBarToggleButton" .. i] = Button
    end
end
hooksecurefunc(ActionBars, "CreateToggleButtons", CreateToggleButtons)

-- check character saved-variables
local function LoadVariables()
    if (not LuaUIData[GetRealmName()][UnitName("player")]) then
        LuaUIData[GetRealmName()][UnitName("player")] = {}
    end

    local Data = LuaUIData[GetRealmName()][UnitName("player")]

    -- hide actionbars
    for i = 5, 6 do
        local ToggleButton = BarButtons[i]
        
        if (Data["HideBar" .. i]) then
            OnClick(ToggleButton)
        end
    end
end
hooksecurefunc(ActionBars, "LoadVariables", LoadVariables)
