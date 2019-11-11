local T, C, L = Tukui:unpack()
local UnitFrames = T.UnitFrames
local Class = select(2, UnitClass("player"))

----------------------------------------------------------------
-- Shaman Class Resources
----------------------------------------------------------------
if (Class ~= "SHAMAN") then return end

UnitFrames.TotemColors = {
	[1] = { 0.58, 0.23, 0.10 },
	[2] = { 0.23, 0.45, 0.13 },
	[3] = { 0.19, 0.48, 0.60 },
	[4] = { 0.42, 0.18, 0.74 }
}

local function Player(self)

	if (not C.UnitFrames.TotemBar) then return end
    
    local Totems = self.Totems
    local Shadow = self.Shadow

    local Spacing = 3

	local FrameWidth, FrameHeight = unpack(C["Units"].Player or { 254, 31 })
    local HealthTexture = T.GetTexture(C["Textures"].UFHealthTexture)
	
	Totems = CreateFrame("Frame", "TukuiTotemBar", self)
	Totems:SetPoint("BOTTOMLEFT", self, "TOPLEFT", -2, 5)
	-- Totems:SetFrameStrata(self.Health:GetFrameStrata())
	-- Totems:SetFrameLevel(self.Health:GetFrameLevel() + 3)
	Totems:SetSize(FrameWidth, 7)
    Totems:CreateBackdrop()
    Totems.Backdrop:SetBorder()
    Totems.Backdrop:SetOutside(nil, 2, 2)
	-- Totems.Destroy = {}
    
    Shadow:Kill()

	for i = 1, 4 do
		local r, g, b = unpack(TukuiUnitFrames.TotemColors[i])

		Totems[i]:ClearAllPoints()
		Totems[i]:CreateBackdrop()
		Totems[i].Backdrop:SetParent(Totems)

		-- Totems[i]:SetStatusBarTexture(HealthTexture)
		-- Totems[i]:SetStatusBarColor(r, g, b)
		-- Totems[i]:SetMinMaxValues(0, 1)
		-- Totems[i]:SetValue(0)

		-- Totems[i].bg = Totems[i]:CreateTexture(nil, "BORDER")
		-- Totems[i].bg:SetAllPoints(Totems[i])
		-- Totems[i].bg:SetTexture(C.Medias.Blank)
		-- Totems[i].bg.multiplier = 0.3

		-- Totems[i].bg:SetVertexColor(r * .3, g * .3, b * .3)
		
		if (i == 1) then
			Totems[i]:Point("BOTTOMLEFT", Totems, "BOTTOMLEFT", 0, 0)
			Totems[i]:Size(61, 8)
		else
			Totems[i]:Point("BOTTOMLEFT", Totems[i-1], "BOTTOMRIGHT", Spacing, 0)
			Totems[i]:Size(62, 8)
		end

		-- Totems.Destroy[i] = CreateFrame("Button", Totems[i]:GetName().."Destroy", UIParent, "SecureUnitButtonTemplate")
		-- Totems.Destroy[i]:RegisterForClicks("RightButtonUp")
		-- Totems.Destroy[i]:SetAllPoints(Totems[i])
		-- Totems.Destroy[i]:SetID(i)
		-- Totems.Destroy[i]:SetAttribute("type2", "destroytotem")
		-- Totems.Destroy[i]:SetAttribute("*totem-slot*", i)
	end
	
	if (C.UnitFrames.PlayerAuras and C.UnitFrames.PlayerAuraBars) then
		self.AuraBars:ClearAllPoints()
		self.AuraBars:SetPoint("TOPLEFT", self, "TOPLEFT", -2, 20)
	elseif (C.UnitFrames.PlayerAuras and not C.UnitFrames.AurasBelow) then
		self.Buffs:ClearAllPoints()
		self.Buffs:Point("BOTTOMLEFT", self, "TOPLEFT", 0, 15)
    end
    
end
hooksecurefunc(UnitFrames, "Player", Player)
