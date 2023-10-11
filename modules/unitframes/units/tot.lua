local T, C, L = Tukui:unpack()
local UnitFrames = T.UnitFrames
local ceil = math.ceil

----------------------------------------------------------------
-- TargetOfTarget
----------------------------------------------------------------
local baseTargetOfTarget = UnitFrames.TargetOfTarget

function UnitFrames:TargetOfTarget()
    -- first, we call the base function
    baseTargetOfTarget(self)

    -- second, we edit it
    local Health = self.Health
    local Width, Height = C.UnitFrames.TargetOfTargetWidth, C.UnitFrames.TargetOfTargetHeight
    
    self.Shadow:Kill()
    self.Panel:Kill()
    self.Backdrop = nil
    self:CreateBackdrop()
    
    local Name =  self.Name
    Name:SetParent(Health)
    Name:ClearAllPoints()
	Name:SetPoint("CENTER", Health, "CENTER", 0, 0)
    
    UnitFrames.SetupHealth(self)
    UnitFrames.SetupPower(self)
    UnitFrames.SetupPlayerAuras(self, Width)
    UnitFrames.SetupRaidTargetIndicator(self)
end
