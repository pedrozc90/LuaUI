local T, C, L = Tukui:unpack()
local ActionBars = T.ActionBars
local Panels = T.Panels
local NUM_ACTIONBAR_BUTTONS = NUM_ACTIONBAR_BUTTONS

----------------------------------------------------------------
-- ActionBar4
----------------------------------------------------------------
local function CreateBar4()
    local Bar = T.Panels.ActionBar4
    local MultiBarRight = MultiBarRight
    local Size = C.ActionBars.NormalButtonSize
	local Spacing = C.ActionBars.ButtonSpacing

	MultiBarRight:SetParent(Bar)
	MultiBarRight:SetScript("OnHide", function() Bar.Backdrop:Hide() end)
	MultiBarRight:SetScript("OnShow", function() Bar.Backdrop:Show() end)

    Bar:ClearAllPoints()
    Bar:Point("RIGHT", UIParent, "RIGHT", -7, 35)
    Bar:Width((Size * 1) + (Spacing * 2) - 2)
    Bar:Height((Size * 12) + (Spacing * 13) - 2)
    Bar.Backdrop:SetBorder("Transparent")
	Bar.Backdrop:SetOutside(nil, 2, 2)

	for i = 1, NUM_ACTIONBAR_BUTTONS do
		local Button = _G["MultiBarRightButton"..i]
		Button:ClearAllPoints()
		Button:Size(Size)

        if (i == 1) then
            local Offset = Spacing - 1
			Button:SetPoint("TOPLEFT", Bar, "TOPLEFT", Offset, -Offset)
        else
            local PreviousButton = _G["MultiBarRightButton"..i-1]
			Button:SetPoint("TOP", PreviousButton, "BOTTOM", 0, -Spacing)
		end

		Bar["Button"..i] = Button
	end

	RegisterStateDriver(Bar, "visibility", "[vehicleui][petbattle][overridebar] hide; show")
end
hooksecurefunc(ActionBars, "CreateBar4", CreateBar4)