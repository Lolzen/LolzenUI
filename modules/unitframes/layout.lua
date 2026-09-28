--// unitframes: layout //--
-- Spawns the frames, places them in Edit Mode holders and builds their options.

local _, ns = ...
local L = ns.L
local oUF = ns.oUF
local UF = ns.UF
local EM = ns.EditMode

ns.RegisterModule("unitframes", L["desc_unitframes"], true)

local UNITS = {"player", "target", "targettarget", "focus", "pet", "boss", "arena", "party", "raid"}
local NUM_BOSS, NUM_ARENA = 5, 3
local RAID_ROW_SPACING = 5

local NAMES = {
	player = "sub_panel_unitframes_player",
	target = "sub_panel_unitframes_target",
	targettarget = "sub_panel_unitframes_targettarget",
	focus = "sub_panel_unitframes_focus",
	pet = "sub_panel_unitframes_pet",
	boss = "sub_panel_unitframes_boss",
	arena = "sub_panel_unitframes_arena",
	party = "sub_panel_unitframes_party",
	raid = "sub_panel_unitframes_raid",
}

-- frame names are kept from older versions (they were used by oUF_MovableFrames)
local FRAME_NAMES = {
	player = "oUF_LolzenPlayer",
	target = "oUF_LolzenTarget",
	targettarget = "oUF_LolzenTargetTarget",
	focus = "oUF_LolzenFocus",
	pet = "oUF_LolzenPet",
	boss = "oUF_LolzenBoss",
	arena = "oUF_LolzenArena",
	party = "oUF_LolzenParty",
	raid = "oUF_LolzenRaid",
}

local frames = {}
local holders = {}
local headers = {}

local function db(key)
	return LolzenUIcfg.unitframes[key]
end

local function value(key, name)
	return db(key)["uf_"..key.."_"..name]
end

--[[ holders ]]----------------------------------------------------------------

local function holderSize(key)
	local width, height = value(key, "width"), value(key, "height")
	local spacing = value(key, "spacing")
	if key == "boss" then
		return width, NUM_BOSS * height + (NUM_BOSS - 1) * spacing
	elseif key == "arena" then
		return width, NUM_ARENA * height + (NUM_ARENA - 1) * spacing
	elseif key == "party" then
		return 5 * width + 4 * spacing, height
	elseif key == "raid" then
		return 8 * width + 7 * spacing, 5 * height + 4 * RAID_ROW_SPACING
	end
	return width, height
end

-- places the (secure) frames inside their holder; only possible out of combat
local function layoutFrames(key)
	local holder = holders[key]
	holder:SetSize(holderSize(key))
	local list = frames[key]
	if key == "boss" or key == "arena" then
		local step = value(key, "height") + value(key, "spacing")
		for i, frame in ipairs(list) do
			frame:ClearAllPoints()
			if key == "boss" then
				-- boss frames grow upwards
				frame:SetPoint("BOTTOM", holder, "BOTTOM", 0, (i - 1) * step)
			else
				frame:SetPoint("TOP", holder, "TOP", 0, -(i - 1) * step)
			end
		end
	elseif headers[key] then
		local header = headers[key]
		header:SetAttribute("oUF-initialConfigFunction", ("self:SetWidth(%d); self:SetHeight(%d)"):format(value(key, "width"), value(key, "height")))
		if key == "party" then
			header:SetAttribute("xOffset", value(key, "spacing"))
		else
			header:SetAttribute("columnSpacing", value(key, "spacing"))
		end
	elseif list and list[1] then
		list[1]:ClearAllPoints()
		list[1]:SetPoint("CENTER", holder)
	end
end

--[[ refresh ]]----------------------------------------------------------------

local function refresh(key)
	for _, frame in ipairs(frames[key] or {}) do
		UF.Apply(frame)
		if frame.unit then
			frame:UpdateAllElements("RefreshUnit")
		end
	end
	ns.RunOutOfCombat(function() layoutFrames(key) end)
end

local function refreshAll()
	UF.ApplyColors()
	for _, key in ipairs(UNITS) do
		if holders[key] then
			refresh(key)
		end
	end
	UF.UpdateAllFades()
end
UF.RefreshAll = refreshAll

-- compatibility with the old option callbacks
ns.SetUFTagUpdate = refreshAll
ns.SetUFTexture = refreshAll
ns.SetUFBorder = refreshAll

