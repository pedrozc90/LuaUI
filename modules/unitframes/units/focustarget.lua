local T, C, L = Tukui:unpack()
local UnitFrames = T.UnitFrames
local ceil = math.ceil

----------------------------------------------------------------
-- FocusTarget
----------------------------------------------------------------
local baseFocusTarget = UnitFrames.FocusTarget

function UnitFrames:FocusTarget()
    -- first, we call the base function
    baseFocusTarget(self)

    -- second, we edit it
    local Health = self.Health
    
    self.Backdrop = nil
    self:CreateBackdrop()
    self.Backdrop:SetOutside()
    
    local Name = self.Name
    Name:SetParent(Health)
    Name:ClearAllPoints()
	Name:SetPoint("LEFT", Health, "LEFT", 5, 0)
    
    UnitFrames.SetupHealth(self)
    UnitFrames.SetupPower(self)
    UnitFrames.SetupFocusAuras(self)
    UnitFrames.SetupFocusCastBar(self)
    UnitFrames.SetupRaidTargetIndicator(self)
end
