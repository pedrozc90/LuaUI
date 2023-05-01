local T, C, L = Tukui:unpack()
local UnitFrames = T.UnitFrames

local class = select(2, UnitClass("player"))

----------------------------------------------------------------
-- Priest Class Resources
----------------------------------------------------------------
if (class ~= "PRIEST" or not T.Retail or not C.UnitFrames.ClassBar) then return end

local basePlayer = UnitFrames.Player

function UnitFrames:Player()
	-- first, we call the base function
	basePlayer(self)

	-- second, we edit it
	local Atonement = self.Atonement

	local HealthTexture = T.GetTexture(C.Textures.UFHealthTexture)

	-- Atonement Bar
	Atonement:ClearAllPoints()
	Atonement:SetParent(self)
	Atonement:SetPoint("BOTTOMLEFT", self, "TOPLEFT", 0, 3)
	Atonement:SetPoint("BOTTOMRIGHT", self, "TOPRIGHT", 0, 3)
	Atonement:SetHeight(3)
	Atonement:SetStatusBarTexture(HealthTexture)
	Atonement:SetScript("OnShow", UnitFrames.MoveBuffHeaderUp)
	Atonement:SetScript("OnHide", UnitFrames.MoveBuffHeaderDown)
end
