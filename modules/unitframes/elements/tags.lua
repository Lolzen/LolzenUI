local _, ns = ...
local oUF = ns.oUF
local tags = oUF.Tags.Methods or oUF.Tags
local tagevents = oUF.TagEvents or oUF.Tags.Events

local percentCurve = C_CurveUtil.CreateCurve()
percentCurve:SetType(Enum.LuaCurveType.Linear)
percentCurve:AddPoint(0, 0)
percentCurve:AddPoint(1, 100)

local alphaCurve = C_CurveUtil.CreateCurve()
alphaCurve:SetType(Enum.LuaCurveType.Linear)
alphaCurve:AddPoint(0.0, 255)
alphaCurve:AddPoint(0.99, 255)
alphaCurve:AddPoint(1.0, 0)

local valueFormat = function(min, max)
	-- determine if local val should be siValue or pure integer
	if LolzenUIcfg.unitframes.general["uf_use_sivalue"] == true then
--		if min >= 1e6 then
--			if LolzenUIcfg.unitframes.general["uf_use_dot_format"] == true then
--				val = ("%.1fm"):format(min / 1e6)
--			else
--				val = ("%.1f"):format(min / 1e6):gsub('%.', 'm')
--			end
--		elseif min >= 1e4 then
--			if LolzenUIcfg.unitframes.general["uf_use_dot_format"] == true then
--				val = ("%.1fk"):format(min / 1e3)
--			else
--				val = format(min / 1e3):gsub('%.', 'k')
--			end
--		else
--			val = min
--		end
--	else
--		val = min
	end

	-- determine if percentage should be shown, and if so in which order/standalone
--	if max ~= nil then
--		if LolzenUIcfg.unitframes.general["uf_use_hp_percent"] == true then
--			if LolzenUIcfg.unitframes.general["uf_use_val_and_perc"] == true then
--				if LolzenUIcfg.unitframes.general["uf_perc_first"] == true then
--					return math.floor(min / max * 100 + 0.5).."%"..LolzenUIcfg.unitframes.general["uf_val_perc_divider"]..val
--				else
--					return val..LolzenUIcfg.unitframes.general["uf_val_perc_divider"]..math.floor(min / max * 100 + 0.5).."%"
--				end
--			else
--				return math.floor(min / max * 100 + 0.5).."%"
--			end
--		else
--			return val
--		end
--	else
--		return val
--	end
	return 1
end

tags["lolzen:health"] = function(unit)
--	if canaccesvalue(unit) then
--	if not UnitIsConnected(unit) or UnitIsDead(unit) or UnitIsGhost(unit) then return end

--	local min, max = UnitHealth(unit), UnitHealthMax(unit)
--	if canaccesvalue(min) and canaccessvalue(max) then
--		return valueFormat(min, max)
--	end
--	end
	local val = UnitHealth(unit)
    if type(val) ~= "number" then return val end
    return AbbreviateNumbers(val)
end
tagevents["lolzen:health"] = "UNIT_CONNECTION UNIT_HEALTH UNIT_MAXHEALTH"

tags["lolzen:power"] = function(unit)
--	local min, max = UnitPower(unit), UnitPowerMax(unit)
--	if canaccesvalue(min) and canaccessvalue(max) then
--		if min == 0 or max == 0 or not UnitIsConnected(unit) or UnitIsDead(unit) or UnitIsGhost(unit) then return end
--
--		return valueFormat(min, nil)
--	end
	local val = UnitPower(unit)
    if type(val) ~= "number" then return val end
    return AbbreviateNumbers(val)
end
tagevents["lolzen:power"] = "UNIT_POWER_UPDATE UNIT_MAXPOWER"