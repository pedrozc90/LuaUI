local T, C, L = Tukui:unpack()
local ActionBars = T.ActionBars
local Movers = T.Movers
local NUM_ACTIONBAR_BUTTONS = NUM_ACTIONBAR_BUTTONS

local ceil = math.ceil

----------------------------------------------------------------
-- ActionBar1: Page 1 (slots 1 to 12)
----------------------------------------------------------------
local baseCreateBar1 = ActionBars.CreateBar1

function ActionBars:CreateBar1()
	-- first, we call the base function
    baseCreateBar1(self)

    -- second, we edit it
	local ActionBar1 = ActionBars.Bars.Bar1

	local Size = C.ActionBars.NormalButtonSize
	local Spacing = C.ActionBars.ButtonSpacing
	local ButtonsPerRow = C.ActionBars.Bar1ButtonsPerRow
	local NumRow = ceil(12 / ButtonsPerRow)
	local Offset = (C.ActionBars.ShowBackdrop) and (Spacing + 1) or 0

	local Width, Height = ActionBars.GetBackgroundSize(ButtonsPerRow, NumRow, Size, Spacing, C.ActionBars.ShowBackdrop)

    ActionBar1:ClearAllPoints()
	ActionBar1:SetPoint("BOTTOM", UIParent, "BOTTOM", 0, C.Lua.ScreenMargin)
	ActionBar1:SetWidth(Width)
	ActionBar1:SetHeight(Height)
	
	if (C.ActionBars.ShowBackdrop) then
		ActionBar1:SetBackdropTransparent()
		ActionBar1.Shadow:Kill()
	end
end
