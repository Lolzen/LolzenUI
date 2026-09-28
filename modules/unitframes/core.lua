--// unitframes: elements //--
-- Creates the widgets of the unit frames and applies the settings to them.
-- Everything config related lives in UF.Apply, so options can be changed live.

local _, ns = ...
local LSM = LibStub("LibSharedMedia-3.0")
local oUF = ns.oUF

local UF = {}
ns.UF = UF

-- what each unit frame consists of
UF.features = {
	player = {power = true, castbar = true, standaloneCastbar = true, classpower = true, threat = true, dispel = true, fade = true, raidmark = true, lead = true, resting = true},
	target = {power = true, auras = true, castbar = true, standaloneCastbar = true, infopanel = true, fade = true, raidmark = true},
	targettarget = {fade = true, raidmark = true},
	focus = {power = true, auras = true, castbar = true, infopanel = true, raidmark = true},
	pet = {castbar = true, fade = true},
	boss = {power = true, auras = true, castbar = true, infopanel = true, raidmark = true},
	arena = {power = true, auras = true, castbar = true, infopanel = true, raidmark = true},
	party = {lead = true, raidmark = true, range = true, readycheck = true, role = true, dispel = true},
	raid = {lead = true, range = true, readycheck = true, role = true, dispel = true},
}

local function general()
	return LolzenUIcfg.unitframes.general
end

function UF.DB(key)
	return LolzenUIcfg.unitframes[key]
end

-- config value of a unit ("uf_<key>_<name>")
local function get(frame, name)
	return LolzenUIcfg.unitframes[frame.unitKey]["uf_"..frame.unitKey.."_"..name]
end
UF.Get = get

local function statusbar()
	return LSM:Fetch("statusbar", general()["uf_statusbar_texture"])
end

--[[ colors ]]-----------------------------------------------------------------

local POWER_TOKENS = {
	[0] = "MANA", [1] = "RAGE", [2] = "FOCUS", [3] = "ENERGY", [4] = "COMBO_POINTS", [5] = "RUNES",
	[6] = "RUNIC_POWER", [7] = "SOUL_SHARDS", [8] = "LUNAR_POWER", [9] = "HOLY_POWER", [11] = "MAELSTROM",
	[12] = "CHI", [13] = "INSANITY", [16] = "ARCANE_CHARGES", [17] = "FURY", [18] = "PAIN",
}

local defaultReaction = {}
for index, color in pairs(oUF.colors.reaction) do
	defaultReaction[index] = color
end

function UF.ApplyColors()
	local cfg = LolzenUIcfg.unitframes
	for index, token in pairs(POWER_TOKENS) do
		local c = cfg.powercolors[index]
		if c then
			local color = oUF:CreateColor(c[1], c[2], c[3])
			oUF.colors.power[token] = color
			oUF.colors.power[index] = color
		end
	end

	local custom = ns.IsModuleEnabled("miscellaneous") and LolzenUIcfg.miscellaneous["misc_alternative_faction_colors"]
	for index = 1, 8 do
		local c = custom and LolzenUIcfg.miscellaneous["misc_faction_colors"][index]
		oUF.colors.reaction[index] = c and oUF:CreateColor(c[1], c[2], c[3]) or defaultReaction[index]
	end
end

--[[ tags ]]-------------------------------------------------------------------

local tags = oUF.Tags.Methods
local tagEvents = oUF.Tags.Events
local format, floor = string.format, math.floor

local function shortValue(value)
	local cfg = general()
	if not cfg["uf_use_sivalue"] then
		return tostring(value)
	end
	local dot = cfg["uf_use_dot_format"]
	if value >= 1e6 then
		local text = format("%.1f", value / 1e6)
		return dot and text.."m" or (text:gsub("%.", "m"))
	elseif value >= 1e4 then
		local text = format("%.1f", value / 1e3)
		return dot and text.."k" or (text:gsub("%.", "k"))
	end
	return tostring(value)
end

local function combine(value, percent)
	local cfg = general()
	if not cfg["uf_use_hp_percent"] then
		return value
	elseif not cfg["uf_use_val_and_perc"] then
		return percent
	elseif cfg["uf_perc_first"] then
		return percent..cfg["uf_val_perc_divider"]..value
	end
	return value..cfg["uf_val_perc_divider"]..percent
