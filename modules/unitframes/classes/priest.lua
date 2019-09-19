local T, C, L = Tukui:unpack()
local UnitFrames = T.UnitFrames
local Class = select(2, UnitClass("player"))

----------------------------------------------------------------
-- Priest Class Resources
----------------------------------------------------------------
if (Class ~= "PRIEST") then return end

local function Player(self)
	local Atonement = self.Atonement
	local Shadow = self.Shadow

	local PowerTexture = T.GetTexture(C["Textures"].UFPowerTexture)
	
	-- Atonement Bar
	Atonement:ClearAllPoints()
	Atonement:Point("BOTTOMLEFT", self, "TOPLEFT", 0, 7)
	Atonement:Point("BOTTOMRIGHT", self, "TOPRIGHT", 0, 7)
	Atonement:Height(3)
	Atonement:SetStatusBarTexture(PowerTexture)
	
	-- create a border around atonemente bar
	Atonement.Backdrop = nil
	Atonement:CreateBackdrop("Transparent")

	-- Remove Shadows
	Shadow:Kill()
end
hooksecurefunc(UnitFrames, "Player", Player)
