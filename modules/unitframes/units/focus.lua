local T, C, L = Tukui:unpack()
local UnitFrames = T.UnitFrames
local ceil = math.ceil

----------------------------------------------------------------
-- Focus
----------------------------------------------------------------
local baseFocus = UnitFrames.Focus

function UnitFrames:Focus()
    -- first, we call the base function
    baseFocus(self)

    -- second, we edit it
    local Health = self.Health
    
    self.Backdrop = nil
    self:CreateBackdrop()
    self.Backdrop:SetOutside()
    
    local Name = self.Name
    Name:ClearAllPoints()
    Name:SetParent(Health)
	Name:SetPoint("LEFT", Health, "LEFT", 5, 0)
    
    UnitFrames.SetupHealth(self)
    UnitFrames.SetupPower(self)
    UnitFrames.SetupFocusAuras(self)
    UnitFrames.SetupFocusCastBar(self)
    UnitFrames.SetupRaidTargetIndicator(self)

    -- local Highlight = self.Highlight
    -- Highlight:Kill()
end