end

-- true only if the value is accessible and true
local function isTrue(value)
	return not ns.IsSecret(value) and value == true
end

local function isDeadOrOffline(unit)
	return isTrue(UnitIsDeadOrGhost(unit)) or (not ns.IsSecret(UnitIsConnected(unit)) and not UnitIsConnected(unit))
end

-- 12.0: health of other units may be secret. Secret values can't be compared or calculated with,
-- but they can be passed to the formatting functions and FontStrings.
local function healthPercentText(unit)
	if UnitHealthPercent and CurveConstants then
		return format("%d%%", UnitHealthPercent(unit, true, CurveConstants.ScaleTo100))
	end
end

tags["lolzen:health"] = function(unit)
	if isDeadOrOffline(unit) then return end
	local cur = UnitHealth(unit)
	if ns.IsSecret(cur) then
		local value = AbbreviateNumbers(cur)
		local percent = healthPercentText(unit)
		return percent and combine(value, percent) or value
	end
	local max = UnitHealthMax(unit)
	local percent = format("%d%%", max > 0 and floor(cur / max * 100 + 0.5) or 0)
	return combine(shortValue(cur), percent)
end
tagEvents["lolzen:health"] = "UNIT_CONNECTION UNIT_HEALTH UNIT_MAXHEALTH"

tags["lolzen:power"] = function(unit)
	if isDeadOrOffline(unit) then return end
	local cur = UnitPower(unit)
	if ns.IsSecret(cur) then
		return AbbreviateNumbers(cur)
	end
	if cur == 0 then return end
	return shortValue(cur)
end
tagEvents["lolzen:power"] = "UNIT_POWER_UPDATE UNIT_MAXPOWER UNIT_CONNECTION"

--[[ element callbacks ]]------------------------------------------------------

local healthCurve
local function postUpdateHealth(element, unit)
	-- color the health text from red to green depending on the health percentage
	if not element.value or not UnitHealthPercent then return end
	healthCurve = healthCurve or oUF.colors.health:GetCurve()
	local color = healthCurve and UnitHealthPercent(unit, true, healthCurve)
	if color then
		element.value:SetTextColor(color:GetRGB())
	end
end

local function postUpdatePower(element, unit, cur)
	local divider = element.__owner.PowerDivider
	if divider and not ns.IsSecret(cur) then
		divider:SetAlpha(cur and cur > 0 and 1 or 0)
	end
end

local function postCastStart(element)
	local notInterruptible = element.notInterruptible
	if not ns.IsSecret(notInterruptible) then
		element.Icon:SetDesaturated(notInterruptible == true)
	end
end

local function postCreateAuraButton(element, button)
	button.Icon:SetTexCoord(.07, .93, .07, .93)
	button.Count:ClearAllPoints()
	button.Count:SetPoint("TOPLEFT")

	local border = CreateFrame("Frame", nil, button, "BackdropTemplate")
	border:SetBackdrop({edgeFile = "Interface\\AddOns\\LolzenUI\\media\\border", edgeSize = 12})
	border:SetPoint("TOPLEFT", button, -2, 3)
	border:SetPoint("BOTTOMRIGHT", button, 3, -2)
	border:SetBackdropBorderColor(0, 0, 0)
	border:SetFrameLevel(button:GetFrameLevel() + 2)

	button.Overlay:SetTexture("Interface\\AddOns\\LolzenUI\\media\\auraborder")
	button.Overlay:SetTexCoord(.07, .93, .07, .93)

	-- the cooldown shows the remaining time (secret aware, no OnUpdate needed)
	button.Cooldown:SetHideCountdownNumbers(false)
	local text = button.Cooldown.GetCountdownFontString and button.Cooldown:GetCountdownFontString()
	if text then
		text:SetFont(LSM:Fetch("font", "DroidSansBold"), 11, "OUTLINE")
	end
end

local function postUpdateAuraButton(element, button, _, data)
	local frame = element.__owner
	local desaturate = get(frame, "aura_desature_nonplayer_auras") and not ns.IsSecret(data.isPlayerAura) and not data.isPlayerAura
	button.Icon:SetDesaturated(desaturate == true)
