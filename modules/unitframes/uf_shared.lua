--// unitframes: shared // --

local _, ns = ...
local L = ns.L
local LSM = LibStub("LibSharedMedia-3.0")
local oUF = ns.oUF

local PostCastStart = function(Castbar, unit, spell, spellrank)
	Castbar.Text:SetText(spell)
	if Castbar.notInterruptible then
		Castbar.Icon:SetDesaturated(true)
	else
		Castbar.Icon:SetDesaturated(false)
	end
end

local PostUpdateHealth = function(Health, unit, min, max)
	if UnitIsDead(unit) then
		Health:SetValue(0)
	elseif UnitIsGhost(unit) then
		Health:SetValue(0)
	end

	local r, g, b = oUF:ColorGradient(min / max, 1, 1, 0, 0, 1, 1, 0, 0, 1, 0)
	Health.value:SetTextColor(r, g, b)
end

local CombatFade = function(self, event)
	local unit = self.unit
	-- the elements which are to be faded
	local elements = {
		self.Health,
		self.Power,
		self.Border,
		self.Panel,
		self.Background,
	}
	local combat = UnitAffectingCombat(unit)
	for _, element in pairs(elements) do
		if combat then
			if element:GetAlpha() == LolzenUIcfg.unitframes.general["uf_fade_combat_incombat"] then return end
			UIFrameFadeIn(element, 0.3, element:GetAlpha(), LolzenUIcfg.unitframes.general["uf_fade_combat_incombat"])
		else
			if element:GetAlpha() == LolzenUIcfg.unitframes.general["uf_fade_combat_outofcombat"] then return end
			UIFrameFadeOut(element, 0.3, element:GetAlpha(), LolzenUIcfg.unitframes.general["uf_fade_combat_outofcombat"])
		end
	end
end

local PostUpdatePower = function(Power, unit, min, max)
	local parent = Power:GetParent()
	if not Power then return end
	if parent.PowerDivider then
		if min > 0 then
			parent.PowerDivider:SetAlpha(1)
		else
			parent.PowerDivider:SetAlpha(0)
		end
	end
end

local PostCreateIcon = function(Auras, button)
	local count = button.count
	count:ClearAllPoints()
	count:SetPoint"BOTTOM"

	button.icon:SetTexCoord(.07, .93, .07, .93)

	local iconborder = CreateFrame("Frame")
	iconborder:SetBackdrop({
		edgeFile = "Interface\\AddOns\\LolzenUI\\media\\border", edgeSize = 12,
		insets = {left = 4, right = 4, top = 4, bottom = 4},
	})
	iconborder:SetParent(button)
	iconborder:SetPoint("TOPLEFT", button, -2, 3)
	iconborder:SetPoint("BOTTOMRIGHT", button, 3, -2)
	iconborder:SetBackdropBorderColor(0, 0, 0)
	iconborder:SetFrameLevel(3)

	--[[
	local overlay = button.overlay
	overlay.SetVertexColor = overlayProxy
	overlay:SetTexture("Interface\\AddOns\\LolzenUI\\media\\auraborder")
	overlay:SetTexCoord(.07, .93, .07, .93)
	]]
end

local PostUpdateIcon = function(icons, unit, button, index, offset, filter, isDebuff)
	-- fix for boss, party & raid
	-- these have a number attached to their names
	if string.find(unit, "boss") then
		unit = "boss"
	elseif string.find(unit, "party") then
		unit = "party"
	elseif string.find(unit, "raid") then
		unit = "raid"
	end

	if LolzenUIcfg.unitframes[unit] and LolzenUIcfg.unitframes[unit]["uf_"..unit.."_aura_desature_nonplayer_auras"] == true then
		if button.isPlayer then
			button.icon:SetDesaturated(false)
		else
			button.icon:SetDesaturated(true)
		end
	end
end

local CreateAura = function(self, num)
	local Auras = CreateFrame("Frame", nil, self)
	local unit = self.unit

	-- fix for boss, party & raid
	-- these have a number attached to their names
	if string.find(unit, "boss") then
		unit = "boss"
	elseif string.find(unit, "party") then
		unit = "party"
	elseif string.find(unit, "raid") then
		unit = "raid"
	end

	-- check if SVs exist, otherwise do nothing
	if LolzenUIcfg.unitframes[unit] and LolzenUIcfg.unitframes[unit]["uf_"..unit.."_aura_size"] then
		Auras:SetSize(num * (LolzenUIcfg.unitframes[unit]["uf_"..unit.."_aura_size"] + 4), LolzenUIcfg.unitframes[unit]["uf_"..unit.."_aura_size"])
		Auras.size = LolzenUIcfg.unitframes[unit]["uf_"..unit.."_aura_size"]
	-- create a fallback to prevent getting errors in BfA
	else
		Auras:SetSize(num * (23 + 4) , 23)
		Auras.size = 23
	end
	if LolzenUIcfg.unitframes[unit]["uf_"..unit.."_aura_spacing"] then
		Auras.spacing = LolzenUIcfg.unitframes[unit]["uf_"..unit.."_aura_spacing"]
	end

	Auras.PostCreateIcon = PostCreateIcon
	Auras.PostUpdateIcon = PostUpdateIcon

	return Auras
