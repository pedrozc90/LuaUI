local T, C, L = Tukui:unpack()
local Minimap = T.Maps.Minimap
local Panels = T.Panels
local Experience = T.Miscellaneous.Experience
local Reputation = T.Miscellaneous.Reputation

----------------------------------------------------------------
-- Minimap
----------------------------------------------------------------
local baseEnable = Minimap.Enable

function Minimap:Enable()

    -- first, call the base function
    baseEnable(self)

    -- second, we edit it
    local Ticket = self.Ticket
    local Mail = MiniMapMailFrame
	local MailBorder = MiniMapMailBorder
    local MailIcon = MiniMapMailIcon
    local HelpOpenTicketButton = HelpOpenTicketButton
	local BGFrame = MiniMapBattlefieldFrame
	local BGFrameBorder = MiniMapBattlefieldBorder
    
    local MinimapZone = self.MinimapZone
	local MinimapCoords = self.MinimapCoords
    local MinimapDataText = Panels.MinimapDataText

    local EarlyExitButton = self.EarlyExitButton

    local Bar1IsShown = Experience.XPBar1:IsShown() or Reputation.XPBar1:IsShown()
    local Bar2IsShown = Experience.XPBar2:IsShown() or Reputation.XPBar2:IsShown()
    
    -- Minimap
    self:ClearAllPoints()
    self:Point("TOPRIGHT", UIParent, "TOPRIGHT", -7, -7)
    self.Backdrop:SetBorder()
    self.Backdrop:SetOutside(nil, 2, 2)

    -- Ticket
    local TicketAnchor = Minimap

    if (Bar2IsShown) then
        TicketAnchor = Experience.XPBar2
    elseif (Bar1IsShown) then
        TicketAnchor = Experience.XPBar1
    end

    Ticket:ClearAllPoints()
    Ticket:Point("TOPLEFT", TicketAnchor, "BOTTOMLEFT", 0, -7)
    Ticket:Point("TOPRIGHT", TicketAnchor, "BOTTOMRIGHT", 0, -7)
    Ticket:Height(23)
    Ticket:CreateBackdrop()

    Ticket.Text:ClearAllPoints()
    Ticket.Text:Point("CENTER", Ticket, "CENTER", 0, 1)

    -- Mail
    Mail:ClearAllPoints()
    Mail:Point("TOPRIGHT", self, "TOPRIGHT", 5, 5)

    -- BGFrame
    BGFrame:ClearAllPoints()
	BGFrame:Point("BOTTOMRIGHT", self, "BOTTOMRIGHT", -5, 5)

    -- MinimapZone
    MinimapZone:ClearAllPoints()
    MinimapZone:Point("TOPLEFT", self, "TOPLEFT", 2, -2)
    MinimapZone:Point("TOPRIGHT", self, "TOPRIGHT", -2, -2)
    MinimapZone:Height(20)
    MinimapZone:SetBorder()

    MinimapZone.Text:ClearAllPoints()
    MinimapZone.Text:Point("CENTER", MinimapZone, "CENTER", 0, 0)
    MinimapZone.Text:SetJustifyH("CENTER")

    -- MinimapCoords
    MinimapCoords:ClearAllPoints()
    MinimapCoords:Point("BOTTOMLEFT", self, "BOTTOMLEFT", 2, 2)
    MinimapCoords:Size(40, 20)
    MinimapCoords:SetBorder()

    MinimapCoords.Text:ClearAllPoints()
    MinimapCoords.Text:Point("CENTER", MinimapCoords, "CENTER", 0, 0)
    MinimapCoords.Text:SetJustifyH("CENTER")

    -- Minimap DataText
    MinimapDataText:ClearAllPoints()
    MinimapDataText:Point("BOTTOM", self, "BOTTOM", 0, 2)
    MinimapDataText:Size(55, 19)
    MinimapDataText:StripTextures()

    -- TaxiEarlyExit
    EarlyExitButton:ClearAllPoints()
    EarlyExitButton:Height(23)

    local EarlyExitAnchor = Minimap
    if (Bar2IsShown) then
        EarlyExitAnchor = Experience.XPBar2
    elseif (Bar1IsShown) then
        EarlyExitAnchor = Experience.XPBar1
    end

    EarlyExitButton:Point("TOPLEFT", EarlyExitAnchor, "BOTTOMLEFT", 0, -7)
    EarlyExitButton:Point("TOPRIGHT", EarlyExitAnchor, "BOTTOMRIGHT", 0, -7)

    EarlyExitButton.Text:ClearAllPoints()
    EarlyExitButton.Text:Point("CENTER", EarlyExitButton, "CENTER", 0, 1)
    EarlyExitButton.Text:SetFont(C.Medias.PixelFont, 12)
    
    EarlyExitButton:NoTemplate()
    EarlyExitButton:CreateBackdrop()
    EarlyExitButton.Backdrop:SetBorder()
    EarlyExitButton.Backdrop:SetOutside(nil, 2, 2)
end