end

local function postUpdateClassPower(element, _, max, maxChanged)
	if not max or not maxChanged then return end
	local frame = element.__owner
	local spacing = get(frame, "classpower_spacing")
	local width = (frame:GetWidth() - spacing * (max - 1)) / max
	for i = 1, max do
		element[i]:SetWidth(width)
	end
end

-- threat: colors the outline (or a glow when outlines are disabled)
local function updateThreat(frame, _, unit)
	if unit ~= frame.unit then return end
	local status = UnitThreatSituation(unit)
	local hasThreat = status ~= nil and not ns.IsSecret(status) and status > 0
	local outline = frame.LolzenOutline
	if outline and general()["uf_outline"] then
		if hasThreat and general()["uf_outline_threat"] then
			outline:SetColor(GetThreatStatusColor(status))
		else
			outline:ResetColor()
		end
		frame.Glow:Hide()
	elseif hasThreat then
		frame.Glow:SetBackdropBorderColor(GetThreatStatusColor(status))
		frame.Glow:Show()
	else
		frame.Glow:Hide()
	end
end

--[[ combat fade ]]------------------------------------------------------------

local fadeFrames = {}

local function fadeAlpha(frame)
	local cfg = general()
	if not cfg["uf_fade_combat"] or ns.EditMode:IsActive() then
		return 1
	end
	if UnitAffectingCombat("player") or (frame.unit and isTrue(UnitAffectingCombat(frame.unit))) then
		return cfg["uf_fade_combat_incombat"]
	end
	return cfg["uf_fade_combat_outofcombat"]
end

-- only the visual parts are faded, the frame itself stays clickable
local function updateFade(frame)
	local alpha = fadeAlpha(frame)
	for _, element in ipairs(frame.fadeElements) do
		element:SetAlpha(alpha)
	end
end

function UF.UpdateAllFades()
	for frame in pairs(fadeFrames) do
		updateFade(frame)
	end
end

local fadeEvents = CreateFrame("Frame")
fadeEvents:RegisterEvent("PLAYER_REGEN_ENABLED")
fadeEvents:RegisterEvent("PLAYER_REGEN_DISABLED")
fadeEvents:RegisterEvent("PLAYER_TARGET_CHANGED")
fadeEvents:SetScript("OnEvent", UF.UpdateAllFades)

--[[ dispel highlight ]]-------------------------------------------------------

local dispelCurve
local function updateDispel(frame, _, unit)
	if unit ~= frame.unit then return end
	local highlight = frame.DispelHighlight
	-- "RAID" returns debuffs the player can dispel
	local aura = UnitCanAssist("player", unit) and C_UnitAuras.GetAuraDataByIndex(unit, 1, "HARMFUL|RAID")
	if aura and C_UnitAuras.GetAuraDispelTypeColor then
		if not dispelCurve then
			dispelCurve = C_CurveUtil.CreateColorCurve()
			dispelCurve:SetType(Enum.LuaCurveType.Step)
			for _, index in pairs(oUF.Enum.DispelType) do
				if oUF.colors.dispel[index] then
					dispelCurve:AddPoint(index, oUF.colors.dispel[index])
				end
			end
		end
		local color = C_UnitAuras.GetAuraDispelTypeColor(unit, aura.auraInstanceID, dispelCurve)
		if color then
			local r, g, b = color:GetRGB()
			highlight:SetVertexColor(r, g, b, 0.5)
			return highlight:Show()
		end
	end
	highlight:Hide()
end

--[[ builders ]]---------------------------------------------------------------

local function createFont(parent, layer)
	local fontString = parent:CreateFontString(nil, layer or "OVERLAY")
	fontString:SetWordWrap(false)
	return fontString
end

