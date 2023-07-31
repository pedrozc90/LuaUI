local T, C, L = Tukui:unpack()
local UnitFrames = T.UnitFrames

function UnitFrames:SetupCombatIndicator()
    local Combat = self.CombatIndicator
    Combat:ClearAllPoints()
    Combat:SetPoint("CENTER", self.Health, "CENTER", 0, 1)
end

function UnitFrames:SetupStatus()
    local Status = self.Status
    Status:ClearAllPoints()
    Status:SetPoint("CENTER", self.Health, "CENTER", 0, 1)
    Status:Hide()
end

function UnitFrames:SetupLeaderIndicator()
    local Leader = self.LeaderIndicator
    Leader:ClearAllPoints()
    Leader:SetPoint("CENTER", self.Health, "TOPLEFT",  0, 3)
    Leader:SetSize(14, 14)
end

function UnitFrames:SetupMasterLooterIndicator()
    local MasterLooter = self.MasterLooterIndicator
    MasterLooter:ClearAllPoints()
    MasterLooter:SetPoint("CENTER", self.Health, "TOPRIGHT", 0, 3)
    MasterLooter:SetSize(14, 14)
end

function UnitFrames:SetupRaidTargetIndicator()
    local RaidIcon = self.RaidTargetIndicator
    RaidIcon:ClearAllPoints()
    RaidIcon:SetPoint("CENTER", self.Health, "TOP", 0, 3)
    RaidIcon:SetSize(16, 16)
end

function UnitFrames:SetupRestingIndicator()
    local RestingIndicator = self.RestingIndicator
    RestingIndicator:ClearAllPoints()
    RestingIndicator:SetPoint("LEFT", self.Name, "RIGHT", 5, 0)
    RestingIndicator:SetSize(16, 16)
    RestingIndicator:Hide()
end

-- Spec Icon
-- SpecIcon:ClearAllPoints()
-- SpecIcon:SetPoint("TOPRIGHT", self, "TOPLEFT", -7, 0)
-- SpecIcon:SetSize(FrameHeight)
-- SpecIcon.Backdrop.Shadow:Kill()

-- Trinket Icon
-- Trinket:ClearAllPoints()
-- Trinket:SetPoint("TOPRIGHT", SpecIcon, "TOPLEFT", -7, 0)
-- Trinket:SetSize(FrameHeight)
-- Trinket.Backdrop.Shadow:Kill()
