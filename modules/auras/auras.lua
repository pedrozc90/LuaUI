local T, C, L = Tukui:unpack()
local Auras = T.Auras
local Minimap = T.Maps.Minimap

-- if (not C.Lua.Enable) then return end
local baseSkin = Auras.Skin
local baseCreateHeaders = Auras.CreateHeaders

----------------------------------------------------------------
-- Auras Timer Ajustments
----------------------------------------------------------------
function Auras:Skin()

    -- first, we call the base function
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
    Holder:SetSize(self:GetWidth(), 6)
	Holder:SetTemplate("Transparent")
	Holder.Shadow:Kill()

	if (Bar) then
        Bar:ClearAllPoints()
        Bar:SetInside()
        Bar:SetStatusBarTexture(C.Medias.Blank)
        Bar:SetStatusBarColor(0, 0.80, 0)
    end

    if (Duration) then
        Duration:ClearAllPoints()
        Duration:SetPoint("BOTTOM", self, "BOTTOM", 2, -15)
    end
end

----------------------------------------------------------------
-- Anchoring Buffs/Debuffs next to the Minimap
----------------------------------------------------------------
function Auras:CreateHeaders()
    
    -- first, we call the base function
    baseCreateHeaders(self)

    -- second, we edit it
	local Headers = Auras.Headers
    local Buffs = Headers[1]
    local Debuffs = Headers[2]

    local xOffset, yOffset = 3, 0
    local AuraSpacing = C.Auras.Spacing or 5
    local AuraXOffset = Buffs:GetHeight() + AuraSpacing
    local AuraYOffset = (C.Auras.ClassicTimer) and 51 or 40

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
