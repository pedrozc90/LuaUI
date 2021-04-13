local T, C, L = Tukui:unpack()
local ActionBars = T.ActionBars
local Movers = T.Movers
local NUM_ACTIONBAR_BUTTONS = NUM_ACTIONBAR_BUTTONS

local ceil = math.ceil

----------------------------------------------------------------
-- ActionBar4
----------------------------------------------------------------
local baseCreateBar4 = ActionBars.CreateBar4

function ActionBars:CreateBar4()

    -- first, we call the base function
    baseCreateBar4(self)

	-- second, we edit it
	if (not C.ActionBars.RightBar) then return end

	local ActionBar4 = ActionBars.Bars.Bar4

    local MultiBarRight = MultiBarRight
	local Size = C.ActionBars.NormalButtonSize
	local Spacing = C.ActionBars.ButtonSpacing
	local ButtonsPerRow = C.ActionBars.Bar4ButtonsPerRow
	local NumButtons = C.ActionBars.Bar4NumButtons
	local Offset = (C.ActionBars.ShowBackdrop) and (Spacing + 1) or 0

	if (NumButtons <= ButtonsPerRow) then
		ButtonsPerRow = NumButtons
	end
	
	local NumRow = ceil(NumButtons / ButtonsPerRow)

	local Width, Height = ActionBars.GetBackgroundSize(ButtonsPerRow, NumRow, Size, Spacing, C.ActionBars.ShowBackdrop)

	ActionBar4:ClearAllPoints()
	ActionBar4:SetWidth(Width)
	ActionBar4:SetHeight(Height)
	if (C.ActionBars.VerticalRightBars) then
		ActionBar4:SetPoint("RIGHT", UIParent, "RIGHT", -C.Lua.ScreenMargin, ceil(-Height / 2) + 7)
	else
		ActionBar4:SetPoint("RIGHT", UIParent, "RIGHT", -C.Lua.ScreenMargin, 5)
	end

    if (C.ActionBars.ShowBackdrop) then
		ActionBar4:SetBackdropTransparent()
		ActionBar4.Shadow:Kill()
    end

	local NumPerRows = ButtonsPerRow
	local NextRowButtonAnchor = _G["MultiBarRightButton1"]

	for i = 1, NUM_ACTIONBAR_BUTTONS do
		local Button = _G["MultiBarRightButton"..i]
		local PreviousButton = _G["MultiBarRightButton"..i-1]
		
		Button:SetSize(Size, Size)
		Button:ClearAllPoints()
		Button:SetAttribute("showgrid", 1)
		Button:ShowGrid(ACTION_BUTTON_SHOW_GRID_REASON_EVENT)

		ActionBars:SkinButton(Button)
		
		if i <= NumButtons then
			if (i == 1) then
				Button:SetPoint("TOPLEFT", ActionBar4, "TOPLEFT", Offset, -Offset)
			elseif (i == NumPerRows + 1) then
				Button:SetPoint("TOPLEFT", NextRowButtonAnchor, "BOTTOMLEFT", 0, -Spacing)

				NumPerRows = NumPerRows + ButtonsPerRow
				NextRowButtonAnchor = _G["MultiBarRightButton"..i]
			else
				Button:SetPoint("LEFT", PreviousButton, "RIGHT", Spacing, 0)
			end
		else
			Button:SetPoint("TOP", UIParent, "TOP", 0, 200)
		end
	end
end