local function buildHealth(frame)
	local health = CreateFrame("StatusBar", nil, frame)
	health:SetAllPoints()
	health:SetFrameLevel(frame:GetFrameLevel() + 1)
	health.colorTapping = frame.unitKey ~= "raid"
	health.colorDisconnected = true
	health.colorClass = true
	health.colorReaction = true
	health.smoothing = Enum.StatusBarInterpolation and Enum.StatusBarInterpolation.Smooth
	health.PostUpdate = postUpdateHealth
	frame.Health = health

	local bg = frame:CreateTexture(nil, "BORDER")
	bg:SetAllPoints()
	bg:SetVertexColor(0.3, 0.3, 0.3)
	frame.Background = bg

	local value = createFont(health)
	frame:Tag(value, "[dead][offline][lolzen:health]")
	health.value = value

	local border = CreateFrame("Frame", nil, frame, "BackdropTemplate")
	border:SetPoint("TOPLEFT", frame, -3, 3)
	border:SetPoint("BOTTOMRIGHT", frame, 3, -3)
	border:SetFrameLevel(frame:GetFrameLevel() + 3)
	frame.Border = border

	frame.fadeElements = {health, bg, border}
end

local function buildPower(frame)
	local power = CreateFrame("StatusBar", nil, frame)
	power:SetHeight(2)
	power:SetPoint("LEFT")
	power:SetPoint("RIGHT")
	power:SetPoint("TOP", frame.Health, "BOTTOM", 0, 2)
	power:SetFrameLevel(frame.Health:GetFrameLevel() + 1)
	power.colorPower = true
	power.smoothing = frame.Health.smoothing
	power.PostUpdate = postUpdatePower
	frame.Power = power

	local divider = power:CreateTexture(nil, "BACKGROUND", nil, 1)
	divider:SetColorTexture(0, 0, 0)
	divider:SetHeight(1)
	divider:SetPoint("BOTTOMLEFT", power, "TOPLEFT")
	divider:SetPoint("BOTTOMRIGHT", power, "TOPRIGHT")
	frame.PowerDivider = divider

	power.value = createFont(power)
	frame:Tag(power.value, "[powercolor][lolzen:power]")

	table.insert(frame.fadeElements, power)
end

local function buildCastbar(frame)
	local castbar = CreateFrame("StatusBar", nil, frame)
	castbar:SetFrameLevel(frame.Health:GetFrameLevel() + 2)
	castbar.PostCastStart = postCastStart
	castbar.PostChannelStart = postCastStart
	frame.Castbar = castbar

	castbar.background = castbar:CreateTexture(nil, "BORDER")
	castbar.background:SetAllPoints()
	castbar.background:SetVertexColor(0.3, 0.3, 0.3)

	castbar.border = CreateFrame("Frame", nil, castbar, "BackdropTemplate")
	castbar.border:SetPoint("TOPLEFT", castbar, -2, 3)
	castbar.border:SetPoint("BOTTOMRIGHT", castbar, 3, -2)

	castbar.Spark = castbar:CreateTexture(nil, "OVERLAY")
	castbar.Spark:SetBlendMode("ADD")
	castbar.Spark:SetPoint("CENTER", castbar:GetStatusBarTexture(), "RIGHT")

	castbar.Icon = castbar:CreateTexture(nil, "OVERLAY")
	castbar.iconBorder = CreateFrame("Frame", nil, castbar, "BackdropTemplate")
	castbar.iconBorder:SetPoint("TOPLEFT", castbar.Icon, -2, 2)
	castbar.iconBorder:SetPoint("BOTTOMRIGHT", castbar.Icon, 3, -2)

	castbar.Time = createFont(castbar)
	castbar.Text = createFont(castbar)

	-- the player can always interrupt his own casts
	if frame.unitKey ~= "player" then
		castbar.Shield = castbar:CreateTexture(nil, "ARTWORK")
		castbar.Shield:SetTexture("Interface\\AddOns\\LolzenUI\\media\\shield")
		castbar.Shield:SetPoint("CENTER", castbar.Icon)
	end
end

local function buildAuras(frame)
	for _, widget in ipairs({"Buffs", "Debuffs", "Auras"}) do
		local auras = CreateFrame("Frame", nil, frame)
		auras.PostCreateButton = postCreateAuraButton
		auras.PostUpdateButton = postUpdateAuraButton
		auras.showDebuffType = widget ~= "Buffs"
		auras.gap = widget == "Auras"
		frame["Lolzen"..widget] = auras
	end
end