--[[ Edit Mode preview ]]------------------------------------------------------

-- frames of units which usually don't exist show the player while the Edit Mode is open
local PREVIEW = {target = true, targettarget = true, focus = true, pet = true, boss = true, arena = true}
local previewActive = false

local function startPreview()
	if previewActive or InCombatLockdown() then return end
	previewActive = true
	for key in pairs(PREVIEW) do
		for _, frame in ipairs(frames[key] or {}) do
			frame.lolzenUnit = frame.lolzenUnit or frame:GetAttribute("unit")
			UnregisterUnitWatch(frame)
			frame:SetAttribute("unit", "player")
			frame:Show()
		end
	end
	UF.UpdateAllFades()
end

local function stopPreview()
	if not previewActive then return end
	previewActive = false
	for key in pairs(PREVIEW) do
		for _, frame in ipairs(frames[key] or {}) do
			if frame.lolzenUnit then
				frame:SetAttribute("unit", frame.lolzenUnit)
				RegisterUnitWatch(frame)
			end
		end
	end
	UF.UpdateAllFades()
end

--[[ style & spawn ]]----------------------------------------------------------

local function createStyle(key)
	return function(frame, unit)
		frame.unitKey = key
		frame.lolzenHeaderChild = key == "party" or key == "raid"
		frames[key] = frames[key] or {}
		table.insert(frames[key], frame)

		UF.Build(frame, unit)
		if UF.features[key].standaloneCastbar then
			frame.castbarHolder = holders[key.."_castbar"]
		end
		UF.Apply(frame, true)
	end
end

local function spawnSingle(self, key, unit, name)
	self:SetActiveStyle("Lolzen - "..key)
	return self:Spawn(unit, name)
end

local function spawnHeaders(self)
	local party = db("party")
	if party["uf_party_enabled"] then
		self:SetActiveStyle("Lolzen - party")
		local header = self:SpawnHeader(FRAME_NAMES.party, nil,
			"showParty", true,
			"showPlayer", true,
			"point", "LEFT",
			"xOffset", party["uf_party_spacing"],
			"yOffset", 0,
			"oUF-initialConfigFunction", ("self:SetWidth(%d); self:SetHeight(%d)"):format(party["uf_party_width"], party["uf_party_height"])
		)
		header:SetVisibility("party")
		header:SetPoint("BOTTOM", holders.party, "BOTTOM")
		headers.party = header
	end

	local raid = db("raid")
	if raid["uf_raid_enabled"] then
		self:SetActiveStyle("Lolzen - raid")
		local header = self:SpawnHeader(FRAME_NAMES.raid, nil,
			"showRaid", true,
			"showPlayer", true,
			"point", "TOP",
			"yOffset", -RAID_ROW_SPACING,
			"groupFilter", "1,2,3,4,5,6,7,8",
			"groupingOrder", "1,2,3,4,5,6,7,8",
			"groupBy", "GROUP",
			"maxColumns", 8,
			"unitsPerColumn", 5,
			"columnSpacing", raid["uf_raid_spacing"],
			"columnAnchorPoint", "LEFT",
			"oUF-initialConfigFunction", ("self:SetWidth(%d); self:SetHeight(%d)"):format(raid["uf_raid_width"], raid["uf_raid_height"])
		)
		header:SetVisibility("raid")
		header:SetPoint("TOPLEFT", holders.raid, "TOPLEFT")
		headers.raid = header

		-- hide the default raid frames
		for _, frame in ipairs({CompactRaidFrameManager, CompactRaidFrameContainer}) do
			pcall(RegisterStateDriver, frame, "visibility", "hide")
		end
	end
end

local function spawn(self)
	for _, key in ipairs({"player", "target", "targettarget", "focus", "pet"}) do
		frames[key] = frames[key] or {}
		spawnSingle(self, key, key, FRAME_NAMES[key])
	end
	for i = 1, NUM_BOSS do
		spawnSingle(self, "boss", "boss"..i, FRAME_NAMES.boss..i)
	end
	for i = 1, NUM_ARENA do
		spawnSingle(self, "arena", "arena"..i, FRAME_NAMES.arena..i)
	end
	spawnHeaders(self)

	for _, key in ipairs(UNITS) do
		frames[key] = frames[key] or {}
		layoutFrames(key)
		for _, frame in ipairs(frames[key]) do
			UF.ApplyIndicators(frame)
		end
	end
