local T, C, L = Tukui:unpack()
local UnitFrames = T.UnitFrames
local ceil = math.ceil

----------------------------------------------------------------
-- Pet
----------------------------------------------------------------
local basePet = UnitFrames.Pet

function UnitFrames:Pet()
    -- first, we call the base function
    basePet(self)

    -- second, we edit it
    local Health = self.Health
    
    self.Shadow:Kill()
    self.Panel:Kill()
    self.Backdrop = nil
    self:CreateBackdrop()
    
    local Name = self.Name
    Name:ClearAllPoints()
    Name:SetParent(Health)
	Name:SetPoint("CENTER", Health, "CENTER", 0, 0)
    
    UnitFrames.SetupHealth(self)
    UnitFrames.SetupPower(self)
    UnitFrames.SetupPetCastBar(self)
    UnitFrames.SetupFocusAuras(self)
    UnitFrames.SetupRaidTargetIndicator(self)
end