local function buildClassPower(frame)
	local _, class = UnitClass("player")
	local function createBar(parent, name)
		local bar = CreateFrame("StatusBar", nil, parent)
		bar:SetHeight(8)
		bar.border = CreateFrame("Frame", nil, bar, "BackdropTemplate")
		bar.border:SetPoint("TOPLEFT", bar, -1, 1)
		bar.border:SetPoint("BOTTOMRIGHT", bar, 1, -1)
		return bar
	end

	if class == "DEATHKNIGHT" then
		local runes = {}
		for i = 1, 6 do
			runes[i] = createBar(frame)
		end
		frame.Runes = runes
		frame.lolzenPowerBars = runes
	elseif class == "MONK" then
		frame.Stagger = createBar(frame)
		frame.lolzenPowerBars = {frame.Stagger}
	end

	local classPower = {}
	for i = 1, 10 do
		classPower[i] = createBar(frame)
	end
	classPower.PostUpdate = postUpdateClassPower
	frame.ClassPower = classPower
	frame.lolzenClassPower = classPower
end

local function buildInfoPanel(frame)
	local panel = CreateFrame("Frame", nil, frame, "BackdropTemplate")
	panel:SetHeight(20)
	panel:SetPoint("TOPLEFT", frame.Health, "BOTTOMLEFT", 0, -4)
	panel:SetPoint("TOPRIGHT", frame.Health, "BOTTOMRIGHT", 0, -4)
	panel:SetFrameLevel(frame:GetFrameLevel() + 3)
	frame.Panel = panel

	frame.Level = createFont(panel)
	frame.Level:SetPoint("LEFT", panel, "LEFT", 2, 0)
	frame:Tag(frame.Level, "[difficulty][level][shortclassification] [arenaspec]")

	frame.Name = createFont(panel)
	frame.Name:SetPoint("RIGHT", panel, "RIGHT", -2, 0)
	frame.Name:SetPoint("LEFT", frame.Level, "RIGHT", 4, 0)
	frame.Name:SetJustifyH("RIGHT")
	frame.Name:SetTextColor(1, 1, 1)
	frame:Tag(frame.Name, "[name]")

	table.insert(frame.fadeElements, panel)
end

function UF.Build(frame, unit)
	local features = UF.features[frame.unitKey]

	frame:SetScript("OnEnter", UnitFrame_OnEnter)
	frame:SetScript("OnLeave", UnitFrame_OnLeave)
	frame:RegisterForClicks("AnyUp")

	buildHealth(frame)
	if features.power then buildPower(frame) end
	if features.castbar then buildCastbar(frame) end
	if features.auras then buildAuras(frame) end
	if features.classpower then buildClassPower(frame) end
	if features.infopanel then buildInfoPanel(frame) end

	local overlay = frame.Health
	if features.raidmark then
		frame.RaidTargetIndicator = overlay:CreateTexture(nil, "OVERLAY")
	end
	if features.lead then
		frame.LeaderIndicator = overlay:CreateTexture(nil, "OVERLAY")
	end
	if features.resting then
		frame.RestingIndicator = overlay:CreateTexture(nil, "OVERLAY")
	end
	if features.role then
		frame.GroupRoleIndicator = overlay:CreateTexture(nil, "OVERLAY")
	end
	if features.readycheck then
		frame.ReadyCheckIndicator = overlay:CreateTexture(nil, "OVERLAY")
	end
	if features.range then
		frame.lolzenRange = {insideAlpha = 1, outsideAlpha = general()["uf_fade_outofreach_alpha"]}
	end

	-- threat: outline color or glow
	frame.Glow = CreateFrame("Frame", nil, frame, "BackdropTemplate")
	frame.Glow:SetBackdrop({edgeFile = "Interface\\AddOns\\LolzenUI\\media\\glow", edgeSize = 5})
	frame.Glow:SetPoint("TOPLEFT", frame, -5, 5)
	frame.Glow:SetPoint("BOTTOMRIGHT", frame, 5, -5)
	frame.Glow:SetFrameLevel(frame:GetFrameLevel())
	frame.Glow:Hide()
	if features.threat then
		frame.ThreatIndicator = {IsObjectType = function() end, Override = updateThreat}
	end

	if features.dispel then
		local highlight = frame.Health:CreateTexture(nil, "OVERLAY")
		highlight:SetAllPoints()
		highlight:Hide()
		frame.DispelHighlight = highlight
		frame:RegisterEvent("UNIT_AURA", updateDispel)
	end

	if features.fade then
		fadeFrames[frame] = true
		frame:RegisterEvent("UNIT_FLAGS", updateFade)
	end
