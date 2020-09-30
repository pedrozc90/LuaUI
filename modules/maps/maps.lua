local T, C, L = Tukui:unpack()
local Minimap = T.Maps.Minimap
local Panels = T.Panels
local Experience = T.Miscellaneous.Experience
local Reputation = T.Miscellaneous.Reputation

----------------------------------------------------------------
-- Minimap
----------------------------------------------------------------
local baseEnable = Minimap.Enable
local baseAddZoneAndCoords = Minimap.AddZoneAndCoords
local baseAddTaxiEarlyExit = Minimap.AddTaxiEarlyExit
local baseStyleMinimap = Minimap.StyleMinimap

function Minimap:AddZoneAndCoords()

    -- first, cann the base function
    baseAddZoneAndCoords(self)

    -- second, we edit it
    local MinimapZone = self.MinimapZone
    local MinimapCoords = self.MinimapCoords

    MinimapZone:ClearAllPoints()
    MinimapZone:Point("TOPLEFT", self, "TOPLEFT", 2, -2)
    MinimapZone:Point("TOPRIGHT", self, "TOPRIGHT", -2, -2)
    MinimapZone:Height(20)
    MinimapZone:SetTripleBorder()

    MinimapZone.Text:ClearAllPoints()
    MinimapZone.Text:Point("CENTER", MinimapZone, "CENTER", 0, 0)
    MinimapZone.Text:SetJustifyH("CENTER")

    MinimapCoords:ClearAllPoints()
    MinimapCoords:Point("BOTTOMLEFT", self, "BOTTOMLEFT", 2, 2)
    MinimapCoords:Size(40, 20)
    MinimapCoords:SetTripleBorder()

    MinimapCoords.Text:ClearAllPoints()
    MinimapCoords.Text:Point("CENTER", MinimapCoords, "CENTER", 0, 0)
    MinimapCoords.Text:SetJustifyH("CENTER")
end

function Minimap:AddTaxiEarlyExit()

    -- first, call the base function
    baseAddTaxiEarlyExit(self)

    -- second, we edit it
    local EarlyExitButton = self.EarlyExitButton

    local Bar1IsShown = Experience.XPBar1:IsShown() or Reputation.XPBar1:IsShown()
    local Bar2IsShown = Experience.XPBar2:IsShown() or Reputation.XPBar2:IsShown()

    EarlyExitButton:ClearAllPoints()
    EarlyExitButton:Height(23)

    local Anchor = Minimap
    if (Bar2IsShown) then
        Anchor = Experience.XPBar2
    elseif (Bar1IsShown) then
        Anchor = Experience.XPBar1
    end

    EarlyExitButton:Point("TOPLEFT", Anchor, "BOTTOMLEFT", -2, -4)
    EarlyExitButton:Point("TOPRIGHT", Anchor, "BOTTOMRIGHT", 2, -4)
    EarlyExitButton:SetTripleBorder("Transparent")

    EarlyExitButton.Text:ClearAllPoints()
    EarlyExitButton.Text:Point("CENTER", EarlyExitButton, "CENTER", 0, 0)
    EarlyExitButton.Text:SetFont(C.Medias.Font, 12)
end

function Minimap:StyleMinimap()

    -- first, call the base function
    baseStyleMinimap(self)

    -- second, we edit it
    local Ticket = self.Ticket

    local Mail = MiniMapMailFrame
	local MailBorder = MiniMapMailBorder
	local MailIcon = MiniMapMailIcon
	local QueueStatusMinimapButton = QueueStatusMinimapButton
	local QueueStatusFrame = QueueStatusFrame
	local MiniMapInstanceDifficulty = MiniMapInstanceDifficulty
	local GuildInstanceDifficulty = GuildInstanceDifficulty
	local HelpOpenTicketButton = HelpOpenTicketButton
	local BGFrame = MiniMapBattlefieldFrame
    local BGFrameBorder = MiniMapBattlefieldBorder
    
    local Bar1IsShown = Experience.XPBar1:IsShown() or Reputation.XPBar1:IsShown()
    local Bar2IsShown = Experience.XPBar2:IsShown() or Reputation.XPBar2:IsShown()

    Mail:ClearAllPoints()
    Mail:Point("TOPRIGHT", self, "TOPRIGHT", 5, 5)

    BGFrame:ClearAllPoints()
    BGFrame:Point("BOTTOMRIGHT", self, "BOTTOMRIGHT", -5, 5)
    
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

    if (MiniMapTrackingFrame) then
		MiniMapTrackingFrame:ClearAllPoints()
		MiniMapTrackingFrame:Point("BOTTOMRIGHT", Minimap, "BOTTOMRIGHT", 2, -4)

		if (MiniMapTrackingIcon) then
			MiniMapTrackingIcon:Size(16)
		end

		-- MiniMapTrackingFrame:CreateBackdrop()
		-- MiniMapTrackingFrame.Backdrop:SetFrameLevel(MiniMapTrackingFrame:GetFrameLevel())
        -- MiniMapTrackingFrame.Backdrop:SetOutside(MiniMapTrackingIcon)
        if (MiniMapTrackingFrame.Backdrop) then
            MiniMapTrackingFrame.Backdrop:SetOutside(MiniMapTrackingIcon, 2, 2)
            MiniMapTrackingFrame.Backdrop:SetTripleBorder()
        end
		-- MiniMapTrackingFrame.Backdrop:CreateShadow()
	end

end

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
    
    local MinimapDataText = Panels.MinimapDataText
    
    -- Minimap
    self:ClearAllPoints()
    self:Point("TOPRIGHT", UIParent, "TOPRIGHT", -7, -7)
    self.Backdrop:SetTripleBorder()
    self.Backdrop:SetOutside(nil, 2, 2)

    -- Minimap DataText
    MinimapDataText:ClearAllPoints()
    MinimapDataText:Point("BOTTOM", self, "BOTTOM", 0, 2)
    MinimapDataText:Size(55, 19)
    MinimapDataText:StripTextures()
end
