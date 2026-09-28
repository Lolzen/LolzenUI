--// outline //--
-- A textured 8-piece frame border with an optional soft drop shadow.
--
-- Usage:
--   local outline = ns.Outline.Create(frame, {size = 12, padding = 2})
--   outline:SetColor(r, g, b)      -- e.g. class color
--   outline:ResetColor()           -- back to the configured default color
--   outline:SetShown(false)
--
-- padding is the distance between the frame edge and the outer edge of the border.
-- It can be a number or a table {left, top, right, bottom}.

local _, ns = ...
local L = ns.L

local Outline = {}
ns.Outline = Outline

local BORDER_TEXTURE = "Interface\\AddOns\\LolzenUI\\media\\outline"
local SHADOW_TEXTURE = "Interface\\AddOns\\LolzenUI\\media\\outline-shadow"

-- the textures are split into a 3x3 grid: 4 corners and 4 edges
local TEXCOORDS = {
	{0, 1/3, 0, 1/3},       -- top left
	{2/3, 1, 0, 1/3},       -- top right
	{0, 1/3, 2/3, 1},       -- bottom left
	{2/3, 1, 2/3, 1},       -- bottom right
	{1/3, 2/3, 0, 1/3},     -- top
	{1/3, 2/3, 2/3, 1},     -- bottom
	{0, 1/3, 1/3, 2/3},     -- left
	{2/3, 1, 1/3, 2/3},     -- right
}

-- every outline, so style changes can be applied to all of them
local registry = setmetatable({}, {__mode = "k"})

local function createPieces(parent, texture, layer, subLevel)
	local pieces = {}
	for i = 1, 8 do
		local piece = parent:CreateTexture(nil, layer, nil, subLevel)
		piece:SetTexture(texture)
		local coords = TEXCOORDS[i]
		piece:SetTexCoord(coords[1], coords[2], coords[3], coords[4])
		pieces[i] = piece
	end
	return pieces
end

-- corners are anchored to the frame, the edges stretch between the corners
local function layoutPieces(pieces, frame, size, left, top, right, bottom)
	for i = 1, 8 do
		pieces[i]:ClearAllPoints()
		pieces[i]:SetSize(size, size)
	end
	pieces[1]:SetPoint("TOPLEFT", frame, "TOPLEFT", -left, top)
	pieces[2]:SetPoint("TOPRIGHT", frame, "TOPRIGHT", right, top)
	pieces[3]:SetPoint("BOTTOMLEFT", frame, "BOTTOMLEFT", -left, -bottom)
	pieces[4]:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", right, -bottom)
	pieces[5]:SetPoint("TOPLEFT", pieces[1], "TOPRIGHT")
	pieces[5]:SetPoint("TOPRIGHT", pieces[2], "TOPLEFT")
	pieces[6]:SetPoint("BOTTOMLEFT", pieces[3], "BOTTOMRIGHT")
	pieces[6]:SetPoint("BOTTOMRIGHT", pieces[4], "BOTTOMLEFT")
	pieces[7]:SetPoint("TOPLEFT", pieces[1], "BOTTOMLEFT")
	pieces[7]:SetPoint("BOTTOMLEFT", pieces[3], "TOPLEFT")
	pieces[8]:SetPoint("TOPRIGHT", pieces[2], "BOTTOMRIGHT")
	pieces[8]:SetPoint("BOTTOMRIGHT", pieces[4], "TOPRIGHT")
end

local function setPiecesShown(pieces, shown)
	for i = 1, 8 do
		pieces[i]:SetShown(shown)
	end
end

local function style()
	return LolzenUIcfg and LolzenUIcfg.style or ns.defaults.style
end

--[[ outline object ]]---------------------------------------------------------

local outlineMixin = {}

function outlineMixin:SetColor(r, g, b, a)
	if type(r) == "table" then
		r, g, b, a = r[1], r[2], r[3], r[4]
	end
	local border = self.border
	for i = 1, 8 do
		border[i]:SetVertexColor(r, g, b, a or 1)
	end
end

function outlineMixin:ResetColor()
	self:SetColor(style()["outline_color"])
end

function outlineMixin:SetShown(shown)
	self.shown = shown
	setPiecesShown(self.border, shown)
	setPiecesShown(self.shadow, shown and style()["outline_shadow"])
end

function outlineMixin:Show()
	self:SetShown(true)
end

function outlineMixin:Hide()
	self:SetShown(false)
end

-- size: edge size of the border, padding: see file header
function outlineMixin:SetLayout(size, padding)
	local left, top, right, bottom
	if type(padding) == "table" then
		left, top, right, bottom = padding[1], padding[2], padding[3], padding[4]
	else
		padding = padding or 0
		left, top, right, bottom = padding, padding, padding, padding
	end
	self.size = size

	layoutPieces(self.border, self.frame, size, left, top, right, bottom)

	-- the shadow reaches a bit further out than the border
	local space = size >= 10 and 3 or size / 3.5
	layoutPieces(self.shadow, self.frame, size, left + space, top + space, right + space, bottom + space)
end

function outlineMixin:ApplyStyle()
	local cfg = style()
	local shadowAlpha = cfg["outline_shadow_alpha"] or 1
	for i = 1, 8 do
		self.shadow[i]:SetVertexColor(0, 0, 0, shadowAlpha)
	end
	setPiecesShown(self.shadow, self.shown and cfg["outline_shadow"])
	if not self.customColor then
		self:ResetColor()
	end
end

--[[ API ]]--------------------------------------------------------------------

-- Outline.Create(frame[, options]) -> outline
-- options.size      - edge size (default 12)
-- options.padding   - see file header (default 2)
-- options.color     - {r, g, b} fixed color; default: the configured outline color
-- options.level     - draw the outline on a child frame with this frame level offset,
--                     so it is rendered above the frame's children
function Outline.Create(frame, options)
	if frame.LolzenOutline then
		return frame.LolzenOutline
	end
	options = options or {}

	local host = frame
	if options.level then
		host = CreateFrame("Frame", nil, frame)
		host:SetAllPoints()
		host:SetFrameLevel(frame:GetFrameLevel() + options.level)
	end

	local outline = Mixin({
		frame = frame,
		host = host,
		shown = true,
		customColor = options.color ~= nil,
	}, outlineMixin)
	outline.shadow = createPieces(host, SHADOW_TEXTURE, "BACKGROUND", -8)
	outline.border = createPieces(host, BORDER_TEXTURE, "OVERLAY", 7)

	outline:SetLayout(options.size or 12, options.padding or 2)
	outline:ApplyStyle()
	if options.color then
		outline:SetColor(options.color)
	end

	frame.LolzenOutline = outline
	registry[outline] = true
	return outline
end

function Outline.Get(frame)
	return frame and frame.LolzenOutline
end

-- re-applies the global style (color, shadow) to every outline
function Outline.RefreshAll()
	for outline in pairs(registry) do
		outline:ApplyStyle()
	end
end

--[[ settings ]]---------------------------------------------------------------

ns.OnInit(nil, function()
	local options = ns.Options.New("style", function() return LolzenUIcfg.style end, ns.defaults.style, Outline.RefreshAll)
	options:Header(L["Outline"])
	options:Color("outline_color", L["Outline color"])
	options:Toggle("outline_shadow", L["Shadow"])
	options:Range("outline_shadow_alpha", L["Shadow alpha"], 0, 1, 0.05)
	ns.SettingsPanel:AddCategory("Style", options)
end)
