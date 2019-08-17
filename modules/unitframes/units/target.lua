local _, ns = ...
local LSM = LibStub("LibSharedMedia-3.0")

ns.SetupTarget = function(self, unit)
	ns.shared(self, unit)

	self:SetSize(LolzenUIcfg.unitframes.target["uf_target_width"], LolzenUIcfg.unitframes.target["uf_target_height"])

	if LolzenUIcfg.unitframes.target["uf_target_use_own_hp_font_settings"] == true then
		self.Health.value:SetFont(LSM:Fetch("font", LolzenUIcfg.unitframes.target["uf_target_hp_font"]), LolzenUIcfg.unitframes.target["uf_target_hp_font_size"], LolzenUIcfg.unitframes.target["uf_target_hp_font_flag"])
		self.Health.value:SetPoint(LolzenUIcfg.unitframes.target["uf_target_hp_anchor"], LolzenUIcfg.unitframes.target["uf_target_hp_posx"], LolzenUIcfg.unitframes.target["uf_target_hp_posy"])
	end

	self.Border:SetPoint("TOPLEFT", self, -3, 3)
	self.Border:SetPoint("BOTTOMRIGHT", self, 3, -2)

	ns.AddPowerBar(self, unit)

	ns.AddPowerPoints(self, unit)
	if LolzenUIcfg.unitframes.target["uf_target_pp_parent"] == "hp" then
		self.Power.value:SetPoint(LolzenUIcfg.unitframes.target["uf_target_pp_anchor"], self.Health.value, LolzenUIcfg.unitframes.target["uf_target_pp_anchor2"], LolzenUIcfg.unitframes.target["uf_target_pp_posx"], LolzenUIcfg.unitframes.target["uf_target_pp_posy"])
	elseif LolzenUIcfg.unitframes.target["uf_target_pp_parent"] == "self" then
		self.Power.value:SetPoint(LolzenUIcfg.unitframes.target["uf_target_pp_anchor"], self, LolzenUIcfg.unitframes.target["uf_target_pp_anchor2"], LolzenUIcfg.unitframes.target["uf_target_pp_posx"], LolzenUIcfg.unitframes.target["uf_target_pp_posy"])
	end
	self.Power.value:SetFont(LSM:Fetch("font", LolzenUIcfg.unitframes.target["uf_target_pp_font"]), LolzenUIcfg.unitframes.target["uf_target_pp_font_size"], LolzenUIcfg.unitframes.target["uf_target_pp_font_flag"])

	if LolzenUIcfg.unitframes.target["uf_target_aura_show_type"] == "Buffs" then
		ns.AddBuffs(self, unit)
		self.Buffs:SetPoint(LolzenUIcfg.unitframes.target["uf_target_aura_anchor1"], self, LolzenUIcfg.unitframes.target["uf_target_aura_anchor2"], LolzenUIcfg.unitframes.target["uf_target_aura_posx"], LolzenUIcfg.unitframes.target["uf_target_aura_posy"])
		self.Buffs.numBuffs = LolzenUIcfg.unitframes.target["uf_target_aura_maxnum"]
		if LolzenUIcfg.unitframes.target["uf_target_aura_show_only_player"] == true then
			self.Buffs.onlyShowPlayer = true
		end
		--self.Buffs.showBuffType = true
		self.Buffs["growth-x"] = LolzenUIcfg.unitframes.target["uf_target_aura_growth_x"]
		self.Buffs["growth-y"] = LolzenUIcfg.unitframes.target["uf_target_aura_growth_y"]
	elseif LolzenUIcfg.unitframes.target["uf_target_aura_show_type"] == "Debuffs" then
		ns.AddDebuffs(self, unit)
		self.Debuffs:SetPoint(LolzenUIcfg.unitframes.target["uf_target_aura_anchor1"], self, LolzenUIcfg.unitframes.target["uf_target_aura_anchor2"], LolzenUIcfg.unitframes.target["uf_target_aura_posx"], LolzenUIcfg.unitframes.target["uf_target_aura_posy"])
		self.Debuffs.numDebuffs = LolzenUIcfg.unitframes.target["uf_target_aura_maxnum"]
		if LolzenUIcfg.unitframes.target["uf_target_aura_show_only_player"] == true then
			self.Debuffs.onlyShowPlayer = true
		end
		--self.Debuffs.showDebuffType = true
		self.Debuffs["growth-x"] = LolzenUIcfg.unitframes.target["uf_target_aura_growth_x"]
		self.Debuffs["growth-y"] = LolzenUIcfg.unitframes.target["uf_target_aura_growth_y"]
	elseif LolzenUIcfg.unitframes.target["uf_target_aura_show_type"] == "Both" then
		ns.AddAuras(self, unit)
		self.Auras:SetPoint(LolzenUIcfg.unitframes.target["uf_target_aura_anchor1"], self, LolzenUIcfg.unitframes.target["uf_target_aura_anchor2"], LolzenUIcfg.unitframes.target["uf_target_aura_posx"], LolzenUIcfg.unitframes.target["uf_target_aura_posy"])
		self.Auras.numTotal = LolzenUIcfg.unitframes.target["uf_target_aura_maxnum"]
		if LolzenUIcfg.unitframes.target["uf_target_aura_show_only_player"] == true then
			self.Auras.onlyShowPlayer = true
		end
		--self.Auras.showBuffType = true
		--self.Auras.showDebuffType = true
		self.Auras["growth-x"] = LolzenUIcfg.unitframes.target["uf_target_aura_growth_x"]
		self.Auras["growth-y"] = LolzenUIcfg.unitframes.target["uf_target_aura_growth_y"]
	end

	ns.AddCastBar(self, unit)
	if LolzenUIcfg.unitframes.target["uf_target_cb_standalone"] == true then
		self.Castbar:SetPoint(LolzenUIcfg.unitframes.target["uf_target_cb_anchor1"], UIParent, LolzenUIcfg.unitframes.target["uf_target_cb_anchor2"], LolzenUIcfg.unitframes.target["uf_target_cb_posx"], LolzenUIcfg.unitframes.target["uf_target_cb_posy"])
		self.Castbar:SetSize(LolzenUIcfg.unitframes.target["uf_target_cb_width"], LolzenUIcfg.unitframes.target["uf_target_cb_height"])
		self.Castbar.background:SetAllPoints(self.Castbar)
		self.Castbar.border:SetPoint("TOPLEFT", self.Castbar, -2, 3)
		self.Castbar.border:SetPoint("BOTTOMRIGHT", self.Castbar, 3, -2)
	else
		self.Castbar:SetAllPoints(self.Health)
	end
	self.Castbar:SetStatusBarColor(LolzenUIcfg.unitframes.target["uf_target_cb_color"][1], LolzenUIcfg.unitframes.target["uf_target_cb_color"][2], LolzenUIcfg.unitframes.target["uf_target_cb_color"][3], LolzenUIcfg.unitframes.target["uf_target_cb_alpha"])

	self.Castbar.Spark:SetSize(self:GetWidth()/27.5, self:GetHeight()*2)

	if LolzenUIcfg.unitframes.target["uf_target_cb_icon_cut"] == true then
		self.Castbar.Icon:SetHeight(LolzenUIcfg.unitframes.target["uf_target_height"])
		-- Get the % point of the texture to show
		-- We calculate the percentage of the icon which has to be cut, depending on icon size, and unitframe size which are both variables
		local p1 = (LolzenUIcfg.unitframes.target["uf_target_cb_icon_size"]-LolzenUIcfg.unitframes.target["uf_target_height"])/2
		local p2 = p1+LolzenUIcfg.unitframes.target["uf_target_height"]
		self.Castbar.Icon:SetTexCoord(0.1, 0.9, 1/(LolzenUIcfg.unitframes.target["uf_target_cb_icon_size"]/p1), 0.9/(0.1+(LolzenUIcfg.unitframes.target["uf_target_cb_icon_size"]/p2)))
	else
		self.Castbar.Icon:SetHeight(LolzenUIcfg.unitframes.target["uf_target_cb_icon_size"])
		self.Castbar.Icon:SetTexCoord(.07, .93, .07, .93)

		self.Castbar.Shield:SetSize(self.Castbar.Icon:GetWidth()*3, self.Castbar.Icon:GetHeight()*3)
		self.Castbar.Shield:SetPoint("CENTER", self.Castbar.Icon, 0, 0)
	end

	self.Castbar.Icon:SetWidth(LolzenUIcfg.unitframes.target["uf_target_cb_icon_size"])
	self.Castbar.Icon:SetPoint(LolzenUIcfg.unitframes.target["uf_target_cb_icon_anchor1"], self.Castbar, LolzenUIcfg.unitframes.target["uf_target_cb_icon_anchor2"], LolzenUIcfg.unitframes.target["uf_target_cb_icon_posx"], LolzenUIcfg.unitframes.target["uf_target_cb_icon_posy"])

	self.Castbar.Time:SetPoint(LolzenUIcfg.unitframes.target["uf_target_cb_time_anchor1"], self.Castbar.Icon, LolzenUIcfg.unitframes.target["uf_target_cb_time_anchor2"], LolzenUIcfg.unitframes.target["uf_target_cb_time_posx"], LolzenUIcfg.unitframes.target["uf_target_cb_time_posy"])
	self.Castbar.Time:SetFont(LSM:Fetch("font", LolzenUIcfg.unitframes.target["uf_target_cb_font"]), LolzenUIcfg.unitframes.target["uf_target_cb_font_size"], LolzenUIcfg.unitframes.target["uf_target_cb_font_flag"])
	self.Castbar.Time:SetTextColor(LolzenUIcfg.unitframes.target["uf_target_cb_font_color"][1], LolzenUIcfg.unitframes.target["uf_target_cb_font_color"][2], LolzenUIcfg.unitframes.target["uf_target_cb_font_color"][3])

	self.Castbar.Text:SetPoint(LolzenUIcfg.unitframes.target["uf_target_cb_text_anchor1"], self.Castbar, LolzenUIcfg.unitframes.target["uf_target_cb_text_anchor2"], LolzenUIcfg.unitframes.target["uf_target_cb_text_posx"], LolzenUIcfg.unitframes.target["uf_target_cb_text_posy"])
	self.Castbar.Text:SetFont(LSM:Fetch("font", LolzenUIcfg.unitframes.target["uf_target_cb_font"]), LolzenUIcfg.unitframes.target["uf_target_cb_font_size"], LolzenUIcfg.unitframes.target["uf_target_cb_font_flag"])
	self.Castbar.Text:SetTextColor(LolzenUIcfg.unitframes.target["uf_target_cb_font_color"][1], LolzenUIcfg.unitframes.target["uf_target_cb_font_color"][2], LolzenUIcfg.unitframes.target["uf_target_cb_font_color"][3])

	ns.AddInfoPanel(self, unit)
	self.Level:SetPoint("LEFT", self.Health, "LEFT", 2, -23) 
	self.Name:SetPoint("RIGHT", self.Health, "RIGHT", -2, -23)

	ns.AddCombatFade(self, unit)
	ns.AddRaidMark(self, unit)
end