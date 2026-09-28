--// settings panel //--
-- LolzenUI's category in the Blizzard settings panel (Esc -> Options -> AddOns -> LolzenUI).
-- It holds the module list and every option which isn't tied to a frame in the Edit Mode.
-- This replaces the former LolzenUI_Options addon.

local addon, ns = ...
local L = ns.L
local Options = ns.Options

local Panel = {}
ns.SettingsPanel = Panel

local mainCategory, mainLayout
local subcategories = {}

-- report errors of single controls instead of breaking the whole panel
local function safecall(func, ...)
	return xpcall(func, geterrorhandler(), ...)
end

local function variableName(opt)
	return ("LolzenUI_%s_%s"):format(opt.builder.id, tostring(opt.key or opt.name))
end

local function addControl(category, layout, opt)
	local kind = opt.kind
	if kind == "header" then
		layout:AddInitializer(CreateSettingsListSectionHeaderInitializer(opt.name))
	elseif kind == "toggle" then
		local setting = Settings.RegisterProxySetting(category, variableName(opt), Settings.VarType.Boolean, opt.name, opt.default and true or false,
			function() return opt:Get() and true or false end,
			function(value) opt:Set(value) end)
		Settings.CreateCheckbox(category, setting, opt.desc)
	elseif kind == "range" then
		local setting = Settings.RegisterProxySetting(category, variableName(opt), Settings.VarType.Number, opt.name, opt.default or opt.min,
			function() return opt:Get() end,
			function(value)
				value = math.floor(value / opt.step + 0.5) * opt.step
				if opt.step < 1 then
					value = tonumber(string.format("%.2f", value))
				end
				opt:Set(value)
			end)
		local sliderOptions = Settings.CreateSliderOptions(opt.min, opt.max, opt.step)
		sliderOptions:SetLabelFormatter(MinimalSliderWithSteppersMixin.Label.Right, opt.formatter or function(value)
			if opt.step < 1 then
				return string.format("%.2f", value)
			end
			return string.format("%d", value)
		end)
		Settings.CreateSlider(category, setting, sliderOptions, opt.desc)
	elseif kind == "select" then
		local default = opt.default
		local varType = type(default) == "number" and Settings.VarType.Number or Settings.VarType.String
		local setting = Settings.RegisterProxySetting(category, variableName(opt), varType, opt.name, default,
			function() return opt:Get() end,
			function(value) opt:Set(value) end)
		Settings.CreateDropdown(category, setting, function()
			local container = Settings.CreateControlTextContainer()
			for _, entry in ipairs(opt:GetValues()) do
				container:Add(entry.value, entry.text)
			end
			return container:GetData()
		end, opt.desc)
	elseif kind == "color" then
		layout:AddInitializer(CreateSettingsButtonInitializer(opt.name, COLOR, function()
			Options.PickColor(opt)
		end, opt.desc, true))
	elseif kind == "text" then
		layout:AddInitializer(CreateSettingsButtonInitializer(opt.name, EDIT, function()
			Options.EditText(opt)
		end, opt.desc, true))
	elseif kind == "button" then
		layout:AddInitializer(CreateSettingsButtonInitializer(opt.label or "", opt.name, opt.func, opt.desc, true))
	end
end

function Panel.Populate(category, layout, options)
	for _, opt in ipairs(options.list) do
		safecall(addControl, category, layout, opt)
	end
end

-- SettingsPanel:AddCategory(name, options[, editModeHint])
-- Creates a subcategory below LolzenUI. If editModeHint is set, a button to open the Edit Mode is added.
function Panel:AddCategory(name, options, editModeHint)
	local category, layout = Settings.RegisterVerticalLayoutSubcategory(mainCategory, L[name])
	subcategories[name] = category

	if editModeHint then
		layout:AddInitializer(CreateSettingsListSectionHeaderInitializer(L["Edit Mode"]))
		layout:AddInitializer(CreateSettingsButtonInitializer(L["Positions and frame options are in the Edit Mode"], L["Open Edit Mode"], ns.OpenEditMode, nil, true))
	end

	if options then
		Panel.Populate(category, layout, options)
	end
	return category, layout
end

function ns.OpenSettings(name)
	local category = (name and subcategories[name]) or mainCategory
	if not category then return end
	if InCombatLockdown() then
		-- the settings panel can't be opened reliably in combat
		ns.Print(ERR_NOT_IN_COMBAT)
		return
	end
	Settings.OpenToCategory(category:GetID())
end

--[[ main category ]]----------------------------------------------------------

local function buildMainCategory()
	mainCategory, mainLayout = Settings.RegisterVerticalLayoutCategory(addon)
	Settings.RegisterAddOnCategory(mainCategory)
	ns.SettingsCategory = mainCategory

	mainLayout:AddInitializer(CreateSettingsListSectionHeaderInitializer(("%s |cffffffff%s|r"):format(addon, C_AddOns.GetAddOnMetadata(addon, "Version") or "")))
	mainLayout:AddInitializer(CreateSettingsButtonInitializer(L["Move frames and change their look"], L["Open Edit Mode"], ns.OpenEditMode, L["Every LolzenUI frame can be moved and configured in the Edit Mode. Select a frame to see its options."], true))
	mainLayout:AddInitializer(CreateSettingsButtonInitializer(L["Tutorial"], L["Show again"], function()
		if ns.ShowTutorial then
			HideUIPanel(SettingsPanel)
			ns.ShowTutorial()
		end
	end, nil, true))

	-- module list
	local modules = Options.New("modules", function() return LolzenUIcfg.modules end, ns.defaults.modules, function()
		ns.AskReload()
	end)
	modules:Header(L["modules_to_load"])
	for _, module in ipairs(ns.GetSortedModules()) do
		local opt = modules:Toggle(module.name, L[module.name])
		opt.desc = module.desc
		if opt.default == nil then
			-- custom modules
			opt.default = true
		end
	end
	Panel.Populate(mainCategory, mainLayout, modules)
end

ns.OnInit(nil, function()
	safecall(buildMainCategory)
end)
