local T, C, L = Tukui:unpack()
local MirrorTimers = T.Miscellaneous.MirrorTimers

----------------------------------------------------------------
-- Mirror Timers (e.g: Breath Timer)
----------------------------------------------------------------
if T.Retail then
	local MirrorTimerContainer = _G.MirrorTimerContainer
	local MirrorTimerAtlas = _G.MirrorTimerAtlas

	function MirrorTimers:SetupTimer(timer, value, maxvalue, paused, label)
		local Bar = self:GetAvailableTimer(timer);
		if (not Bar) then return end
	
		local Texture = MirrorTimerAtlas[timer] or C.Medias.Blank
		local Font, FontSize, FontStyle = C.Medias.Font, 12, nil
	
		Bar:SetHeight(21)
		Bar:SetWidth(210)
		Bar:StripTextures()
		Bar:CreateBackdrop()
		Bar.Backdrop:SetBackdropColor(unpack(C.General.BackdropColor))
	
		if (Bar.Backdrop.Shadow) then
			Bar.Backdrop.Shadow:Kill()
		end
	
		if (Bar.StatusBar) then
			Bar.StatusBar:ClearAllPoints()
			Bar.StatusBar:SetInside(Bar, 2, 2)
			Bar.StatusBar:SetStatusBarTexture(Texture)
			Bar.StatusBar.SetStatusBarTexture = function() return end
		end
		
		if (Bar.Text) then
			Bar.Text:ClearAllPoints()
			Bar.Text:SetPoint("CENTER", Bar, "CENTER", 0, 0)
			Bar.Text:SetFont(Font, FontSize, FontStyle)
		end
	
		if (Bar.Border) then
			Bar.Border:SetTexture(nil)
		end
	
		Bar.isSkinned = true
	end
else
	function MirrorTimers:Update()
		local Texture = C.Medias.Blank
		local Font, FontSize, FontStyle = C.Medias.Font, 12, nil

		for i = 1, MIRRORTIMER_NUMTIMERS, 1 do
			local Bar = _G["MirrorTimer"..i]

			if (Bar and not Bar.isSkinned) then
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
end
