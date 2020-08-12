local T, C, L = Tukui:unpack()
local Auras = T.Auras
local Minimap = T.Maps.Minimap
local Panels = T.Panels

----------------------------------------------------------------
-- Auras
----------------------------------------------------------------
local baseCreateHeaders = Auras.CreateHeaders
local baseSkin = Auras.Skin

function Auras:CreateHeaders()
    
    -- first, call the base function
    baseCreateHeaders(self)

    -- second, we edit it
	local Headers = Auras.Headers
    local Buffs = Headers[1]
    local Debuffs = Headers[2]

    local xOffset, yOffset = 5, 2
    local AuraSpacing = C.Auras.Spacing or 5
    local AuraXOffset = Buffs:GetHeight() + AuraSpacing
    local AuraYOffset = (C.Auras.ClassicTimer) and 42 or 43

    if (Buffs) then
        Buffs:ClearAllPoints()
        Buffs:SetPoint("TOPRIGHT", Minimap, "TOPLEFT", -xOffset, yOffset)
        Buffs:SetAttribute("wrapAfter", C.Auras.BuffsPerRow)
        Buffs:SetAttribute("wrapYOffset", -AuraYOffset)
        Buffs:SetAttribute("xOffset", -AuraXOffset)
    end

    if (Debuffs) then
        Debuffs:ClearAllPoints()
        Debuffs:SetPoint("BOTTOMRIGHT", Minimap, "BOTTOMLEFT", -xOffset, -yOffset)
        Debuffs:SetAttribute("wrapAfter", C.Auras.BuffsPerRow)
        Debuffs:SetAttribute("wrapYOffset", -AuraYOffset)
        Debuffs:SetAttribute("xOffset", -AuraXOffset)
    end
end

function Auras:Skin()

    -- first, call the base function
    baseSkin(self)

    -- second, we edit it
    local Duration = self.Duration
	local Bar = self.Bar
	local Holder = self.Holder
	local Icon = self.Icon
	local Count = self.Count
	
	Count:ClearAllPoints()
	Count:SetPoint("BOTTOMRIGHT", self, "BOTTOMRIGHT", -1, 2)

	Holder:ClearAllPoints()
    Holder:SetPoint("TOP", self, "BOTTOM", 0, -3)
    Holder:Size(self:GetWidth(), 6)
	Holder.Shadow:Kill()

	if (Bar) then
        Bar:ClearAllPoints()
        Bar:SetInside()
        Bar:SetStatusBarTexture(C.Medias.Blank)
        Bar:SetStatusBarColor(.0, .8, .0)
    end

    if (Duration) then
        Duration:ClearAllPoints()
        Duration:SetPoint("BOTTOM", self, "BOTTOM", 2, -12)
    end

    self:SetTripleBorder()
end
