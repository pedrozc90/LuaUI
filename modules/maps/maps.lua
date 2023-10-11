local T, C, L = Tukui:unpack()
local Minimap = T.Maps.Minimap
local DataTexts = T.DataTexts
local Experience = T.Miscellaneous.Experience

----------------------------------------------------------------
-- Minimap
----------------------------------------------------------------
local baseStyleMinimap = Minimap.StyleMinimap
local basePositionMinimap = Minimap.PositionMinimap
local baseAddZoneAndCoords = Minimap.AddZoneAndCoords
local baseAddMinimapDataTexts = Minimap.AddMinimapDataTexts
local baseAddTaxiEarlyExit = Minimap.AddTaxiEarlyExit
local baseStartHighlight = Minimap.StartHighlight

function Minimap:StyleMinimap()
    -- first, we call the base function
    baseStyleMinimap(self)

    -- second, we edit it
    local Mail = MinimapCluster and MinimapCluster.MailFrame or MiniMapMailFrame
    local MailBorder = MiniMapMailBorder
    local MailIcon = MiniMapMailIcon

    if (Mail) then
        if (T.Retail) then
            Mail:SetParent(Minimap)
        end

        Mail:ClearAllPoints()
        Mail:SetPoint("TOPRIGHT", Minimap, "TOPRIGHT", 4, 4)
    end

    if (T.Retail) then
        local QueueStatusMinimapButton = QueueStatusMinimapButton
        local QueueStatusFrame = QueueStatusFrame
        local QueueStatusButton = QueueStatusButton
        local MiniMapInstanceDifficulty = MiniMapInstanceDifficulty
        local GuildInstanceDifficulty = GuildInstanceDifficulty
        local HelpOpenTicketButton = HelpOpenTicketButton

        local TukuiQueueStatusHolder = TukuiQueueStatusHolder

        if (QueueStatusMinimapButton) then
            QueueStatusMinimapButton:ClearAllPoints()
            QueueStatusMinimapButton:SetPoint("BOTTOMRIGHT", self, "BOTTOMRIGHT", 3, -3)
        end

        if (TukuiQueueStatusHolder) then
            TukuiQueueStatusHolder:ClearAllPoints()
            TukuiQueueStatusHolder:SetPoint("TOPLEFT", Minimap, "BOTTOMLEFT", 0, -20)
        end

        if (QueueStatusButton) then
            QueueStatusButton:SetScale(0.85)
        end
        -- if (QueueStatusButton) then
        --     QueueStatusButton:ClearAllPoints()
        --     QueueStatusButton:SetParent(UIParent)
        --     QueueStatusButton:SetScale(0.85)
        --     QueueStatusButton:SetPoint("TOPLEFT", Minimap, "BOTTOMLEFT", 0, -20)

        --     hooksecurefunc(QueueStatusButton, "SetPoint", function(self)
        --         self:ClearAllPoints()
        --         self:SetParent(UIParent)
        --         self:SetPoint("TOPLEFT", Minimap, "BOTTOMLEFT", 0, -20)
        --     end)
        -- end

        if (MiniMapInstanceDifficulty) then
            MiniMapInstanceDifficulty:ClearAllPoints()
            MiniMapInstanceDifficulty:SetPoint("TOPLEFT", self, "TOPLEFT", 2, -2)
        end

        if (GuildInstanceDifficulty) then
            GuildInstanceDifficulty:ClearAllPoints()
            GuildInstanceDifficulty:SetPoint("TOPLEFT", self, "TOPLEFT", 2, -2)
        end
    else
        local BGFrame = MiniMapBattlefieldFrame
        local BGFrameBorder = MiniMapBattlefieldBorder
        local BGFrameIcon = MiniMapBattlefieldIcon
        local LFGFrame = MiniMapLFGFrame
        local LFGFrameBorder = MiniMapLFGFrameBorder
    end
end

function Minimap:PositionMinimap()
    -- first, we call the base function
    basePositionMinimap(self)

    -- second, we edit it
    self:ClearAllPoints()
    self:SetPoint("TOPRIGHT", UIParent, "TOPRIGHT", -C.Lua.ScreenMargin, -C.Lua.ScreenMargin)