end

--[[ applying the settings ]]--------------------------------------------------

local function setFont(fontString, font, size, flag)
	ns.SetFont(fontString, font, size, flag)
end

local function setPoint(region, point, relativeTo, relativePoint, x, y)
	region:ClearAllPoints()
	region:SetPoint(point, relativeTo, relativePoint, x, y)
end

local function borderBackdrop(size)
	return {edgeFile = LSM:Fetch("border", general()["uf_border"]), edgeSize = size or 12}
end

local function applyBorder(frame)
	local useOutline = general()["uf_outline"]
	frame.Border:SetBackdrop(borderBackdrop())
	frame.Border:SetBackdropBorderColor(0, 0, 0)
	frame.Border:SetShown(not useOutline)
	if useOutline then
		ns.Outline.Create(frame, {size = 12, padding = 2, level = 4})
	end
	if frame.LolzenOutline then
		frame.LolzenOutline:SetShown(useOutline)
		frame.LolzenOutline:ResetColor()
	end
	if frame.Panel then
		frame.Panel:SetBackdrop({bgFile = "Interface\\AddOns\\LolzenUI\\media\\statusbar", edgeFile = not useOutline and borderBackdrop().edgeFile or nil, edgeSize = 12, insets = {left = 2, right = 2, top = 3, bottom = 2}})
		frame.Panel:SetBackdropColor(0, 0, 0, 0.8)
		frame.Panel:SetBackdropBorderColor(0, 0, 0)
		if useOutline then
			ns.Outline.Create(frame.Panel, {size = 12, padding = 2})
		end
		if frame.Panel.LolzenOutline then
			frame.Panel.LolzenOutline:SetShown(useOutline)
		end
	end
end

local function applyHealthText(frame)
	local key = frame.unitKey
	local db = UF.DB(key)
	local own = db["uf_"..key.."_use_own_hp_font_settings"]
	local src, prefix = own and db or general(), own and "uf_"..key.."_hp" or "uf_general_hp"
	local value = frame.Health.value
	setFont(value, src[prefix.."_font"], src[prefix.."_font_size"], src[prefix.."_font_flag"])
	setPoint(value, src[prefix.."_anchor"], frame.Health, src[prefix.."_anchor"], src[prefix.."_posx"], src[prefix.."_posy"])
end

local function applyPowerText(frame)
	local value = frame.Power.value
	setFont(value, get(frame, "pp_font"), get(frame, "pp_font_size"), get(frame, "pp_font_flag"))
	local relativeTo = get(frame, "pp_parent") == "hp" and frame.Health.value or frame
	setPoint(value, get(frame, "pp_anchor"), relativeTo, get(frame, "pp_anchor2"), get(frame, "pp_posx"), get(frame, "pp_posy"))
	local hidden = frame.unitKey == "boss" and not get(frame, "show_power")
	frame.Power:SetAlpha(hidden and 0 or 1)
	value:SetAlpha(hidden and 0 or 1)
end

