--// nameplates // --

local _, ns = ...
local L = ns.L
local LSM = LibStub("LibSharedMedia-3.0")
local oUF = ns.oUF

ns.RegisterModule("nameplates", L["desc_nameplates"], true)

local general, castbar
local plates = {}

local AURA_WIDGETS = {Buffs = "Buffs", Debuffs = "Debuffs", Both = "Auras"}

--[[ callbacks ]]--------------------------------------------------------------

local function updateTargetIndicator(frame)
	local isTarget = frame.unit and UnitIsUnit(frame.unit, "target")
	if ns.IsSecret(isTarget) then
		isTarget = false
	end
	frame.TargetIndicator:SetShown(general["np_targetindicator"] and isTarget == true)
end

local function updateThreat(frame, _, unit)
	if unit ~= frame.unit then return end
	local glow = frame.Glow
	if not general["np_threatindicator"] then
		return glow:Hide()
	end
	local status = UnitThreatSituation("player", unit)
	if status == nil or ns.IsSecret(status) or status == 0 then
		return glow:Hide()
	end
	glow:SetBackdropBorderColor(GetThreatStatusColor(status))
	glow:Show()
end

local function postCastStart(element)
	element.Icon:SetDesaturated(element.notInterruptible == true)
end

local function postCreateButton(_, button)
	button.Icon:SetTexCoord(.07, .93, .07, .93)
	button.Count:ClearAllPoints()
	button.Count:SetPoint("BOTTOMRIGHT", 2, -2)
	ns.SetFont(button.Count, general["np_lvlname_font"], 7, general["np_lvlname_font_flag"])
	button.Cooldown:SetHideCountdownNumbers(true)
	ns.Outline.Create(button, {size = 8, padding = 1, color = {0, 0, 0}})
end

local function postUpdateButton(element, button, _, data)
	local desaturate = general["np_aura_desature_nonplayer_auras"] and not ns.IsSecret(data.isPlayerAura) and not data.isPlayerAura
	button.Icon:SetDesaturated(desaturate == true)
end

--[[ layout ]]-----------------------------------------------------------------

