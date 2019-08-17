local _, ns = ...
local LSM = LibStub("LibSharedMedia-3.0")

ns.SetupBoss = function(self, unit)
	ns.shared(self, unit)

	self:SetSize(LolzenUIcfg.unitframes.boss["uf_boss_width"], LolzenUIcfg.unitframes.boss["uf_boss_height"])

	if LolzenUIcfg.unitframes.boss["uf_boss_use_own_hp_font_settings"] == true then
		self.Health.value:SetFont(LSM:Fetch("font", LolzenUIcfg.unitframes.boss["uf_boss_hp_font"]), LolzenUIcfg.unitframes.boss["uf_boss_hp_font_size"], LolzenUIcfg.unitframes.boss["uf_boss_hp_font_flag"])
		self.Health.value:SetPoint(LolzenUIcfg.unitframes.boss["uf_boss_hp_anchor"], LolzenUIcfg.unitframes.boss["uf_boss_hp_posx"], LolzenUIcfg.unitframes.boss["uf_boss_hp_posy"])
	end

	self.Border:SetPoint("TOPLEFT", self, -3, 3)
	self.Border:SetPoint("BOTTOMRIGHT", self, 3, -2)

	if LolzenUIcfg.unitframes.boss["uf_boss_show_power"] == true then
		ns.AddPowerPoints(self, unit)
		if LolzenUIcfg.unitframes.boss["uf_boss_pp_parent"] == "hp" then
			self.Power.value:SetPoint(LolzenUIcfg.unitframes.boss["uf_boss_pp_anchor"], self.Health.value, LolzenUIcfg.unitframes.boss["uf_boss_pp_anchor2"], LolzenUIcfg.unitframes.boss["uf_boss_pp_posx"], LolzenUIcfg.unitframes.boss["uf_boss_pp_posy"])
		elseif LolzenUIcfg.unitframes.boss["uf_boss_pp_parent"] == "self" then
			self.Power.value:SetPoint(LolzenUIcfg.unitframes.boss["uf_boss_pp_anchor"], self, LolzenUIcfg.unitframes.boss["uf_boss_pp_anchor2"], LolzenUIcfg.unitframes.boss["uf_boss_pp_posx"], LolzenUIcfg.unitframes.boss["uf_boss_pp_posy"])
		end
		self.Power.value:SetFont(LSM:Fetch("font", LolzenUIcfg.unitframes.boss["uf_boss_pp_font"]), LolzenUIcfg.unitframes.boss["uf_boss_pp_font_size"], LolzenUIcfg.unitframes.boss["uf_boss_pp_font_flag"])
	end

	if LolzenUIcfg.unitframes.boss["uf_boss_aura_show_type"] == "Buffs" then
		ns.AddBuffs(self, unit)
		self.Buffs:SetPoint(LolzenUIcfg.unitframes.boss["uf_boss_aura_anchor1"], self, LolzenUIcfg.unitframes.boss["uf_boss_aura_anchor2"], LolzenUIcfg.unitframes.boss["uf_boss_aura_posx"], LolzenUIcfg.unitframes.boss["uf_boss_aura_posy"])
		self.Buffs.numBuffs = LolzenUIcfg.unitframes.boss["uf_boss_aura_maxnum"]
		if LolzenUIcfg.unitframe.bosss["uf_boss_aura_show_only_player"] == true then
			self.Buffs.onlyShowPlayer = true
		end
		--self.Buffs.showBuffType = true
		self.Buffs["growth-x"] = LolzenUIcfg.unitframes.boss["uf_boss_aura_growth_x"]
		self.Buffs["growth-y"] = LolzenUIcfg.unitframes.boss["uf_boss_aura_growth_y"]
	elseif LolzenUIcfg.unitframes.boss["uf_boss_aura_show_type"] == "Debuffs" then
		ns.AddDebuffs(self, unit)
		self.Debuffs:SetPoint(LolzenUIcfg.unitframes.boss["uf_boss_aura_anchor1"], self, LolzenUIcfg.unitframes.boss["uf_boss_aura_anchor2"], LolzenUIcfg.unitframes.boss["uf_boss_aura_posx"], LolzenUIcfg.unitframes.boss["uf_boss_aura_posy"])
		self.Debuffs.numDebuffs = LolzenUIcfg.unitframes.boss["uf_boss_aura_maxnum"]
		if LolzenUIcfg.unitframes.boss["uf_boss_aura_show_only_player"] == true then
			self.Debuffs.onlyShowPlayer = true
		end
		--self.Debuffs.showDebuffType = true
		self.Debuffs["growth-x"] = LolzenUIcfg.unitframes.boss["uf_boss_aura_growth_x"]
		self.Debuffs["growth-y"] = LolzenUIcfg.unitframes.boss["uf_boss_aura_growth_y"]
	elseif LolzenUIcfg.unitframes.boss["uf_boss_aura_show_type"] == "Both" then
		ns.AddAuras(self, unit)
		self.Auras:SetPoint(LolzenUIcfg.unitframes.boss["uf_boss_aura_anchor1"], self, LolzenUIcfg.unitframes.boss["uf_boss_aura_anchor2"], LolzenUIcfg.unitframes.boss["uf_boss_aura_posx"], LolzenUIcfg.unitframes.boss["uf_boss_aura_posy"])
		self.Auras.numTotal = LolzenUIcfg.unitframes.boss["uf_boss_aura_maxnum"]
		if LolzenUIcfg.unitframes.boss["uf_boss_aura_show_only_player"] == true then
			self.Auras.onlyShowPlayer = true
		end
		--self.Auras.showBuffType = true
		--self.Auras.showDebuffType = true
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
end