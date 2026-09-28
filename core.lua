--// core //--

local addon, ns = ...
local L = ns.L

-- make the namespace available to other addons (e.g. custom modules)
_G[addon] = ns

--[[ Module registry ]]--------------------------------------------------------

-- array of {name, desc, hasOptions}; kept for backwards compatibility with custom modules
ns.modules = {}
local moduleByName = {}

local initCallbacks = {}
local loginCallbacks = {}

-- ns.RegisterModule(name, desc[, hasOptions])
-- Registers a module so it shows up in the module list of the options.
function ns.RegisterModule(name, desc, hasOptions)
	if moduleByName[name] then
		return moduleByName[name]
	end
	local module = {
		name = name,
		desc = desc,
		hasOptions = hasOptions,
	}
	ns.modules[#ns.modules + 1] = module
	moduleByName[name] = module
	return module
end

function ns.GetModule(name)
	return moduleByName[name]
end

-- returns the modules sorted by their localized name
function ns.GetSortedModules()
	local sorted = {}
	for i = 1, #ns.modules do
		sorted[i] = ns.modules[i]
	end
	table.sort(sorted, function(a, b)
		return L[a.name] < L[b.name]
	end)
	return sorted
end

function ns.IsModuleEnabled(name)
	return LolzenUIcfg ~= nil and LolzenUIcfg.modules ~= nil and LolzenUIcfg.modules[name] ~= false
end

-- ns.OnInit(module, func)
-- func runs once on ADDON_LOADED (after the saved variables are initialized), only if the module is enabled.
-- Pass nil as module to always run the function.
function ns.OnInit(module, func)
	initCallbacks[#initCallbacks + 1] = {module, func}
end

-- ns.OnLogin(module, func)
-- func runs once on PLAYER_LOGIN, only if the module is enabled.
function ns.OnLogin(module, func)
	loginCallbacks[#loginCallbacks + 1] = {module, func}
end

-- custom modules may register their own saved variables (kept for compatibility)
function ns.customModuleOptions(module, defaults)
	if not LolzenUIcfg[module] then
		LolzenUIcfg[module] = defaults
	end
end

local function runCallbacks(callbacks)
	for i = 1, #callbacks do
		local module, func = callbacks[i][1], callbacks[i][2]
		if module == nil or ns.IsModuleEnabled(module) then
			-- one broken module shouldn't take down the whole UI
			xpcall(func, geterrorhandler())
		end
	end
	wipe(callbacks)
end

--[[ Helpers ]]----------------------------------------------------------------

local LSM = LibStub("LibSharedMedia-3.0")

-- true if the value is a 12.0+ secret value which must not be compared or used in arithmetic
local issecretvalue = issecretvalue
function ns.IsSecret(value)
	return issecretvalue ~= nil and issecretvalue(value) or false
end

-- sets a LibSharedMedia font on a FontString
function ns.SetFont(fontString, font, size, flag)
	fontString:SetFont(LSM:Fetch("font", font), size, flag or "")
end

-- returns r, g, b from a {r, g, b} table
function ns.RGB(color)
	return color[1], color[2], color[3]
end

-- "|cffrrggbb" for a {r, g, b} table
function ns.HexColor(color)
	return string.format("|cff%02x%02x%02x", color[1] * 255, color[2] * 255, color[3] * 255)
end

function ns.Print(msg)
	print("|cff5599ffLolzenUI|r: "..msg)
end

function ns.DeepCopy(value)
	if type(value) ~= "table" then
		return value
	end
	local copy = {}
	for k, v in pairs(value) do
		copy[k] = ns.DeepCopy(v)
	end
	return copy
end

-- Runs func now, or as soon as combat ends if we are in combat lockdown.
-- Queued functions are unique, so spamming a setting only runs the update once.
local combatQueue = {}
local combatFrame = CreateFrame("Frame")
combatFrame:SetScript("OnEvent", function(self)
	self:UnregisterEvent("PLAYER_REGEN_ENABLED")
	for func in pairs(combatQueue) do
		combatQueue[func] = nil
		func()
	end
end)

function ns.RunOutOfCombat(func)
	if InCombatLockdown() then
		combatQueue[func] = true
		combatFrame:RegisterEvent("PLAYER_REGEN_ENABLED")
		return false
	end
	func()
	return true
end

StaticPopupDialogs["LOLZENUI_RELOAD"] = {
	text = L["A reload of the UI is required for this change to take effect."],
	button1 = RELOADUI,
	button2 = LATER,
	OnAccept = function()
		ReloadUI()
	end,
	timeout = 0,
	whileDead = true,
	hideOnEscape = true,
	preferredIndex = 3,
}

function ns.AskReload()
	StaticPopup_Show("LOLZENUI_RELOAD")
end

-- parent for Blizzard frames we don't want to see
ns.HiddenFrame = CreateFrame("Frame")
ns.HiddenFrame:Hide()

function ns.Kill(frame)
	if not frame then return end
	if frame.UnregisterAllEvents then
		frame:UnregisterAllEvents()
	end
	frame:SetParent(ns.HiddenFrame)
end

-- hides a frame without touching its events (it keeps working, it's just not visible)
function ns.Hide(frame)
	if frame then
		frame:SetParent(ns.HiddenFrame)
	end
end

--[[ Slash commands ]]---------------------------------------------------------

function ns.OpenEditMode()
	if InCombatLockdown() then
		ns.Print(ERR_NOT_IN_COMBAT)
		return
	end
	if SettingsPanel and SettingsPanel:IsShown() then
		HideUIPanel(SettingsPanel)
	end
	ShowUIPanel(EditModeManagerFrame)
end

SLASH_LOLZENUI1 = "/lolzen"
SLASH_LOLZENUI2 = "/lolzenui"
SlashCmdList["LOLZENUI"] = function(msg)
	msg = strtrim(msg or ""):lower()
	if msg == "edit" or msg == "em" or msg == "move" then
		ns.OpenEditMode()
	else
		ns.OpenSettings()
	end
end

--[[ Initialization ]]---------------------------------------------------------

local loader = CreateFrame("Frame")
loader:RegisterEvent("ADDON_LOADED")
loader:RegisterEvent("PLAYER_LOGIN")
loader:SetScript("OnEvent", function(self, event, name)
	if event == "ADDON_LOADED" then
		if name ~= addon then return end
		self:UnregisterEvent("ADDON_LOADED")
		ns.InitDB()
		runCallbacks(initCallbacks)
	else
		self:UnregisterEvent("PLAYER_LOGIN")
		runCallbacks(loginCallbacks)
		self:SetScript("OnEvent", nil)
	end
end)
