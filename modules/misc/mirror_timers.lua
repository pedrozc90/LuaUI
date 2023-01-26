local T, C, L = Tukui:unpack()
local MirrorTimers = T.Miscellaneous.MirrorTimers

----------------------------------------------------------------
-- Mirror Timers (e.g: Breath Timer)
----------------------------------------------------------------
function MirrorTimers:Update()
    local Texture = C.Medias.Blank
    local Font, FontSize, FontStyle = C.Medias.Font, 12, nil

    for i = 1, MIRRORTIMER_NUMTIMERS, 1 do
		local Bar = _G["MirrorTimer"..i]
		
		if Bar and not Bar.isSkinned then
			local Status = Bar.StatusBar or _G[Bar:GetName().."StatusBar"]
			local Border = Bar.Border or _G[Bar:GetName().."Border"]
			local Text = Bar.Text or _G[Bar:GetName().."Text"]

            Bar:SetHeight(20)
            Bar:SetWidth(210)
			Bar:StripTextures()
			Bar:CreateBackdrop()
			Bar.Backdrop:SetBackdropColor(unpack(C.General.BackdropColor))
			
            if (not C.General.HideShadows) then
                Bar.Backdrop:CreateShadow()
            end

			Status:ClearAllPoints()
			Status:SetInside(Bar, 2, 2)
			Status:SetStatusBarTexture(Texture)
			Status.SetStatusBarTexture = function() return end
				
			Text:ClearAllPoints()
			Text:SetPoint("CENTER", Bar, "CENTER", 0, 0)
            Text:SetFont(Font, FontSize, FontStyle)

			Border:SetTexture(nil)

			Bar.isSkinned = true
		end
	end
end