end

--[[ options ]]----------------------------------------------------------------

local ANCHOR_VALUES = {"hp", "self"}

local function buildUnitOptions(key)
	local features = UF.features[key]
	local prefix = "uf_"..key.."_"
	local cfg = db(key)
	local options = ns.Options.New("uf_"..key, function() return db(key) end, ns.defaults.unitframes[key], function() refresh(key) end)
	local function k(name) return prefix..name end
	local notOwnFont = function() return not cfg[k("use_own_hp_font_settings")] end

	options:Header(L["Size"])
	options:Range(k("width"), L["width"], 20, 600, 1)
	options:Range(k("height"), L["height"], 4, 100, 1)
	if cfg[k("spacing")] then
		options:Range(k("spacing"), L["spacing"], 0, 100, 1)
	end
	if key == "party" or key == "raid" then
		options:Toggle(k("enabled"), L[key == "party" and "sub_panel_unitframes_party_use_LolzenUI" or "sub_panel_unitframes_raid_use_LolzenUI"], ns.AskReload)
	end

	options:Header(L["uf_healthpoints"])
	options:Toggle(k("use_own_hp_font_settings"), L["uf_healthpoints_overwrite_global_settings"])
	options:Font(k("hp_font")):SetDisabled(notOwnFont)
	options:Range(k("hp_font_size"), L["size"], 4, 40, 1):SetDisabled(notOwnFont)
	options:Flag(k("hp_font_flag")):SetDisabled(notOwnFont)
	options:Anchor(k("hp_anchor")):SetDisabled(notOwnFont)
	options:Range(k("hp_posx"), L["PosX"], -100, 100, 1):SetDisabled(notOwnFont)
	options:Range(k("hp_posy"), L["PosY"], -100, 100, 1):SetDisabled(notOwnFont)

	if features.power then
		options:Header(L["uf_powerpoints"])
		if key == "boss" then
			options:Toggle(k("show_power"), L["sub_panel_unitframes_boss_show_power"])
		end
		options:FontGroup(k("pp_font"))
		options:Select(k("pp_parent"), L["parent"], ns.Options.ListValues(ANCHOR_VALUES, {hp = L["uf_healthpoints"], self = L["frame"]}))
		options:Anchor(k("pp_anchor"), L["anchor"])
		options:Anchor(k("pp_anchor2"), L["parent"])
		options:Range(k("pp_posx"), L["PosX"], -100, 100, 1)
		options:Range(k("pp_posy"), L["PosY"], -100, 100, 1)
	end

	if features.auras then
		options:Header(L["auras"])
		options:Select(k("aura_show_type"), L["show"], ns.Options.ListValues({"Buffs", "Debuffs", "Both", "None"}))
		options:Range(k("aura_maxnum"), L["show_max_0_to_40"], 0, 40, 1)
		options:Range(k("aura_size"), L["size"], 8, 64, 1)
		options:Range(k("aura_spacing"), L["spacing"], 0, 20, 1)
		options:Anchor(k("aura_anchor1"), L["anchor"])
		options:Anchor(k("aura_anchor2"), L["parent"])
		options:Range(k("aura_posx"), L["PosX"], -200, 200, 1)
		options:Range(k("aura_posy"), L["PosY"], -200, 200, 1)
		options:Select(k("aura_growth_x"), L["growth_x"], ns.Options.ListValues({"LEFT", "RIGHT"}))
		options:Select(k("aura_growth_y"), L["growth_y"], ns.Options.ListValues({"UP", "DOWN"}))
		options:Toggle(k("aura_show_only_player"), L["show_only_player_auras"])
		options:Toggle(k("aura_desature_nonplayer_auras"), L["desature_auras_not_by_player"])
	end

	if features.castbar then
		local notStandalone = function() return not cfg[k("cb_standalone")] end
		options:Header(L["uf_castbar"])
		if features.standaloneCastbar then
			options:Toggle(k("cb_standalone"), L["uf_use_standalone_castbar"])
			options:Range(k("cb_width"), L["width"], 20, 600, 1):SetDisabled(notStandalone)
			options:Range(k("cb_height"), L["height"], 4, 100, 1):SetDisabled(notStandalone)
		end
		options:Color(k("cb_color"), L["color"])
		options:Range(k("cb_alpha"), L["alpha"], 0, 1, 0.05)
		options:Toggle(k("cb_icon_cut"), L["uf_trim_castbar_icon"])
		options:Range(k("cb_icon_size"), L["icon"].." "..L["size"], 4, 100, 1)
		options:Anchor(k("cb_icon_anchor1"), L["icon"].." "..L["anchor"])
		options:Anchor(k("cb_icon_anchor2"), L["icon"].." "..L["parent"])
		options:Range(k("cb_icon_posx"), L["icon"].." "..L["PosX"], -200, 200, 1)
		options:Range(k("cb_icon_posy"), L["icon"].." "..L["PosY"], -200, 200, 1)
		options:Header(L["uf_time_and_spellname_header"])
		options:FontGroup(k("cb_font"))
		options:Color(k("cb_font_color"), L["color"])
		options:Anchor(k("cb_time_anchor1"), L["time"].." "..L["anchor"])
		options:Anchor(k("cb_time_anchor2"), L["time"].." "..L["parent"])
		options:Range(k("cb_time_posx"), L["time"].." "..L["PosX"], -200, 200, 1)
		options:Range(k("cb_time_posy"), L["time"].." "..L["PosY"], -200, 200, 1)
		options:Anchor(k("cb_text_anchor1"), L["text"].." "..L["anchor"])
		options:Anchor(k("cb_text_anchor2"), L["text"].." "..L["parent"])
		options:Range(k("cb_text_posx"), L["text"].." "..L["PosX"], -200, 200, 1)
		options:Range(k("cb_text_posy"), L["text"].." "..L["PosY"], -200, 200, 1)
	end

	if features.classpower then
		options:Header(L["sub_panel_unitframes_player_classpower_and_runes_header"])
		options:Media(k("classpower_border"), L["border"], "border")
		options:Range(k("classpower_spacing"), L["spacing"], 0, 20, 1)
		options:Anchor(k("classpower_anchor1"), L["anchor"])
		options:Anchor(k("classpower_anchor2"), L["parent"])
		options:Range(k("classpower_posx"), L["PosX"], -100, 100, 1)
		options:Range(k("classpower_posy"), L["PosY"], -100, 100, 1)
	end

	if features.resting then
		options:Header(L["uf_restingindicator_header"])
		options:Toggle(k("show_restingindicator"), L["uf_show_restingindicator"])
		options:Range(k("resting_size"), L["size"], 4, 64, 1)
		options:PointGroup(k("resting_anchor"), k("resting_posx"), k("resting_posy"), nil, 50)
	end

	if features.role then
		options:Header(L["uf_roleindicator_header"])
		options:Toggle(k("showroleindicator"), L["uf_show_roleindicator"])
		options:Range(k("ri_size"), L["size"], 4, 64, 1)
		options:PointGroup(k("ri_anchor"), k("ri_posx"), k("ri_posy"), nil, 50)
	end

	if features.readycheck then
		options:Header(L["uf_readycheckindicator_header"])
		options:Range(k("rc_size"), L["size"], 4, 64, 1)
		options:PointGroup(k("rc_anchor"), k("rc_posx"), k("rc_posy"), nil, 50)
	end

	return options