local function applyCastbar(frame)
	local castbar = frame.Castbar
	local texture = statusbar()
	castbar:SetStatusBarTexture(texture)
	castbar.background:SetTexture(texture)
	local color = get(frame, "cb_color")
	castbar:SetStatusBarColor(color[1], color[2], color[3], get(frame, "cb_alpha"))

	local standalone = UF.features[frame.unitKey].standaloneCastbar and get(frame, "cb_standalone")
	castbar:ClearAllPoints()
	if standalone and frame.castbarHolder then
		local width, height = get(frame, "cb_width"), get(frame, "cb_height")
		frame.castbarHolder:SetSize(width, height)
		frame.castbarHolder:Show()
		castbar:SetAllPoints(frame.castbarHolder)
	else
		if frame.castbarHolder then
			frame.castbarHolder:Hide()
		end
		castbar:SetAllPoints(frame.Health)
	end
	castbar.background:SetShown(standalone)
	castbar.border:SetBackdrop(borderBackdrop())
	castbar.border:SetBackdropBorderColor(0, 0, 0)
	castbar.border:SetShown(standalone)

	local height = standalone and get(frame, "cb_height") or get(frame, "height")
	local width = standalone and get(frame, "cb_width") or get(frame, "width")
	castbar.Spark:SetSize(width / 27.5, height * 2)

	-- the icon can be cut to the height of the castbar
	local icon, iconSize = castbar.Icon, get(frame, "cb_icon_size")
	icon:SetWidth(iconSize)
	if get(frame, "cb_icon_cut") and iconSize > height then
		icon:SetHeight(height)
		local cut = (iconSize - height) / 2 / iconSize
		icon:SetTexCoord(0.1, 0.9, 0.1 + cut * 0.8, 0.9 - cut * 0.8)
	else
		icon:SetHeight(iconSize)
		icon:SetTexCoord(.07, .93, .07, .93)
	end
	setPoint(icon, get(frame, "cb_icon_anchor1"), castbar, get(frame, "cb_icon_anchor2"), get(frame, "cb_icon_posx"), get(frame, "cb_icon_posy"))
	castbar.iconBorder:SetBackdrop(borderBackdrop())
	castbar.iconBorder:SetBackdropBorderColor(0, 0, 0)
	if castbar.Shield then
		castbar.Shield:SetSize(iconSize * 1.5, iconSize * 1.5)
	end

	local font, size, flag = get(frame, "cb_font"), get(frame, "cb_font_size"), get(frame, "cb_font_flag")
	local fontColor = get(frame, "cb_font_color")
	for _, fontString in ipairs({castbar.Time, castbar.Text}) do
		setFont(fontString, font, size, flag)
		fontString:SetTextColor(fontColor[1], fontColor[2], fontColor[3])
	end
	setPoint(castbar.Time, get(frame, "cb_time_anchor1"), icon, get(frame, "cb_time_anchor2"), get(frame, "cb_time_posx"), get(frame, "cb_time_posy"))
	setPoint(castbar.Text, get(frame, "cb_text_anchor1"), castbar, get(frame, "cb_text_anchor2"), get(frame, "cb_text_posx"), get(frame, "cb_text_posy"))
end

local AURA_WIDGETS = {Buffs = "Buffs", Debuffs = "Debuffs", Both = "Auras"}

local function applyAuras(frame, initial)
	local active = AURA_WIDGETS[get(frame, "aura_show_type")]
	if not initial then
		frame:DisableElement("Auras")
	end
	local size, spacing, num = get(frame, "aura_size"), get(frame, "aura_spacing"), get(frame, "aura_maxnum")
	local growthX, growthY = get(frame, "aura_growth_x"), get(frame, "aura_growth_y")
	for _, widget in pairs(AURA_WIDGETS) do
		local auras = frame["Lolzen"..widget]
		auras.size = size
		auras.spacing = spacing
		auras.growthX = growthX
		auras.growthY = growthY
		auras.initialAnchor = (growthY == "UP" and "BOTTOM" or "TOP")..(growthX == "RIGHT" and "LEFT" or "RIGHT")
		auras.onlyShowPlayer = get(frame, "aura_show_only_player")
		auras.num = num
		auras.numBuffs = num
		auras.numDebuffs = num
		auras.numTotal = num
		auras:SetSize(math.max(1, num) * (size + spacing), size)
		setPoint(auras, get(frame, "aura_anchor1"), frame, get(frame, "aura_anchor2"), get(frame, "aura_posx"), get(frame, "aura_posy"))
		frame[widget] = widget == active and auras or nil
		auras:SetShown(widget == active)
	end
	if active and not initial then
		frame:EnableElement("Auras")
	end
end

