local T, C, L = Tukui:unpack()
local ActionBars = T.ActionBars

----------------------------------------------------------------
-- Extra ActionBar
----------------------------------------------------------------
local Button = ExtraActionButton1
local Zone = ZoneAbilityFrame
local ZoneButton = Zone.SpellButton
local Texture = Button.style
local ZoneTexture = ZoneButton.Style

local function SetUpExtraActionButton()
    local Holder = _G["TukuiExtraActionButton"]
    local Size = 42

    Holder:ClearAllPoints()
    Holder:SetPoint("BOTTOM", UIParent, "BOTTOM", 0, 230)
    Holder:Size(160, 80)

    -- remove shadows
    Button.Shadow:Kill()

    -- extra button
    ExtraActionBarFrame:ClearAllPoints()
    ExtraActionBarFrame:SetPoint("CENTER", Holder, "CENTER", 0, 0)
    
    -- extra action button
    Button:SetSize(Size, Size)

    -- zone ability
    ZoneAbilityFrame:ClearAllPoints()
    ZoneAbilityFrame:SetPoint("CENTER", Holder, "CENTER", 0, 0)
    
    -- zone ability button
    ZoneButton:SetSize(Size, Size)
end
hooksecurefunc(ActionBars, "SetUpExtraActionButton", SetUpExtraActionButton)