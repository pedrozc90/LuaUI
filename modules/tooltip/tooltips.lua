local T, C, L = Tukui:unpack()
local Tooltips = T.Tooltips
local Panels = T.Panels
local Bags = T.Inventory.Bags

----------------------------------------------------------------
-- Tooltips
----------------------------------------------------------------
local baseCreateAnchor = Tooltips.CreateAnchor
local baseSetTooltipDefaultAnchor = Tooltips.SetTooltipDefaultAnchor
local baseSkin = Tooltips.Skin
local baseEnable = Tooltips.Enable

function Tooltips:OnUpdate(elapsed)

    local DataTextRight = Panels.DataTextRight
    local RightChatBG = Panels.RightChatBG
    local Pet = oUF_TukuiPet
    local Bag = Bags["Bag"]

    local Anchor = self.Anchor
    Anchor:ClearAllPoints()
    if (Bag and Bag:IsVisible()) then
        if (Bag.BagsContainer and Bag.BagsContainer:IsVisible()) then
            Anchor:Point("BOTTOMRIGHT", Bag.BagsContainer, "TOPRIGHT", -2, 5)
        else
            Anchor:Point("BOTTOMRIGHT", Bag, "TOPRIGHT", -2, 5)
        end
    elseif (Pet and Pet:IsVisible()) then
        Anchor:Point("BOTTOMRIGHT", Pet, "TOPRIGHT", 0, 7)
    elseif (RightChatBG and RightChatBG:IsShown()) then
        Anchor:Point("BOTTOMRIGHT", RightChatBG, "TOPRIGHT", 0, 7)
    else
        Anchor:Point("BOTTOMRIGHT", DataTextRight, "TOPRIGHT", 0, 7)
    end
end

function Tooltips:CreateAnchor()

    -- first, call the base function
    baseCreateAnchor(self)

    local DataTextRight = Panels.DataTextRight
    local RightChatBG = Panels.RightChatBG

    -- second, we edit it
    local Anchor = self.Anchor

    Anchor:ClearAllPoints()
    Anchor:Point("BOTTOMRIGHT", RightChatBG, "TOPRIGHT", 0, 7)

end

function Tooltips:SetTooltipDefaultAnchor(parent)

    -- first, call the base function
    baseSetTooltipDefaultAnchor(self)

    -- second, we edit it
    local Anchor = Tooltips.Anchor

    -- self:ClearAllPoints()
    if (C.Tooltips.MouseOver) then
		if (parent ~= UIParent) then
			self:ClearAllPoints()
            self:SetPoint("BOTTOMRIGHT", Anchor, "TOPRIGHT", 0, 7)
		else
            self:SetOwner(parent, "ANCHOR_CURSOR")
		end
	else
		self:ClearAllPoints()
        self:SetPoint("BOTTOMRIGHT", Anchor, "BOTTOMRIGHT", 0, 0)
	end
    
end

function Tooltips:Skin(unit)

    -- first, call the base function
    baseSkin(self)

    -- second, we edit it
    self.Backdrop:SetBorder("Transparent")
    self.Backdrop:SetOutside(nil, 2, 2)

end

function Tooltips:Enable()

    -- first, call the base function
    baseEnable(self)

    -- tooltip health bar
    local HealthBar = GameTooltipStatusBar

	HealthBar:ClearAllPoints()
    HealthBar:Point("BOTTOMLEFT", HealthBar:GetParent(), "TOPLEFT", 0, 7)
    HealthBar:Point("BOTTOMRIGHT", HealthBar:GetParent(), "TOPRIGHT", 0, 7)
    HealthBar:Height(9)
    HealthBar.Backdrop:SetBorder()
    HealthBar.Backdrop:SetOutside(nil, 2, 2)

    if (C.Tooltips.UnitHealthText) then
		HealthBar.Text:ClearAllPoints()
		HealthBar.Text:Point("CENTER", HealthBar, "CENTER", 0, 1)
    end
    
    -- update tooltip position to void overlay
    self:SetScript("OnUpdate", self.OnUpdate)
end
