﻿--// core //--

local addon, ns = ...
-- make the ns available to the seperate options addon
_G[addon] = ns

-- Create an empty table which will be filled by modules
ns.modules = {}

ns.RegisterModule = function(module, hasOptions)
	if not ns.modules[module] then
		ns.modules[#ns.modules+1] = {
			["name"] = module,
			["hasOptions"] = hasOptions
		}
	end
end

ns.customModuleOptions = function(module, defaults)
	if not LolzenUIcfg[module] then
		LolzenUIcfg[module] = defaults
	end
end

-- pixel perfection
if GetCVar("useuiscale") == "0" then
	SetCVar("uiScale", 768/string.match(({GetScreenResolutions()})[GetCurrentResolution()], "%d+x(%d+)"))
	SetCVar("useuiscale", 1)
end