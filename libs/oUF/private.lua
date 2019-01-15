local parent, ns = ...
local Private = ns.oUF.Private

function Private.argcheck(value, num, ...)
	assert(type(num) == 'number', "Bad argument #2 to 'argcheck' (number expected, got " .. type(num) .. ')')

	for i = 1, select('#', ...) do
		if(type(value) == select(i, ...)) then return end
	end

	local types = strjoin(', ', ...)
	local name = debugstack(2,2,0):match(": in function [`<](.-)['>]")
	error(string.format("Bad argument #%d to '%s' (%s expected, got %s)", num, name, types, type(value)), 3)
end

function Private.print(...)
	print('|cff33ff99oUF:|r', ...)
end

function Private.error(...)
	Private.print('|cffff0000Error:|r ' .. string.format(...))
end

function Private.UnitExists(unit)
	return unit and (UnitExists(unit) or ShowBossFrameWhenUninteractable(unit))
end

local validator = CreateFrame('Frame')

function Private.validateUnit(unit)
	local isOK, _ = pcall(validator.RegisterUnitEvent, validator, 'UNIT_HEALTH', unit)
	if(isOK) then
		_, unit = validator:IsEventRegistered('UNIT_HEALTH')
		validator:UnregisterEvent('UNIT_HEALTH')

		return not not unit
	end
end
