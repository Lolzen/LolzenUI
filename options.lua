--// option descriptors //--
-- Modules describe their options once. The same description is rendered in the Edit Mode
-- (editmode.lua, via LibEditMode) and/or in the Blizzard settings panel (settings.lua).

local _, ns = ...
local L = ns.L
local LSM = LibStub("LibSharedMedia-3.0")
local LBT = LibStub("LibButtonTexture-1.0")

local Options = {}
ns.Options = Options

Options.anchors = {"TOPLEFT", "TOP", "TOPRIGHT", "LEFT", "CENTER", "RIGHT", "BOTTOMLEFT", "BOTTOM", "BOTTOMRIGHT"}
Options.flags = {"", "OUTLINE", "THINOUTLINE", "THICKOUTLINE", "MONOCHROME"}

local function listValues(list, names)
	local values = {}
	for i = 1, #list do
		local value = list[i]
		values[i] = {value = value, text = names and names[value] or tostring(value)}
	end
	return values
end

local function mediaValues(lib, mediatype)
	return function()
		return listValues(lib:List(mediatype))
	end
end

--[[ option object ]]----------------------------------------------------------

local option = {}
option.__index = option

function option:Get()
	local value = self.builder.getDB()[self.key]
	if value == nil then
		return self.default
	end
	return value
end

function option:Set(value)
	self.builder.getDB()[self.key] = value
	if self.apply then
		self.apply(value, self.key)
	end
	if self.builder.onChange then
		self.builder.onChange(self.key, value)
	end
end

function option:GetValues()
	local values = self.values
	if type(values) == "function" then
		values = values()
	end
	return values
end

function option:IsHidden()
	return self.hidden ~= nil and self.hidden() or false
end

function option:IsDisabled()
	return self.disabled ~= nil and self.disabled() or false
end

-- chainable modifiers
function option:SetHidden(func)
	self.hidden = func
	return self
end

function option:SetDisabled(func)
	self.disabled = func
	return self
end

function option:SetDesc(desc)
	self.desc = desc
	return self
end

--[[ builder ]]----------------------------------------------------------------

local builder = {}
builder.__index = builder

-- Options.New(id, getDB, defaults[, onChange])
-- id: unique identifier (used for setting variable names)
-- getDB: function returning the saved variable table the options are stored in
-- defaults: table holding the default values for the keys
-- onChange(key, value): called after any option of this builder has been changed
function Options.New(id, getDB, defaults, onChange)
	return setmetatable({
		id = id,
		list = {},
		getDB = getDB,
		defaults = defaults or {},
		onChange = onChange,
	}, builder)
end

