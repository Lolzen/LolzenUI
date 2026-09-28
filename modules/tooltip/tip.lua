--// tooltip // --
-- The default tooltip position is handled by the Edit Mode ("HUD Tooltip").

local _, ns = ...
local L = ns.L
local LSM = LibStub("LibSharedMedia-3.0")

ns.RegisterModule("tooltip", L["desc_tooltip"], true)

local format = string.format
local cfg
local skinned = {}
local factionBG, raidIcon
local targetWatcher

local MOB_TYPE = {
	normal = "",
	worldboss = " Boss",
	rareelite = " + Rare",
	rare = " Rare",
	elite = " +",
	trivial = " Trivial",
	minus = " -",
}

local FACTION_ICONS = {
	Alliance = "Interface\\Timer\\Alliance-Logo",
	Horde = "Interface\\Timer\\Horde-Logo",
}

--[[ skin ]]-------------------------------------------------------------------

local function setBorderColor(tooltip, r, g, b)
	local outline = tooltip.LolzenOutline
	if cfg["tip_outline"] and outline then
		outline:SetColor(r, g, b)
	elseif tooltip.SetBackdropBorderColor then
		tooltip:SetBackdropBorderColor(r, g, b)
	end
end

local function resetBorder(tooltip)
	if not skinned[tooltip] then return end
	tooltip:SetBackdropColor(0, 0, 0, 1)
	if cfg["tip_outline"] and tooltip.LolzenOutline then
		tooltip.LolzenOutline:ResetColor()
	else
		tooltip:SetBackdropBorderColor(1, 1, 1)
	end
end

local function applySkin(tooltip)
	if not skinned[tooltip] then
		skinned[tooltip] = true
		if not tooltip.SetBackdrop then
			Mixin(tooltip, BackdropTemplateMixin)
			tooltip:HookScript("OnSizeChanged", tooltip.OnBackdropSizeChanged)
		end
		hooksecurefunc(tooltip, "SetOwner", resetBorder)
	end

	local useOutline = cfg["tip_outline"]
	tooltip:SetBackdrop({
		bgFile = "Interface\\Buttons\\WHITE8x8",
		edgeFile = not useOutline and LSM:Fetch("border", cfg["tip_border"]) or nil,
		tileEdge = true,
		edgeSize = 16,
		insets = {left = 3, right = 3, top = 3, bottom = 3},
	})
	if useOutline then
		ns.Outline.Create(tooltip, {size = 18, padding = 1})
	end
	if tooltip.LolzenOutline then
		tooltip.LolzenOutline:SetShown(useOutline)
	end
	if tooltip.NineSlice then
		tooltip.NineSlice:SetAlpha(0)
	end
	resetBorder(tooltip)
end

local function skinAll()
	for _, name in ipairs({"GameTooltip", "ItemRefTooltip", "ShoppingTooltip1", "ShoppingTooltip2", "ItemRefShoppingTooltip1", "ItemRefShoppingTooltip2", "EmbeddedItemTooltip"}) do
		local tooltip = _G[name]
		if tooltip then
			applySkin(tooltip)
		end
	end
	GameTooltipStatusBar:SetStatusBarTexture(LSM:Fetch("statusbar", cfg["tip_healthbar_texture"]))
end

--[[ units ]]------------------------------------------------------------------

local specIcons = {}
local function buildSpecIcons()
	for classID = 1, GetNumClasses() do
		for specIndex = 1, GetNumSpecializationsForClassID(classID) do
			local _, name, _, icon = GetSpecializationInfoForClassID(classID, specIndex)
			if name and icon then
				specIcons[name] = icon
			end
		end
	end
end

local function line(i)
	return _G["GameTooltipTextLeft"..i]
end

-- the text of a tooltip line, nil if it isn't accessible (12.0 secret values)
local function lineText(i)
	local fontString = line(i)
	local text = fontString and fontString:GetText()
	if text == nil or ns.IsSecret(text) then return end
	return text
end

