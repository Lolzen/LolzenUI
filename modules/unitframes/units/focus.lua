local _, ns = ...
local LSM = LibStub("LibSharedMedia-3.0")

ns.SetupFocus = function(self, unit)
	ns.shared(self, unit)

	self:SetSize(LolzenUIcfg.unitframes.focus["uf_focus_width"], LolzenUIcfg.unitframes.focus["uf_focus_height"])

	if LolzenUIcfg.unitframes.focus["uf_focus_use_own_hp_font_settings"] == true then
		self.Health.value:SetFont(LSM:Fetch("font", LolzenUIcfg.unitframes.focus["uf_focus_hp_font"]), LolzenUIcfg.unitframes.focus["uf_focus_hp_font_size"], LolzenUIcfg.unitframes.focus["uf_focus_hp_font_flag"])
		self.Health.value:SetPoint(LolzenUIcfg.unitframes.focus["uf_focus_hp_anchor"], LolzenUIcfg.unitframes.focus["uf_focus_hp_posx"], LolzenUIcfg.unitframes.focus["uf_focus_hp_posy"])
	end

	self.Border:SetPoint("TOPLEFT", self, -3, 3)
	self.Border:SetPoint("BOTTOMRIGHT", self, 3, -2)

	ns.AddPowerBar(self, unit)
	ns.AddPowerPoints(self, unit)
	if LolzenUIcfg.unitframes.focus["uf_focus_pp_parent"] == "hp" then
		self.Power.value:SetPoint(LolzenUIcfg.unitframes.focus["uf_focus_pp_anchor"], self.Health.value, LolzenUIcfg.unitframes.focus["uf_focus_pp_anchor2"], LolzenUIcfg.unitframes.focus["uf_focus_pp_posx"], LolzenUIcfg.unitframes.focus["uf_focus_pp_posy"])
	elseif LolzenUIcfg.unitframes.focus["uf_focus_pp_parent"] == "self" then
		self.Power.value:SetPoint(LolzenUIcfg.unitframes.focus["uf_focus_pp_anchor"], self, LolzenUIcfg.unitframes.focus["uf_focus_pp_anchor2"], LolzenUIcfg.unitframes.focus["uf_focus_pp_posx"], LolzenUIcfg.unitframes.focus["uf_focus_pp_posy"])
	end
	self.Power.value:SetFont(LSM:Fetch("font", LolzenUIcfg.unitframes.focus["uf_focus_pp_font"]), LolzenUIcfg.unitframes.focus["uf_focus_pp_font_size"], LolzenUIcfg.unitframes.focus["uf_focus_pp_font_flag"])

	ns.AddBuffs(self, unit)
	ns.AddDebuffs(self, unit)
	ns.AddAuras(self, unit)

	if LolzenUIcfg.unitframes.focus["uf_focus_aura_show_type"] == "Buffs" then
		self.Buffs:SetPoint(LolzenUIcfg.unitframes.focus["uf_focus_aura_anchor1"], self, LolzenUIcfg.unitframes.focus["uf_focus_aura_anchor2"], LolzenUIcfg.unitframes.focus["uf_focus_aura_posx"], LolzenUIcfg.unitframes.focus["uf_focus_aura_posy"])
		self.Buffs.numBuffs = LolzenUIcfg.unitframes.focus["uf_focus_aura_maxnum"]
		if LolzenUIcfg.unitframes.focus["uf_focus_aura_show_only_player"] == true then
			self.Buffs.onlyShowPlayer = true
		end
		self.Buffs["growth-x"] = LolzenUIcfg.unitframes.focus["uf_focus_aura_growth_x"]
		self.Buffs["growth-y"] = LolzenUIcfg.unitframes.focus["uf_focus_aura_growth_y"]
	elseif LolzenUIcfg.unitframes.focus["uf_focus_aura_show_type"] == "Debuffs" then
		self.Debuffs:SetPoint(LolzenUIcfg.unitframes.focus["uf_focus_aura_anchor1"], self, LolzenUIcfg.unitframes.focus["uf_focus_aura_anchor2"], LolzenUIcfg.unitframes.focus["uf_focus_aura_posx"], LolzenUIcfg.unitframes.focus["uf_focus_aura_posy"])
		self.Debuffs.numDebuffs = LolzenUIcfg.unitframes.focus["uf_focus_aura_maxnum"]
		if LolzenUIcfg.unitframes.focus["uf_focus_aura_show_only_player"] == true then
			self.Debuffs.onlyShowPlayer = true
		end
		self.Debuffs["growth-x"] = LolzenUIcfg.unitframes.focus["uf_focus_aura_growth_x"]
		self.Debuffs["growth-y"] = LolzenUIcfg.unitframes.focus["uf_focus_aura_growth_y"]
	elseif LolzenUIcfg.unitframes.focus["uf_focus_aura_show_type"] == "Both" then
		self.Auras:SetPoint(LolzenUIcfg.unitframes.focus["uf_focus_aura_anchor1"], self, LolzenUIcfg.unitframes.focus["uf_focus_aura_anchor2"], LolzenUIcfg.unitframes.focus["uf_focus_aura_posx"], LolzenUIcfg.unitframes.focus["uf_focus_aura_posy"])
		self.Auras.numTotal = LolzenUIcfg.unitframes.focus["uf_focus_aura_maxnum"]
		if LolzenUIcfg.unitframes.focus["uf_focus_aura_show_only_player"] == true then
			self.Auras.onlyShowPlayer = true
		end
		self.Auras["growth-x"] = LolzenUIcfg.unitframes.focus["uf_focus_aura_growth_x"]
		self.Auras["growth-y"] = LolzenUIcfg.unitframes.focus["uf_focus_aura_growth_y"]
	end

	ns.AddCastBar(self, unit)
	self.Castbar:SetAllPoints(self.Health)
	self.Castbar:SetStatusBarColor(LolzenUIcfg.unitframes.focus["uf_focus_cb_color"][1], LolzenUIcfg.unitframes.focus["uf_focus_cb_color"][2], LolzenUIcfg.unitframes.focus["uf_focus_cb_color"][3], LolzenUIcfg.unitframes.focus["uf_focus_cb_alpha"])

	self.Castbar.Spark:SetSize(self:GetWidth()/27.5, self:GetHeight()*2)

	if LolzenUIcfg.unitframes.focus["uf_focus_cb_icon_cut"] == true then
		self.Castbar.Icon:SetHeight(LolzenUIcfg.unitframes.focus["uf_focus_height"])
		-- Get the % point of the texture to show
		-- We calculate the percentage of the icon which has to be cut, depending on icon size, and unitframe size which are both variables
		local p1 = (LolzenUIcfg.unitframes.focus["uf_focus_cb_icon_size"]-LolzenUIcfg.unitframes.focus["uf_focus_height"])/2
		local p2 = p1+LolzenUIcfg.unitframes.focus["uf_focus_height"]
		self.Castbar.Icon:SetTexCoord(0.1, 0.9, 1/(LolzenUIcfg.unitframes.focus["uf_focus_cb_icon_size"]/p1), 0.9/(0.1+(LolzenUIcfg.unitframes.focus["uf_focus_cb_icon_size"]/p2)))
	else
		self.Castbar.Icon:SetHeight(LolzenUIcfg.unitframes.focus["uf_focus_cb_icon_size"])
		self.Castbar.Icon:SetTexCoord(.07, .93, .07, .93)

		self.Castbar.Shield:SetSize(self.Castbar.Icon:GetWidth()*3, self.Castbar.Icon:GetHeight()*3)
		self.Castbar.Shield:SetPoint("CENTER", self.Castbar.Icon, 0, 0)
	end

	self.Castbar.Icon:SetWidth(LolzenUIcfg.unitframes.focus["uf_focus_cb_icon_size"])
	self.Castbar.Icon:SetPoint(LolzenUIcfg.unitframes.focus["uf_focus_cb_icon_anchor1"], self.Castbar, LolzenUIcfg.unitframes.focus["uf_focus_cb_icon_anchor2"], LolzenUIcfg.unitframes.focus["uf_focus_cb_icon_posx"], LolzenUIcfg.unitframes.focus["uf_focus_cb_icon_posy"])

	self.Castbar.Time:SetPoint(LolzenUIcfg.unitframes.focus["uf_focus_cb_time_anchor1"], self.Castbar.Icon, LolzenUIcfg.unitframes.focus["uf_focus_cb_time_anchor2"], LolzenUIcfg.unitframes.focus["uf_focus_cb_time_posx"], LolzenUIcfg.unitframes.focus["uf_focus_cb_time_posy"])
	self.Castbar.Time:SetFont(LSM:Fetch("font", LolzenUIcfg.unitframes.focus["uf_focus_cb_font"]), LolzenUIcfg.unitframes.focus["uf_focus_cb_font_size"], LolzenUIcfg.unitframes.focus["uf_focus_cb_font_flag"])
	self.Castbar.Time:SetTextColor(LolzenUIcfg.unitframes.focus["uf_focus_cb_font_color"][1], LolzenUIcfg.unitframes.focus["uf_focus_cb_font_color"][2], LolzenUIcfg.unitframes.focus["uf_focus_cb_font_color"][3])

	self.Castbar.Text:SetPoint(LolzenUIcfg.unitframes.focus["uf_focus_cb_text_anchor1"], self.Castbar, LolzenUIcfg.unitframes.focus["uf_focus_cb_text_anchor2"], LolzenUIcfg.unitframes.focus["uf_focus_cb_text_posx"], LolzenUIcfg.unitframes.focus["uf_focus_cb_text_posy"])
	self.Castbar.Text:SetFont(LSM:Fetch("font", LolzenUIcfg.unitframes.focus["uf_focus_cb_font"]), LolzenUIcfg.unitframes.focus["uf_focus_cb_font_size"], LolzenUIcfg.unitframes.focus["uf_focus_cb_font_flag"])
	self.Castbar.Text:SetTextColor(LolzenUIcfg.unitframes.focus["uf_focus_cb_font_color"][1], LolzenUIcfg.unitframes.focus["uf_focus_cb_font_color"][2], LolzenUIcfg.unitframes.focus["uf_focus_cb_font_color"][3])

	ns.AddInfoPanel(self, unit)
	self.Level:SetPoint("LEFT", self.Health, "LEFT", 2, -18) 
	self.Name:SetPoint("RIGHT", self.Health, "RIGHT", -2, -18)

	ns.AddRaidMark(self, unit)

	ns.SetUFFocusSize = function()
		self:SetSize(LolzenUIcfg.unitframes.focus["uf_focus_width"], LolzenUIcfg.unitframes.focus["uf_focus_height"])
	end

	ns.SetUFFocusOwnFont = function()
		if LolzenUIcfg.unitframes.focus["uf_focus_use_own_hp_font_settings"] == true then
			self.Health.value:SetFont(LSM:Fetch("font", LolzenUIcfg.unitframes.focus["uf_focus_hp_font"]), LolzenUIcfg.unitframes.focus["uf_focus_hp_font_size"], LolzenUIcfg.unitframes.focus["uf_focus_hp_font_flag"])
			self.Health.value:ClearAllPoints()
			self.Health.value:SetPoint(LolzenUIcfg.unitframes.focus["uf_focus_hp_anchor"], LolzenUIcfg.unitframes.focus["uf_focus_hp_posx"], LolzenUIcfg.unitframes.focus["uf_focus_hp_posy"])
		else
			self.Health.value:SetFont(LSM:Fetch("font", LolzenUIcfg.unitframes.general["uf_general_hp_font"]), LolzenUIcfg.unitframes.general["uf_general_hp_font_size"], LolzenUIcfg.unitframes.general["uf_general_hp_font_flag"])
			self.Health.value:ClearAllPoints()
			self.Health.value:SetPoint(LolzenUIcfg.unitframes.general["uf_general_hp_anchor"], LolzenUIcfg.unitframes.general["uf_general_hp_posx"], LolzenUIcfg.unitframes.general["uf_general_hp_posy"])
		end
	end

	ns.SetUFFocusHPFont = function()
		if LolzenUIcfg.unitframes.focus["uf_focus_use_own_hp_font_settings"] == true then
			self.Health.value:SetFont(LSM:Fetch("font", LolzenUIcfg.unitframes.focus["uf_focus_hp_font"]), LolzenUIcfg.unitframes.focus["uf_focus_hp_font_size"], LolzenUIcfg.unitframes.focus["uf_focus_hp_font_flag"])
		end
	end

	ns.SetUFFocusHPPos = function()
		if LolzenUIcfg.unitframes.focus["uf_focus_use_own_hp_font_settings"] == true then
			self.Health.value:ClearAllPoints()
			self.Health.value:SetPoint(LolzenUIcfg.unitframes.focus["uf_focus_hp_anchor"], LolzenUIcfg.unitframes.focus["uf_focus_hp_posx"], LolzenUIcfg.unitframes.focus["uf_focus_hp_posy"])
		end
	end

	ns.SetUFFocusPowerFont = function()
		self.Power.value:SetFont(LSM:Fetch("font", LolzenUIcfg.unitframes.focus["uf_focus_pp_font"]), LolzenUIcfg.unitframes.focus["uf_focus_pp_font_size"], LolzenUIcfg.unitframes.focus["uf_focus_pp_font_flag"])
	end

	ns.SetUFFocusPowerPos = function()
		self.Power.value:ClearAllPoints()
		if LolzenUIcfg.unitframes.focus["uf_focus_pp_parent"] == "hp" then
			self.Power.value:SetPoint(LolzenUIcfg.unitframes.focus["uf_focus_pp_anchor"], self.Health.value, LolzenUIcfg.unitframes.focus["uf_focus_pp_anchor2"], LolzenUIcfg.unitframes.focus["uf_focus_pp_posx"], LolzenUIcfg.unitframes.focus["uf_focus_pp_posy"])
		elseif LolzenUIcfg.unitframes.focus["uf_focus_pp_parent"] == "self" then
			self.Power.value:SetPoint(LolzenUIcfg.unitframes.focus["uf_focus_pp_anchor"], self, LolzenUIcfg.unitframes.focus["uf_focus_pp_anchor2"], LolzenUIcfg.unitframes.focus["uf_focus_pp_posx"], LolzenUIcfg.unitframes.focus["uf_focus_pp_posy"])
		end
	end

	ns.SetUFFocusAuraType = function()
		if LolzenUIcfg.unitframes.focus["uf_focus_aura_show_type"] == "Buffs" then
			self.Buffs:SetPoint(LolzenUIcfg.unitframes.focus["uf_focus_aura_anchor1"], self, LolzenUIcfg.unitframes.focus["uf_focus_aura_anchor2"], LolzenUIcfg.unitframes.focus["uf_focus_aura_posx"], LolzenUIcfg.unitframes.focus["uf_focus_aura_posy"])
			self.Buffs.numBuffs = LolzenUIcfg.unitframes.focus["uf_focus_aura_maxnum"]
			if LolzenUIcfg.unitframes.focus["uf_focus_aura_show_only_player"] == true then
				self.Buffs.onlyShowPlayer = true
			end
			self.Buffs["growth-x"] = LolzenUIcfg.unitframes.focus["uf_focus_aura_growth_x"]
			self.Buffs["growth-y"] = LolzenUIcfg.unitframes.focus["uf_focus_aura_growth_y"]
			self.Debuffs:Hide()
			self.Auras:Hide()
			self.Buffs:Show()
		elseif LolzenUIcfg.unitframes.focus["uf_focus_aura_show_type"] == "Debuffs" then
			self.Debuffs:SetPoint(LolzenUIcfg.unitframes.focus["uf_focus_aura_anchor1"], self, LolzenUIcfg.unitframes.focus["uf_focus_aura_anchor2"], LolzenUIcfg.unitframes.focus["uf_focus_aura_posx"], LolzenUIcfg.unitframes.focus["uf_focus_aura_posy"])
			self.Debuffs.numDebuffs = LolzenUIcfg.unitframes.focus["uf_focus_aura_maxnum"]
			if LolzenUIcfg.unitframes.focus["uf_focus_aura_show_only_player"] == true then
				self.Debuffs.onlyShowPlayer = true
			end
			self.Debuffs["growth-x"] = LolzenUIcfg.unitframes.focus["uf_focus_aura_growth_x"]
			self.Debuffs["growth-y"] = LolzenUIcfg.unitframes.focus["uf_focus_aura_growth_y"]
			self.Buffs:Hide()
			self.Auras:Hide()
			self.Debuffs:Show()
		elseif LolzenUIcfg.unitframes.focus["uf_focus_aura_show_type"] == "Both" then
			self.Auras:SetPoint(LolzenUIcfg.unitframes.focus["uf_focus_aura_anchor1"], self, LolzenUIcfg.unitframes.focus["uf_focus_aura_anchor2"], LolzenUIcfg.unitframes.focus["uf_focus_aura_posx"], LolzenUIcfg.unitframes.focus["uf_focus_aura_posy"])
			self.Auras.numTotal = LolzenUIcfg.unitframes.focus["uf_focus_aura_maxnum"]
			if LolzenUIcfg.unitframes.focus["uf_focus_aura_show_only_player"] == true then
				self.Auras.onlyShowPlayer = true
			end
			self.Auras["growth-x"] = LolzenUIcfg.unitframes.focus["uf_focus_aura_growth_x"]
			self.Auras["growth-y"] = LolzenUIcfg.unitframes.focus["uf_focus_aura_growth_y"]
			self.Buffs:Hide()
			self.Debuffs:Hide()
			self.Auras:Show()
		else
			self.Buffs:Hide()
			self.Debuffs:Hide()
			self.Auras:Hide()
		end
	end

	ns.SetUFFocusAuraNum = function()
		self.Buffs.num = LolzenUIcfg.unitframes.focus["uf_focus_aura_maxnum"]
		self.Debuffs.num = LolzenUIcfg.unitframes.focus["uf_focus_aura_maxnum"]
		self.Auras.numTotal = LolzenUIcfg.unitframes.focus["uf_focus_aura_maxnum"]
		self:UpdateAllElements('RefreshUnit')
	end

	ns.SetUFFocusAuraSpacing = function()
		self.Buffs.spacing = LolzenUIcfg.unitframes.focus["uf_focus_aura_spacing"]
		self.Debuffs.spacing = LolzenUIcfg.unitframes.focus["uf_focus_aura_spacing"]
		self.Auras.spacing = LolzenUIcfg.unitframes.focus["uf_focus_aura_spacing"]
		self.Buffs:ForceUpdate()
		self.Debuffs:ForceUpdate()
		self.Auras:ForceUpdate()
	end

	ns.SetUFFocusAuraSize = function()
		self.Buffs.size = LolzenUIcfg.unitframes.focus["uf_focus_aura_size"]
		self.Debuffs.size = LolzenUIcfg.unitframes.focus["uf_focus_aura_size"]
		self.Auras.size = LolzenUIcfg.unitframes.focus["uf_focus_aura_size"]
		self:UpdateAllElements('RefreshUnit')
	end

	ns.SetUFFocusAuraPos = function()
		self.Buffs:ClearAllPoints()
		self.Debuffs:ClearAllPoints()
		self.Auras:ClearAllPoints()
		self.Buffs:SetPoint(LolzenUIcfg.unitframes.focus["uf_focus_aura_anchor1"], self, LolzenUIcfg.unitframes.focus["uf_focus_aura_anchor2"], LolzenUIcfg.unitframes.focus["uf_focus_aura_posx"], LolzenUIcfg.unitframes.focus["uf_focus_aura_posy"])
		self.Debuffs:SetPoint(LolzenUIcfg.unitframes.focus["uf_focus_aura_anchor1"], self, LolzenUIcfg.unitframes.focus["uf_focus_aura_anchor2"], LolzenUIcfg.unitframes.focus["uf_focus_aura_posx"], LolzenUIcfg.unitframes.focus["uf_focus_aura_posy"])
		self.Auras:SetPoint(LolzenUIcfg.unitframes.focus["uf_focus_aura_anchor1"], self, LolzenUIcfg.unitframes.focus["uf_focus_aura_anchor2"], LolzenUIcfg.unitframes.focus["uf_focus_aura_posx"], LolzenUIcfg.unitframes.focus["uf_focus_aura_posy"])
	end

	ns.SetUFFocusAuraGrowth = function()
		self.Buffs["growth-x"] = LolzenUIcfg.unitframes.focus["uf_focus_aura_growth_x"]
		self.Buffs["growth-y"] = LolzenUIcfg.unitframes.focus["uf_focus_aura_growth_y"]
		self.Debuffs["growth-x"] = LolzenUIcfg.unitframes.focus["uf_focus_aura_growth_x"]
		self.Debuffs["growth-y"] = LolzenUIcfg.unitframes.focus["uf_focus_aura_growth_y"]
		self.Auras["growth-x"] = LolzenUIcfg.unitframes.focus["uf_focus_aura_growth_x"]
		self.Auras["growth-y"] = LolzenUIcfg.unitframes.focus["uf_focus_aura_growth_y"]
		self.Buffs:ForceUpdate()
		self.Debuffs:ForceUpdate()
		self.Auras:ForceUpdate()
	end

	ns.SetUFFocusAuraShowOnlyPlayerAuras = function()
		if LolzenUIcfg.unitframes.focus["uf_focus_aura_show_only_player"] then
			self.Buffs.onlyShowPlayer = true
			self.Debuffs.onlyShowPlayer = true
			self.Auras.onlyShowPlayer = true
		else
			self.Buffs.onlyShowPlayer = false
			self.Debuffs.onlyShowPlayer = false
			self.Auras.onlyShowPlayer = false
		end
		self:UpdateAllElements('RefreshUnit')
	end

	ns.SetUFFocusAuraDesatureNonPlayerAuras = function()
		self.Auras.PostUpdateIcon(self.Auras)
		self.Auras:ForceUpdate()
	end

	ns.SetUFFocusCBColor = function()
		self.Castbar:SetStatusBarColor(LolzenUIcfg.unitframes.focus["uf_focus_cb_color"][1], LolzenUIcfg.unitframes.focus["uf_focus_cb_color"][2], LolzenUIcfg.unitframes.focus["uf_focus_cb_color"][3], LolzenUIcfg.unitframes.focus["uf_focus_cb_alpha"])
	end

	ns.SetUFFocusCBIconPos = function()
		self.Castbar.Icon:ClearAllPoints()
		self.Castbar.Icon:SetPoint(LolzenUIcfg.unitframes.focus["uf_focus_cb_icon_anchor1"], self.Castbar, LolzenUIcfg.unitframes.focus["uf_focus_cb_icon_anchor2"], LolzenUIcfg.unitframes.focus["uf_focus_cb_icon_posx"], LolzenUIcfg.unitframes.focus["uf_focus_cb_icon_posy"])
	end

	ns.SetUFFocusCBIconCutAndSize = function()
		self.Castbar.Icon:SetWidth(LolzenUIcfg.unitframes.focus["uf_focus_cb_icon_size"])
		if LolzenUIcfg.unitframes.focus["uf_focus_cb_icon_cut"] == true then
			self.Castbar.Icon:SetHeight(LolzenUIcfg.unitframes.focus["uf_focus_height"])
			-- Get the % point of the texture to show
			-- We calculate the percentage of the icon which has to be cut, depending on icon size, and unitframe size which are both variables
			local p1 = (LolzenUIcfg.unitframes.focus["uf_focus_cb_icon_size"]-LolzenUIcfg.unitframes.focus["uf_focus_height"])/2
			local p2 = p1+LolzenUIcfg.unitframes.focus["uf_focus_height"]
			self.Castbar.Icon:SetTexCoord(0.1, 0.9, 1/(LolzenUIcfg.unitframes.focus["uf_focus_cb_icon_size"]/p1), 0.9/(0.1+(LolzenUIcfg.unitframes.focus["uf_focus_cb_icon_size"]/p2)))
		else
			self.Castbar.Icon:SetHeight(LolzenUIcfg.unitframes.focus["uf_focus_cb_icon_size"])
			self.Castbar.Icon:SetTexCoord(.07, .93, .07, .93)
		end
	end

	ns.SetUFFocusCBTimePos = function()
		self.Castbar.Text:ClearAllPoints()
		self.Castbar.Time:SetPoint(LolzenUIcfg.unitframes.focus["uf_focus_cb_time_anchor1"], self.Castbar.Icon, LolzenUIcfg.unitframes.focus["uf_focus_cb_time_anchor2"], LolzenUIcfg.unitframes.focus["uf_focus_cb_time_posx"], LolzenUIcfg.unitframes.focus["uf_focus_cb_time_posy"])
	end

	ns.SetUFFocusCBTextPos = function()
		self.Castbar.Text:ClearAllPoints()
		self.Castbar.Text:SetPoint(LolzenUIcfg.unitframes.focus["uf_focus_cb_text_anchor1"], self.Castbar, LolzenUIcfg.unitframes.focus["uf_focus_cb_text_anchor2"], LolzenUIcfg.unitframes.focus["uf_focus_cb_text_posx"], LolzenUIcfg.unitframes.focus["uf_focus_cb_text_posy"])
	end

	ns.SetUFFocusCBTextFont = function()
		self.Castbar.Text:SetFont(LSM:Fetch("font", LolzenUIcfg.unitframes.focus["uf_focus_cb_font"]), LolzenUIcfg.unitframes.focus["uf_focus_cb_font_size"], LolzenUIcfg.unitframes.focus["uf_focus_cb_font_flag"])
		self.Castbar.Time:SetFont(LSM:Fetch("font", LolzenUIcfg.unitframes.focus["uf_focus_cb_font"]), LolzenUIcfg.unitframes.focus["uf_focus_cb_font_size"], LolzenUIcfg.unitframes.focus["uf_focus_cb_font_flag"])
	end

	ns.SetUFFocusCBTextColor = function()
		self.Castbar.Text:SetTextColor(LolzenUIcfg.unitframes.focus["uf_focus_cb_font_color"][1], LolzenUIcfg.unitframes.focus["uf_focus_cb_font_color"][2], LolzenUIcfg.unitframes.focus["uf_focus_cb_font_color"][3])
		self.Castbar.Time:SetTextColor(LolzenUIcfg.unitframes.focus["uf_focus_cb_font_color"][1], LolzenUIcfg.unitframes.focus["uf_focus_cb_font_color"][2], LolzenUIcfg.unitframes.focus["uf_focus_cb_font_color"][3])
	end
end