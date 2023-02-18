local T, C, L = Tukui:unpack()
local ActionBars = T.ActionBars
local Movers = T.Movers
local NUM_ACTIONBAR_BUTTONS = NUM_ACTIONBAR_BUTTONS

local ceil = math.ceil

----------------------------------------------------------------
-- ActionBar7: Extra Action Bar
----------------------------------------------------------------
local baseCreateBar7 = ActionBars.CreateBar7

function ActionBars:CreateBar7()
	-- first, we call the base function
	baseCreateBar7(self)

	-- second, we edit it
	if (not C.ActionBars.Bar7) then return end

	local ActionBar4 = ActionBars.Bars.Bar4
	local ActionBar5 = ActionBars.Bars.Bar5
	local ActionBar6 = ActionBars.Bars.Bar6
	local ActionBar7 = ActionBars.Bars.Bar7

	local MultiBar6 = MultiBar6
	local Size = C.ActionBars.NormalButtonSize
	local Spacing = C.ActionBars.ButtonSpacing
	local ButtonsPerRow = C.ActionBars.Bar7ButtonsPerRow
	local NumButtons = C.ActionBars.Bar7NumButtons
	local Padding = (C.ActionBars.ShowBackdrop) and Spacing or 0

	if (NumButtons <= ButtonsPerRow) then
		ButtonsPerRow = NumButtons
	end

	local NumRow = ceil(NumButtons / ButtonsPerRow)

	local Width, Height = ActionBars.GetBackgroundSize(ButtonsPerRow, NumRow, Size, Spacing, C.ActionBars.ShowBackdrop)

	ActionBar7:ClearAllPoints()
	ActionBar7:SetWidth(Width)
	ActionBar7:SetHeight(Height)

	if (ActionBar6 and C.ActionBars.Bar6) then
		ActionBar7:SetPoint("RIGHT", ActionBar6, "LEFT", -Spacing, 0)
	elseif (ActionBar5 and C.ActionBars.LeftBar) then
		ActionBar7:SetPoint("RIGHT", ActionBar5, "LEFT", -Spacing, 0)
	elseif (ActionBar4 and C.ActionBars.RightBar) then
		ActionBar7:SetPoint("RIGHT", ActionBar4, "LEFT", -Spacing, 0)
	else
		ActionBar7:SetPoint("RIGHT", UIParent, "RIGHT", -C.Lua.ScreenMargin, 0)
	end

	if (C.ActionBars.ShowBackdrop) then
		ActionBar7:SetBackdropTransparent()
		ActionBar7.Shadow:Kill()
	end
end
