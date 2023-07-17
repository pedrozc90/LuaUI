local T, C, L = Tukui:unpack()
local UnitFrames = T.UnitFrames
local ceil = math.ceil

----------------------------------------------------------------
-- Boss
----------------------------------------------------------------
local baseBoss = UnitFrames.Boss

function UnitFrames:Boss()
    -- first, we call the base function
    baseBoss(self)

    -- second, we edit it
    local Health = self.Health
    
    self.Backdrop = nil
    self:CreateBackdrop()
    
    local Name = self.Name
    Name:SetParent(Health)
    Name:ClearAllPoints()
	Name:SetPoint("CENTER", Health, "CENTER", 0, 0)

    self:Tag(Name, "[Tukui:Classification][Tukui:DiffColor][level] [Tukui:GetNameColor][Tukui:NameMedium]")
    
    UnitFrames.SetupHealth(self)
    UnitFrames.SetupPower(self)
    UnitFrames.SetupFocusAuras(self)
    UnitFrames.SetupFocusCastBar(self)
    UnitFrames.SetupRaidTargetIndicator(self)
end