local function applyClassPower(frame)
	local texture = statusbar()
	local spacing = get(frame, "classpower_spacing")
	local backdrop = {edgeFile = LSM:Fetch("border", get(frame, "classpower_border")), tile = true, tileSize = 4, edgeSize = 4}

	local function styleBars(bars, count)
		for i, bar in ipairs(bars) do
			bar:SetStatusBarTexture(texture)
			bar:ClearAllPoints()
			if i == 1 then
				bar:SetPoint(get(frame, "classpower_anchor1"), frame, get(frame, "classpower_anchor2"), get(frame, "classpower_posx"), get(frame, "classpower_posy"))
			else
				bar:SetPoint("LEFT", bars[i - 1], "RIGHT", spacing, 0)
			end
			if count then
				bar:SetWidth((get(frame, "width") - spacing * (count - 1)) / count)
			end
			bar.border:SetBackdrop(backdrop)
			bar.border:SetBackdropBorderColor(0, 0, 0)
		end
	end
	styleBars(frame.lolzenClassPower)
	if frame.Runes then
		styleBars(frame.Runes, #frame.Runes)
	elseif frame.Stagger then
		styleBars({frame.Stagger}, 1)
	end
end

local function applyIcon(icon, size, point, relativeTo, x, y)
	icon:SetSize(size, size)
	setPoint(icon, point, relativeTo, point, x, y)
end

local function applyIndicators(frame, initial)
	local cfg = general()
	if frame.RaidTargetIndicator then
		applyIcon(frame.RaidTargetIndicator, cfg["uf_ri_size"], cfg["uf_ri_anchor"], frame.Health, cfg["uf_ri_posx"], cfg["uf_ri_posy"])
	end
	if frame.LeaderIndicator then
		applyIcon(frame.LeaderIndicator, cfg["uf_lead_size"], cfg["uf_lead_anchor"], frame.Health, cfg["uf_lead_posx"], cfg["uf_lead_posy"])
	end
	if frame.RestingIndicator then
		applyIcon(frame.RestingIndicator, get(frame, "resting_size"), get(frame, "resting_anchor"), frame.Health, get(frame, "resting_posx"), get(frame, "resting_posy"))
		frame.RestingIndicator:SetAlpha(get(frame, "show_restingindicator") and 1 or 0)
	end
	if frame.GroupRoleIndicator then
		applyIcon(frame.GroupRoleIndicator, get(frame, "ri_size"), get(frame, "ri_anchor"), frame.Health, get(frame, "ri_posx"), get(frame, "ri_posy"))
		frame.GroupRoleIndicator:SetAlpha(get(frame, "showroleindicator") and 1 or 0)
	end
	if frame.ReadyCheckIndicator then
		applyIcon(frame.ReadyCheckIndicator, get(frame, "rc_size"), get(frame, "rc_anchor"), frame.Health, get(frame, "rc_posx"), get(frame, "rc_posy"))
	end
	local range = frame.lolzenRange
	if range then
		range.outsideAlpha = cfg["uf_fade_outofreach_alpha"]
		if initial then
			-- oUF enables the element after the style function if the widget exists
			frame.Range = cfg["uf_fade_outofreach"] and range or nil
		elseif cfg["uf_fade_outofreach"] then
			frame.Range = range
			frame:EnableElement("Range")
		else
			frame:DisableElement("Range")
			frame:SetAlpha(1)
		end
	end
	if frame.DispelHighlight then
		frame.DispelHighlight:SetTexture(statusbar())
	end
	if fadeFrames[frame] then
		updateFade(frame)
	end
end

-- UF.Apply(frame[, initial])
-- applies all settings to a unit frame; secure parts (size) are postponed while in combat
function UF.Apply(frame, initial)
	local features = UF.features[frame.unitKey]
	local texture = statusbar()
	frame.Health:SetStatusBarTexture(texture)
	frame.Background:SetTexture(texture)
	if frame.Power then
		frame.Power:SetStatusBarTexture(texture)
	end

	applyBorder(frame)
	applyHealthText(frame)
	if features.power then applyPowerText(frame) end
	if features.castbar then applyCastbar(frame) end
	if features.auras then applyAuras(frame, initial) end
	if features.classpower then applyClassPower(frame) end
	applyIndicators(frame, initial)

	local width, height = get(frame, "width"), get(frame, "height")
	if frame.lolzenHeaderChild then
		-- the size of header children is set by the header (initialConfigFunction)
		ns.RunOutOfCombat(function() frame:SetSize(width, height) end)
	elseif not initial then
		ns.RunOutOfCombat(function() frame:SetSize(width, height) end)
	else
		frame:SetSize(width, height)
	end
end

UF.ApplyIndicators = applyIndicators
