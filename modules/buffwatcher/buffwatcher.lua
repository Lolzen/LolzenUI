--// buffwatcher // --
-- Shows icons for a per character list of auras while they are active on the player.

local _, ns = ...
local L = ns.L

ns.RegisterModule("buffwatcher", L["desc_buffwatcher"], true)

local cfg, list
local anchor
local icons = {}
local UPDATE_INTERVAL = 0.1

local function createIcon(index)
	local icon = CreateFrame("Frame", nil, anchor)
	icon.texture = icon:CreateTexture(nil, "ARTWORK")
	icon.texture:SetAllPoints()
	icon.texture:SetTexCoord(.04, .94, .04, .94)

	ns.Outline.Create(icon, {size = 12, padding = 2})

	icon.time = icon:CreateFontString(nil, "OVERLAY")
	icon.time:SetPoint("TOP", icon, "BOTTOM", 0, 7)
	ns.SetFont(icon.time, "DroidSansBold", 12, "OUTLINE")

	icon.count = icon:CreateFontString(nil, "OVERLAY")
	icon.count:SetPoint("CENTER")
	ns.SetFont(icon.count, "DroidSansBold", 18, "OUTLINE")

	icon:Hide()
	icons[index] = icon
	return icon
end

local function layout()
	local size, spacing = cfg["buffwatch_icon_size"], cfg["buffwatch_icon_spacing"]
	local num = #list
	anchor:SetSize(math.max(size, num * size + (num - 1) * spacing), size)
	for i = 1, math.max(num, #icons) do
		local icon = icons[i]
		if i <= num then
			icon = icon or createIcon(i)
			icon:SetSize(size, size)
			icon:ClearAllPoints()
			icon:SetPoint("LEFT", anchor, "LEFT", (i - 1) * (size + spacing), 0)
			icon.spellID = list[i]
			icon.texture:SetTexture(C_Spell.GetSpellTexture(list[i]))
		elseif icon then
			icon.spellID = nil
			icon:Hide()
		end
	end
end

local function updateTimers(self, elapsed)
	self.elapsed = (self.elapsed or 0) + elapsed
	if self.elapsed < UPDATE_INTERVAL then return end
	self.elapsed = 0

	local now = GetTime()
	local active = false
	for i = 1, #icons do
		local icon = icons[i]
		local expiration = icon:IsShown() and icon.expiration
		if expiration then
			local remaining = expiration - now
			if remaining > 0 then
				active = true
				if remaining > 4 then
					icon.time:SetFormattedText("%.1f", remaining)
				else
					icon.time:SetFormattedText("|cffff0000%.1f|r", remaining)
				end
			else
				icon.time:SetText("")
			end
		end
	end
	if not active then
		self:SetScript("OnUpdate", nil)
	end
end

local function updateAuras()
	local needsTimer = false
	for i = 1, #list do
		local icon = icons[i]
		local aura = icon and C_UnitAuras.GetPlayerAuraBySpellID(list[i])
		if aura then
			local expiration = aura.expirationTime
			-- secret values (12.0 restrictions) can't be used for our own countdown
			if ns.IsSecret(expiration) or not expiration or expiration == 0 then
				icon.expiration = nil
				icon.time:SetText("")
			else
				icon.expiration = expiration
				needsTimer = true
			end
			local count = aura.applications
			if not ns.IsSecret(count) and count and count > 1 then
				icon.count:SetText(count)
			else
				icon.count:SetText("")
			end
			icon:Show()
		elseif icon then
			icon.expiration = nil
			icon:SetShown(ns.EditMode:IsActive())
		end
	end
	if needsTimer then
		anchor:SetScript("OnUpdate", updateTimers)
	end
end

local function resolveSpell(input)
	input = strtrim(input or "")
	if input == "" then return end
	local info = C_Spell.GetSpellInfo(tonumber(input) or input)
	return info and info.spellID
end

local function addSpell(input)
	local spellID = resolveSpell(input)
	if not spellID then
		return ns.Print(L["Unknown spell: "]..tostring(input))
	end
	if not tContains(list, spellID) then
		table.insert(list, spellID)
		layout()
		updateAuras()
	end
end

local function removeSpell(input)
	local spellID = resolveSpell(input)
	for i = #list, 1, -1 do
		if list[i] == spellID or list[i] == tonumber(input) then
			table.remove(list, i)
		end
	end
	layout()
	updateAuras()
end

ns.BuffWatcherUpdate = function()
	layout()
	updateAuras()
end

ns.OnInit("buffwatcher", function()
	cfg = LolzenUIcfg.buffwatcher
	local playerName = UnitName("player")
	cfg["buffwatchlist"][playerName] = cfg["buffwatchlist"][playerName] or {}
	list = cfg["buffwatchlist"][playerName]

	anchor = CreateFrame("Frame", "LolzenUI_BuffWatcher", UIParent)
	layout()

	local options = ns.Options.New("buffwatcher", function() return LolzenUIcfg.buffwatcher end, ns.defaults.buffwatcher, ns.BuffWatcherUpdate)
	options:Header(L["icon"])
	options:Range("buffwatch_icon_size", L["bw_icon_size"], 10, 100, 1)
	options:Range("buffwatch_icon_spacing", L["bw_icon_spacing"], 0, 50, 1)
	options:Button(L["Add aura..."], function()
		ns.ShowTextInput(L["bw_add_or_delete_text"], nil, addSpell)
	end)
	options:Button(L["Remove aura..."], function()
		ns.ShowTextInput(L["bw_add_or_delete_text"], nil, removeSpell)
	end)

	ns.EditMode:AddFrame(anchor, {
		name = L["LolzenUI: Buffwatcher"],
		pos = {
			db = function() return LolzenUIcfg.buffwatcher end,
			point = "buffwatch_anchor",
			x = "buffwatch_pos_x",
			y = "buffwatch_pos_y",
		},
		defaults = ns.defaults.buffwatcher,
		options = options,
	})
	ns.EditMode:RegisterCallback("enter", updateAuras)
	ns.EditMode:RegisterCallback("exit", updateAuras)

	local events = CreateFrame("Frame")
	events:RegisterUnitEvent("UNIT_AURA", "player")
	events:RegisterEvent("PLAYER_ENTERING_WORLD")
	events:SetScript("OnEvent", updateAuras)
end)
