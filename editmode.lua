--// Edit Mode integration //--
-- Renders option descriptors (options.lua) into LibEditMode dialogs and handles frame positions.

local _, ns = ...
local L = ns.L
local LEM = LibStub("LibEditMode")
local Options = ns.Options

local EM = {}
ns.EditMode = EM
EM.lib = LEM

local SettingType = LEM.SettingType

local function round(value)
	return math.floor(value * 10 + 0.5) / 10
end

--[[ descriptors -> LibEditMode settings ]]------------------------------------

local function convert(opt, sections, section)
	local kind = opt.kind
	local setting = {
		name = opt.name,
		desc = opt.desc,
	}

	if kind == "header" then
		setting.kind = SettingType.Expander
		setting.default = false
		setting.get = function()
			return sections[section]
		end
		setting.set = function(_, value)
			sections[section] = value
		end
		return setting
	end

	-- options belonging to a collapsed section are hidden
	setting.hidden = function()
		return (section and not sections[section]) or opt:IsHidden()
	end
	setting.disabled = function()
		return opt:IsDisabled()
	end

	if kind == "toggle" then
		setting.kind = SettingType.Checkbox
		setting.default = opt.default and true or false
		setting.get = function()
			return opt:Get() and true or false
		end
		setting.set = function(_, value)
			opt:Set(value)
		end
	elseif kind == "range" then
		setting.kind = SettingType.Slider
		setting.default = opt.default or opt.min
		setting.minValue = opt.min
		setting.maxValue = opt.max
		setting.valueStep = opt.step
		setting.formatter = opt.formatter
		setting.get = function()
			return opt:Get()
		end
		setting.set = function(_, value)
			-- sliders report floats, snap them to the step size
			local step = opt.step
			value = math.floor(value / step + 0.5) * step
			if step < 1 then
				value = tonumber(string.format("%.2f", value))
			end
			if value ~= opt:Get() then
				opt:Set(value)
			end
		end
	elseif kind == "select" then
		setting.kind = SettingType.Dropdown
		setting.default = opt.default
		setting.height = 300
		setting.values = function()
			return opt:GetValues()
		end
		setting.get = function()
			return opt:Get()
		end
		setting.set = function(_, value)
			opt:Set(value)
		end
	elseif kind == "color" then
		setting.kind = SettingType.ColorPicker
		setting.hasOpacity = opt.hasAlpha
		local default = opt.default or {1, 1, 1}
		setting.default = CreateColor(default[1], default[2], default[3], default[4] or 1)
		setting.get = function()
			local color = opt:Get()
			return CreateColor(color[1], color[2], color[3], color[4] or 1)
		end
		setting.set = function(_, color)
			local r, g, b, a = color:GetRGBA()
			opt:Set({r, g, b, opt.hasAlpha and a or nil})
		end
	else
		-- text inputs and buttons are rendered as dialog buttons
		return nil
	end

	return setting
end

-- returns the LibEditMode settings and extra buttons for a list of descriptors
function EM.Build(list)
	local settings, buttons = {}, {}
	-- expanded state of the sections; the first section starts expanded
	local sections = {true}
	local section
	for _, opt in ipairs(list) do
		if opt.kind == "header" then
			section = (section or 0) + 1
			settings[#settings + 1] = convert(opt, sections, section)
		elseif opt.kind == "text" then
			buttons[#buttons + 1] = {
				text = opt.name,
				click = function()
					Options.EditText(opt)
				end,
			}
		elseif opt.kind == "button" then
			buttons[#buttons + 1] = {
				text = opt.name,
				click = opt.func,
			}
		else
			local setting = convert(opt, sections, section)
			if setting then
				settings[#settings + 1] = setting
			end
		end
	end
	return settings, buttons
end

--[[ positions ]]--------------------------------------------------------------

-- pos: {db = function, point = key, rel = key?, parent = key?, x = key, y = key}
function EM.ApplyPosition(frame, pos)
	local db = pos.db()
	local point = db[pos.point] or "CENTER"
	local rel = pos.rel and db[pos.rel] or point
	local parent = pos.parent and _G[db[pos.parent]] or UIParent
	frame:ClearAllPoints()
	frame:SetPoint(point, parent, rel, db[pos.x] or 0, db[pos.y] or 0)
end

-- a plain frame used as position handle for frames which can't be moved directly (secure frames, groups, ...)
function EM.CreateHolder(name, width, height)
	local holder = CreateFrame("Frame", name, UIParent)
	holder:SetSize(width, height)
	holder:SetClampedToScreen(true)
	return holder
end

--[[ public API ]]-------------------------------------------------------------

-- EM:AddFrame(frame, spec)
-- spec.name     - name shown in the Edit Mode
-- spec.pos      - position description (see ApplyPosition)
-- spec.defaults - table holding the default values of the position keys
-- spec.options  - options builder (options.lua), optional
-- spec.category - name of a settings panel category to link to, optional
-- spec.onMove   - called after the frame has been moved, optional
function EM:AddFrame(frame, spec)
	local pos, defaults = spec.pos, spec.defaults

	EM.ApplyPosition(frame, pos)

	LEM:AddFrame(frame, function(_, _, point, x, y)
		local db = pos.db()
		db[pos.point] = point
		if pos.rel then
			db[pos.rel] = point
		end
		if pos.parent then
			db[pos.parent] = "UIParent"
		end
		db[pos.x] = round(x)
		db[pos.y] = round(y)
		if spec.onMove then
			spec.onMove(point, x, y)
		end
	end, {
		point = defaults[pos.point],
		x = defaults[pos.x],
		y = defaults[pos.y],
	}, spec.name)

	-- make thin frames (e.g. 4px bars) easier to grab
	local selection = LEM.frameSelections and LEM.frameSelections[frame]
	if selection then
		local width, height = frame:GetSize()
		local padX = math.max(0, (20 - width) / 2)
		local padY = math.max(0, (20 - height) / 2)
		selection:SetHitRectInsets(-padX, -padX, -padY, -padY)
	end

	local settings, buttons = {}, {}
	if spec.options then
		settings, buttons = EM.Build(spec.options.list)
	end
	if spec.category then
		buttons[#buttons + 1] = {
			text = L["More options..."],
			click = function()
				ns.OpenSettings(spec.category)
			end,
		}
	end
	if #settings > 0 then
		LEM:AddFrameSettings(frame, settings)
	end
	if #buttons > 0 then
		LEM:AddFrameSettingsButtons(frame, buttons)
	end
end

-- EM:AddSystemSettings(systemNames, options[, subSystemID])
-- Attaches options to a Blizzard Edit Mode system (e.g. "ActionBar", "Minimap").
-- systemNames can be a list of alternative enum names (they differ between client versions).
-- Returns false if the system doesn't exist in this client.
function EM:AddSystemSettings(systemNames, options, subSystemID)
	if type(systemNames) ~= "table" then
		systemNames = {systemNames}
	end
	local systemID
	for _, name in ipairs(systemNames) do
		systemID = Enum.EditModeSystem and Enum.EditModeSystem[name]
		if systemID then break end
	end
	if not systemID then
		return false
	end
	local settings, buttons = EM.Build(options.list)
	if #settings > 0 then
		LEM:AddSystemSettings(systemID, settings, subSystemID)
	end
	if #buttons > 0 then
		LEM:AddSystemSettingsButtons(systemID, buttons, subSystemID)
	end
	return true
end

function EM:Refresh(frame)
	LEM:RefreshFrameSettings(frame)
end

function EM:IsActive()
	return LEM:IsInEditMode()
end

function EM:RegisterCallback(event, callback)
	LEM:RegisterCallback(event, callback)
end
