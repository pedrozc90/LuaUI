local T, C, L = Tukui:unpack()
local ActionBars = T.ActionBars
local Movers = T.Movers
local NUM_ACTIONBAR_BUTTONS = NUM_ACTIONBAR_BUTTONS

local ceil = math.ceil

----------------------------------------------------------------
-- ActionBar5
----------------------------------------------------------------
local baseCreateBar5 = ActionBars.CreateBar5

function ActionBars:CreateBar5()
    -- first, we call the base function
    baseCreateBar5(self)

	-- second, we edit it
	if (not C.ActionBars.LeftBar) then return end

    local ActionBar5 = ActionBars.Bars.Bar5
    local ActionBar4 = ActionBars.Bars.Bar4
    
    local MultiBarLeft = MultiBarLeft
	local Size = C.ActionBars.NormalButtonSize
	local Spacing = C.ActionBars.ButtonSpacing
	local ButtonsPerRow = C.ActionBars.Bar5ButtonsPerRow
    local NumButtons = C.ActionBars.Bar5NumButtons
	local Offset = (C.ActionBars.ShowBackdrop) and (Spacing + 1) or 0
    
    if (NumButtons <= ButtonsPerRow) then
		ButtonsPerRow = NumButtons
	end
	
	local NumRow = ceil(NumButtons / ButtonsPerRow)

    local Width, Height = ActionBars.GetBackgroundSize(ButtonsPerRow, NumRow, Size, Spacing, C.ActionBars.ShowBackdrop)

    ActionBar5:ClearAllPoints()
    ActionBar5:SetWidth(Width)
	ActionBar5:SetHeight(Height)
    if (C.ActionBars.RightBar) then
        if (C.ActionBars.VerticalRightBars) then
            ActionBar5:SetPoint("BOTTOMRIGHT", ActionBar4, "TOPRIGHT", 0, Spacing - 2)
        else
            ActionBar5:SetPoint("RIGHT", ActionBar4, "LEFT", -Spacing, 0)
        end
    else
        ActionBar5:SetPoint("RIGHT", UIParent, "RIGHT", -C.Lua.ScreenMargin, 5)
    end

    if (C.ActionBars.ShowBackdrop) then
        ActionBar5:SetBackdropTransparent()
        ActionBar5.Shadow:Kill()
    end

    local NumPerRows = ButtonsPerRow
	local NextRowButtonAnchor = _G["MultiBarLeftButton1"]

	for i = 1, NUM_ACTIONBAR_BUTTONS do
		local Button = _G["MultiBarLeftButton"..i]
		local PreviousButton = _G["MultiBarLeftButton"..i-1]
		
		Button:SetSize(Size, Size)
		Button:ClearAllPoints()
		Button:SetAttribute("showgrid", 1)
		Button:ShowGrid(ACTION_BUTTON_SHOW_GRID_REASON_EVENT)

		ActionBars:SkinButton(Button)
		
		if i <= NumButtons then
			if (i == 1) then
				Button:SetPoint("TOPLEFT", ActionBar5, "TOPLEFT", Offset, -Offset)
			elseif (i == NumPerRows + 1) then
				Button:SetPoint("TOPLEFT", NextRowButtonAnchor, "BOTTOMLEFT", 0, -Spacing)

				NumPerRows = NumPerRows + ButtonsPerRow
				NextRowButtonAnchor = _G["MultiBarLeftButton"..i]
			else
				Button:SetPoint("LEFT", PreviousButton, "RIGHT", Spacing, 0)
			end
		else
			Button:SetPoint("TOP", UIParent, "TOP", 0, 200)
		end
	end
end
