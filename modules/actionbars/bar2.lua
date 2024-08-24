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

    -- if (ActionBar2) then
    --     ActionBar2:Kill()
    -- end

    local Left = CreateFrame("Frame", ActionBar2:GetName() .. "Left", ActionBar2)
    Left:SetPoint("BOTTOMRIGHT", ActionBar1, "BOTTOMLEFT", -Spacing, 0)
    Left:SetFrameStrata("LOW")
    Left:SetFrameLevel(10)
    Left:SetWidth(Width)
    Left:SetHeight(Height)
    ActionBar2.Left = Left

    local Right = CreateFrame("Frame", ActionBar2:GetName() .. "Right", ActionBar2)
    Right:SetPoint("BOTTOMLEFT", ActionBar1, "BOTTOMRIGHT", Spacing, 0)
    Right:SetFrameStrata("LOW")
    Right:SetFrameLevel(10)
    Right:SetWidth(Width)
    Right:SetHeight(Height)
    ActionBar2.Right = Right

    if ActionBar2.Backdrop then ActionBar2.Backdrop:Kill() end
    if ActionBar2.Shadow then ActionBar2.Shadow:Kill() end

    if (C.ActionBars.ShowBackdrop) then
        Left:CreateBackdrop("Transparent")
        Right:CreateBackdrop("Transparent")
    end

    -- if (not T.Retail) then
    --     MultiBarBottomLeft:SetShown(true)
    -- else
    --     Settings.SetValue("PROXY_SHOW_ACTIONBAR_2", true)
    -- end

    -- MultiBarBottomLeft:SetShown(true)
    -- MultiBarBottomLeft:SetParent(ActionBar2Left)

    for i = 1, NUM_ACTIONBAR_BUTTONS do
        local Button = ActionBar2["Button" .. i]
        Button:SetSize(Size, Size)
        Button:ClearAllPoints()
        Button:SetAttribute("showgrid", 1)
        -- Button:ShowGrid(ACTION_BUTTON_SHOW_GRID_REASON_EVENT)

        -- ActionBars:SkinButton(Button)

        if (i == 1) then
            Button:SetPoint("TOPLEFT", Left, "TOPLEFT", Padding, -Padding)
        elseif (i == 7) then
            Button:SetPoint("TOPLEFT", Right, "TOPLEFT", Padding, -Padding)
        else
            local PreviousButton = ActionBar2["Button" .. (i - 1)]
            Button:SetPoint("LEFT", PreviousButton, "RIGHT", Spacing, 0)
        end

        ActionBar2["Button" .. i] = Button
    end

    -- RegisterStateDriver(ActionBar2, "visibility", "[vehicleui] hide; show")

    -- Movers:RegisterFrame(Left, "Action Bar Left #2")
    -- Movers:RegisterFrame(ActionBar2Right, "Action Bar Right #2")
    Movers.Defaults["TukuiActionBar2"] = nil

    -- self.Bars.Bar2Left = ActionBar2Left
    -- self.Bars.Bar2Right = ActionBar2Right
end
