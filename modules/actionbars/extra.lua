local T, C, L = Tukui:unpack()
local ActionBars = T.ActionBars
local Movers = T.Movers
local Button = ExtraActionButton1
local Icon = ExtraActionButton1Icon
local Container = ExtraAbilityContainer
local ZoneAbilities = ZoneAbilityFrame

----------------------------------------------------------------
-- Extra ActionBar
----------------------------------------------------------------
local baseSetupExtraButton = ActionBars.SetupExtraButton

function ActionBars:SetupExtraButton()
    -- first, we call the base function
    baseSetupExtraButton(self)

    -- second, we edit it
    local Holder = _G["TukuiExtraActionButton"]
    local Bar = ExtraActionBarFrame
    local Icon = ExtraActionButton1Icon

    Holder:ClearAllPoints()
    -- Holder:SetPoint("BOTTOM", UIParent, "BOTTOM", 0, 288)
    Holder:SetPoint("BOTTOM", UIParent, "BOTTOM", 0, 330)
    Holder:SetSize(160, 80)

    Container:ClearAllPoints()
    Container:SetPoint("CENTER", Holder, "CENTER", 0, 0)

    -- Button:SetSize(42, 42)

    if (C.ActionBars.ShowBackdrop) then
        Button:SetBackdropTransparent()
    end

    if (Button.Shadow) then
        Button.Shadow:Kill()
    end

    -- extra button
    -- Bar:ClearAllPoints()
    -- Bar:SetPoint("CENTER", Holder, "CENTER", 0, 0)

    -- zone ability
    -- ZoneAbilities:ClearAllPoints()
    -- ZoneAbilities:SetPoint("CENTER", Holder, "CENTER", 0, 0)
end