local function colorHex(r, g, b, text)
	return format("|cff%02x%02x%02x%s|r", r * 255, g * 255, b * 255, text)
end

local function classColor(unit)
	local _, class = UnitClass(unit)
	local color = class and RAID_CLASS_COLORS[class]
	if color then
		return color.r, color.g, color.b
	end
	return 0.5, 0.5, 0.5
end

local function reactionColor(unit)
	local reaction = UnitReaction(unit, "player")
	if not reaction then return 0.5, 0.5, 0.5 end
	if ns.IsModuleEnabled("miscellaneous") and LolzenUIcfg.miscellaneous["misc_alternative_faction_colors"] then
		local color = LolzenUIcfg.miscellaneous["misc_faction_colors"][reaction]
		if color then
			return color[1], color[2], color[3]
		end
	end
	local color = FACTION_BAR_COLORS[reaction]
	if color then
		return color.r, color.g, color.b
	end
	return 0.5, 0.5, 0.5
end

local function unitColor(unit)
	if UnitIsPlayer(unit) then
		return classColor(unit)
	end
	return reactionColor(unit)
end

local function coloredLevel(unit)
	local level = UnitLevel(unit)
	if level == -1 then
		return "|cffff0000??|r"
	end
	local color = GetQuestDifficultyColor(level)
	return colorHex(color.r, color.g, color.b, level)
end

local function statusFlag(unit)
	local key
	if UnitIsAFK(unit) then
		key = "tip_statusflag_afk"
	elseif UnitIsDND(unit) then
		key = "tip_statusflag_dnd"
	elseif not UnitIsConnected(unit) then
		key = "tip_statusflag_off"
	else
		return ""
	end
	local r, g, b = ns.RGB(cfg[key.."_color"])
	return colorHex(r, g, b, cfg[key]).." "
end

local function pvpFlag(unit)
	if not UnitIsPVP(unit) then return "" end
	local _, instanceType = IsInInstance()
	if instanceType == "pvp" or instanceType == "arena" or GetZonePVPInfo() == "combat" then
		return ""
	end
	return "|cff00ff00(PvP)|r "
end

local function updateTarget(unit)
	local right = _G["GameTooltipTextRight1"]
	local target = unit.."target"
	if cfg["tip_show_target"] and UnitExists(target) then
		local text
		if UnitIsUnit(target, "player") then
			text = "|cffffffff[YOU]|r"
		else
			local name = UnitName(target)
			if ns.IsSecret(name) then
				text = name
			else
				local r, g, b = unitColor(target)
				text = colorHex(r, g, b, name)
			end
		end
		right:SetText("|cffffffff>>|r "..text)
		right:Show()
	else
		right:SetText("")
		right:Hide()
	end
	GameTooltip:AppendText("")
end

local function addSpecIcon(unit)
	local race = UnitRace(unit)
	for i = 2, GameTooltip:NumLines() do
		local text = lineText(i)
		if text and not text:find("|T", 1, true) and not (race and text:find(race, 1, true)) then
			for name, icon in pairs(specIcons) do
				if text:find(name, 1, true) then
					line(i):SetFormattedText("|T%s:16:16:0:0|t %s", icon, text)
					return
				end
			end
		end
	end
end

