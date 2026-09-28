local _, ns = ...
local LSM = LibStub("LibSharedMedia-3.0")
local oUF = ns.oUF

ns.shared = function(self, unit)
	local function SetupPowerColors(oUF)
	-- Convert config colors to ColorMixin objects
	local function ToColorObject(colorTable)
		if type(colorTable) == "table" then
			local r = colorTable[1] or colorTable.r or 1
			local g = colorTable[2] or colorTable.g or 1
			local b = colorTable[3] or colorTable.b or 1
			local a = colorTable[4] or colorTable.a or 1
			return CreateColor(r, g, b, a)
		end
		return CreateColor(1, 1, 1, 1)
	end
	
	-- Map old power type indices to new Enum.PowerType values
	oUF.colors.power[Enum.PowerType.Mana] = ToColorObject(LolzenUIcfg.unitframes.powercolors[0])
	oUF.colors.power[Enum.PowerType.Rage] = ToColorObject(LolzenUIcfg.unitframes.powercolors[1])
	oUF.colors.power[Enum.PowerType.Focus] = ToColorObject(LolzenUIcfg.unitframes.powercolors[2])
	oUF.colors.power[Enum.PowerType.Energy] = ToColorObject(LolzenUIcfg.unitframes.powercolors[3])
	oUF.colors.power[Enum.PowerType.ComboPoints] = ToColorObject(LolzenUIcfg.unitframes.powercolors[4])
	oUF.colors.power[Enum.PowerType.Runes] = ToColorObject(LolzenUIcfg.unitframes.powercolors[5])
	oUF.colors.power[Enum.PowerType.RunicPower] = ToColorObject(LolzenUIcfg.unitframes.powercolors[6])
	oUF.colors.power[Enum.PowerType.SoulShards] = ToColorObject(LolzenUIcfg.unitframes.powercolors[7])
	oUF.colors.power[Enum.PowerType.LunarPower] = ToColorObject(LolzenUIcfg.unitframes.powercolors[8])
	oUF.colors.power[Enum.PowerType.HolyPower] = ToColorObject(LolzenUIcfg.unitframes.powercolors[9])
	oUF.colors.power[Enum.PowerType.Maelstrom] = ToColorObject(LolzenUIcfg.unitframes.powercolors[11])
	oUF.colors.power[Enum.PowerType.Chi] = ToColorObject(LolzenUIcfg.unitframes.powercolors[12])
	oUF.colors.power[Enum.PowerType.Insanity] = ToColorObject(LolzenUIcfg.unitframes.powercolors[13])
	oUF.colors.power[Enum.PowerType.ArcaneCharges] = ToColorObject(LolzenUIcfg.unitframes.powercolors[16])
	oUF.colors.power[Enum.PowerType.Fury] = ToColorObject(LolzenUIcfg.unitframes.powercolors[17])
	oUF.colors.power[Enum.PowerType.Pain] = ToColorObject(LolzenUIcfg.unitframes.powercolors[18])
	
	-- Also set up backward compatibility with string keys if needed
	-- This allows old code to still work
	oUF.colors.power["MANA"] = oUF.colors.power[Enum.PowerType.Mana]
	oUF.colors.power["RAGE"] = oUF.colors.power[Enum.PowerType.Rage]
	oUF.colors.power["FOCUS"] = oUF.colors.power[Enum.PowerType.Focus]
	oUF.colors.power["ENERGY"] = oUF.colors.power[Enum.PowerType.Energy]
	oUF.colors.power["COMBO_POINTS"] = oUF.colors.power[Enum.PowerType.ComboPoints]
	oUF.colors.power["RUNES"] = oUF.colors.power[Enum.PowerType.Runes]
	oUF.colors.power["RUNIC_POWER"] = oUF.colors.power[Enum.PowerType.RunicPower]
	oUF.colors.power["SOUL_SHARDS"] = oUF.colors.power[Enum.PowerType.SoulShards]
	oUF.colors.power["LUNAR_POWER"] = oUF.colors.power[Enum.PowerType.LunarPower]
	oUF.colors.power["HOLY_POWER"] = oUF.colors.power[Enum.PowerType.HolyPower]
	oUF.colors.power["MAELSTROM"] = oUF.colors.power[Enum.PowerType.Maelstrom]
	oUF.colors.power["CHI"] = oUF.colors.power[Enum.PowerType.Chi]
	oUF.colors.power["INSANITY"] = oUF.colors.power[Enum.PowerType.Insanity]
	oUF.colors.power["ARCANE_CHARGES"] = oUF.colors.power[Enum.PowerType.ArcaneCharges]
	oUF.colors.power["FURY"] = oUF.colors.power[Enum.PowerType.Fury]
	oUF.colors.power["PAIN"] = oUF.colors.power[Enum.PowerType.Pain]

	-- Backward compatibility with string keys
