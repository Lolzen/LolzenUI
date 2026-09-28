--// databar //--
-- Shared code of the xpbar and artifactbar modules: a thin statusbar with an optional 1px border and a text.

local _, ns = ...
local L = ns.L
local LSM = LibStub("LibSharedMedia-3.0")

local barMixin = {}

function barMixin:Get(key)
	return self.db[self.prefix.."_"..key]
end

function barMixin:ApplySize()
	self:SetSize(self:Get("width"), self:Get("height"))
end

function barMixin:ApplyTexture()
	local texture = LSM:Fetch("statusbar", self:Get("texture"))
	self:SetStatusBarTexture(texture)
	self.bg:SetTexture(texture)
end

function barMixin:ApplyAlpha()
	self:SetAlpha(self:Get("alpha"))
	self.bg:SetVertexColor(0, 0, 0, self:Get("bg_alpha"))
end

function barMixin:ApplyBorder()
	local lines = self.lines
	if not self:Get("1px_border") then
		for i = 1, #lines do
			lines[i]:Hide()
		end
		return
	end

	if #lines == 0 then
		for i = 1, 4 do
			local line = self:CreateTexture(nil, "OVERLAY")
			line:SetColorTexture(0, 0, 0, 1)
			lines[i] = line
		end
	end

	-- rounded: the side lines sit outside of the bar, so the corners stay empty
	local inset = self:Get("1px_border_round") and 0 or 1
	local top, bottom, left, right = lines[1], lines[2], lines[3], lines[4]
	top:ClearAllPoints()
	top:SetHeight(1)
	top:SetPoint("BOTTOMLEFT", self, "TOPLEFT")
	top:SetPoint("BOTTOMRIGHT", self, "TOPRIGHT")
	bottom:ClearAllPoints()
	bottom:SetHeight(1)
	bottom:SetPoint("TOPLEFT", self, "BOTTOMLEFT")
	bottom:SetPoint("TOPRIGHT", self, "BOTTOMRIGHT")
	left:ClearAllPoints()
	left:SetWidth(1)
	left:SetPoint("TOPRIGHT", self, "TOPLEFT", inset, 0)
	left:SetPoint("BOTTOMRIGHT", self, "BOTTOMLEFT", inset, 0)
	right:ClearAllPoints()
	right:SetWidth(1)
	right:SetPoint("TOPLEFT", self, "TOPRIGHT", -inset, 0)
	right:SetPoint("BOTTOMLEFT", self, "BOTTOMRIGHT", -inset, 0)
	for i = 1, 4 do
		lines[i]:Show()
	end
end

function barMixin:ApplyText()
	local text = self.text
	ns.SetFont(text, self:Get("font"), self:Get("font_size"), self:Get("font_flag"))
	text:SetTextColor(ns.RGB(self:Get("font_color")))
	text:ClearAllPoints()
	text:SetPoint(self:Get("text_anchor1"), self, self:Get("text_posx"), self:Get("text_posy"))
	text:SetShown(not self:Get("mouseover_text") or self:IsMouseOver())
end

function barMixin:ApplyAll()
	self:ApplySize()
	self:ApplyTexture()
	self:ApplyAlpha()
	self:ApplyBorder()
	self:ApplyText()
end

local function onEnter(self)
	self.text:Show()
end

local function onLeave(self)
	if self:Get("mouseover_text") then
		self.text:Hide()
	end
end

-- coalesce bursts of events (UPDATE_FACTION fires a lot) into one update per frame
local function requestUpdate(self)
	if self.updatePending then return end
	self.updatePending = true
	C_Timer.After(0, self.doUpdate)
end

-- ns.CreateDataBar(name, prefix, db, defaults, updateFunc)
function ns.CreateDataBar(name, prefix, db, defaults, updateFunc)
	local bar = Mixin(CreateFrame("StatusBar", name, UIParent), barMixin)
	bar.prefix = prefix
	bar.db = db
	bar.lines = {}
	bar:SetFrameStrata("BACKGROUND")
	bar:SetStatusBarColor(1, 1, 1)

	bar.bg = bar:CreateTexture(nil, "BACKGROUND")
	bar.bg:SetAllPoints()

	bar.text = bar:CreateFontString(nil, "OVERLAY")
	-- the text shouldn't fade with the bar
	bar.text:SetIgnoreParentAlpha(true)

	bar:SetScript("OnEnter", onEnter)
	bar:SetScript("OnLeave", onLeave)

	bar.Update = updateFunc
	bar.RequestUpdate = requestUpdate
	bar.doUpdate = function()
		bar.updatePending = false
		bar:Update()
	end
	bar:SetScript("OnEvent", requestUpdate)

	bar:ApplyAll()

	-- Edit Mode
	local options = ns.Options.New(prefix, function() return db end, defaults, function()
		bar:ApplyAll()
		bar:Update()
	end)
	bar.options = options

	options:Header(L["Size"])
	options:Range(prefix.."_width", L["width"], 20, 2000, 1)
	options:Range(prefix.."_height", L["height"], 1, 40, 1)
	options:Header(L["Appearance"])
	options:Media(prefix.."_texture", L["texture"], "statusbar")
	options:Range(prefix.."_alpha", L["alpha"], 0, 1, 0.05)
	options:Range(prefix.."_bg_alpha", L["bgalpha"], 0, 1, 0.05)
	options:Toggle(prefix.."_1px_border", L["xp_draw_1px"])
	options:Toggle(prefix.."_1px_border_round", L["xp_1px_round"]):SetDisabled(function() return not db[prefix.."_1px_border"] end)
	options:Header(L["text"])
	options:Toggle(prefix.."_mouseover_text", L["xp_mouseover_text"])
	options:FontGroup(prefix.."_font")
	options:Color(prefix.."_font_color", L["color"])
	options:PointGroup(prefix.."_text_anchor1", prefix.."_text_posx", prefix.."_text_posy")

	return bar, options
end

-- register a databar in the Edit Mode (call after all options have been added)
function ns.RegisterDataBar(bar, editModeName, defaults)
	local prefix = bar.prefix
	ns.EditMode:AddFrame(bar, {
		name = editModeName,
		pos = {
			db = function() return bar.db end,
			point = prefix.."_anchor",
			parent = prefix.."_parent",
			x = prefix.."_posx",
			y = prefix.."_posy",
		},
		defaults = defaults,
		options = bar.options,
	})

	-- the bars may be hidden when there is nothing to show; always show them in the Edit Mode
	ns.EditMode:RegisterCallback("enter", function()
		bar.inEditMode = true
		bar:Show()
	end)
	ns.EditMode:RegisterCallback("exit", function()
		bar.inEditMode = false
		bar:Update()
	end)
end
