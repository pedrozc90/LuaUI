local T, C, L = Tukui:unpack()
local Toolkit = T00LKIT
local Settings = Toolkit.Settings
local API = Toolkit.API
local Functions = Toolkit.Functions
local Scales = Toolkit.UIScales
local Frames = Toolkit.Frames



----------------------------------------------------------------
-- API: Read DOCS\API.txt for more informations.
----------------------------------------------------------------

API.NoTemplate = function(self)
    self.BorderIsCreated = nil
	self.BorderTop:Kill()
	self.BorderBottom:Kill()
	self.BorderLeft:Kill()
	self.BorderRight:Kill()
end

API.SetTripleBorder = function(self, BackgroundTemplate, BackgroundTexture)
	if (self.BorderIsCreated) then
        self:NoTemplate()
	end
	self:SetTemplate(BackgroundTemplate, BackgroundTexture, "Triple")
end

-- ----------------------------------------------------------------
-- -- Merge Tukui API with WoW API
-- ----------------------------------------------------------------

-- local function AddAPI(object)
-- 	local mt = getmetatable(object).__index
--     -- create new API
-- 	if not object.SetBorder then mt.SetBorder = SetBorder end
-- 	if not object.NoTemplate then mt.NoTemplate = NoTemplate end
-- end

-- local Handled = {["Frame"] = true}

-- local Object = CreateFrame("Frame")
-- AddAPI(Object)
-- AddAPI(Object:CreateTexture())
-- AddAPI(Object:CreateFontString())

-- Object = EnumerateFrames()

-- while Object do
-- 	if not Object:IsForbidden() and not Handled[Object:GetObjectType()] then
-- 		AddAPI(Object)
-- 		Handled[Object:GetObjectType()] = true
-- 	end

-- 	Object = EnumerateFrames(Object)
-- end

-- Enable the API
Toolkit:Enable()

-- Settings we want to use for our API
Settings.UIScale = T.PerfectScale
Settings.NormalTexture = C.Medias.Blank
Settings.GlowTexture = C.Medias.Glow
Settings.ShadowTexture = C.Medias.Glow
Settings.DefaultFont = C.Medias.PixelFont
Settings.BackdropColor = C.General.BackdropColor
Settings.BorderColor =  C.General.BorderColor
Settings.ClassColors = T.Colors.class
