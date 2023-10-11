local T, C, L = Tukui:unpack()
local UnitFrames = T.UnitFrames
local ActionBars = T.ActionBars
local ceil = math.ceil

----------------------------------------------------------------
-- Target
----------------------------------------------------------------
local baseTarget = UnitFrames.Target

function UnitFrames:Target()
    -- first, we call the base function
    baseTarget(self)

    -- second, we edit it
    local Health = self.Health

    local Width, Height = C.UnitFrames.TargetWidth, C.UnitFrames.TargetHeight
    
    self.Panel:Kill()
    self.Shadow:Kill()
    self.Backdrop = nil
    self:CreateBackdrop()
    
    local Name = self.Name
    Name:SetParent(Health)
    Name:ClearAllPoints()
	Name:SetPoint("LEFT", Health, "LEFT", 5, 0)

    UnitFrames.SetupHealth(self)
    UnitFrames.SetupPower(self)
    UnitFrames.SetupAlternativePower(self)
    UnitFrames.SetupCastBar(self)
    UnitFrames.SetupPlayerAuras(self, Width)
    UnitFrames.SetupPortrait(self)
    UnitFrames.SetupCombatFeedbackText(self)
    UnitFrames.SetupLeaderIndicator(self)
    UnitFrames.SetupMasterLooterIndicator(self)
    UnitFrames.SetupRaidTargetIndicator(self)
end
