local T, C, L = Tukui:unpack()
local ActionBars = T.ActionBars
local Movers = T.Movers
local NUM_ACTIONBAR_BUTTONS = NUM_ACTIONBAR_BUTTONS

local ceil = math.ceil

----------------------------------------------------------------
-- ActionBar8: Extra Action Bar
----------------------------------------------------------------
local baseCreateBar8 = ActionBars.CreateBar8

function ActionBars:CreateBar8()
	-- first, we call the base function
	baseCreateBar8(self)

	-- second, we edit it
	if (not C.ActionBars.Bar8) then return end

	local ActionBar4 = ActionBars.Bars.Bar4
	local ActionBar5 = ActionBars.Bars.Bar5
	local ActionBar6 = ActionBars.Bars.Bar6
	local ActionBar7 = ActionBars.Bars.Bar7
	local ActionBar8 = ActionBars.Bars.Bar8

	local MultiBar7 = MultiBar7
	local Size = C.ActionBars.NormalButtonSize
	local Spacing = C.ActionBars.ButtonSpacing
	local ButtonsPerRow = C.ActionBars.Bar8ButtonsPerRow
	local NumButtons = C.ActionBars.Bar8NumButtons
	local Padding = (C.ActionBars.ShowBackdrop) and Spacing or 0
    
    if (NumButtons <= ButtonsPerRow) then
		ButtonsPerRow = NumButtons
	end
	
	local NumRow = ceil(NumButtons / ButtonsPerRow)

    local Width, Height = ActionBars.GetBackgroundSize(ButtonsPerRow, NumRow, Size, Spacing, C.ActionBars.ShowBackdrop)

	ActionBar8:ClearAllPoints()
	ActionBar8:SetWidth(Width)
	ActionBar8:SetHeight(Height)

	if (ActionBar7 and C.ActionBars.Bar7) then
		ActionBar8:SetPoint("RIGHT", ActionBar7, "LEFT", -Spacing, 0)
	elseif (ActionBar6 and C.ActionBars.Bar6) then
		ActionBar8:SetPoint("RIGHT", ActionBar6, "LEFT", -Spacing, 0)
	elseif (ActionBar5 and C.ActionBars.LeftBar) then
		ActionBar8:SetPoint("RIGHT", ActionBar5, "LEFT", -Spacing, 0)
	elseif (ActionBar4 and C.ActionBars.RightBar) then
		ActionBar8:SetPoint("RIGHT", ActionBar4, "LEFT", -Spacing, 0)
	else
		ActionBar8:SetPoint("RIGHT", UIParent, "RIGHT", -C.Lua.ScreenMargin, 0)
	end

	if (C.ActionBars.ShowBackdrop) then
        ActionBar8:SetBackdropTransparent()
        ActionBar8.Shadow:Kill()
    end
end