end

local POWER_NAMES = {
	[0] = "mana", [1] = "rage", [2] = "focus", [3] = "energy", [4] = "combopoints", [5] = "runes",
	[6] = "runicpower", [7] = "soulshards", [8] = "lunarpower", [9] = "holypower", [11] = "maelstrom",
	[12] = "chi", [13] = "insanity", [16] = "arcanecharges", [17] = "fury", [18] = "pain",
}

local function buildGeneralOptions()
	local cfg = db("general")
	local options = ns.Options.New("uf_general", function() return db("general") end, ns.defaults.unitframes.general, refreshAll)

	options:Header(L["uf_healthpoints"])
	options:Toggle("uf_use_sivalue", L["uf_general_use_short_values"])
	options:Toggle("uf_use_dot_format", L["uf_general_use dot_divider"])
	options:Toggle("uf_use_hp_percent", L["uf_general_use_hp_percent"])
	options:Toggle("uf_use_val_and_perc", L["uf_general_use_both_value_and_percent"])
	options:Toggle("uf_perc_first", L["uf_general_switch_value_and_percent_order"])
	options:Text("uf_val_perc_divider", L["uf_general_hpdivider_text"])
	options:Header(L["uf_general_hp_font_options"])
	options:FontGroup("uf_general_hp_font")
	options:PointGroup("uf_general_hp_anchor", "uf_general_hp_posx", "uf_general_hp_posy")

	options:Header(L["texture"])
	options:Media("uf_statusbar_texture", L["texture"], "statusbar")
	options:Toggle("uf_outline", L["Use outline"])
	options:Toggle("uf_outline_threat", L["Color the outline by threat"])
	options:Media("uf_border", L["border"], "border"):SetDisabled(function() return cfg["uf_outline"] end)

	options:Header(L["uf_general_combatfade"])
	options:Toggle("uf_fade_combat", L["uf_general_combatfade"])
	options:Range("uf_fade_combat_incombat", L["uf_general_combatfade_in_combat_alpha"], 0, 1, 0.05)
	options:Range("uf_fade_combat_outofcombat", L["uf_general_combatfade_out_of_combat_alpha"], 0, 1, 0.05)
	options:Toggle("uf_fade_outofreach", L["uf_general_fadout_out_of_reach"])
	options:Range("uf_fade_outofreach_alpha", L["uf_general_fadout_out_of_reach_alpha"], 0, 1, 0.05)

	options:Header(L["raidmarks"])
	options:Range("uf_ri_size", L["size"], 4, 64, 1)
	options:PointGroup("uf_ri_anchor", "uf_ri_posx", "uf_ri_posy", nil, 50)
	options:Header(L["uf_general_leadindicator"])
	options:Range("uf_lead_size", L["size"], 4, 64, 1)
	options:PointGroup("uf_lead_anchor", "uf_lead_posx", "uf_lead_posy", nil, 50)

	options:Header(L["sub_panel_unitframes_powercolors"])
	local colors = LolzenUIcfg.unitframes.powercolors
	for index, name in pairs(POWER_NAMES) do
		local opt = options:Add({kind = "color", name = L["sub_panel_unitframes_powercolors_"..name], key = "powercolor"..index})
		opt.Get = function() return colors[index] end
		opt.Set = function(_, color)
			colors[index] = color
			refreshAll()
		end
	end

	ns.SettingsPanel:AddCategory("unitframes", options, true)