-- applies every setting; also used for live updates from the options
local function refresh(frame, initial)
	local statusbar = LSM:Fetch("statusbar", general["np_texture"])

	local health = frame.Health
	health:SetSize(general["np_width"], general["np_height"])
	health:SetStatusBarTexture(statusbar)
	health.bg:SetTexture(statusbar)

	ns.SetFont(frame.Level, general["np_lvlname_font"], general["np_lvlname_font_size"], general["np_lvlname_font_flag"])
	frame.Level:ClearAllPoints()
	frame.Level:SetPoint(general["np_lvlname_anchor"], health, general["np_lvlname_posx"], general["np_lvlname_posy"])

	local mark = frame.RaidTargetIndicator
	mark:SetSize(general["np_raidmark_size"], general["np_raidmark_size"])
	mark:ClearAllPoints()
	mark:SetPoint(general["np_raidmark_anchor"], health, general["np_raidmark_posx"], general["np_raidmark_posy"])
	mark:SetAlpha(general["np_raidtargetindicator"] and 1 or 0)

	frame.TargetIndicator:SetWidth(general["np_width"])

	-- castbar
	local cb = frame.Castbar
	cb:SetStatusBarTexture(LSM:Fetch("statusbar", castbar["np_cb_texture"]))
	cb:SetSize(castbar["np_cb_width"], castbar["np_cb_height"])
	cb:ClearAllPoints()
	cb:SetPoint(castbar["np_cb_anchor"], health, castbar["np_cb_anchor2"], castbar["np_cb_posx"], castbar["np_cb_posy"])
	cb.Spark:SetSize(castbar["np_spark_width"], castbar["np_spark_height"])
	cb.Icon:SetSize(castbar["np_cbicon_size"], castbar["np_cbicon_size"])
	cb.Icon:ClearAllPoints()
	cb.Icon:SetPoint(castbar["np_cbicon_anchor"], health, castbar["np_cbicon_anchor2"], castbar["np_cbicon_posx"], castbar["np_cbicon_posy"])
	ns.SetFont(cb.Time, castbar["np_cbtime_font"], castbar["np_cbtime_font_size"], castbar["np_cbtime_font_flag"])
	cb.Time:ClearAllPoints()
	cb.Time:SetPoint(castbar["np_cbtime_anchor"], cb, castbar["np_cbtime_anchor2"], castbar["np_cbtime_posx"], castbar["np_cbtime_posy"])
	ns.SetFont(cb.Text, castbar["np_cbtext_font"], castbar["np_cbtext_font_size"], castbar["np_cbtext_font_flag"])
	cb.Text:ClearAllPoints()
	cb.Text:SetPoint(castbar["np_cbtext_anchor"], cb, castbar["np_cbtext_anchor2"], castbar["np_cbtext_posx"], castbar["np_cbtext_posy"])

	-- auras: only one of the widgets is active
	local activeWidget = AURA_WIDGETS[general["np_aura_show_type"]]
	if not initial then
		-- the aura element picks up its widgets when it's enabled
		frame:DisableElement("Auras")
	end
	for _, widget in pairs(AURA_WIDGETS) do
		local auras = frame["Lolzen"..widget]
		auras.size = general["np_aura_size"]
		auras.spacing = general["np_aura_spacing"]
		auras.growthX = general["np_aura_growth_x"]
		auras.growthY = general["np_aura_growth_y"]
		auras.initialAnchor = (general["np_aura_growth_y"] == "UP" and "BOTTOM" or "TOP")..(general["np_aura_growth_x"] == "RIGHT" and "LEFT" or "RIGHT")
		auras.onlyShowPlayer = general["np_aura_show_only_player"]
		auras.num = general["np_aura_maxnum"]
		auras.numTotal = general["np_aura_maxnum"]
		auras:SetSize(math.max(1, general["np_aura_maxnum"]) * (general["np_aura_size"] + general["np_aura_spacing"]), general["np_aura_size"])
		auras:ClearAllPoints()
		auras:SetPoint(general["np_aura_anchor1"], health, general["np_aura_anchor2"], general["np_aura_posx"], general["np_aura_posy"])
		frame[widget] = (widget == activeWidget) and auras or nil
		auras:SetShown(widget == activeWidget)
	end
	if activeWidget and not initial then
		frame:EnableElement("Auras")
	end

	updateTargetIndicator(frame)
end

local function createAuras(frame)
	local auras = CreateFrame("Frame", nil, frame)
	auras.PostCreateButton = postCreateButton
	auras.PostUpdateButton = postUpdateButton
	return auras
end

