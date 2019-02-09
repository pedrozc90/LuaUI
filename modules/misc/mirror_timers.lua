local T, C, L = Tukui:unpack()
local MirrorTimers = T.Miscellaneous.MirrorTimers

----------------------------------------------------------------
-- Mirror Timers (e.g: Breath Timer)
----------------------------------------------------------------
local function Update()
    local Texture = C["Medias"].Blank
    local Font, FontSize, FontStyle = C["Medias"].Font, 12, nil

    for i = 1, MIRRORTIMER_NUMTIMERS, 1 do
        local Bar = _G["MirrorTimer"..i]
        local Status = _G[Bar:GetName().."StatusBar"]
        local Border = _G[Bar:GetName().."Border"]
        local Text = _G[Bar:GetName().."Text"]
        
        -- Bar:ClearAllPoints()
        Bar:Width(210)
        Bar:Height(16)
        Bar:SetBackdrop(nil)
        Bar:CreateBackdrop("Default")
        Bar.Shadow:Kill()

        Status:ClearAllPoints()
        Status:SetAllPoints()
        Status:SetStatusBarTexture(Texture)

        Text:ClearAllPoints()
        Text:Point("CENTER", Bar, "CENTER", 0, -1)
        Text:SetFont(Font, FontSize, FontStyle)
    end
end
hooksecurefunc(MirrorTimers, "Update", Update)