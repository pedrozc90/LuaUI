local T, C, L = Tukui:unpack()
local UnitFrames = T.UnitFrames
local ceil = math.ceil

----------------------------------------------------------------
-- Arena
----------------------------------------------------------------
local baseArena = UnitFrames.Arena

function UnitFrames:Arena()
    -- first, we call the base function
    baseArena(self)

    -- second, we edit it
    local Health = self.Health

    local Width, Height = C.UnitFrames.ArenaWidth, C.UnitFrames.ArenaHeight
    
    self.Backdrop = nil
    self:CreateBackdrop()
    
    local Name = self.Name
    Name:SetParent(Health)
    Name:ClearAllPoints()
	Name:SetPoint("CENTER", Health, "CENTER", 0, 0)
    
    UnitFrames.SetupHealth(self)
    UnitFrames.SetupPower(self)
    UnitFrames.SetupFocusAuras(self)
    UnitFrames.SetupFocusCastBar(self)
    UnitFrames.SetupRaidTargetIndicator(self)

    -- Trinket Icon
    if (T.BCC or T.WotLK) then
        local Trinket = self.Trinket
        Trinket:ClearAllPoints()
        Trinket:SetPoint("TOPRIGHT", SpecIcon, "TOPLEFT", -7, 0)
        Trinket:SetSize(Height, Height)
        Trinket.Shadow:Kill()
    end
end
