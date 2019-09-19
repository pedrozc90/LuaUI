local T, C, L = Tukui:unpack()

----------------------------------------------------------------
-- API: Read DOCS\API.txt for more informations.
----------------------------------------------------------------
-- Override previous Tukui SetOutside function.
local function SetOutside(obj, anchor, xOffset, yOffset)
	xOffset = xOffset or 2
	yOffset = yOffset or 2
	anchor = anchor or obj:GetParent()

	if obj:GetPoint() then obj:ClearAllPoints() end

	obj:Point("TOPLEFT", anchor, "TOPLEFT", -xOffset, yOffset)
	obj:Point("BOTTOMRIGHT", anchor, "BOTTOMRIGHT", xOffset, -yOffset)
end

-- Override previous Tukui SetInside function.
local function SetInside(obj, anchor, xOffset, yOffset)
	xOffset = xOffset or 2
	yOffset = yOffset or 2
	anchor = anchor or obj:GetParent()

	if obj:GetPoint() then obj:ClearAllPoints() end

	obj:Point("TOPLEFT", anchor, "TOPLEFT", xOffset, -yOffset)
	obj:Point("BOTTOMRIGHT", anchor, "BOTTOMRIGHT", -xOffset, yOffset)
end

-- Override previous Tukui SetTemplte function. (old tukui border)
local function SetTemplate(f, t, tex)
	local balpha = 1
	if t == "Transparent" then balpha = 0.8 end
	local borderr, borderg, borderb = unpack(C.General.BorderColor)
	local backdropr, backdropg, backdropb = unpack(C.General.BackdropColor)
	local backdropa = balpha
	local texture = C.Medias.Blank

	if tex then
		texture = C.Medias.Normal
	end

	f:SetBackdrop({
		bgFile = texture,
		edgeFile = C.Medias.Blank,
		tile = false, tileSize = 0, edgeSize = T.Scale(1),
	})

	if (not f.isInsetDone) then
		f.insettop = f:CreateTexture(nil, "BORDER")
		f.insettop:Point("TOPLEFT", f, "TOPLEFT", -1, 1)
		f.insettop:Point("TOPRIGHT", f, "TOPRIGHT", 1, -1)
		f.insettop:Height(1)
		f.insettop:SetColorTexture(.0,.0,.0)
		f.insettop:SetDrawLayer("BORDER", -7)

		f.insetbottom = f:CreateTexture(nil, "BORDER")
		f.insetbottom:Point("BOTTOMLEFT", f, "BOTTOMLEFT", -1, -1)
		f.insetbottom:Point("BOTTOMRIGHT", f, "BOTTOMRIGHT", 1, -1)
		f.insetbottom:Height(1)
		f.insetbottom:SetColorTexture(.0,.0,.0)
		f.insetbottom:SetDrawLayer("BORDER", -7)

		f.insetleft = f:CreateTexture(nil, "BORDER")
		f.insetleft:Point("TOPLEFT", f, "TOPLEFT", -1, 1)
		f.insetleft:Point("BOTTOMLEFT", f, "BOTTOMLEFT", 1, -1)
		f.insetleft:Width(1)
		f.insetleft:SetColorTexture(.0,.0,.0)
		f.insetleft:SetDrawLayer("BORDER", -7)

		f.insetright = f:CreateTexture(nil, "BORDER")
		f.insetright:Point("TOPRIGHT", f, "TOPRIGHT", 1, 1)
		f.insetright:Point("BOTTOMRIGHT", f, "BOTTOMRIGHT", -1, -1)
		f.insetright:Width(1)
		f.insetright:SetColorTexture(.0,.0,.0)
		f.insetright:SetDrawLayer("BORDER", -7)

		f.insetinsidetop = f:CreateTexture(nil, "BORDER")
		f.insetinsidetop:Point("TOPLEFT", f, "TOPLEFT", 1, -1)
		f.insetinsidetop:Point("TOPRIGHT", f, "TOPRIGHT", -1, 1)
		f.insetinsidetop:Height(1)
		f.insetinsidetop:SetColorTexture(.0,.0,.0)
		f.insetinsidetop:SetDrawLayer("BORDER", -7)

		f.insetinsidebottom = f:CreateTexture(nil, "BORDER")
		f.insetinsidebottom:Point("BOTTOMLEFT", f, "BOTTOMLEFT", 1, 1)
		f.insetinsidebottom:Point("BOTTOMRIGHT", f, "BOTTOMRIGHT", -1, 1)
		f.insetinsidebottom:Height(1)
		f.insetinsidebottom:SetColorTexture(.0,.0,.0)
		f.insetinsidebottom:SetDrawLayer("BORDER", -7)

		f.insetinsideleft = f:CreateTexture(nil, "BORDER")
		f.insetinsideleft:Point("TOPLEFT", f, "TOPLEFT", 1, -1)
		f.insetinsideleft:Point("BOTTOMLEFT", f, "BOTTOMLEFT", -1, 1)
		f.insetinsideleft:Width(1)
		f.insetinsideleft:SetColorTexture(.0,.0,.0)
		f.insetinsideleft:SetDrawLayer("BORDER", -7)

		f.insetinsideright = f:CreateTexture(nil, "BORDER")
		f.insetinsideright:Point("TOPRIGHT", f, "TOPRIGHT", -1, -1)
		f.insetinsideright:Point("BOTTOMRIGHT", f, "BOTTOMRIGHT", 1, 1)
		f.insetinsideright:Width(1)
		f.insetinsideright:SetColorTexture(.0,.0,.0)
		f.insetinsideright:SetDrawLayer("BORDER", -7)

		f.isInsetDone = true
	end

	f:SetBackdropColor(backdropr, backdropg, backdropb, backdropa)
	f:SetBackdropBorderColor(borderr, borderg, borderb)
end

local borders = {
	"insettop",
	"insetbottom",
	"insetleft",
	"insetright",
	"insetinsidetop",
	"insetinsidebottom",
	"insetinsideleft",
	"insetinsideright",
}

-- hide insets (border)
local function HideInsets(f)
	for i, border in pairs(borders) do
		if f[border] then
			f[border]:SetColorTexture(.0,.0,.0,.0)
		end
	end
end

----------------------------------------------------------------
-- Merge Tukui API with WoW API
----------------------------------------------------------------

local function AddAPI(object)
	local mt = getmetatable(object).__index

    -- override existing API
	mt.SetOutside = SetOutside
	mt.SetInside = SetInside
	mt.SetTemplate = SetTemplate
	mt.HideInsets = HideInsets

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