local function modifyUnit(tooltip, unit)
	-- the tooltip can switch from one unit to another without being hidden
	raidIcon:SetTexture(nil)
	factionBG:SetTexture(nil)

	local name = UnitName(unit)
	if ns.IsSecret(name) then return end
	local isPlayer = UnitIsPlayer(unit)
	local r, g, b = unitColor(unit)
	setBorderColor(tooltip, r, g, b)

	if isPlayer then
		line(1):SetText(pvpFlag(unit)..statusFlag(unit)..colorHex(r, g, b, name))

		-- guild name
		local guild = GetGuildInfo(unit)
		if guild and (cfg["tip_use_guild_color_globally"] or UnitIsInMyGuild(unit)) then
			line(2):SetTextColor(ns.RGB(cfg["tip_own_guild_color"]))
		end
	else
		line(1):SetText(pvpFlag(unit)..colorHex(r, g, b, name))
	end

	-- level line
	for i = 2, GameTooltip:NumLines() do
		local text = lineText(i)
		if text and text:find(LEVEL, 1, true) == 1 then
			if isPlayer then
				line(i):SetText(("%s %s %s"):format(coloredLevel(unit), UnitRace(unit) or "", UnitClass(unit) or ""))
			else
				line(i):SetText(("%s%s %s"):format(coloredLevel(unit), MOB_TYPE[UnitClassification(unit)] or "", UnitCreatureType(unit) or ""))
			end
		elseif text == PVP_ENABLED then
			line(i):SetText("")
		end
	end

	if isPlayer and cfg["tip_display_talents"] then
		addSpecIcon(unit)
	end

	if cfg["tip_show_raidmark"] then
		local index = GetRaidTargetIndex(unit)
		if index and not ns.IsSecret(index) then
			raidIcon:SetTexture("Interface\\TargetingFrame\\UI-RaidTargetingIcon_"..index)
		end
	end
	if cfg["tip_show_factionicons"] then
		local faction = UnitFactionGroup(unit)
		factionBG:SetTexture(faction and FACTION_ICONS[faction])
	end

	updateTarget(unit)
end

local function onUnitTooltip(tooltip)
	if tooltip ~= GameTooltip then return end
	local _, unit = tooltip:GetUnit()
	if not unit or ns.IsSecret(unit) then return end
	-- restricted (secret) unit information raises errors; keep the default tooltip in that case
	pcall(modifyUnit, tooltip, unit)
	targetWatcher.unit = unit
	targetWatcher:RegisterEvent("UNIT_TARGET")
end

--[[ items & spells ]]---------------------------------------------------------

local function setTitleIcon(tooltip, icon)
	local title = _G[tooltip:GetName().."TextLeft1"]
	local text = title and title:GetText()
	if not text or ns.IsSecret(text) or text:find("|T", 1, true) then return end
	title:SetFormattedText("|T%s:16:16:0:0|t %s", icon, text)
end

local function addID(tooltip, label, id)
	if not cfg["tip_show_ids"] or not id or ns.IsSecret(id) then return end
	tooltip:AddLine(("|cff888888%s:|r |cffffffff%d|r"):format(label, id))
	tooltip:Show()
end

local function onItemTooltip(tooltip, data)
	if not data or not data.id or not tooltip.GetName then return end
	local quality = C_Item.GetItemQualityByID(data.id)
	if quality then
		setBorderColor(tooltip, C_Item.GetItemQualityColor(quality))
	end
	if cfg["tip_show_icons"] then
		local icon = C_Item.GetItemIconByID(data.id)
		if icon then
			setTitleIcon(tooltip, icon)
		end
	end
	addID(tooltip, L["Item ID"], data.id)
end

local function onSpellTooltip(tooltip, data)
	if not data or not data.id or not tooltip.GetName then return end
	if cfg["tip_show_icons"] then
		local icon = C_Spell.GetSpellTexture(data.id)
		if icon then
			setTitleIcon(tooltip, icon)
		end
	end
	addID(tooltip, L["Spell ID"], data.id)
end

--[[ init ]]-------------------------------------------------------------------

ns.setTTBorder = skinAll
ns.setTTHBTexture = skinAll

