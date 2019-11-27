--[[
Based on LibSharedMedia-3.0 by Elkano
Esentially just a modified version!
]]

local MAJOR, MINOR = "LibButtonTexture-1.0", 1
local lib = LibStub:NewLibrary(MAJOR, MINOR)

if not lib then return end

local _G = getfenv(0)

local pairs	= _G.pairs
local type = _G.type

local band = _G.bit.band

local table_insert = _G.table.insert
local table_sort = _G.table.sort

local CallbackHandler = LibStub:GetLibrary("CallbackHandler-1.0")

lib.callbacks = lib.callbacks or CallbackHandler:New(lib)

lib.DefaultMedia = lib.DefaultMedia or {}
lib.MediaList = lib.MediaList or {}
lib.MediaTable = lib.MediaTable or {}
lib.MediaType = lib.MediaType or {}
lib.OverrideMedia = lib.OverrideMedia or {}

local defaultMedia = lib.DefaultMedia
local mediaList = lib.MediaList
local mediaTable = lib.MediaTable
local overrideMedia = lib.OverrideMedia

lib.MediaType.BORDER = "border"
lib.MediaType.FLASHING = "flashing"
lib.MediaType.CHECKED = "checked"
lib.MediaType.HOVER = "hover"
lib.MediaType.PUSHED = "pushed"

-- BORDER
if not lib.MediaTable.border then lib.MediaTable.border = {} end
lib.MediaTable.border["None"] = [[]]
lib.MediaTable.border["Blizzard QuickSlot2"] = [[Interface\Buttons\UI-Quickslot2]]
lib.DefaultMedia.border = "Blizzard QuickSlot2"

-- FLASHING
if not lib.MediaTable.flashing then lib.MediaTable.flashing = {} end
lib.MediaTable.flashing["None"] = [[]]
lib.MediaTable.flashing["Blizzard QuickSlotRed"] = [[Interface\Buttons\UI-QuickslotRed]]
lib.DefaultMedia.flashing = "Blizzard QuickSlotRed"

-- CHECKED
if not lib.MediaTable.checked then lib.MediaTable.checked = {} end
lib.MediaTable.checked["None"] = [[]]
lib.MediaTable.checked["Blizzard CheckButtonHilight"] = [[Interface\Buttons\CheckButtonHilight]]
lib.DefaultMedia.checked = "Blizzard CheckButtonHilight"

-- HOVER
if not lib.MediaTable.hover then lib.MediaTable.hover = {} end
lib.MediaTable.hover["None"] = [[]]
lib.MediaTable.hover["Blizzard ButtonHilight-Square"] = [[Interface\Buttons\ButtonHilight-Square]]
lib.DefaultMedia.hover = "Blizzard ButtonHilight-Square"

-- PUSHED
if not lib.MediaTable.pushed then lib.MediaTable.pushed = {} end
lib.MediaTable.pushed["None"] = [[]]
lib.MediaTable.pushed["Blizzard UI-Quickslot-Depress"] = [[Interface\Buttons\UI-Quickslot-Depress]]
lib.DefaultMedia.pushed = "Blizzard UI-Quickslot-Depress"

local function rebuildMediaList(mediatype)
	local mtable = mediaTable[mediatype]
	if not mtable then return end
	if not mediaList[mediatype] then mediaList[mediatype] = {} end
	local mlist = mediaList[mediatype]
	-- list can only get larger, so simply overwrite it
	local i = 0
	for k in pairs(mtable) do
		i = i + 1
		mlist[i] = k
	end
	table_sort(mlist)
end

function lib:Register(mediatype, key, data, langmask)
	if type(mediatype) ~= "string" then
		error(MAJOR..":Register(mediatype, key, data, langmask) - mediatype must be string, got "..type(mediatype))
	end
	if type(key) ~= "string" then
		error(MAJOR..":Register(mediatype, key, data, langmask) - key must be string, got "..type(key))
	end
	mediatype = mediatype:lower()
	if not mediaTable[mediatype] then mediaTable[mediatype] = {} end
	local mtable = mediaTable[mediatype]
	if mtable[key] then return false end
	
	mtable[key] = data
	rebuildMediaList(mediatype)
	self.callbacks:Fire("LibSharedMedia_Registered", mediatype, key)
	return true
end

function lib:Fetch(mediatype, key, noDefault)
	local mtt = mediaTable[mediatype]
	local overridekey = overrideMedia[mediatype]
	local result = mtt and ((overridekey and mtt[overridekey] or mtt[key]) or (not noDefault and defaultMedia[mediatype] and mtt[defaultMedia[mediatype]])) or nil
	return result ~= "" and result or nil
end

function lib:IsValid(mediatype, key)
	return mediaTable[mediatype] and (not key or mediaTable[mediatype][key]) and true or false
end

function lib:HashTable(mediatype)
	return mediaTable[mediatype]
end

function lib:List(mediatype)
	if not mediaTable[mediatype] then
		return nil
	end
	if not mediaList[mediatype] then
		rebuildMediaList(mediatype)
	end
	return mediaList[mediatype]
end

function lib:GetGlobal(mediatype)
	return overrideMedia[mediatype]
end

function lib:SetGlobal(mediatype, key)
	if not mediaTable[mediatype] then
		return false
	end
	overrideMedia[mediatype] = (key and mediaTable[mediatype][key]) and key or nil
	self.callbacks:Fire("LibSharedMedia_SetGlobal", mediatype, overrideMedia[mediatype])
	return true
end

function lib:GetDefault(mediatype)
	return defaultMedia[mediatype]
end

function lib:SetDefault(mediatype, key)
	if mediaTable[mediatype] and mediaTable[mediatype][key] and not defaultMedia[mediatype] then
		defaultMedia[mediatype] = key
		return true
	else
		return false
	end
end
