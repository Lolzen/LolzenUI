--// itemlevel (core) // --
-- Shared helpers for showing item levels on item buttons.

local _, ns = ...
local L = ns.L

ns.RegisterModule("itemlevel", L["desc_itemlevel"], true)

local IL = {}
ns.ItemLevel = IL

local cfg
local texts = setmetatable({}, {__mode = "k"})
local refreshers = {}

local function applyStyle(text, button)
	ns.SetFont(text, cfg["ilvl_font"], cfg["ilvl_font_size"], cfg["ilvl_font_flag"])
	text:ClearAllPoints()
	text:SetPoint(cfg["ilvl_anchor"], button, cfg["ilvl_font_posx"], cfg["ilvl_font_posy"])
end

local function getText(button)
	local text = texts[button]
	if not text then
		text = button:CreateFontString(nil, "OVERLAY")
		applyStyle(text, button)
		texts[button] = text
	end
	return text
end

-- IL.Set(button, itemLevel, quality[, enabled])
-- shows the item level on the button or hides it if there is none
function IL.Set(button, itemLevel, quality, enabled)
	if enabled == false or not itemLevel or itemLevel <= 1 then
		local text = texts[button]
		if text then
			text:SetText("")
		end
		return
	end
	local text = getText(button)
	text:SetText(itemLevel)
	if cfg["ilvl_use_itemquality_color"] and quality then
		local r, g, b = C_Item.GetItemQualityColor(quality)
		text:SetTextColor(r, g, b)
	else
		text:SetTextColor(ns.RGB(cfg["ilvl_font_color"]))
	end
end

local function isEquippable(link)
	if C_Item.IsEquippableItem then
		return C_Item.IsEquippableItem(link)
	end
	local _, _, _, equipLoc = C_Item.GetItemInfoInstant(link)
	return equipLoc and equipLoc ~= "" and equipLoc ~= "INVTYPE_NON_EQUIP_IGNORE"
end

-- item level & quality of an item link (only for equippable items)
function IL.FromLink(link)
	if not link or not isEquippable(link) then return end
	local itemLevel = C_Item.GetDetailedItemLevelInfo(link)
	local _, _, quality = C_Item.GetItemInfo(link)
	return itemLevel, quality
end

-- item level & quality of an ItemLocation (includes upgrades etc.)
function IL.FromLocation(location)
	if not location or not location:IsValid() or not C_Item.DoesItemExist(location) then return end
	local link = C_Item.GetItemLink(location)
	if not link or not isEquippable(link) then return end
	return C_Item.GetCurrentItemLevel(location), C_Item.GetItemQuality(location)
end

function IL.FromBagSlot(bag, slot)
	if not bag or not slot then return end
	return IL.FromLocation(ItemLocation:CreateFromBagAndSlot(bag, slot))
end

-- modules register a function which updates all their visible buttons
function IL.RegisterRefresher(func)
	refreshers[#refreshers + 1] = func
end

function IL.RefreshAll()
	for button, text in pairs(texts) do
		applyStyle(text, button)
	end
	for i = 1, #refreshers do
		refreshers[i]()
	end
end

function IL.IsEnabled(key)
	return cfg[key]
end

ns.OnInit("itemlevel", function()
	cfg = LolzenUIcfg.itemlevel

	local options = ns.Options.New("itemlevel", function() return LolzenUIcfg.itemlevel end, ns.defaults.itemlevel, IL.RefreshAll)
	options:Header(L["show"])
	options:Toggle("ilvl_characterframe", L["ilvl_show_on_characterframe"])
	options:Toggle("ilvl_inspectframe", L["ilvl_show_on_inspectframe"])
	options:Toggle("ilvl_bags", L["ilvl_show_on_bags"])
	options:Header(L["ilvl_header_text"])
	options:FontGroup("ilvl_font")
	options:Toggle("ilvl_use_itemquality_color", L["ilvl_use_quality_color"])
	options:Color("ilvl_font_color", L["color"])
	options:PointGroup("ilvl_anchor", "ilvl_font_posx", "ilvl_font_posy", nil, 30)
	ns.SettingsPanel:AddCategory("itemlevel", options)
end)
