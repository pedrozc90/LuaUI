local T, C, L = Tukui:unpack()
local ActionBars = T.ActionBars
local NUM_ACTIONBAR_BUTTONS = NUM_ACTIONBAR_BUTTONS

local ceil = math.ceil

----------------------------------------------------------------
-- ActionBar3: Page 5 Bottom Right ActionBar (slots 49 to 60)
----------------------------------------------------------------
local baseCreateBar3 = ActionBars.CreateBar3

function ActionBars:CreateBar3()
    -- first, we call the base function
    baseCreateBar3(self)

    -- second, we edit it
    if (not C.ActionBars.BottomRightBar) then return end

    local ActionBar3 = ActionBars.Bars.Bar3

    local MultiBarBottomRight = MultiBarBottomRight
    local Size = C.ActionBars.NormalButtonSize
	local Spacing = C.ActionBars.ButtonSpacing
	local ButtonsPerRow = C.ActionBars.Bar3ButtonsPerRow
	local NumButtons = C.ActionBars.Bar3NumButtons

	local Padding = (C.ActionBars.ActionBar3Background) and (Spacing + 1) or 0
	
	if NumButtons <= ButtonsPerRow then
		ButtonsPerRow = NumButtons
	end
	
    local NumRow = ceil(NumButtons / ButtonsPerRow)
	
	local Width, Height = ActionBars.GetBackgroundSize(ButtonsPerRow, NumRow, Size, Spacing, C.ActionBars.ActionBar3Background)

    ActionBar3:ClearAllPoints()
    ActionBar3:SetPoint("TOPLEFT", UIParent, "TOPLEFT", 250, -C.Lua.ScreenMargin)
    ActionBar3:SetWidth(Width)
	ActionBar3:SetHeight(Height)

    if (C.ActionBars.ShowBackdrop) then
        ActionBar3:SetBackdropTransparent()
        ActionBar3.Shadow:Kill()
    end

	if (ActionBar3.Backdrop and (not C.ActionBars.ActionBar3Background)) then
		ActionBar3.Backdrop:Kill()
	end

    local NumPerRows = ButtonsPerRow
	local NextRowButtonAnchor = _G["MultiBarBottomRightButton1"]

	for i = 1, NUM_ACTIONBAR_BUTTONS do
		local Button = _G["MultiBarBottomRightButton"..i]
		local PreviousButton = _G["MultiBarBottomRightButton"..i-1]
		
		Button:SetSize(Size, Size)
		Button:ClearAllPoints()
		Button:SetAttribute("showgrid", 1)
		Button:ShowGrid(ACTION_BUTTON_SHOW_GRID_REASON_EVENT)

		ActionBars:SkinButton(Button)

		ActionBars.HideActionSlot(Button)
		Button:SetScript("OnEnter", ActionBars.ShowActionSlot)
		Button:SetScript("OnLeave", ActionBars.HideActionSlot)
		
		if (i <= NumButtons) then
			if (i == 1) then
				Button:SetPoint("TOPLEFT", ActionBar3, "TOPLEFT", Padding, -Padding)
			elseif (i == NumPerRows + 1) then
				Button:SetPoint("TOPLEFT", NextRowButtonAnchor, "BOTTOMLEFT", 0, -Spacing)

				NumPerRows = NumPerRows + ButtonsPerRow
				NextRowButtonAnchor = _G["MultiBarBottomRightButton"..i]
			else
				Button:SetPoint("LEFT", PreviousButton, "RIGHT", Spacing, 0)
			end
		else
			Button:SetPoint("TOP", UIParent, "TOP", 0, 200)
		end
	end
end
