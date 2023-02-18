local T, C, L = Tukui:unpack()
local Toolkit = T.Toolkit
local ToolkitAPI = T.Toolkit.API

-- Lib Globals
local select = select
local unpack = unpack
local type = type
local assert = assert
local getmetatable = getmetatable

-- WoW Globals
local CreateFrame = CreateFrame
local CreateTexture = CreateTexture

----------------------------------------------------------------
-- API: Read DOCS\API.txt for more informations.
----------------------------------------------------------------
local function SetBackdropTransparent(self)
	if (not self.Backdrop) then return end
	local BackdropAlpha = 0.75
	local BackdropR, BackdropG, BackdropB = unpack(C.General.BackdropColor)
	self.Backdrop:SetBackdropColor(BackdropR, BackdropG, BackdropB, BackdropAlpha)
end

----------------------------------------------------------------
-- Merge Tukui API with WoW API
----------------------------------------------------------------

local function AddAPI(object)
	local mt = getmetatable(object).__index

	if not object.SetBackdropTransparent then mt.SetBackdropTransparent = SetBackdropTransparent end
	-- create new API
	-- if not object.Kill then mt.Kill = Kill end
end

local Handled = {["Frame"] = true}
local Object = CreateFrame("Frame")

AddAPI(Object)
AddAPI(Object:CreateTexture())
AddAPI(Object:CreateFontString())

Object = EnumerateFrames()

while Object do
	if not Object:IsForbidden() and not Handled[Object:GetObjectType()] then
		AddAPI(Object)
		Handled[Object:GetObjectType()] = true
	end

	Object = EnumerateFrames(Object)
end
