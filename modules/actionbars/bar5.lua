local T, C, L = Tukui:unpack()
local ActionBars = T.ActionBars
local Movers = T.Movers
local NUM_ACTIONBAR_BUTTONS = NUM_ACTIONBAR_BUTTONS

----------------------------------------------------------------
-- ActionBar5
----------------------------------------------------------------
local baseCreateBar5 = ActionBars.CreateBar5

function ActionBars:CreateBar5()
    -- first, we call the base function
    baseCreateBar5(self)

    -- second, we edit it
    local ActionBar5 = ActionBars.Bars.Bar5
    if (not ActionBar5) then return end
    
    local MultiBarLeft = MultiBarLeft
	local Size = C.ActionBars.NormalButtonSize
	local Spacing = C.ActionBars.ButtonSpacing
	local ButtonsPerRow = C.ActionBars.Bar5ButtonsPerRow
	local NumButtons = C.ActionBars.Bar5NumButtons

    local Padding = Size + Spacing + 7

    ActionBar5:ClearAllPoints()
    ActionBar5:SetPoint("RIGHT", UIParent, "RIGHT", -Padding, 7)

    if (C.ActionBars.ShowBackdrop) then
        ActionBar5:SetBackdropTransparent()
        ActionBar5.Shadow:Kill()
    end

    -- local Bar = T.Panels.ActionBar5
    -- local MultiBarLeft = MultiBarLeft
    -- local Size = C.ActionBars.NormalButtonSize
	-- local Spacing = C.ActionBars.ButtonSpacing

    -- MultiBarLeft:SetParent(Bar)
	-- MultiBarLeft:SetScript("OnHide", function() Bar.Backdrop:Hide() end)
    -- MultiBarLeft:SetScript("OnShow", function() Bar.Backdrop:Show() end)

    -- Bar:ClearAllPoints()
    -- Bar:SetPoint("RIGHT", Panels.ActionBar4, "LEFT", -7, 0)
    -- Bar:SetWidth((Size * 1) + (Spacing * 2) - 2)
    -- Bar:SetHeight((Size * 12) + (Spacing * 13) - 2)
    -- Bar.Backdrop:StripTextures(true)
    -- Bar.Backdrop = nil
    -- Bar:CreateBackdrop("Transparent")

	-- for i = 1, NUM_ACTIONBAR_BUTTONS do
	-- 	local Button = _G["MultiBarLeftButton"..i]
	-- 	Button:ClearAllPoints()
	-- 	Button:SetSize(Size)

    --     if (i == 1) then
    --         local Offset = Spacing - 1
	-- 		Button:SetPoint("TOPLEFT", Bar, "TOPLEFT", Offset, -Offset)
    --     else
    --         local PreviousButton = _G["MultiBarLeftButton"..i-1]
	-- 		Button:SetPoint("TOP", PreviousButton, "BOTTOM", 0, -Spacing)
	-- 	end

	-- 	Bar["Button"..i] = Button
	-- end

	-- RegisterStateDriver(Bar, "visibility", "[vehicleui][petbattle][overridebar] hide; show")
end
