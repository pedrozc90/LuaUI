local T, C, L = Tukui:unpack()
local ActionBars = T.ActionBars
local Movers = T.Movers
local NUM_ACTIONBAR_BUTTONS = NUM_ACTIONBAR_BUTTONS

local ceil = math.ceil

----------------------------------------------------------------
-- ActionBar2: Page 6 - Bottom Left ActionBar (slots 61 to 72)
----------------------------------------------------------------
local baseCreateBar2 = ActionBars.CreateBar2

function ActionBars:CreateBar2()
    -- first, we call the base function
    baseCreateBar2(self)

    -- second, we edit it
    local ActionBar1 = ActionBars.Bars.Bar1
    local ActionBar2 = ActionBars.Bars.Bar2
    local ActionBar3 = ActionBars.Bars.Bar3

    local MultiBarBottomLeft = MultiBarBottomLeft
	local Size = C.ActionBars.NormalButtonSize
	local Spacing = C.ActionBars.ButtonSpacing
	local ButtonsPerRow = 6 -- C.ActionBars.Bar2ButtonsPerRow
    local NumButtons = 6    -- C.ActionBars.Bar2NumButtons
    local Padding = (C.ActionBars.ShowBackdrop) and Spacing or 0

    local NumRow = ceil(NumButtons / ButtonsPerRow)
    
    local Width, Height = ActionBars.GetBackgroundSize(ButtonsPerRow, NumRow, Size, Spacing, C.ActionBars.ShowBackdrop)

    if (ActionBar2) then
        ActionBar2:Kill()
    end

    local ActionBar2Left = CreateFrame("Frame", "TukuiActionBar2Left", T.PetHider, "SecureHandlerStateTemplate")
	ActionBar2Left:SetPoint("BOTTOMRIGHT", ActionBar1, "BOTTOMLEFT", -Spacing, 0)
	ActionBar2Left:SetFrameStrata("LOW")
	ActionBar2Left:SetFrameLevel(10)
	ActionBar2Left:SetWidth(Width)
    ActionBar2Left:SetHeight(Height)
    
    local ActionBar2Right = CreateFrame("Frame", "TukuiActionBar2Right", T.PetHider, "SecureHandlerStateTemplate")
	ActionBar2Right:SetPoint("BOTTOMLEFT", ActionBar1, "BOTTOMRIGHT", Spacing, 0)
	ActionBar2Right:SetFrameStrata("LOW")
	ActionBar2Right:SetFrameLevel(10)
	ActionBar2Right:SetWidth(Width)
    ActionBar2Right:SetHeight(Height)

    if (C.ActionBars.ShowBackdrop) then
        ActionBar2Left:CreateBackdrop("Transparent")
        ActionBar2Right:CreateBackdrop("Transparent")
    end

    if (not T.Retail) then
		MultiBarBottomLeft:SetShown(true)
	else
		Settings.SetValue("PROXY_SHOW_ACTIONBAR_2", true)
	end

    -- MultiBarBottomLeft:SetShown(true)
	MultiBarBottomLeft:SetParent(ActionBar2Left)

	for i = 1, NUM_ACTIONBAR_BUTTONS do
        local Button = _G["MultiBarBottomLeftButton" .. i]

        Button:SetSize(Size, Size)
		Button:ClearAllPoints()
		Button:SetAttribute("showgrid", 1)
        -- Button:ShowGrid(ACTION_BUTTON_SHOW_GRID_REASON_EVENT)
        
        ActionBars:SkinButton(Button)

        if (i == 1) then
            Button:SetPoint("BOTTOMRIGHT", ActionBar2Left, "BOTTOMRIGHT", -Padding, Padding)
        elseif (i == 7) then
            Button:SetPoint("BOTTOMRIGHT", ActionBar2Right, "BOTTOMRIGHT", -Padding, Padding)
        else
            local PreviousButton = _G["MultiBarBottomLeftButton" .. (i-1)]
            Button:SetPoint("RIGHT", PreviousButton, "LEFT", -Spacing, 0)
        end

		ActionBar2["Button" .. i] = Button
	end

	RegisterStateDriver(ActionBar2, "visibility", "[vehicleui] hide; show")

    Movers:RegisterFrame(ActionBar2Left, "Action Bar Left #2")
    Movers:RegisterFrame(ActionBar2Right, "Action Bar Right #2")
    Movers.Defaults["TukuiActionBar2"] = nil
    
    self.Bars.Bar2Left = ActionBar2Left
    self.Bars.Bar2Right = ActionBar2Right
end
