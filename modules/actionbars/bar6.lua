local T, C, L = Tukui:unpack()
local ActionBars = T.ActionBars
local Movers = T.Movers
local NUM_ACTIONBAR_BUTTONS = NUM_ACTIONBAR_BUTTONS

local ceil = math.ceil

----------------------------------------------------------------
-- ActionBar6: Extra Action Bar
----------------------------------------------------------------
local baseCreateBar6 = ActionBars.CreateBar6

function ActionBars:CreateBar6()
	-- first, we call the base function
	baseCreateBar6(self)

	-- second, we edit it
	if (not C.ActionBars.Bar6) then return end

	local ActionBar4 = ActionBars.Bars.Bar4
	local ActionBar5 = ActionBars.Bars.Bar5
	local ActionBar6 = ActionBars.Bars.Bar6

	local MultiBar5 = MultiBar5
	local Size = C.ActionBars.NormalButtonSize
	local Spacing = C.ActionBars.ButtonSpacing
	local ButtonsPerRow = C.ActionBars.Bar6ButtonsPerRow
	local NumButtons = C.ActionBars.Bar6NumButtons
	local Padding = (C.ActionBars.ShowBackdrop) and Spacing or 0

	if (NumButtons <= ButtonsPerRow) then
		ButtonsPerRow = NumButtons
	end

	local NumRow = ceil(NumButtons / ButtonsPerRow)

	local Width, Height = ActionBars.GetBackgroundSize(ButtonsPerRow, NumRow, Size, Spacing, C.ActionBars.ShowBackdrop)

	ActionBar6:ClearAllPoints()
	ActionBar6:SetWidth(Width)
	ActionBar6:SetHeight(Height)

	if (ActionBar5 and C.ActionBars.LeftBar) then
		ActionBar6:SetPoint("RIGHT", ActionBar5, "LEFT", -Spacing, 0)
	elseif (ActionBar4 and C.ActionBars.RightBar) then
		ActionBar6:SetPoint("RIGHT", ActionBar4, "LEFT", -Spacing, 0)
	else
		ActionBar6:SetPoint("RIGHT", UIParent, "RIGHT", -C.Lua.ScreenMargin, 0)
	end

	if (C.ActionBars.ShowBackdrop) then
		ActionBar6:SetBackdropTransparent()
		ActionBar6.Shadow:Kill()
	end
end
