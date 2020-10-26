local _, ns = ...
local oUF = ns.oUF
local tags = oUF.Tags.Methods or oUF.Tags
local tagevents = oUF.TagEvents or oUF.Tags.Events

local valueFormat = function(min, max)
	local val, perc = 0, nil

	-- determine if local val should be siValue or pure integer
	if LolzenUIcfg.unitframes.general["uf_use_sivalue"] == true then
		if min >= 1e6 then
			if LolzenUIcfg.unitframes.general["uf_use_dot_format"] == true then
				val = ("%.1fm"):format(min / 1e6)
			else
				val = ("%.1f"):format(min / 1e6):gsub('%.', 'm')
			end
		elseif min >= 1e4 then
			if LolzenUIcfg.unitframes.general["uf_use_dot_format"] == true then
				val = ("%.1fk"):format(min / 1e3)
			else
				val = format(min / 1e3):gsub('%.', 'k')
			end
		end
	else
		val = min
	end

	-- determine if percentage should be shown, and if so in which order/standalone
	if LolzenUIcfg.unitframes.general["uf_use_hp_percent"] == true then
		if LolzenUIcfg.unitframes.general["uf_use_val_and_perc"] == true then
			if LolzenUIcfg.unitframes.general["uf_perc_first"] == true then
				return math.floor(min / max * 100 + 0.5).."%"..LolzenUIcfg.unitframes.general["uf_val_perc_divider"]..val
			else
				return val..LolzenUIcfg.unitframes.general["uf_val_perc_divider"]..math.floor(min / max * 100 + 0.5).."%"
			end
		else
			return math.floor(min / max * 100 + 0.5).."%"
		end
	else
		return val
	end
end

tags["lolzen:health"] = function(unit)
	if not UnitIsConnected(unit) or UnitIsDead(unit) or UnitIsGhost(unit) then return end

	local min, max = UnitHealth(unit), UnitHealthMax(unit)
	return valueFormat(min, max)
end
tagevents["lolzen:health"] = "UNIT_CONNECTION UNIT_HEALTH UNIT_MAXHEALTH"

tags["lolzen:power"] = function(unit)
	local min, max = UnitPower(unit), UnitPowerMax(unit)
	if min == 0 or max == 0 or not UnitIsConnected(unit) or UnitIsDead(unit) or UnitIsGhost(unit) then return end

	return valueFormat(min)
end
tagevents["lolzen:power"] = "UNIT_POWER_UPDATE UNIT_MAXPOWER"