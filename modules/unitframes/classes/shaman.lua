local T, C, L = Tukui:unpack()
local UnitFrames = T.UnitFrames
local Class = select(2, UnitClass("player"))
local MAX_TOTEMS = MAX_TOTEMS

----------------------------------------------------------------
-- Shaman Class Resources
----------------------------------------------------------------
if (Class ~= "SHAMAN") then return end

local baseShaman = UnitFrames.AddClassFeatures["SHAMAN"]

UnitFrames.AddClassFeatures["SHAMAN"] = function(self)

    if (not C.UnitFrames.TotemBar) then return end
    
    -- first, call the base function
    baseShaman(self)
    
    -- second, we edit it
    local Totems = self.Totems
    local Shadow = self.Shadow

    local FrameWidth, FrameHeight = unpack(C["Units"].Player or { 254, 31 })
    local HealthTexture = T.GetTexture(C["Textures"].UFHealthTexture)
	
	Totems:ClearAllPoints()
	Totems:SetPoint("BOTTOMLEFT", self, "TOPLEFT", -2, 5)
    Totems:SetSize(FrameWidth, 7)
    Totems.Backdrop:Kill()
    
    Shadow:Kill()

    local Spacing = 3
    local TotemWidth, TotemDelta = T.EqualSizes(FrameWidth, MAX_TOTEMS, Spacing)

	for i = 1, MAX_TOTEMS do
		local r, g, b = unpack(UnitFrames.TotemColors[i])

        Totems[i]:ClearAllPoints()
        Totems[i]:SetHeight(Totems:GetHeight())
        Totems[i]:SetWidth(TotemWidth)
        Totems[i]:CreateBackdrop()
        Totems[i].Backdrop:SetTripleBorder()
        Totems[i].Backdrop:SetParent(Totems)
        
        if ((TotemDelta > 0) and (i <= TotemDelta)) then
            Totems[i]:SetWidth(TotemWidth + 1)
        else
            Totems[i]:SetWidth(TotemWidth)
        end
		
		if (i == 1) then
			Totems[i]:Point("BOTTOMLEFT", Totems, "BOTTOMLEFT", 1, 0)
		else
			Totems[i]:Point("BOTTOMLEFT", Totems[i-1], "BOTTOMRIGHT", Spacing, 0)
		end
	end
	
	if (C.UnitFrames.PlayerAuras and C.UnitFrames.PlayerAuraBars) then
		self.AuraBars:ClearAllPoints()
		self.AuraBars:SetPoint("TOPLEFT", self, "TOPLEFT", -2, 20)
	elseif (C.UnitFrames.PlayerAuras and not C.UnitFrames.AurasBelow) then
		self.Buffs:ClearAllPoints()
		self.Buffs:Point("BOTTOMLEFT", self, "TOPLEFT", 0, 15)
    end
end