end

ns.shared = function(self, unit, isSingle)
	self.colors.power["MANA"] = LolzenUIcfg.unitframes.powercolors[0]
	self.colors.power["RAGE"] = LolzenUIcfg.unitframes.powercolors[1]
	self.colors.power["FOCUS"] = LolzenUIcfg.unitframes.powercolors[2]
	self.colors.power["ENERGY"] = LolzenUIcfg.unitframes.powercolors[3]
	self.colors.power["COMBO_POINTS"] = LolzenUIcfg.unitframes.powercolors[4]
	self.colors.power["RUNES"] = LolzenUIcfg.unitframes.powercolors[5]
	self.colors.power["RUNIC_POWER"] = LolzenUIcfg.unitframes.powercolors[6]
	self.colors.power["SOUL_SHARDS"] = LolzenUIcfg.unitframes.powercolors[7]
	self.colors.power["LUNAR_POWER"] = LolzenUIcfg.unitframes.powercolors[8]
	self.colors.power["HOLY_POWER"] = LolzenUIcfg.unitframes.powercolors[9]
	self.colors.power["MAELSTROM"] = LolzenUIcfg.unitframes.powercolors[11]
	self.colors.power["CHI"] = LolzenUIcfg.unitframes.powercolors[12]
	self.colors.power["INSANITY"] = LolzenUIcfg.unitframes.powercolors[13]
	self.colors.power["ARCANE_CHARGES"] = LolzenUIcfg.unitframes.powercolors[16]
	self.colors.power["FURY"] = LolzenUIcfg.unitframes.powercolors[17]
	self.colors.power["PAIN"] = LolzenUIcfg.unitframes.powercolors[18]

	self:SetScript("OnEnter", UnitFrame_OnEnter)
	self:SetScript("OnLeave", UnitFrame_OnLeave)

	self:RegisterForClicks("AnyUp")

	-- use custom reaction colors
	if LolzenUIcfg.modules["miscellaneous"] == true and LolzenUIcfg.miscellaneous["misc_alternative_faction_colors"] == true then
		self.colors.reaction = LolzenUIcfg.miscellaneous["misc_faction_colors"]
	end

	local Border = CreateFrame("Frame", nil, self)
	Border:SetBackdrop({
		edgeFile = LSM:Fetch("border", LolzenUIcfg.unitframes.general["uf_border"]), edgeSize = 12,
		insets = {left = 4, right = 4, top = 4, bottom = 4},
	})
	Border:SetPoint("TOPLEFT", self, -3, 3)
	Border:SetPoint("BOTTOMRIGHT", self, 3, -3)
	Border:SetBackdropBorderColor(0, 0, 0)
	Border:SetFrameLevel(3)
	self.Border = Border

	local Health = CreateFrame("StatusBar", nil, self)
	Health:SetStatusBarTexture(LSM:Fetch("statusbar", LolzenUIcfg.unitframes.general["uf_statusbar_texture"]))
	Health:SetFrameStrata("LOW")

	Health.colorTapping = true
	Health.colorClass = true
	Health.colorReaction = true

	Health:SetPoint("TOP")
	Health:SetPoint("LEFT")
	Health:SetPoint("RIGHT")

	self.Health = Health

	local HealthPoints = Health:CreateFontString(nil, "OVERLAY")
	HealthPoints:SetFont(LSM:Fetch("font", LolzenUIcfg.unitframes.general["uf_general_hp_font"]), LolzenUIcfg.unitframes.general["uf_general_hp_font_size"], LolzenUIcfg.unitframes.general["uf_general_hp_font_flag"])
	HealthPoints:SetPoint(LolzenUIcfg.unitframes.general["uf_general_hp_anchor"], LolzenUIcfg.unitframes.general["uf_general_hp_posx"], LolzenUIcfg.unitframes.general["uf_general_hp_posy"])
	if LolzenUIcfg.unitframes.general["uf_use_val_and_perc"] == true then
		if LolzenUIcfg.unitframes.general["uf_perc_first"] == true then
			self:Tag(HealthPoints, "[|cffc41f3b>dead<|r][|cff999999>offline<|r][perhp]%"..LolzenUIcfg.unitframes.general["uf_val_perc_divider"].."[lolzen:health]")
		else
			self:Tag(HealthPoints, "[|cffc41f3b>dead<|r][|cff999999>offline<|r][lolzen:health]"..LolzenUIcfg.unitframes.general["uf_val_perc_divider"].."[perhp]%")
		end
	elseif LolzenUIcfg.unitframes.general["uf_use_hp_percent"] == true and LolzenUIcfg.unitframes.general["uf_use_val_and_perc"] == false then
		self:Tag(HealthPoints, "[|cffc41f3b>dead<|r][|cff999999>offline<|r][perhp]%")
	else
		self:Tag(HealthPoints, "[|cffc41f3b>dead<|r][|cff999999>offline<|r][lolzen:health]")
	end

	Health.value = HealthPoints

	local Power = CreateFrame("StatusBar", nil, self)
	Power:SetHeight(2)
	Power:SetStatusBarTexture(LSM:Fetch("statusbar", LolzenUIcfg.unitframes.general["uf_statusbar_texture"]))
	Power:SetFrameStrata("MEDIUM")
	Power.colorPower = true

	self.Power = Power

	local PowerDivider = Power:CreateTexture(nil, "OVERLAY")
	PowerDivider:SetTexture("Interface\\AddOns\\LolzenUI\\media\\statusbar")
	PowerDivider:SetVertexColor(0, 0, 0)
	self.PowerDivider = PowerDivider

	local PowerPoints = Power:CreateFontString(nil, "OVERLAY")
	PowerPoints:SetFont("Interface\\AddOns\\LolzenUI\\fonts\\DroidSansBold.ttf", 18, "THINOUTLINE")
	self:Tag(PowerPoints, "[powercolor][lolzen:power]")
	self.Power.value = PowerPoints

	local bg = self:CreateTexture(nil, "BORDER")
	bg:SetAllPoints(self)
	bg:SetTexture(LSM:Fetch("statusbar", LolzenUIcfg.unitframes.general["uf_statusbar_texture"]))
	bg:SetVertexColor(0.3, 0.3, 0.3)
	bg:SetAlpha(1)
	self.Background = bg

	local RaidTargetIndicator = Health:CreateTexture(nil, "OVERLAY")
	RaidTargetIndicator:SetSize(LolzenUIcfg.unitframes.general["uf_ri_size"], LolzenUIcfg.unitframes.general["uf_ri_size"])
	RaidTargetIndicator:SetPoint(LolzenUIcfg.unitframes.general["uf_ri_anchor"], Health, LolzenUIcfg.unitframes.general["uf_ri_posx"], LolzenUIcfg.unitframes.general["uf_ri_posy"])
	self.RaidTargetIndicator = RaidTargetIndicator

	local lead = Health:CreateTexture(nil, "OVERLAY")
	lead:SetSize(LolzenUIcfg.unitframes.general["uf_lead_size"], LolzenUIcfg.unitframes.general["uf_lead_size"])
	lead:SetPoint(LolzenUIcfg.unitframes.general["uf_lead_anchor"], Health, LolzenUIcfg.unitframes.general["uf_lead_posx"], LolzenUIcfg.unitframes.general["uf_lead_posy"])
	self.LeaderIndicator = lead

	local Castbar = CreateFrame("StatusBar", nil, self)
	Castbar:SetStatusBarTexture(LSM:Fetch("statusbar", LolzenUIcfg.unitframes.general["uf_statusbar_texture"]))
	Castbar:SetFrameStrata("MEDIUM")
	Castbar:SetParent(self)
	self.Castbar = Castbar

	local cbbg = Castbar:CreateTexture(nil, "BORDER")
	cbbg:SetTexture(LSM:Fetch("statusbar", LolzenUIcfg.unitframes.general["uf_statusbar_texture"]))
	cbbg:SetVertexColor(0.3, 0.3, 0.3)
	cbbg:SetAlpha(1)
	self.Castbar.background = cbbg

	local cbborder = CreateFrame("Frame")
	cbborder:SetBackdrop({
		edgeFile = LSM:Fetch("border", LolzenUIcfg.unitframes.general["uf_border"]), edgeSize = 12,
		insets = {left = 4, right = 4, top = 4, bottom = 4},
	})
	cbborder:SetParent(Castbar)
	cbborder:SetBackdropBorderColor(0, 0, 0)
	cbborder:SetFrameLevel(3)
	self.Castbar.border = cbborder

	local Spark = Castbar:CreateTexture(nil, "OVERLAY")
	Spark:SetBlendMode("ADD")
	self.Castbar.Spark = Spark

	local icon = Castbar:CreateTexture(nil, "BACKGROUND")
	icon:SetDrawLayer("OVERLAY", 0)
	self.Castbar.Icon = icon

	local iconborder = CreateFrame("Frame")
	iconborder:SetBackdrop({
		edgeFile = LSM:Fetch("border", LolzenUIcfg.unitframes.general["uf_border"]), edgeSize = 12,
		insets = {left = 4, right = 4, top = 4, bottom = 4},
	})
	iconborder:SetParent(Castbar)
	iconborder:SetPoint("TOPLEFT", icon, -2, 3)
	iconborder:SetPoint("BOTTOMRIGHT", icon, 3, -2)
	iconborder:SetBackdropBorderColor(0, 0, 0)
	iconborder:SetFrameLevel(3)
	self.Castbar.Iconborder = iconborder

	local Time = Castbar:CreateFontString(nil, "OVERLAY")
	Time:SetFont("Interface\\AddOns\\LolzenUI\\fonts\\DroidSansBold.ttf", 12, "OUTLINE")
	self.Castbar.Time = Time

	local cbtext = Castbar:CreateFontString(nil, "OVERLAY")
	cbtext:SetFont("Interface\\AddOns\\LolzenUI\\fonts\\DroidSansBold.ttf", 12, "OUTLINE")
	self.Castbar.Text = cbtext

	local Shield = Castbar:CreateTexture(nil, "ARTWORK")
	Shield:SetTexture("Interface\\AddOns\\LolzenUI\\media\\shield")
	self.Castbar.Shield = Shield

	local Buffs = CreateAura(self, 8)
	self.Buffs = Buffs

	local Debuffs = CreateAura(self, 8)
	self.Debuffs = Debuffs

	local Auras = CreateAura(self, 8)
	self.Auras = Auras

	local panel = CreateFrame("Frame")
	panel:SetParent(self)
	panel:SetFrameLevel(3)
	self.Panel = panel

	local Panelborder = CreateFrame("Frame", nil, self)
	Panelborder:SetBackdrop({
		bgFile = "Interface\\AddOns\\LolzenUI\\media\\statusbar",
		edgeFile = LSM:Fetch("border", LolzenUIcfg.unitframes.general["uf_border"]), edgeSize = 12,
		insets = {left = 2, right = 2, top = 3, bottom = 2},
	})
	Panelborder:SetPoint("TOPLEFT", panel, -3, 3)
	Panelborder:SetPoint("BOTTOMRIGHT", panel, 3, -1)
	Panelborder:SetBackdropBorderColor(0, 0, 0)
	Panelborder:SetFrameLevel(3)
	Panelborder:SetBackdropColor(0, 0, 0, 0.8)

	local level = Health:CreateFontString(nil, "OVERLAY")
	level:SetFont("Interface\\AddOns\\LolzenUI\\fonts\\DroidSans.ttf", 12, "THINOUTLINE")
	self:Tag(level, "[difficulty][level][shortclassification]")
	self.Level = level

	local name = Health:CreateFontString(nil, "OVERLAY")
	name:SetFont("Interface\\AddOns\\LolzenUI\\fonts\\DroidSans.ttf", 12, "THINOUTLINE")
	name:SetTextColor(1, 1, 1)
	self:Tag(name, "[name]")
	self.Name = name

	local role = Health:CreateTexture(nil, "OVERLAY")
	self.GroupRoleIndicator = role

	local rc = Health:CreateTexture(nil, "OVERLAY")
	self.ReadyCheckIndicator = rc

	if unit == "player" or unit == "party" or unit == "raid" then
		local dbh = Health:CreateTexture(nil, "OVERLAY")
		dbh:SetAllPoints(Health)
		dbh:SetTexture(LSM:Fetch("statusbar", LolzenUIcfg.unitframes.general["uf_statusbar_texture"]))
		dbh:SetVertexColor(0, 0, 0, 0)
		self.DebuffHighlight = dbh
		self.DebuffHighlightAlpha = 0.5
		self.DebuffHighlightFilter = true
	end

	if LolzenUIcfg.unitframes.general["uf_fade_outofreach"] == true then
		if unit == "party" or unit == "raid" then
			self.Range = {
				insideAlpha = 1,
				outsideAlpha = LolzenUIcfg.unitframes.general["uf_fade_outofreach_alpha"],
			}
		end
	end

	if LolzenUIcfg.unitframes.general["uf_fade_combat"] == true then
		if unit ~= "party" and unit ~= "raid" then
			table.insert(self.__elements, CombatFade)
			self:RegisterEvent("PLAYER_REGEN_ENABLED", CombatFade, true)
			self:RegisterEvent('PLAYER_REGEN_DISABLED', CombatFade, true)
			self:RegisterEvent("PLAYER_TARGET_CHANGED", CombatFade, true)
			self:RegisterEvent("UNIT_TARGET", CombatFade)
		end
	end

	Health.PostUpdate = PostUpdateHealth
	Power.PostUpdate = PostUpdatePower
	Castbar.PostChannelStart = PostCastStart
	Castbar.PostCastStart = PostCastStart
end