oUF.colors.reaction["HATED"]      = oUF.colors.reaction[1]
oUF.colors.reaction["HOSTILE"]    = oUF.colors.reaction[2]
oUF.colors.reaction["UNFRIENDLY"] = oUF.colors.reaction[3]
oUF.colors.reaction["NEUTRAL"]    = oUF.colors.reaction[4]
oUF.colors.reaction["FRIENDLY"]   = oUF.colors.reaction[5]
oUF.colors.reaction["HONORED"]    = oUF.colors.reaction[6]
oUF.colors.reaction["REVERED"]    = oUF.colors.reaction[7]
oUF.colors.reaction["EXALTED"]    = oUF.colors.reaction[8]
end

-- Call this function after oUF is loaded
SetupPowerColors(oUF)

	-- use custom reaction colors
	if LolzenUIcfg.modules["miscellaneous"] == true and LolzenUIcfg.miscellaneous["misc_alternative_faction_colors"] == true then
		self.colors.reaction = LolzenUIcfg.miscellaneous["misc_faction_colors"]
	end

	self:SetScript("OnEnter", UnitFrame_OnEnter)
	self:SetScript("OnLeave", UnitFrame_OnLeave)

	self:RegisterForClicks("AnyUp")

	ns.AddBorder(self, unit)
	ns.AddHealthBar(self, unit)
	ns.AddHealthPoints(self, unit)

	ns.SetUFTagUpdate = function()
		for i, v in pairs(oUF.objects) do
			v:UpdateTags()
		end
	end

	ns.SetUFTexture = function()
		for i, v in pairs(oUF.objects) do
			if v.unit:match("nameplate") then return end
			v.Health:SetStatusBarTexture(LSM:Fetch("statusbar", LolzenUIcfg.unitframes.general["uf_statusbar_texture"]))
			v.Background:SetTexture(LSM:Fetch("statusbar", LolzenUIcfg.unitframes.general["uf_statusbar_texture"]))
		end
	end

	ns.SetUFBorder = function()
		for i, v in pairs(oUF.objects) do
			if v.unit:match("nameplate") then return end
			v.Border:SetBackdrop({
				edgeFile = LSM:Fetch("border", LolzenUIcfg.unitframes.general["uf_border"]), edgeSize = 12,
				insets = {left = 4, right = 4, top = 4, bottom = 4},
			})
			v.Border:SetBackdropBorderColor(0, 0, 0)
		end
	end

	ns.SetUFRaidMarkSize = function()
		for i, v in pairs(oUF.objects) do
			if v.unit:match("nameplate") then return end
			if v.RaidTargetIndicator then
				v.RaidTargetIndicator:SetSize(LolzenUIcfg.unitframes.general["uf_ri_size"], LolzenUIcfg.unitframes.general["uf_ri_size"])
			end
		end
	end

	ns.SetUFRaidMarkPos = function()
		for i, v in pairs(oUF.objects) do
			if v.unit:match("nameplate") then return end
			if v.RaidTargetIndicator then
				v.RaidTargetIndicator:ClearAllPoints()
				v.RaidTargetIndicator:SetPoint(LolzenUIcfg.unitframes.general["uf_ri_anchor"], v.Health, LolzenUIcfg.unitframes.general["uf_ri_posx"], LolzenUIcfg.unitframes.general["uf_ri_posy"])
			end
		end
	end

	ns.SetUFLeadIndicatorSize = function()
		for i, v in pairs(oUF.objects) do
			if v.unit:match("nameplate") then return end
			if v.LeaderIndicator then
				v.LeaderIndicator:SetSize(LolzenUIcfg.unitframes.general["uf_lead_size"], LolzenUIcfg.unitframes.general["uf_lead_size"])
			end
		end
	end

	ns.SetUFLeadIndicatorPos = function()
		for i, v in pairs(oUF.objects) do
			if v.unit:match("nameplate") then return end
			if v.LeaderIndicator then
				v.LeaderIndicator:ClearAllPoints()
				v.LeaderIndicator:SetPoint(LolzenUIcfg.unitframes.general["uf_lead_anchor"], v.Health, LolzenUIcfg.unitframes.general["uf_lead_posx"], LolzenUIcfg.unitframes.general["uf_lead_posy"])
			end
		end
	end

	ns.SetUFCombatFade = function()
		for i, v in pairs(oUF.objects) do
			if v.unit:match("nameplate") or string.find(unit, "party") or string.find(unit, "raid") then return end
			if LolzenUIcfg.unitframes.general["uf_fade_combat"] == true then
				ns.EnableCombatFade(v, v.unit)
			else
				ns.DisableCombatFade(v, v.unit)
			end
		end
	end

	ns.SetUFCombatFadeAlpha = function()
		for i, v in pairs(oUF.objects) do
			if v.unit:match("nameplate") or string.find(unit, "party") or string.find(unit, "raid") then return end
			if LolzenUIcfg.unitframes.general["uf_fade_combat"] == true then
				ns.UpdateCombatFade(v, v.unit)
			end
		end
	end

	ns.SetUFGeneralHPFont = function()
		for i, v in pairs(oUF.objects) do
			if v.unit:match("nameplate") then return end
			local UNIT
			if string.find(v.unit, "player") then
				UNIT = "player"
			elseif string.find(v.unit, "target") then
				UNIT = "target"
			elseif string.find(v.unit, "targettarget") then
				UNIT = "targettarget"
			elseif string.find(v.unit, "pet") then
				UNIT = "pet"
			elseif string.find(v.unit, "focus") then
				UNIT = "focus"
			elseif string.find(v.unit, "boss") then
				UNIT = "boss"
			elseif string.find(v.unit, "party") then
				UNIT = "party"
			elseif string.find(v.unit, "raid") then
				UNIT = "raid"
			elseif string.find(v.unit, "arena") then
				UNIT = "arena"
			end
			if LolzenUIcfg.unitframes[UNIT]["uf_"..UNIT.."_use_own_hp_font_settings"] == true then return end
			v.Health.value:SetFont(LSM:Fetch("font", LolzenUIcfg.unitframes.general["uf_general_hp_font"]), LolzenUIcfg.unitframes.general["uf_general_hp_font_size"], LolzenUIcfg.unitframes.general["uf_general_hp_font_flag"])
		end
	end

	ns.SetUFGeneralHPPos = function()
		for i, v in pairs(oUF.objects) do
			if v.unit:match("nameplate") then return end
			local UNIT
			if string.find(v.unit, "player") then
				UNIT = "player"
			elseif string.find(v.unit, "target") then
				UNIT = "target"
			elseif string.find(v.unit, "targettarget") then
				UNIT = "targettarget"
			elseif string.find(v.unit, "pet") then
				UNIT = "pet"
			elseif string.find(v.unit, "focus") then
				UNIT = "focus"
			elseif string.find(v.unit, "boss") then
				UNIT = "boss"
			elseif string.find(v.unit, "party") then
				UNIT = "party"
			elseif string.find(v.unit, "raid") then
				UNIT = "raid"
			elseif string.find(v.unit, "arena") then
				UNIT = "arena"
			end
			if LolzenUIcfg.unitframes[UNIT]["uf_"..UNIT.."_use_own_hp_font_settings"] == true then return end
			v.Health.value:ClearAllPoints()
			v.Health.value:SetPoint(LolzenUIcfg.unitframes.general["uf_general_hp_anchor"], LolzenUIcfg.unitframes.general["uf_general_hp_posx"], LolzenUIcfg.unitframes.general["uf_general_hp_posy"])
		end
	end

	ns.SetUFPowerColorMana = function()
		self.colors.power["MANA"] = LolzenUIcfg.unitframes.powercolors[0]
		for i, v in pairs(oUF.objects) do
			if v.Power then
				v.Power:ForceUpdate()
				v:UpdateTags()
			end
		end
	end

	ns.SetUFPowerColorRage = function()
		self.colors.power["RAGE"] = LolzenUIcfg.unitframes.powercolors[1]
		for i, v in pairs(oUF.objects) do
			if v.Power then
				v.Power:ForceUpdate()
				v:UpdateTags()
			end
		end
	end

	ns.SetUFPowerColorFocus = function()
		self.colors.power["FOCUS"] = LolzenUIcfg.unitframes.powercolors[2]
		for i, v in pairs(oUF.objects) do
			if v.Power then
				v.Power:ForceUpdate()
				v:UpdateTags()
			end
		end
	end

	ns.SetUFPowerColorEnergy = function()
		self.colors.power["ENERGY"] = LolzenUIcfg.unitframes.powercolors[3]
		for i, v in pairs(oUF.objects) do
			if v.Power then
				v.Power:ForceUpdate()
				v:UpdateTags()
			end
		end
	end

	ns.SetUFPowerColorCP = function()
		self.colors.power["COMBO_POINTS"] = LolzenUIcfg.unitframes.powercolors[4]
		for i, v in pairs(oUF.objects) do
			if v.unit:match("player") then
				v.ClassPower:ForceUpdate()
			end
		end
	end

	ns.SetUFPowerColorRunes = function()
		self.colors.power["RUNES"] = LolzenUIcfg.unitframes.powercolors[5]
		for i, v in pairs(oUF.objects) do
			if v.unit:match("player") then
				v.Runes:ForceUpdate()
			end
		end
	end

	ns.SetUFPowerColorRunePower = function()
		self.colors.power["RUNIC_POWER"] = LolzenUIcfg.unitframes.powercolors[6]
		for i, v in pairs(oUF.objects) do
			if v.Power then
				v.Power:ForceUpdate()
				v:UpdateTags()
			end
		end
	end

	ns.SetUFPowerColorSoulshards = function()
		self.colors.power["SOUL_SHARDS"] = LolzenUIcfg.unitframes.powercolors[7]
		for i, v in pairs(oUF.objects) do
			if v.unit:match("player") then
				v.ClassPower:ForceUpdate()
			end
		end
	end

	ns.SetUFPowerColorLunarPower = function()
		self.colors.power["LUNAR_POWER"] = LolzenUIcfg.unitframes.powercolors[8]
		for i, v in pairs(oUF.objects) do
			if v.Power then
				v.Power:ForceUpdate()
				v:UpdateTags()
			end
		end
	end

	ns.SetUFPowerColorHolyPower = function()
		self.colors.power["HOLY_POWER"] = LolzenUIcfg.unitframes.powercolors[9]
		for i, v in pairs(oUF.objects) do
			if v.unit:match("player") then
				v.ClassPower:ForceUpdate()
			end
		end
	end

	ns.SetUFPowerColorMaelstrom = function()
		self.colors.power["MAELSTROM"] = LolzenUIcfg.unitframes.powercolors[11]
		for i, v in pairs(oUF.objects) do
			if v.Power then
				v.Power:ForceUpdate()
				v:UpdateTags()
			end
		end
	end

	ns.SetUFPowerColorChi = function()
		self.colors.power["CHI"] = LolzenUIcfg.unitframes.powercolors[12]
		for i, v in pairs(oUF.objects) do
			if v.Power then
				v.Power:ForceUpdate()
				v:UpdateTags()
			end
		end
	end

	ns.SetUFPowerColorInsanity = function()
		self.colors.power["INSANITY"] = LolzenUIcfg.unitframes.powercolors[13]
		for i, v in pairs(oUF.objects) do
			if v.Power then
				v.Power:ForceUpdate()
				v:UpdateTags()
			end
		end
	end

	ns.SetUFPowerColorArcaneCharges = function()
		self.colors.power["ARCANE_CHARGES"] = LolzenUIcfg.unitframes.powercolors[16]
		for i, v in pairs(oUF.objects) do
			if v.unit:match("player") then
				v.ClassPower:ForceUpdate()
			end
		end
	end

	ns.SetUFPowerColorFury = function()
		self.colors.power["FURY"] = LolzenUIcfg.unitframes.powercolors[17]
		for i, v in pairs(oUF.objects) do
			if v.Power then
				v.Power:ForceUpdate()
				v:UpdateTags()
			end
		end
	end

	ns.SetUFPowerColorPain = function()
		self.colors.power["PAIN"] = LolzenUIcfg.unitframes.powercolors[18]
		for i, v in pairs(oUF.objects) do
			if v.Power then
				v.Power:ForceUpdate()
				v:UpdateTags()
			end
		end
	end
end