local function style(frame, unit)
	plates[frame] = true

	local health = CreateFrame("StatusBar", nil, frame)
	health:SetPoint("CENTER")
	health.colorTapping = true
	health.colorDisconnected = true
	health.colorClass = true
	health.colorReaction = true
	health.smoothing = Enum.StatusBarInterpolation and Enum.StatusBarInterpolation.Smooth
	health.bg = health:CreateTexture(nil, "BACKGROUND")
	health.bg:SetAllPoints()
	health.bg:SetVertexColor(0, 0, 0, 0.5)
	frame.Health = health

	local level = health:CreateFontString(nil, "OVERLAY")
	frame:Tag(level, "[difficulty][level][shortclassification] |cffffffff[name]|r")
	frame.Level = level

	local cb = CreateFrame("StatusBar", nil, health)
	cb:SetStatusBarColor(1, 1, 1, 1)
	cb.smoothing = health.smoothing
	cb.Spark = cb:CreateTexture(nil, "OVERLAY")
	cb.Spark:SetBlendMode("ADD")
	cb.Spark:SetPoint("CENTER", cb:GetStatusBarTexture(), "RIGHT")
	cb.Icon = cb:CreateTexture(nil, "BACKGROUND")
	cb.Icon:SetTexCoord(.07, .93, .07, .93)
	cb.Time = cb:CreateFontString(nil, "OVERLAY")
	cb.Time:SetTextColor(1, 1, 1)
	cb.Text = cb:CreateFontString(nil, "OVERLAY")
	cb.Text:SetTextColor(1, 1, 1)
	cb.Shield = cb:CreateTexture(nil, "OVERLAY")
	cb.Shield:SetSize(20, 20)
	cb.Shield:SetTexture("Interface\\AddOns\\LolzenUI\\media\\shield")
	cb.Shield:SetPoint("CENTER", cb.Icon)
	cb.PostCastStart = postCastStart
	cb.PostChannelStart = postCastStart
	frame.Castbar = cb

	frame.RaidTargetIndicator = health:CreateTexture(nil, "OVERLAY")

	local target = health:CreateTexture(nil, "OVERLAY")
	target:SetPoint("TOPLEFT", health, "BOTTOMLEFT", 0, -1)
	target:SetHeight(5)
	target:SetTexture("Interface\\AddOns\\LolzenUI\\media\\target-glow")
	target:SetVertexColor(48/255, 113/255, 191/255)
	target:Hide()
	frame.TargetIndicator = target
	frame:RegisterEvent("PLAYER_TARGET_CHANGED", updateTargetIndicator, true)

	local glow = CreateFrame("Frame", nil, frame, "BackdropTemplate")
	glow:SetBackdrop({edgeFile = "Interface\\AddOns\\LolzenUI\\media\\glow", edgeSize = 5})
	glow:SetPoint("TOPLEFT", health, -5, 5)
	glow:SetPoint("BOTTOMRIGHT", health, 5, -5)
	glow:Hide()
	frame.Glow = glow
	frame.ThreatIndicator = {
		IsObjectType = function() end,
		Override = updateThreat,
	}

	frame.LolzenBuffs = createAuras(frame)
	frame.LolzenDebuffs = createAuras(frame)
	frame.LolzenDebuffs.showDebuffType = true
	frame.LolzenAuras = createAuras(frame)
	frame.LolzenAuras.showDebuffType = true
	frame.LolzenAuras.gap = true

	refresh(frame, true)
end

local function refreshAll()
	SetCVar("nameplateSelectedScale", general["np_selected_scale"])
	for frame in pairs(plates) do
		refresh(frame)
		if frame.unit then
			frame:UpdateAllElements("RefreshUnit")
		end
	end
end

-- kept for compatibility with the old option callbacks
ns.setNPSize = refreshAll

--[[ options ]]----------------------------------------------------------------

