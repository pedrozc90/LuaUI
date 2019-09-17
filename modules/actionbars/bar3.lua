local T, C, L = Tukui:unpack()
local ActionBars = T.ActionBars
local Panels = T.Panels
local NUM_ACTIONBAR_BUTTONS = NUM_ACTIONBAR_BUTTONS

----------------------------------------------------------------
-- ActionBar3
----------------------------------------------------------------
local function CreateBar3()
    local Bar = Panels.ActionBar6
    local MultiBarBottomRight = MultiBarBottomRight
    local Size = C.ActionBars.NormalButtonSize
	local Spacing = C.ActionBars.ButtonSpacing
    
    MultiBarBottomRight:SetParent(Bar)
    MultiBarBottomRight:SetScript("OnHide", function() Bar.Backdrop:Hide() end)
    MultiBarBottomRight:SetScript("OnShow", function() Bar.Backdrop:Show() end)

    Bar:ClearAllPoints()
    Bar:Point("LEFT", UIParent, "LEFT", 7, 35)
    Bar:Width((Size * 1) + (Spacing * 2) - 2)
    Bar:Height((Size * 12) + (Spacing * 13) - 2)
    Bar.Backdrop:SetBorder("Transparent")
	Bar.Backdrop:SetOutside(nil, 2, 2)

	for i = 1, NUM_ACTIONBAR_BUTTONS do
		local Button = _G["MultiBarBottomRightButton"..i]
        Button:ClearAllPoints()
        Button:Size(Size)

        local Offset = Spacing - 1
        if (i == 1) then
            Button:SetPoint("TOPLEFT", Bar, "TOPLEFT", Offset, -Offset)
        else
            local PreviousButton = _G["MultiBarBottomRightButton"..i-1]
            Button:SetPoint("TOP", PreviousButton, "BOTTOM", 0, -Spacing)
        end

		Bar["Button"..i] = Button
	end

    RegisterStateDriver(Bar, "visibility", "[vehicleui][petbattle][overridebar] hide; show")
end
hooksecurefunc(ActionBars, "CreateBar3", CreateBar3)