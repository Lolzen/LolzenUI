local _, ns = ...
local LSM = LibStub("LibSharedMedia-3.0")
local oUF = ns.oUF

ns.SetupBoss = function(self, unit)
	ns.shared(self, unit)

	self:SetSize(LolzenUIcfg.unitframes.boss["uf_boss_width"], LolzenUIcfg.unitframes.boss["uf_boss_height"])

	if LolzenUIcfg.unitframes.boss["uf_boss_use_own_hp_font_settings"] == true then
		self.Health.value:SetFont(LSM:Fetch("font", LolzenUIcfg.unitframes.boss["uf_boss_hp_font"]), LolzenUIcfg.unitframes.boss["uf_boss_hp_font_size"], LolzenUIcfg.unitframes.boss["uf_boss_hp_font_flag"])
		self.Health.value:SetPoint(LolzenUIcfg.unitframes.boss["uf_boss_hp_anchor"], LolzenUIcfg.unitframes.boss["uf_boss_hp_posx"], LolzenUIcfg.unitframes.boss["uf_boss_hp_posy"])
	end

	self.Border:SetPoint("TOPLEFT", self, -3, 3)
	self.Border:SetPoint("BOTTOMRIGHT", self, 3, -2)

	ns.AddPowerBar(self, unit)
	ns.AddPowerPoints(self, unit)
	if LolzenUIcfg.unitframes.boss["uf_boss_pp_parent"] == "hp" then
		self.Power.value:SetPoint(LolzenUIcfg.unitframes.boss["uf_boss_pp_anchor"], self.Health.value, LolzenUIcfg.unitframes.boss["uf_boss_pp_anchor2"], LolzenUIcfg.unitframes.boss["uf_boss_pp_posx"], LolzenUIcfg.unitframes.boss["uf_boss_pp_posy"])
	elseif LolzenUIcfg.unitframes.boss["uf_boss_pp_parent"] == "self" then
		self.Power.value:SetPoint(LolzenUIcfg.unitframes.boss["uf_boss_pp_anchor"], self, LolzenUIcfg.unitframes.boss["uf_boss_pp_anchor2"], LolzenUIcfg.unitframes.boss["uf_boss_pp_posx"], LolzenUIcfg.unitframes.boss["uf_boss_pp_posy"])
	end
	self.Power.value:SetFont(LSM:Fetch("font", LolzenUIcfg.unitframes.boss["uf_boss_pp_font"]), LolzenUIcfg.unitframes.boss["uf_boss_pp_font_size"], LolzenUIcfg.unitframes.boss["uf_boss_pp_font_flag"])

	if LolzenUIcfg.unitframes.boss["uf_boss_show_power"] ~= true then
		self.Power:SetAlpha(0)
		self.Power.value:SetAlpha(0)
	end

	ns.AddBuffs(self, unit)
	ns.AddDebuffs(self, unit)
	ns.AddAuras(self, unit)

	if LolzenUIcfg.unitframes.boss["uf_boss_aura_show_type"] == "Buffs" then
		self.Buffs:SetPoint(LolzenUIcfg.unitframes.boss["uf_boss_aura_anchor1"], self, LolzenUIcfg.unitframes.boss["uf_boss_aura_anchor2"], LolzenUIcfg.unitframes.boss["uf_boss_aura_posx"], LolzenUIcfg.unitframes.boss["uf_boss_aura_posy"])
		self.Buffs.numBuffs = LolzenUIcfg.unitframes.boss["uf_boss_aura_maxnum"]
		if LolzenUIcfg.unitframes.boss["uf_boss_aura_show_only_player"] == true then
			self.Buffs.onlyShowPlayer = true
		end
		self.Buffs["growth-x"] = LolzenUIcfg.unitframes.boss["uf_boss_aura_growth_x"]
		self.Buffs["growth-y"] = LolzenUIcfg.unitframes.boss["uf_boss_aura_growth_y"]
	elseif LolzenUIcfg.unitframes.boss["uf_boss_aura_show_type"] == "Debuffs" then
		self.Debuffs:SetPoint(LolzenUIcfg.unitframes.boss["uf_boss_aura_anchor1"], self, LolzenUIcfg.unitframes.boss["uf_boss_aura_anchor2"], LolzenUIcfg.unitframes.boss["uf_boss_aura_posx"], LolzenUIcfg.unitframes.boss["uf_boss_aura_posy"])
		self.Debuffs.numDebuffs = LolzenUIcfg.unitframes.boss["uf_boss_aura_maxnum"]
		if LolzenUIcfg.unitframes.boss["uf_boss_aura_show_only_player"] == true then
			self.Debuffs.onlyShowPlayer = true
		end
		self.Debuffs["growth-x"] = LolzenUIcfg.unitframes.boss["uf_boss_aura_growth_x"]
		self.Debuffs["growth-y"] = LolzenUIcfg.unitframes.boss["uf_boss_aura_growth_y"]
	elseif LolzenUIcfg.unitframes.boss["uf_boss_aura_show_type"] == "Both" then
		self.Auras:SetPoint(LolzenUIcfg.unitframes.boss["uf_boss_aura_anchor1"], self, LolzenUIcfg.unitframes.boss["uf_boss_aura_anchor2"], LolzenUIcfg.unitframes.boss["uf_boss_aura_posx"], LolzenUIcfg.unitframes.boss["uf_boss_aura_posy"])
		self.Auras.numTotal = LolzenUIcfg.unitframes.boss["uf_boss_aura_maxnum"]
		if LolzenUIcfg.unitframes.boss["uf_boss_aura_show_only_player"] == true then
			self.Auras.onlyShowPlayer = true
		end
		self.Auras["growth-x"] = LolzenUIcfg.unitframes.boss["uf_boss_aura_growth_x"]
		self.Auras["growth-y"] = LolzenUIcfg.unitframes.boss["uf_boss_aura_growth_y"]
	end

	ns.AddCastBar(self, unit)
	self.Castbar:SetAllPoints(self.Health)
	self.Castbar:SetStatusBarColor(LolzenUIcfg.unitframes.boss["uf_boss_cb_color"][1], LolzenUIcfg.unitframes.boss["uf_boss_cb_color"][2], LolzenUIcfg.unitframes.boss["uf_boss_cb_color"][3], LolzenUIcfg.unitframes.boss["uf_boss_cb_alpha"])

	self.Castbar.Spark:SetSize(self:GetWidth()/27.5, self:GetHeight()*2)

	if LolzenUIcfg.unitframes.boss["uf_boss_cb_icon_cut"] == true then
		self.Castbar.Icon:SetHeight(LolzenUIcfg.unitframes.boss["uf_boss_height"])
		-- Get the % point of the texture to show
		-- We calculate the percentage of the icon which has to be cut, depending on icon size, and unitframe size which are both variables
		local p1 = (LolzenUIcfg.unitframes.boss["uf_boss_cb_icon_size"]-LolzenUIcfg.unitframes.boss["uf_boss_height"])/2
		local p2 = p1+LolzenUIcfg.unitframes.boss["uf_boss_height"]
		self.Castbar.Icon:SetTexCoord(0.1, 0.9, 1/(LolzenUIcfg.unitframes.boss["uf_boss_cb_icon_size"]/p1), 0.9/(0.1+(LolzenUIcfg.unitframes.boss["uf_boss_cb_icon_size"]/p2)))
	else
		self.Castbar.Icon:SetHeight(LolzenUIcfg.unitframes.boss["uf_boss_cb_icon_size"])
		self.Castbar.Icon:SetTexCoord(.07, .93, .07, .93)

		self.Castbar.Shield:SetSize(self.Castbar.Icon:GetWidth()*3, self.Castbar.Icon:GetHeight()*3)
		self.Castbar.Shield:SetPoint("CENTER", self.Castbar.Icon, 0, 0)
	end

	self.Castbar.Icon:SetWidth(LolzenUIcfg.unitframes.boss["uf_boss_cb_icon_size"])
	self.Castbar.Icon:SetPoint(LolzenUIcfg.unitframes.boss["uf_boss_cb_icon_anchor1"], self.Castbar, LolzenUIcfg.unitframes.boss["uf_boss_cb_icon_anchor2"], LolzenUIcfg.unitframes.boss["uf_boss_cb_icon_posx"], LolzenUIcfg.unitframes.boss["uf_boss_cb_icon_posy"])

	self.Castbar.Time:SetPoint(LolzenUIcfg.unitframes.boss["uf_boss_cb_time_anchor1"], self.Castbar.Icon, LolzenUIcfg.unitframes.boss["uf_boss_cb_time_anchor2"], LolzenUIcfg.unitframes.boss["uf_boss_cb_time_posx"], LolzenUIcfg.unitframes.boss["uf_boss_cb_time_posy"])
	self.Castbar.Time:SetFont(LSM:Fetch("font", LolzenUIcfg.unitframes.boss["uf_boss_cb_font"]), LolzenUIcfg.unitframes.boss["uf_boss_cb_font_size"], LolzenUIcfg.unitframes.boss["uf_boss_cb_font_flag"])
	self.Castbar.Time:SetTextColor(LolzenUIcfg.unitframes.boss["uf_boss_cb_font_color"][1], LolzenUIcfg.unitframes.boss["uf_boss_cb_font_color"][2], LolzenUIcfg.unitframes.boss["uf_boss_cb_font_color"][3])

	self.Castbar.Text:SetPoint(LolzenUIcfg.unitframes.boss["uf_boss_cb_text_anchor1"], self.Castbar, LolzenUIcfg.unitframes.boss["uf_boss_cb_text_anchor2"], LolzenUIcfg.unitframes.boss["uf_boss_cb_text_posx"], LolzenUIcfg.unitframes.boss["uf_boss_cb_text_posy"])
	self.Castbar.Text:SetFont(LSM:Fetch("font", LolzenUIcfg.unitframes.boss["uf_boss_cb_font"]), LolzenUIcfg.unitframes.boss["uf_boss_cb_font_size"], LolzenUIcfg.unitframes.boss["uf_boss_cb_font_flag"])
	self.Castbar.Text:SetTextColor(LolzenUIcfg.unitframes.boss["uf_boss_cb_font_color"][1], LolzenUIcfg.unitframes.boss["uf_boss_cb_font_color"][2], LolzenUIcfg.unitframes.boss["uf_boss_cb_font_color"][3])

	ns.AddInfoPanel(self, unit)
	self.Level:SetPoint("LEFT", self.Health, "LEFT", 2, -18)
	self.Name:SetPoint("RIGHT", self.Health, "RIGHT", -2, -18)

	ns.AddRaidMark(self, unit)

	ns.SetUFBossSize = function()
		for i, v in pairs(oUF.objects) do
			if v.origUnit == "boss1" or v.origUnit == "boss2" or v.origUnit == "boss3" or v.origUnit == "boss4" or v.origUnit == "boss5" then
				v:SetSize(LolzenUIcfg.unitframes.boss["uf_boss_width"], LolzenUIcfg.unitframes.boss["uf_boss_height"])
			end
		end
	end

	ns.SetUFBossOwnFont = function()
		if LolzenUIcfg.unitframes.boss["uf_boss_use_own_hp_font_settings"] == true then
			for i, v in pairs(oUF.objects) do
				if v.origUnit == "boss1" or v.origUnit == "boss2" or v.origUnit == "boss3" or v.origUnit == "boss4" or v.origUnit == "boss5" then
					v.Health.value:SetFont(LSM:Fetch("font", LolzenUIcfg.unitframes.boss["uf_boss_hp_font"]), LolzenUIcfg.unitframes.boss["uf_boss_hp_font_size"], LolzenUIcfg.unitframes.boss["uf_boss_hp_font_flag"])
					v.Health.value:ClearAllPoints()
					v.Health.value:SetPoint(LolzenUIcfg.unitframes.boss["uf_boss_hp_anchor"], LolzenUIcfg.unitframes.boss["uf_boss_hp_posx"], LolzenUIcfg.unitframes.boss["uf_boss_hp_posy"])
				end
			end
		else
			for i, v in pairs(oUF.objects) do
				if v.origUnit == "boss1" or v.origUnit == "boss2" or v.origUnit == "boss3" or v.origUnit == "boss4" or v.origUnit == "boss5" then
					v.Health.value:SetFont(LSM:Fetch("font", LolzenUIcfg.unitframes.general["uf_general_hp_font"]), LolzenUIcfg.unitframes.general["uf_general_hp_font_size"], LolzenUIcfg.unitframes.general["uf_general_hp_font_flag"])
					v.Health.value:ClearAllPoints()
					v.Health.value:SetPoint(LolzenUIcfg.unitframes.general["uf_general_hp_anchor"], LolzenUIcfg.unitframes.general["uf_general_hp_posx"], LolzenUIcfg.unitframes.general["uf_general_hp_posy"])
				end
			end
		end
	end

	ns.SetUFBossHPFont = function()
		if LolzenUIcfg.unitframes.boss["uf_boss_use_own_hp_font_settings"] == true then
			for i, v in pairs(oUF.objects) do
				if v.origUnit == "boss1" or v.origUnit == "boss2" or v.origUnit == "boss3" or v.origUnit == "boss4" or v.origUnit == "boss5" then
					v.Health.value:SetFont(LSM:Fetch("font", LolzenUIcfg.unitframes.boss["uf_boss_hp_font"]), LolzenUIcfg.unitframes.boss["uf_boss_hp_font_size"], LolzenUIcfg.unitframes.boss["uf_boss_hp_font_flag"])
				end
			end
		end
	end

	ns.SetUFBossHPPos = function()
		if LolzenUIcfg.unitframes.boss["uf_boss_use_own_hp_font_settings"] == true then
			for i, v in pairs(oUF.objects) do
				if v.origUnit == "boss1" or v.origUnit == "boss2" or v.origUnit == "boss3" or v.origUnit == "boss4" or v.origUnit == "boss5" then
					v.Health.value:ClearAllPoints()
					v.Health.value:SetPoint(LolzenUIcfg.unitframes.boss["uf_boss_hp_anchor"], LolzenUIcfg.unitframes.boss["uf_boss_hp_posx"], LolzenUIcfg.unitframes.boss["uf_boss_hp_posy"])
				end
			end
		end
	end

	ns.SetUFBossPowerToggle = function()
		if LolzenUIcfg.unitframes.boss["uf_boss_show_power"] == true then
			for i, v in pairs(oUF.objects) do
				if v.origUnit == "boss1" or v.origUnit == "boss2" or v.origUnit == "boss3" or v.origUnit == "boss4" or v.origUnit == "boss5" then
					v.Power:SetAlpha(1)
					v.Power.value:SetAlpha(1)
				end
			end
		else
			for i, v in pairs(oUF.objects) do
				if v.origUnit == "boss1" or v.origUnit == "boss2" or v.origUnit == "boss3" or v.origUnit == "boss4" or v.origUnit == "boss5" then
					v.Power:SetAlpha(0)
					v.Power.value:SetAlpha(0)
				end
			end
		end
	end

	ns.SetUFBossPowerFont = function()
		for i, v in pairs(oUF.objects) do
			if v.origUnit == "boss1" or v.origUnit == "boss2" or v.origUnit == "boss3" or v.origUnit == "boss4" or v.origUnit == "boss5" then
				v.Power.value:SetFont(LSM:Fetch("font", LolzenUIcfg.unitframes.boss["uf_boss_pp_font"]), LolzenUIcfg.unitframes.boss["uf_boss_pp_font_size"], LolzenUIcfg.unitframes.boss["uf_boss_pp_font_flag"])
			end
		end
	end

	ns.SetUFBossPowerPos = function()
		for i, v in pairs(oUF.objects) do
			if v.origUnit == "boss1" or v.origUnit == "boss2" or v.origUnit == "boss3" or v.origUnit == "boss4" or v.origUnit == "boss5" then
				v.Power.value:ClearAllPoints()
				if LolzenUIcfg.unitframes.boss["uf_boss_pp_parent"] == "hp" then
					v.Power.value:SetPoint(LolzenUIcfg.unitframes.boss["uf_boss_pp_anchor"], v.Health.value, LolzenUIcfg.unitframes.boss["uf_boss_pp_anchor2"], LolzenUIcfg.unitframes.boss["uf_boss_pp_posx"], LolzenUIcfg.unitframes.boss["uf_boss_pp_posy"])
				elseif LolzenUIcfg.unitframes.boss["uf_boss_pp_parent"] == "self" then
					v.Power.value:SetPoint(LolzenUIcfg.unitframes.boss["uf_boss_pp_anchor"], v, LolzenUIcfg.unitframes.boss["uf_boss_pp_anchor2"], LolzenUIcfg.unitframes.boss["uf_boss_pp_posx"], LolzenUIcfg.unitframes.boss["uf_boss_pp_posy"])
				end
			end
		end
	end

	ns.SetUFBossAuraType = function()
		if LolzenUIcfg.unitframes.boss["uf_boss_aura_show_type"] == "Buffs" then
			for i, v in pairs(oUF.objects) do
				if v.origUnit == "boss1" or v.origUnit == "boss2" or v.origUnit == "boss3" or v.origUnit == "boss4" or v.origUnit == "boss5" then
					v.Buffs:SetPoint(LolzenUIcfg.unitframes.boss["uf_boss_aura_anchor1"], v, LolzenUIcfg.unitframes.boss["uf_boss_aura_anchor2"], LolzenUIcfg.unitframes.boss["uf_boss_aura_posx"], LolzenUIcfg.unitframes.boss["uf_boss_aura_posy"])
					v.Buffs.numBuffs = LolzenUIcfg.unitframes.boss["uf_boss_aura_maxnum"]
					if LolzenUIcfg.unitframes.boss["uf_boss_aura_show_only_player"] == true then
						v.Buffs.onlyShowPlayer = true
					end
					v.Buffs["growth-x"] = LolzenUIcfg.unitframes.boss["uf_boss_aura_growth_x"]
					v.Buffs["growth-y"] = LolzenUIcfg.unitframes.boss["uf_boss_aura_growth_y"]
					v.Debuffs:Hide()
					v.Auras:Hide()
					v.Buffs:Show()
				end
			end
		elseif LolzenUIcfg.unitframes.boss["uf_boss_aura_show_type"] == "Debuffs" then
			for i, v in pairs(oUF.objects) do
				if v.origUnit == "boss1" or v.origUnit == "boss2" or v.origUnit == "boss3" or v.origUnit == "boss4" or v.origUnit == "boss5" then
					v.Debuffs:SetPoint(LolzenUIcfg.unitframes.boss["uf_boss_aura_anchor1"], v, LolzenUIcfg.unitframes.boss["uf_boss_aura_anchor2"], LolzenUIcfg.unitframes.boss["uf_boss_aura_posx"], LolzenUIcfg.unitframes.boss["uf_boss_aura_posy"])
					v.Debuffs.numDebuffs = LolzenUIcfg.unitframes.boss["uf_boss_aura_maxnum"]
					if LolzenUIcfg.unitframes.boss["uf_boss_aura_show_only_player"] == true then
						v.Debuffs.onlyShowPlayer = true
					end
					v.Debuffs["growth-x"] = LolzenUIcfg.unitframes.boss["uf_boss_aura_growth_x"]
					v.Debuffs["growth-y"] = LolzenUIcfg.unitframes.boss["uf_boss_aura_growth_y"]
					v.Buffs:Hide()
					v.Auras:Hide()
					v.Debuffs:Show()
				end
			end
		elseif LolzenUIcfg.unitframes.boss["uf_boss_aura_show_type"] == "Both" then
			for i, v in pairs(oUF.objects) do
				if v.origUnit == "boss1" or v.origUnit == "boss2" or v.origUnit == "boss3" or v.origUnit == "boss4" or v.origUnit == "boss5" then
					v.Auras:SetPoint(LolzenUIcfg.unitframes.boss["uf_boss_aura_anchor1"], v, LolzenUIcfg.unitframes.boss["uf_boss_aura_anchor2"], LolzenUIcfg.unitframes.boss["uf_boss_aura_posx"], LolzenUIcfg.unitframes.boss["uf_boss_aura_posy"])
					v.Auras.numTotal = LolzenUIcfg.unitframes.boss["uf_boss_aura_maxnum"]
					if LolzenUIcfg.unitframes.boss["uf_boss_aura_show_only_player"] == true then
						v.Auras.onlyShowPlayer = true
					end
					v.Auras["growth-x"] = LolzenUIcfg.unitframes.boss["uf_boss_aura_growth_x"]
					v.Auras["growth-y"] = LolzenUIcfg.unitframes.boss["uf_boss_aura_growth_y"]
					v.Buffs:Hide()
					v.Debuffs:Hide()
					v.Auras:Show()
				end
			end
		else
			for i, v in pairs(oUF.objects) do
				if v.origUnit == "boss1" or v.origUnit == "boss2" or v.origUnit == "boss3" or v.origUnit == "boss4" or v.origUnit == "boss5" then
					v.Buffs:Hide()
					v.Debuffs:Hide()
					v.Auras:Hide()
				end
			end
		end
	end

	ns.SetUFBossAuraNum = function()
		for i, v in pairs(oUF.objects) do
			if v.origUnit == "boss1" or v.origUnit == "boss2" or v.origUnit == "boss3" or v.origUnit == "boss4" or v.origUnit == "boss5" then
				v.Buffs.num = LolzenUIcfg.unitframes.boss["uf_boss_aura_maxnum"]
				v.Debuffs.num = LolzenUIcfg.unitframes.boss["uf_boss_aura_maxnum"]
				v.Auras.numTotal = LolzenUIcfg.unitframes.boss["uf_boss_aura_maxnum"]
				v:UpdateAllElements('RefreshUnit')
			end
		end
	end

	ns.SetUFBossAuraSpacing = function()
		for i, v in pairs(oUF.objects) do
			if v.origUnit == "boss1" or v.origUnit == "boss2" or v.origUnit == "boss3" or v.origUnit == "boss4" or v.origUnit == "boss5" then
				v.Buffs.spacing = LolzenUIcfg.unitframes.boss["uf_boss_aura_spacing"]
				v.Debuffs.spacing = LolzenUIcfg.unitframes.boss["uf_boss_aura_spacing"]
				v.Auras.spacing = LolzenUIcfg.unitframes.boss["uf_boss_aura_spacing"]
				v.Buffs:ForceUpdate()
				v.Debuffs:ForceUpdate()
				v.Auras:ForceUpdate()
			end
		end
	end

	ns.SetUFBossAuraSize = function()
		for i, v in pairs(oUF.objects) do
			if v.origUnit == "boss1" or v.origUnit == "boss2" or v.origUnit == "boss3" or v.origUnit == "boss4" or v.origUnit == "boss5" then
				v.Buffs.size = LolzenUIcfg.unitframes.boss["uf_boss_aura_size"]
				v.Debuffs.size = LolzenUIcfg.unitframes.boss["uf_boss_aura_size"]
				v.Auras.size = LolzenUIcfg.unitframes.boss["uf_boss_aura_size"]
				v:UpdateAllElements('RefreshUnit')
			end
		end
	end

	ns.SetUFBossAuraPos = function()
		for i, v in pairs(oUF.objects) do
			if v.origUnit == "boss1" or v.origUnit == "boss2" or v.origUnit == "boss3" or v.origUnit == "boss4" or v.origUnit == "boss5" then
				v.Buffs:ClearAllPoints()
				v.Debuffs:ClearAllPoints()
				v.Auras:ClearAllPoints()
				v.Buffs:SetPoint(LolzenUIcfg.unitframes.boss["uf_boss_aura_anchor1"], v, LolzenUIcfg.unitframes.boss["uf_boss_aura_anchor2"], LolzenUIcfg.unitframes.boss["uf_boss_aura_posx"], LolzenUIcfg.unitframes.boss["uf_boss_aura_posy"])
				v.Debuffs:SetPoint(LolzenUIcfg.unitframes.boss["uf_boss_aura_anchor1"], v, LolzenUIcfg.unitframes.boss["uf_boss_aura_anchor2"], LolzenUIcfg.unitframes.boss["uf_boss_aura_posx"], LolzenUIcfg.unitframes.boss["uf_boss_aura_posy"])
				v.Auras:SetPoint(LolzenUIcfg.unitframes.boss["uf_boss_aura_anchor1"], v, LolzenUIcfg.unitframes.boss["uf_boss_aura_anchor2"], LolzenUIcfg.unitframes.boss["uf_boss_aura_posx"], LolzenUIcfg.unitframes.boss["uf_boss_aura_posy"])
			end
		end
	end

	ns.SetUFBossAuraGrowth = function()
		for i, v in pairs(oUF.objects) do
			if v.origUnit == "boss1" or v.origUnit == "boss2" or v.origUnit == "boss3" or v.origUnit == "boss4" or v.origUnit == "boss5" then
				v.Buffs["growth-x"] = LolzenUIcfg.unitframes.boss["uf_boss_aura_growth_x"]
				v.Buffs["growth-y"] = LolzenUIcfg.unitframes.boss["uf_boss_aura_growth_y"]
				v.Debuffs["growth-x"] = LolzenUIcfg.unitframes.boss["uf_boss_aura_growth_x"]
				v.Debuffs["growth-y"] = LolzenUIcfg.unitframes.boss["uf_boss_aura_growth_y"]
				v.Auras["growth-x"] = LolzenUIcfg.unitframes.boss["uf_boss_aura_growth_x"]
				v.Auras["growth-y"] = LolzenUIcfg.unitframes.boss["uf_boss_aura_growth_y"]
				v.Buffs:ForceUpdate()
				v.Debuffs:ForceUpdate()
				v.Auras:ForceUpdate()
			end
		end
	end

	ns.SetUFBossAuraShowOnlyPlayerAuras = function()
		for i, v in pairs(oUF.objects) do
			if v.origUnit == "boss1" or v.origUnit == "boss2" or v.origUnit == "boss3" or v.origUnit == "boss4" or v.origUnit == "boss5" then
				if LolzenUIcfg.unitframes.boss["uf_boss_aura_show_only_player"] then
					v.Buffs.onlyShowPlayer = true
					v.Debuffs.onlyShowPlayer = true
					v.Auras.onlyShowPlayer = true
				else
					v.Buffs.onlyShowPlayer = false
					v.Debuffs.onlyShowPlayer = false
					v.Auras.onlyShowPlayer = false
				end
				v:UpdateAllElements('RefreshUnit')
			end
		end
	end

	ns.SetUFBossAuraDesatureNonPlayerAuras = function()
		for i, v in pairs(oUF.objects) do
			if v.origUnit == "boss1" or v.origUnit == "boss2" or v.origUnit == "boss3" or v.origUnit == "boss4" or v.origUnit == "boss5" then
				v.Auras.PostUpdateIcon(v.Auras)
				v.Auras:ForceUpdate()
			end
		end
	end

	ns.SetUFBossCBColor = function()
		for i, v in pairs(oUF.objects) do
			if v.origUnit == "boss1" or v.origUnit == "boss2" or v.origUnit == "boss3" or v.origUnit == "boss4" or v.origUnit == "boss5" then
				v.Castbar:SetStatusBarColor(LolzenUIcfg.unitframes.boss["uf_boss_cb_color"][1], LolzenUIcfg.unitframes.boss["uf_boss_cb_color"][2], LolzenUIcfg.unitframes.boss["uf_boss_cb_color"][3], LolzenUIcfg.unitframes.boss["uf_boss_cb_alpha"])
			end
		end
	end

	ns.SetUFBossCBIconPos = function()
		for i, v in pairs(oUF.objects) do
			if v.origUnit == "boss1" or v.origUnit == "boss2" or v.origUnit == "boss3" or v.origUnit == "boss4" or v.origUnit == "boss5" then
				v.Castbar.Icon:ClearAllPoints()
				v.Castbar.Icon:SetPoint(LolzenUIcfg.unitframes.boss["uf_boss_cb_icon_anchor1"], self.Castbar, LolzenUIcfg.unitframes.boss["uf_boss_cb_icon_anchor2"], LolzenUIcfg.unitframes.boss["uf_boss_cb_icon_posx"], LolzenUIcfg.unitframes.boss["uf_boss_cb_icon_posy"])
			end
		end
	end

	ns.SetUFBossCBIconCutAndSize = function()
		for i, v in pairs(oUF.objects) do
			if v.origUnit == "boss1" or v.origUnit == "boss2" or v.origUnit == "boss3" or v.origUnit == "boss4" or v.origUnit == "boss5" then
				v.Castbar.Icon:SetWidth(LolzenUIcfg.unitframes.boss["uf_boss_cb_icon_size"])
				if LolzenUIcfg.unitframes.boss["uf_boss_cb_icon_cut"] == true then
					v.Castbar.Icon:SetHeight(LolzenUIcfg.unitframes.boss["uf_boss_height"])
					-- Get the % point of the texture to show
					-- We calculate the percentage of the icon which has to be cut, depending on icon size, and unitframe size which are both variables
					local p1 = (LolzenUIcfg.unitframes.boss["uf_boss_cb_icon_size"]-LolzenUIcfg.unitframes.boss["uf_boss_height"])/2
					local p2 = p1+LolzenUIcfg.unitframes.boss["uf_boss_height"]
					v.Castbar.Icon:SetTexCoord(0.1, 0.9, 1/(LolzenUIcfg.unitframes.boss["uf_boss_cb_icon_size"]/p1), 0.9/(0.1+(LolzenUIcfg.unitframes.boss["uf_boss_cb_icon_size"]/p2)))
				else
					v.Castbar.Icon:SetHeight(LolzenUIcfg.unitframes.boss["uf_boss_cb_icon_size"])
					v.Castbar.Icon:SetTexCoord(.07, .93, .07, .93)
				end
			end
		end
	end

	ns.SetUFBossCBTimePos = function()
		for i, v in pairs(oUF.objects) do
			if v.origUnit == "boss1" or v.origUnit == "boss2" or v.origUnit == "boss3" or v.origUnit == "boss4" or v.origUnit == "boss5" then
				v.Castbar.Text:ClearAllPoints()
				v.Castbar.Time:SetPoint(LolzenUIcfg.unitframes.boss["uf_boss_cb_time_anchor1"], self.Castbar.Icon, LolzenUIcfg.unitframes.boss["uf_boss_cb_time_anchor2"], LolzenUIcfg.unitframes.boss["uf_boss_cb_time_posx"], LolzenUIcfg.unitframes.boss["uf_boss_cb_time_posy"])
			end
		end
	end

	ns.SetUFBossCBTextPos = function()
		for i, v in pairs(oUF.objects) do
			if v.origUnit == "boss1" or v.origUnit == "boss2" or v.origUnit == "boss3" or v.origUnit == "boss4" or v.origUnit == "boss5" then
				v.Castbar.Text:ClearAllPoints()
				v.Castbar.Text:SetPoint(LolzenUIcfg.unitframes.boss["uf_boss_cb_text_anchor1"], self.Castbar, LolzenUIcfg.unitframes.boss["uf_boss_cb_text_anchor2"], LolzenUIcfg.unitframes.boss["uf_boss_cb_text_posx"], LolzenUIcfg.unitframes.boss["uf_boss_cb_text_posy"])
			end
		end
	end

	ns.SetUFBossCBTextFont = function()
		for i, v in pairs(oUF.objects) do
			if v.origUnit == "boss1" or v.origUnit == "boss2" or v.origUnit == "boss3" or v.origUnit == "boss4" or v.origUnit == "boss5" then
				v.Castbar.Text:SetFont(LSM:Fetch("font", LolzenUIcfg.unitframes.boss["uf_boss_cb_font"]), LolzenUIcfg.unitframes.boss["uf_boss_cb_font_size"], LolzenUIcfg.unitframes.boss["uf_boss_cb_font_flag"])
				v.Castbar.Time:SetFont(LSM:Fetch("font", LolzenUIcfg.unitframes.boss["uf_boss_cb_font"]), LolzenUIcfg.unitframes.boss["uf_boss_cb_font_size"], LolzenUIcfg.unitframes.boss["uf_boss_cb_font_flag"])
			end
		end
	end

	ns.SetUFBossCBTextColor = function()
		for i, v in pairs(oUF.objects) do
			if v.origUnit == "boss1" or v.origUnit == "boss2" or v.origUnit == "boss3" or v.origUnit == "boss4" or v.origUnit == "boss5" then
				v.Castbar.Text:SetTextColor(LolzenUIcfg.unitframes.boss["uf_boss_cb_font_color"][1], LolzenUIcfg.unitframes.boss["uf_boss_cb_font_color"][2], LolzenUIcfg.unitframes.boss["uf_boss_cb_font_color"][3])
				v.Castbar.Time:SetTextColor(LolzenUIcfg.unitframes.boss["uf_boss_cb_font_color"][1], LolzenUIcfg.unitframes.boss["uf_boss_cb_font_color"][2], LolzenUIcfg.unitframes.boss["uf_boss_cb_font_color"][3])
			end
		end
	end
end