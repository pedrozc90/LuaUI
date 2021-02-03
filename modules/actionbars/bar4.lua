local T, C, L = Tukui:unpack()
local ActionBars = T.ActionBars
local Movers = T.Movers
local NUM_ACTIONBAR_BUTTONS = NUM_ACTIONBAR_BUTTONS

----------------------------------------------------------------
-- ActionBar4
----------------------------------------------------------------
local baseCreateBar4 = ActionBars.CreateBar4

function ActionBars:CreateBar4()

    -- first, we call the base function
    baseCreateBar4(self)

    -- second, we edit it
	local ActionBar4 = ActionBars.Bars.Bar4
	if (not ActionBar4) then return end

    local MultiBarRight = MultiBarRight
	local Size = C.ActionBars.NormalButtonSize
	local Spacing = C.ActionBars.ButtonSpacing
	local ButtonsPerRow = C.ActionBars.Bar4ButtonsPerRow
	local NumButtons = C.ActionBars.Bar4NumButtons

    ActionBar4:ClearAllPoints()
    ActionBar4:SetPoint("RIGHT", UIParent, "RIGHT", -7, 7)

    if (C.ActionBars.ShowBackdrop) then
		ActionBar4:SetBackdropTransparent()
		ActionBar4.Shadow:Kill()
    end

	-- for i = 1, NUM_ACTIONBAR_BUTTONS do
	-- 	local Button = _G["MultiBarRightButton"..i]
	-- 	Button:ClearAllPoints()
	-- 	Button:SetSize(Size)

    --     if (i == 1) then
    --         local Offset = Spacing - 1
	-- 		Button:SetPoint("TOPLEFT", Bar, "TOPLEFT", Offset, -Offset)
    --     else
    --         local PreviousButton = _G["MultiBarRightButton"..i-1]
	-- 		Button:SetPoint("TOP", PreviousButton, "BOTTOM", 0, -Spacing)
	-- 	end

	-- 	Bar["Button"..i] = Button
	-- end

	-- RegisterStateDriver(ActionBar5, "visibility", "[vehicleui] hide; show")
end