end

--[[ init ]]-------------------------------------------------------------------

ns.OnInit("unitframes", function()
	UF.ApplyColors()

	for _, key in ipairs(UNITS) do
		oUF:RegisterStyle("Lolzen - "..key, createStyle(key))
		local holder = EM.CreateHolder(FRAME_NAMES[key].."Holder", holderSize(key))
		holders[key] = holder

		local name = "LolzenUI: "..L[NAMES[key]]
		EM:AddFrame(holder, {
			name = name,
			pos = {
				db = function() return db(key) end,
				point = "uf_"..key.."_anchor",
				x = "uf_"..key.."_posx",
				y = "uf_"..key.."_posy",
			},
			defaults = ns.defaults.unitframes[key],
			options = buildUnitOptions(key),
			category = "unitframes",
		})

		if UF.features[key].standaloneCastbar then
			local castbarHolder = EM.CreateHolder(FRAME_NAMES[key].."CastbarHolder", value(key, "cb_width"), value(key, "cb_height"))
			holders[key.."_castbar"] = castbarHolder
			EM:AddFrame(castbarHolder, {
				name = name..": "..L["uf_castbar"],
				pos = {
					db = function() return db(key) end,
					point = "uf_"..key.."_cb_anchor1",
					rel = "uf_"..key.."_cb_anchor2",
					x = "uf_"..key.."_cb_posx",
					y = "uf_"..key.."_cb_posy",
				},
				defaults = ns.defaults.unitframes[key],
			})
			castbarHolder:SetShown(value(key, "cb_standalone"))
		end
	end

	buildGeneralOptions()

	EM:RegisterCallback("enter", startPreview)
	EM:RegisterCallback("exit", function()
		ns.RunOutOfCombat(stopPreview)
	end)

	oUF:Factory(spawn)
end)