ns.OnInit("tooltip", function()
	cfg = LolzenUIcfg.tooltip
	buildSpecIcons()

	factionBG = GameTooltip:CreateTexture(nil, "BACKGROUND", nil, -8)
	factionBG:SetSize(64, 64)
	factionBG:SetPoint("RIGHT", GameTooltip, "TOPLEFT", 32, -4)

	raidIcon = GameTooltip:CreateTexture(nil, "OVERLAY")
	raidIcon:SetSize(18, 18)
	raidIcon:SetPoint("TOP", GameTooltip, "TOP", 0, 5)

	GameTooltipStatusBar:ClearAllPoints()
	GameTooltipStatusBar:SetPoint("BOTTOMLEFT", 5, 4)
	GameTooltipStatusBar:SetPoint("BOTTOMRIGHT", -5, 4)
	GameTooltipStatusBar:SetStatusBarColor(0.3, 0.9, 0.3, 1)
	GameTooltipStatusBar:SetHeight(2)

	skinAll()
	if SharedTooltip_SetBackdropStyle then
		-- Blizzard re-applies its own style on some tooltips
		hooksecurefunc("SharedTooltip_SetBackdropStyle", function(tooltip)
			if skinned[tooltip] and tooltip.NineSlice then
				tooltip.NineSlice:SetAlpha(0)
			end
		end)
	end

	-- update the target of the unit while the tooltip is shown
	targetWatcher = CreateFrame("Frame")
	targetWatcher:SetScript("OnEvent", function(self, _, unit)
		if unit == self.unit and GameTooltip:IsShown() then
			pcall(updateTarget, unit)
		end
	end)

	GameTooltip:HookScript("OnHide", function()
		raidIcon:SetTexture(nil)
		factionBG:SetTexture(nil)
		targetWatcher:UnregisterEvent("UNIT_TARGET")
	end)

	hooksecurefunc("GameTooltip_SetDefaultAnchor", function(tooltip, parent)
		if cfg["tip_anchor_cursor"] and tooltip == GameTooltip then
			tooltip:SetOwner(parent, "ANCHOR_CURSOR")
		end
	end)

	TooltipDataProcessor.AddTooltipPostCall(Enum.TooltipDataType.Unit, onUnitTooltip)
	TooltipDataProcessor.AddTooltipPostCall(Enum.TooltipDataType.Item, onItemTooltip)
	TooltipDataProcessor.AddTooltipPostCall(Enum.TooltipDataType.Spell, onSpellTooltip)

	-- look: attached to the "HUD Tooltip" dialog in the Edit Mode
	local look = ns.Options.New("tooltip_look", function() return LolzenUIcfg.tooltip end, ns.defaults.tooltip, skinAll)
	look:Header("LolzenUI")
	look:Toggle("tip_anchor_cursor", L["Anchor at the cursor"])
	look:Toggle("tip_outline", L["Use outline"])
	look:Media("tip_border", L["border"], "border"):SetDisabled(function() return cfg["tip_outline"] end)
	look:Media("tip_healthbar_texture", L["tt_healthbar_header"], "statusbar")
	if not ns.EditMode:AddSystemSettings("HudTooltip", look) then
		ns.SettingsPanel:AddCategory("tooltip_look", look)
	end

	-- content: settings panel
	local options = ns.Options.New("tooltip", function() return LolzenUIcfg.tooltip end, ns.defaults.tooltip)
	options:Header(L["show"])
	options:Toggle("tip_show_factionicons", L["tt_show_factionicons"])
	options:Toggle("tip_show_raidmark", L["show_raidmarks"])
	options:Toggle("tip_display_talents", L["tt_show_talents"])
	options:Toggle("tip_show_target", L["Show the target of the unit"])
	options:Toggle("tip_show_icons", L["Show item and spell icons"])
	options:Toggle("tip_show_ids", L["Show item and spell IDs"])
	options:Header(L["tt_flags_header"])
	options:Text("tip_statusflag_afk", L["afk_flag"])
	options:Color("tip_statusflag_afk_color", L["afk_flag"])
	options:Text("tip_statusflag_dnd", L["dnd_flag"])
	options:Color("tip_statusflag_dnd_color", L["dnd_flag"])
	options:Text("tip_statusflag_off", L["tt_offline_flag"])
	options:Color("tip_statusflag_off_color", L["tt_offline_flag"])
	options:Header(L["tt_player_guild_header"])
	options:Color("tip_own_guild_color", L["color"])
	options:Toggle("tip_use_guild_color_globally", L["tt_use_guild_color_globally"])
	ns.SettingsPanel:AddCategory("tooltip", options, true)
end)
