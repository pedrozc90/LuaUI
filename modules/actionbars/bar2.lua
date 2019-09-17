local T, C, L = Tukui:unpack()
local ActionBars = T.ActionBars
local Panels = T.Panels
local NUM_ACTIONBAR_BUTTONS = NUM_ACTIONBAR_BUTTONS

----------------------------------------------------------------
-- ActionBar2
----------------------------------------------------------------
local function CreateBar2()
    local LeftBar = Panels.ActionBar2
    local RightBar = Panels.ActionBar3
    local MultiBarBottomLeft = MultiBarBottomLeft
    local Size = C.ActionBars.NormalButtonSize
    local Spacing = C.ActionBars.ButtonSpacing

    local Width = (Size * 6) + (Spacing * 7) - 2
    local Height = (Size * 1) + (Spacing * 2) - 2

	MultiBarBottomLeft:SetParent(LeftBar)
    MultiBarBottomLeft:SetScript("OnHide", function()
        LeftBar.Backdrop:Hide()
        RightBar.Backdrop:Hide()
    end)

    MultiBarBottomLeft:SetScript("OnShow", function()
        LeftBar.Backdrop:Show()
        RightBar.Backdrop:Show()
    end)
    
    LeftBar:ClearAllPoints()
    LeftBar:Point("BOTTOMRIGHT", Panels.ActionBar1, "BOTTOMLEFT", -7, 0)
    LeftBar:Width(Width)
    LeftBar:Height(Height)
    LeftBar.Backdrop:SetBorder("Transparent")
	LeftBar.Backdrop:SetOutside(nil, 2, 2)

	for i = 1, NUM_ACTIONBAR_BUTTONS do
        local Button = _G["MultiBarBottomLeftButton"..i]
        Button:Show()
        Button:ClearAllPoints()
        Button:Size(Size)
        -- Button:SetAttribute("showgrid", 1)

        local Offset = Spacing - 1
		if (i == 1) then
			Button:SetPoint("BOTTOMRIGHT", LeftBar, "BOTTOMRIGHT", -Offset, Offset)
		elseif (i == 7) then
            Button:SetPoint("BOTTOMRIGHT", RightBar, "BOTTOMRIGHT", -Offset, Offset)
        else
            local PreviousButton = _G["MultiBarBottomLeftButton"..i-1]
			Button:SetPoint("RIGHT", PreviousButton, "LEFT", -Spacing, 0)
		end

		LeftBar["Button"..i] = Button
	end

	RegisterStateDriver(LeftBar, "visibility", "[vehicleui][petbattle][overridebar] hide; show")
end
hooksecurefunc(ActionBars, "CreateBar2", CreateBar2)

----------------------------------------------------------------
-- ActionBar3 Backdrop
----------------------------------------------------------------
local function CreateBar3()
    local Bar = Panels.ActionBar3
    local Size = C.ActionBars.NormalButtonSize
    local Spacing = C.ActionBars.ButtonSpacing

    local Width = (Size * 6) + (Spacing * 7) - 2
    local Height = (Size * 1) + (Spacing * 2) - 2
    
    Bar:ClearAllPoints()
    Bar:Point("BOTTOMLEFT", Panels.ActionBar1, "BOTTOMRIGHT", 7, 0)
    Bar:Width(Width)
    Bar:Height(Height)
    Bar.Backdrop:SetBorder("Transparent")
	Bar.Backdrop:SetOutside(nil, 2, 2)
end
hooksecurefunc(ActionBars, "CreateBar3", CreateBar3)