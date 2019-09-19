local T, C, L = Tukui:unpack()
local Misc = T.Miscellaneous
local Panels = T.Panels

-- Lib Globals
local _G = _G
local unpack = unpack
local select = select

-- WoW Globals
local DEFAULT_FILL_BAR_MAX = 6
local STRING_STATUS = " (%d/%d)"

local f = CreateFrame("Frame")
f:RegisterEvent("ADDON_LOADED")
f:SetScript("OnEvent", function(self, event, ...)
    self[event](self, ...)
end)

function f:ADDON_LOADED(addon)
    if (addon ~= "Blizzard_ArchaeologyUI") then return end
    
    if (not ArcheologyDigsiteProgressBar) then return end

    local Bar = ArcheologyDigsiteProgressBar
    local StatusBar = ArcheologyDigsiteProgressBar.FillBar
    local Title = ArcheologyDigsiteProgressBar.BarTitle

    local DataTextLeft = Panels.DataTextLeft
    local Texture = C.Medias.Blank
    local Font, FontSize, FontStyle = C.Medias.PixelFont, 12, "MONOCHROMEOUTLINE"

    Bar:ClearAllPoints()
    Bar:SetPoint("TOP", UIErrorsFrame, "BOTTOM", 0, 720)
    Bar:StripTextures()
    Bar.Shadow:Kill()

    StatusBar:SetSize(255, 16)
    StatusBar:SetStatusBarTexture(Texture)
    StatusBar:SetStatusBarColor(1.0, 0.5, 0.0, 1)
    StatusBar:CreateBackdrop()

    Title:ClearAllPoints()
    Title:SetPoint("CENTER", ArcheologyDigsiteProgressBar, "CENTER", 0, 1)
    Title:SetFont(Font, FontSize, FontStyle)

    self:UnregisterAllEvents()
    self:SetScript("OnEvent", nil)
end