function builder:Add(opt)
	opt.builder = self
	if opt.key ~= nil and opt.default == nil then
		opt.default = self.defaults[opt.key]
	end
	self.list[#self.list + 1] = setmetatable(opt, option)
	return opt
end

function builder:Header(name)
	return self:Add({kind = "header", name = name})
end

function builder:Toggle(key, name, apply)
	return self:Add({kind = "toggle", key = key, name = name, apply = apply})
end

function builder:Range(key, name, min, max, step, apply, formatter)
	return self:Add({kind = "range", key = key, name = name, min = min, max = max, step = step or 1, apply = apply, formatter = formatter})
end

-- values: array of {value = ..., text = ...} or a function returning such an array
function builder:Select(key, name, values, apply)
	return self:Add({kind = "select", key = key, name = name, values = values, apply = apply})
end

function builder:Font(key, name, apply)
	return self:Select(key, name or L["font"], mediaValues(LSM, "font"), apply)
end

function builder:Flag(key, name, apply)
	return self:Select(key, name or L["flag"], listValues(Options.flags, {[""] = NONE}), apply)
end

function builder:Anchor(key, name, apply)
	return self:Select(key, name or L["anchor"], listValues(Options.anchors), apply)
end

-- mediatype: "statusbar", "border", "background", "sound", "font"
function builder:Media(key, name, mediatype, apply)
	return self:Select(key, name, mediaValues(LSM, mediatype), apply)
end

-- button textures from LibButtonTexture ("border", "flashing", "checked", "hover", "pushed", "buff", "debuff")
function builder:ButtonTexture(key, name, mediatype, apply)
	return self:Select(key, name, mediaValues(LBT, mediatype), apply)
end

function builder:Color(key, name, apply, hasAlpha)
	return self:Add({kind = "color", key = key, name = name, apply = apply, hasAlpha = hasAlpha})
end

-- free text (edited in a popup)
function builder:Text(key, name, apply)
	return self:Add({kind = "text", key = key, name = name, apply = apply})
end

function builder:Button(name, func)
	return self:Add({kind = "button", name = name, func = func})
end

-- convenience: font, size and flag of a FontString
function builder:FontGroup(prefix, apply, sizeKey, flagKey)
	self:Font(prefix, nil, apply)
	self:Range(sizeKey or prefix.."_size", L["size"], 4, 40, 1, apply)
	self:Flag(flagKey or prefix.."_flag", nil, apply)
end

-- convenience: anchor + offsets
function builder:PointGroup(anchorKey, xKey, yKey, apply, range)
	range = range or 100
	self:Anchor(anchorKey, nil, apply)
	self:Range(xKey, L["PosX"], -range, range, 1, apply)
	self:Range(yKey, L["PosY"], -range, range, 1, apply)
end

Options.ListValues = listValues

--[[ shared UI helpers ]]------------------------------------------------------

-- ns.ShowColorPicker(color, hasAlpha, callback)
-- color: {r, g, b[, a]} table; callback(r, g, b, a) is called on every change and on cancel
function ns.ShowColorPicker(color, hasAlpha, callback)
	local r, g, b, a = color[1] or 1, color[2] or 1, color[3] or 1, color[4] or 1
	local function onChange()
		local nr, ng, nb = ColorPickerFrame:GetColorRGB()
		local na = hasAlpha and ColorPickerFrame:GetColorAlpha() or nil
		callback(nr, ng, nb, na)
	end
	ColorPickerFrame:SetupColorPickerAndShow({
		r = r, g = g, b = b,
		opacity = a,
		hasOpacity = hasAlpha,
		swatchFunc = onChange,
		opacityFunc = onChange,
		cancelFunc = function(previous)
			callback(previous.r, previous.g, previous.b, hasAlpha and previous.a or nil)
		end,
	})
end

function Options.PickColor(opt)
	ns.ShowColorPicker(opt:Get(), opt.hasAlpha, function(r, g, b, a)
		opt:Set({r, g, b, a})
	end)
end

local function getEditBox(popup)
	return (popup.GetEditBox and popup:GetEditBox()) or popup.editBox or popup.EditBox
end

StaticPopupDialogs["LOLZENUI_EDIT_TEXT"] = {
	text = "%s",
	button1 = ACCEPT,
	button2 = CANCEL,
	hasEditBox = true,
	editBoxWidth = 350,
	OnShow = function(self, data)
		local editBox = getEditBox(self)
		editBox:SetText(data.get and data.get() or "")
		editBox:HighlightText()
		editBox:SetFocus()
	end,
	OnAccept = function(self, data)
		data.set(getEditBox(self):GetText())
	end,
	EditBoxOnEnterPressed = function(self, data)
		data.set(self:GetText())
		self:GetParent():Hide()
	end,
	EditBoxOnEscapePressed = function(self)
		self:GetParent():Hide()
	end,
	timeout = 0,
	whileDead = true,
	hideOnEscape = true,
	preferredIndex = 3,
}

-- ns.ShowTextInput(title, get, set)
function ns.ShowTextInput(title, get, set)
	StaticPopup_Show("LOLZENUI_EDIT_TEXT", title, nil, {get = get, set = set})
end

function Options.EditText(opt)
	ns.ShowTextInput(opt.name, function() return opt:Get() end, function(text) opt:Set(text) end)
end
