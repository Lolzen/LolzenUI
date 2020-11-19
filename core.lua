--// core //--

local addon, ns = ...
local L = ns.L
-- make the ns available to the seperate options addon
_G[addon] = ns

-- Create an empty table which will be filled by modules
ns.modules = {}

local sortTable = {}
local sort_func = function(a, b)
	return L[a.name] < L[b.name] 
end

ns.RegisterModule = function(module, desc, hasOptions)
	if not ns.modules[module] then
		ns.modules[#ns.modules+1] = {
			["name"] = module,
			["desc"] = desc,
			["hasOptions"] = hasOptions
		}
	end
	-- sort localized module names alphabethically
	table.sort(LolzenUI.modules, sort_func)
end

ns.customModuleOptions = function(module, defaults)
	if not LolzenUIcfg[module] then
		LolzenUIcfg[module] = defaults
	end
end

-- pixel perfection
--if GetCVar("useuiscale") == "0" then
--	SetCVar("uiScale", 768/string.match(({GetScreenResolutions()})[GetCurrentResolution()], "%d+x(%d+)"))
--	SetCVar("useuiscale", 1)
--end

-- make the InterfaceOptionsFrame movable
InterfaceOptionsFrame:SetMovable(true)
InterfaceOptionsFrame:EnableMouse(true)
InterfaceOptionsFrame:SetScript("OnMouseDown", function(self, button)
	self:StartMoving()
	self.isMoving = true
end)
InterfaceOptionsFrame:SetScript("OnMouseUp", function(self, button)
	self:StopMovingOrSizing()
	self.isMoving = false
end)
InterfaceOptionsFrame:SetScript("OnHide", function(self)
	if self.isMoving then
		self:StopMovingOrSizing()
		self.isMoving = false
	end
end)

local version, build, date, tocversion = GetBuildInfo()
local addonversion = GetAddOnMetadata(addon, "Version")
if not string.find(addonversion, version) then
	print("|cff5599ffLolzenUI|r: Version numbers don't match!")
	print("Please look for an update at: http://www.wowinterface.com/downloads/info24512-LolzenUI.html or https://github.com/Lolzen/LolzenUI (dev version)")
	print("WoW patch version: "..version..", LolzenUI version: "..addonversion)
end