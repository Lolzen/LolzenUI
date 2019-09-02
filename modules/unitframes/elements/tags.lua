local _, ns = ...
local oUF = ns.oUF
local tags = oUF.Tags.Methods or oUF.Tags
local tagevents = oUF.TagEvents or oUF.Tags.Events

local siValue = function(val)
	if val >= 1e6 then
		if LolzenUIcfg.unitframes.general["uf_use_dot_format"] == true then
			return ("%.1fm"):format(val / 1e6)
		else
			return ("%.1f"):format(val / 1e6):gsub('%.', 'm')
		end
	elseif val >= 1e4 then
		if LolzenUIcfg.unitframes.general["uf_use_dot_format"] == true then
			return ("%.1fk"):format(val / 1e3)
		else
			return ("%.1f"):format(val / 1e3):gsub('%.', 'k')
		end
	else
		return val
	end
end

tags["lolzen:health"] = function(unit)
	if not UnitIsConnected(unit) or UnitIsDead(unit) or UnitIsGhost(unit) then return end

	local min, max = UnitHealth(unit), UnitHealthMax(unit)
	if LolzenUIcfg.unitframes.general["uf_use_sivalue"] == true then
		return siValue(min)
	else
		return min
	end
end

tags["lolzen:power"] = function(unit)
	local min, max = UnitPower(unit), UnitPowerMax(unit)
	if min == 0 or max == 0 or not UnitIsConnected(unit) or UnitIsDead(unit) or UnitIsGhost(unit) then return end

	if LolzenUIcfg.unitframes.general["uf_use_sivalue"] == true then
		return siValue(min)
	else
		return min
	end
end
tagevents["lolzen:power"] = "UNIT_POWER_UPDATE UNIT_MAXPOWER"