local function buildOptions()
	local options = ns.Options.New("nameplates", function() return LolzenUIcfg.nameplates.general end, ns.defaults.nameplates.general, refreshAll)
	options:Header(L["np_nameplates_general_header"])
	options:Range("np_width", L["width"], 20, 300, 1)
	options:Range("np_height", L["height"], 1, 40, 1)
	options:Range("np_selected_scale", L["np_target_nameplate_scale"], 0.5, 3, 0.05)
	options:Media("np_texture", L["texture"], "statusbar")
	options:Toggle("np_targetindicator", L["np_show_targetindicator"])
	options:Toggle("np_threatindicator", L["np_show_threat_border"])
	options:Header(L["np_level_and_name_header"])
	options:FontGroup("np_lvlname_font")
	options:PointGroup("np_lvlname_anchor", "np_lvlname_posx", "np_lvlname_posy", nil, 50)
	options:Header(L["raidmarks"])
	options:Toggle("np_raidtargetindicator", L["show_raidmarks"])
	options:Range("np_raidmark_size", L["size"], 4, 64, 1)
	options:PointGroup("np_raidmark_anchor", "np_raidmark_posx", "np_raidmark_posy", nil, 50)
	options:Header(L["auras"])
	options:Select("np_aura_show_type", L["show"], ns.Options.ListValues({"Buffs", "Debuffs", "Both", "None"}))
	options:Range("np_aura_maxnum", L["show_max_0_to_40"], 0, 40, 1)
	options:Range("np_aura_size", L["size"], 4, 64, 1)
	options:Range("np_aura_spacing", L["spacing"], 0, 20, 1)
	options:Anchor("np_aura_anchor1", L["anchor"])
	options:Anchor("np_aura_anchor2", L["parent"])
	options:Range("np_aura_posx", L["PosX"], -100, 100, 1)
	options:Range("np_aura_posy", L["PosY"], -100, 100, 1)
	options:Select("np_aura_growth_x", L["growth_x"], ns.Options.ListValues({"LEFT", "RIGHT"}))
	options:Select("np_aura_growth_y", L["growth_y"], ns.Options.ListValues({"UP", "DOWN"}))
	options:Toggle("np_aura_show_only_player", L["show_only_player_auras"])
	options:Toggle("np_aura_desature_nonplayer_auras", L["desature_auras_not_by_player"])
	local category, layout = ns.SettingsPanel:AddCategory("nameplates", options)

	local cb = ns.Options.New("nameplates_castbar", function() return LolzenUIcfg.nameplates.castbar end, ns.defaults.nameplates.castbar, refreshAll)
	cb:Header(L["sub_panel_nameplates_castbar"])
	cb:Media("np_cb_texture", L["texture"], "statusbar")
	cb:Range("np_cb_width", L["width"], 10, 300, 1)
	cb:Range("np_cb_height", L["height"], 1, 40, 1)
	cb:Anchor("np_cb_anchor", L["anchor"])
	cb:Anchor("np_cb_anchor2", L["parent"])
	cb:Range("np_cb_posx", L["PosX"], -100, 100, 1)
	cb:Range("np_cb_posy", L["PosY"], -100, 100, 1)
	cb:Header(L["sub_panel_nameplates_spark_header"])
	cb:Range("np_spark_width", L["width"], 1, 40, 1)
	cb:Range("np_spark_height", L["height"], 1, 40, 1)
	cb:Header(L["icon"])
	cb:Range("np_cbicon_size", L["size"], 4, 64, 1)
	cb:Anchor("np_cbicon_anchor", L["anchor"])
	cb:Anchor("np_cbicon_anchor2", L["parent"])
	cb:Range("np_cbicon_posx", L["PosX"], -100, 100, 1)
	cb:Range("np_cbicon_posy", L["PosY"], -100, 100, 1)
	cb:Header(L["time"])
	cb:FontGroup("np_cbtime_font")
	cb:Anchor("np_cbtime_anchor", L["anchor"])
	cb:Anchor("np_cbtime_anchor2", L["parent"])
	cb:Range("np_cbtime_posx", L["PosX"], -100, 100, 1)
	cb:Range("np_cbtime_posy", L["PosY"], -100, 100, 1)
	cb:Header(L["text"])
	cb:FontGroup("np_cbtext_font")
	cb:Anchor("np_cbtext_anchor", L["anchor"])
	cb:Anchor("np_cbtext_anchor2", L["parent"])
	cb:Range("np_cbtext_posx", L["PosX"], -100, 100, 1)
	cb:Range("np_cbtext_posy", L["PosY"], -100, 100, 1)
	ns.SettingsPanel.Populate(category, layout, cb)
end

ns.OnInit("nameplates", function()
	general = LolzenUIcfg.nameplates.general
	castbar = LolzenUIcfg.nameplates.castbar

	oUF:RegisterStyle("Lolzen - Nameplates", style)
	oUF:SetActiveStyle("Lolzen - Nameplates")
	local driver = oUF:SpawnNamePlates("LolzenUI_NamePlate")
	if driver then
		driver:SetTargetCallback(updateTargetIndicator)
		driver:SetCVars({
			nameplateSelectedScale = general["np_selected_scale"],
		})
	end

	buildOptions()
end)
