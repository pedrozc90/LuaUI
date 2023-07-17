local T, C, L = Tukui:unpack()
local UnitFrames = T.UnitFrames
local ActionBars = T.ActionBars
local Class = select(2, UnitClass("player"))
local MAX_TOTEMS = MAX_TOTEMS
local ceil = math.ceil

----------------------------------------------------------------
-- Player
----------------------------------------------------------------
local basePlayer = UnitFrames.Player

function UnitFrames:Player()
    -- first, we call the base function
    basePlayer(self)

    -- second, we edit it
    local Health = self.Health

    self.Panel:Kill()
    self.Shadow:Kill()
    self.Backdrop = nil
    self:CreateBackdrop()

    local Name = self.Name
    Name:ClearAllPoints()
    Name:SetParent(Health)
	Name:SetPoint("CENTER", Health, "CENTER", 0, 0)

    UnitFrames.SetupHealth(self)
    UnitFrames.SetupPower(self)
    UnitFrames.SetupAdditionalPower(self)
    UnitFrames.SetupPlayerAuras(self)
    UnitFrames.SetupCastBar(self)
    UnitFrames.SetupPortrait(self)
    UnitFrames.SetupComboPoints(self)
    UnitFrames.SetupTotemBar(self)
    UnitFrames.SetupCombatFeedbackText(self)
    UnitFrames.SetupCombatIndicator(self)
    UnitFrames.SetupStatus(self)
    UnitFrames.SetupLeaderIndicator(self)
    UnitFrames.SetupMasterLooterIndicator(self)
    UnitFrames.SetupRaidTargetIndicator(self)
    UnitFrames.SetupRestingIndicator(self)
end
