local T, C, L = Tukui:unpack()
local UnitFrames = T.UnitFrames
local Class = select(2, UnitClass("player"))

----------------------------------------------------------------
-- Priest Class Resources
----------------------------------------------------------------
if (Class ~= "PRIEST") then return end

local basePlayer = UnitFrames.Player

function UnitFrames:Player()

	-- first, we call the base function
    basePlayer(self)

    -- second, we edit it
	local Atonement = self.Atonement

	local HealthTexture = T.GetTexture(C.Textures.UFHealthTexture)

	-- Atonement Bar
	Atonement:ClearAllPoints()
	Atonement:SetPoint("BOTTOMLEFT", self.Health, "TOPLEFT", 0, 3)
	Atonement:SetPoint("BOTTOMRIGHT", self.Health, "TOPRIGHT", 0, 3)
	Atonement:SetHeight(3)
	Atonement:SetStatusBarTexture(HealthTexture)
end
