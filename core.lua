--// core //--

local addon, ns = ...

-- Create an empty table which will be filled by modules
ns.modules = {}
-- make the ns available to the seperate options addon
_G[addon] = ns

ns.RegisterModule = function(module)
	if not ns.modules[module] then
		tinsert(ns.modules, module)
	end
end