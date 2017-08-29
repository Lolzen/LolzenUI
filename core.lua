--// core //--

local addon, ns = ...

-- Create an empty table which will be filled by modules
ns.modules = {}

ns.RegisterModule = function(module)
	if not ns.modules[module] then
		tinsert(ns.modules, module)
	end
end