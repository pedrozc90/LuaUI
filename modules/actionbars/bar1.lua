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
	
	ActionBar1:SetScript("OnEvent", function(self, event, unit, ...)
		if (event == "PLAYER_ENTERING_WORLD") then
			local NumPerRows = ButtonsPerRow
			local NextRowButtonAnchor = _G["ActionButton1"]
			
			for i = 1, NUM_ACTIONBAR_BUTTONS do
				local Button = _G["ActionButton"..i]
				local PreviousButton = _G["ActionButton"..i-1]
					
				Button:SetSize(Size, Size)
				Button:ClearAllPoints()
				Button:SetParent(self)
				Button:SetAttribute("showgrid", 1)
				Button:ShowGrid(ACTION_BUTTON_SHOW_GRID_REASON_EVENT)
					
				ActionBars:SkinButton(Button)

				if (i == 1) then
					Button:SetPoint("TOPLEFT", ActionBar1, "TOPLEFT", Offset, -Offset)
				elseif (i == NumPerRows + 1) then
					Button:SetPoint("TOPLEFT", NextRowButtonAnchor, "BOTTOMLEFT", 0, -Spacing)
						
					NumPerRows = NumPerRows + ButtonsPerRow
					NextRowButtonAnchor = _G["ActionButton"..i]
				else
					Button:SetPoint("LEFT", PreviousButton, "RIGHT", Spacing, 0)
				end
			end
		elseif (event == "UPDATE_VEHICLE_ACTIONBAR") or (event == "UPDATE_OVERRIDE_ACTIONBAR") then
			for i = 1, 12 do
				local Button = _G["ActionButton"..i]
				local Action = Button.action
				local Icon = Button.icon

				if Action >= 120 then
					local Texture = GetActionTexture(Action)

					if (Texture) then
						Icon:SetTexture(Texture)
						Icon:Show()
					else
						if Icon:IsShown() then
							Icon:Hide()
						end
					end
				end
			end
		end
	end)
end