end

function Minimap:AddMinimapDataTexts()
    -- first, we call the base function
    baseAddMinimapDataTexts(self)

    -- second, we edit it
    local MinimapDataText = DataTexts.Panels.Minimap

    MinimapDataText:ClearAllPoints()
    MinimapDataText:SetPoint("BOTTOM", self, "BOTTOM", 0, 2)
    MinimapDataText:SetSize(self:GetWidth(), 19)
    MinimapDataText:StripTextures()
end

function Minimap:AddZoneAndCoords()
    -- first, we call the base function
    baseAddZoneAndCoords(self)

    -- second, we edit it
    local MinimapZone = self.MinimapZone

    -- MinimapZone
    MinimapZone:ClearAllPoints()
    MinimapZone:SetPoint("TOPLEFT", self, "TOPLEFT", 2, -2)
    MinimapZone:SetPoint("TOPRIGHT", self, "TOPRIGHT", -2, -2)
    MinimapZone:SetHeight(23)
    MinimapZone:SetTemplate("Transparent")

    MinimapZone.Text:ClearAllPoints()
    MinimapZone.Text:SetPoint("CENTER", MinimapZone, "CENTER", 0, 0)
    MinimapZone.Text:SetFont(C.Medias.Font, 12)
    MinimapZone.Text:SetJustifyH("CENTER")

    -- MinimapCoords
    if (C.Maps.MinimapCoords) then
        local MinimapCoords = self.MinimapCoords

        MinimapCoords:ClearAllPoints()
        MinimapCoords:SetPoint("BOTTOMLEFT", self, "BOTTOMLEFT", 2, 2)
        MinimapCoords:SetSize(40, 20)
        MinimapCoords:SetTemplate("Transparent")

        MinimapCoords.Text:ClearAllPoints()
        MinimapCoords.Text:SetPoint("CENTER", MinimapCoords, "CENTER", 0, 0)
        MinimapCoords.Text:SetFont(C.Medias.Font, 10)
        MinimapCoords.Text:SetJustifyH("CENTER")
    end
end

function Minimap:AddTaxiEarlyExit()
    -- first, we call the base function
    baseAddTaxiEarlyExit(self)

    -- second, we edit it
    local EarlyExitButton = self.EarlyExitButton

    EarlyExitButton:ClearAllPoints()
    EarlyExitButton:SetPoint("TOPLEFT", self, "BOTTOMLEFT", 0, -3)
    EarlyExitButton:SetPoint("TOPRIGHT", self, "BOTTOMRIGHT", 0, -3)
    EarlyExitButton:SetHeight(DataTexts.Panels.Minimap:GetHeight())
    EarlyExitButton:SetScript("OnShow", function (self)
        local ExpirenceBar = Experience.XPBar1
        local ReputationBar = Experience.XPBar2

        local Anchor = Minimap
        if (ReputationBar and ReputationBar:IsShown()) then
            Anchor = ReputationBar
        elseif (ExpirenceBar and ExpirenceBar:IsShown()) then
            Anchor = ExpirenceBar
        end
        EarlyExitButton:SetPoint("TOPLEFT", Anchor, "BOTTOMLEFT", 0, -3)
        EarlyExitButton:SetPoint("TOPRIGHT", Anchor, "BOTTOMRIGHT", 0, -3)
    end)

    EarlyExitButton.Text:ClearAllPoints()
    EarlyExitButton.Text:SetPoint("CENTER", EarlyExitButton, "CENTER", 0, 0)
    EarlyExitButton.Text:SetFont(C.Medias.Font, 12)
end

function Minimap:StartHighlight()
    -- first, we call the base function
    baseStartHighlight(self)

    -- second, we edit it
    if (Minimap.Highlight) then
        Minimap.Highlight:ClearAllPoints()
        Minimap.Highlight:SetPoint("TOP", 0, 10)
        Minimap.Highlight:SetPoint("BOTTOM", 0, -10)
        Minimap.Highlight:SetPoint("LEFT", -10, 0)
        Minimap.Highlight:SetPoint("RIGHT", 10, 0)
        Minimap.Highlight:SetBackdropBorderColor(1, 1, 0)
    end
end
