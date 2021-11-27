local _, ns = ...
local LSM = LibStub("LibSharedMedia-3.0")
local oUF = ns.oUF

ns.SetupArena = function(self, unit)
	ns.shared(self, unit)

	self:SetSize(LolzenUIcfg.unitframes.arena["uf_arena_width"], LolzenUIcfg.unitframes.arena["uf_arena_height"])

	if LolzenUIcfg.unitframes.arena["uf_arena_use_own_hp_font_settings"] == true then
		self.Health.value:SetFont(LSM:Fetch("font", LolzenUIcfg.unitframes.arena["uf_arena_hp_font"]), LolzenUIcfg.unitframes.arena["uf_arena_hp_font_size"], LolzenUIcfg.unitframes.arena["uf_arena_hp_font_flag"])
		self.Health.value:SetPoint(LolzenUIcfg.unitframes.arena["uf_arena_hp_anchor"], LolzenUIcfg.unitframes.arena["uf_arena_hp_posx"], LolzenUIcfg.unitframes.arena["uf_arena_hp_posy"])
	end

	self.Border:SetPoint("TOPLEFT", self, -3, 3)
	self.Border:SetPoint("BOTTOMRIGHT", self, 3, -2)

	ns.AddPowerBar(self, unit)
	ns.AddPowerPoints(self, unit)
	if LolzenUIcfg.unitframes.arena["uf_arena_pp_parent"] == "hp" then
		self.Power.value:SetPoint(LolzenUIcfg.unitframes.arena["uf_arena_pp_anchor"], self.Health.value, LolzenUIcfg.unitframes.arena["uf_arena_pp_anchor2"], LolzenUIcfg.unitframes.arena["uf_arena_pp_posx"], LolzenUIcfg.unitframes.arena["uf_arena_pp_posy"])
	elseif LolzenUIcfg.unitframes.arena["uf_arena_pp_parent"] == "self" then
		self.Power.value:SetPoint(LolzenUIcfg.unitframes.arena["uf_arena_pp_anchor"], self, LolzenUIcfg.unitframes.arena["uf_arena_pp_anchor2"], LolzenUIcfg.unitframes.arena["uf_arena_pp_posx"], LolzenUIcfg.unitframes.arena["uf_arena_pp_posy"])
	end
	self.Power.value:SetFont(LSM:Fetch("font", LolzenUIcfg.unitframes.arena["uf_arena_pp_font"]), LolzenUIcfg.unitframes.arena["uf_arena_pp_font_size"], LolzenUIcfg.unitframes.arena["uf_arena_pp_font_flag"])

	ns.AddBuffs(self, unit)
	ns.AddDebuffs(self, unit)
	ns.AddAuras(self, unit)

	if LolzenUIcfg.unitframes.arena["uf_arena_aura_show_type"] == "Buffs" then
		self.Buffs:SetPoint(LolzenUIcfg.unitframes.arena["uf_arena_aura_anchor1"], self, LolzenUIcfg.unitframes.arena["uf_arena_aura_anchor2"], LolzenUIcfg.unitframes.arena["uf_arena_aura_posx"], LolzenUIcfg.unitframes.arena["uf_arena_aura_posy"])
		self.Buffs.numBuffs = LolzenUIcfg.unitframes.arena["uf_arena_aura_maxnum"]
		if LolzenUIcfg.unitframes.arena["uf_arena_aura_show_only_player"] == true then
			self.Buffs.onlyShowPlayer = true
		end
		self.Buffs["growth-x"] = LolzenUIcfg.unitframes.arena["uf_arena_aura_growth_x"]
		self.Buffs["growth-y"] = LolzenUIcfg.unitframes.arena["uf_arena_aura_growth_y"]
	elseif LolzenUIcfg.unitframes.arena["uf_arena_aura_show_type"] == "Debuffs" then
		self.Debuffs:SetPoint(LolzenUIcfg.unitframes.arena["uf_arena_aura_anchor1"], self, LolzenUIcfg.unitframes.arena["uf_arena_aura_anchor2"], LolzenUIcfg.unitframes.arena["uf_arena_aura_posx"], LolzenUIcfg.unitframes.arena["uf_arena_aura_posy"])
		self.Debuffs.numDebuffs = LolzenUIcfg.unitframes.arena["uf_arena_aura_maxnum"]
		if LolzenUIcfg.unitframes.arena["uf_arena_aura_show_only_player"] == true then
			self.Debuffs.onlyShowPlayer = true
		end
		self.Debuffs["growth-x"] = LolzenUIcfg.unitframes.arena["uf_arena_aura_growth_x"]
		self.Debuffs["growth-y"] = LolzenUIcfg.unitframes.arena["uf_arena_aura_growth_y"]
	elseif LolzenUIcfg.unitframes.arena["uf_arena_aura_show_type"] == "Both" then
		self.Auras:SetPoint(LolzenUIcfg.unitframes.arena["uf_arena_aura_anchor1"], self, LolzenUIcfg.unitframes.arena["uf_arena_aura_anchor2"], LolzenUIcfg.unitframes.arena["uf_arena_aura_posx"], LolzenUIcfg.unitframes.arena["uf_arena_aura_posy"])
		self.Auras.numTotal = LolzenUIcfg.unitframes.arena["uf_arena_aura_maxnum"]
		if LolzenUIcfg.unitframes.arena["uf_arena_aura_show_only_player"] == true then
			self.Auras.onlyShowPlayer = true
		end
		self.Auras["growth-x"] = LolzenUIcfg.unitframes.arena["uf_arena_aura_growth_x"]
		self.Auras["growth-y"] = LolzenUIcfg.unitframes.arena["uf_arena_aura_growth_y"]
	end

	ns.AddCastBar(self, unit)
	self.Castbar:SetAllPoints(self.Health)
	self.Castbar:SetStatusBarColor(LolzenUIcfg.unitframes.arena["uf_arena_cb_color"][1], LolzenUIcfg.unitframes.arena["uf_arena_cb_color"][2], LolzenUIcfg.unitframes.arena["uf_arena_cb_color"][3], LolzenUIcfg.unitframes.arena["uf_arena_cb_alpha"])

	self.Castbar.Spark:SetSize(self:GetWidth()/27.5, self:GetHeight()*2)

	if LolzenUIcfg.unitframes.arena["uf_arena_cb_icon_cut"] == true then
		self.Castbar.Icon:SetHeight(LolzenUIcfg.unitframes.arena["uf_arena_height"])
		-- Get the % point of the texture to show
		-- We calculate the percentage of the icon which has to be cut, depending on icon size, and unitframe size which are both variables
		local p1 = (LolzenUIcfg.unitframes.arena["uf_arena_cb_icon_size"]-LolzenUIcfg.unitframes.arena["uf_arena_height"])/2
		local p2 = p1+LolzenUIcfg.unitframes.arena["uf_arena_height"]
		self.Castbar.Icon:SetTexCoord(0.1, 0.9, 1/(LolzenUIcfg.unitframes.arena["uf_arena_cb_icon_size"]/p1), 0.9/(0.1+(LolzenUIcfg.unitframes.arena["uf_arena_cb_icon_size"]/p2)))
	else
		self.Castbar.Icon:SetHeight(LolzenUIcfg.unitframes.arena["uf_arena_cb_icon_size"])
		self.Castbar.Icon:SetTexCoord(.07, .93, .07, .93)

		self.Castbar.Shield:SetSize(self.Castbar.Icon:GetWidth()*3, self.Castbar.Icon:GetHeight()*3)
		self.Castbar.Shield:SetPoint("CENTER", self.Castbar.Icon, 0, 0)
	end

	self.Castbar.Icon:SetWidth(LolzenUIcfg.unitframes.arena["uf_arena_cb_icon_size"])
	self.Castbar.Icon:SetPoint(LolzenUIcfg.unitframes.arena["uf_arena_cb_icon_anchor1"], self.Castbar, LolzenUIcfg.unitframes.arena["uf_arena_cb_icon_anchor2"], LolzenUIcfg.unitframes.arena["uf_arena_cb_icon_posx"], LolzenUIcfg.unitframes.arena["uf_arena_cb_icon_posy"])

	self.Castbar.Time:SetPoint(LolzenUIcfg.unitframes.arena["uf_arena_cb_time_anchor1"], self.Castbar.Icon, LolzenUIcfg.unitframes.arena["uf_arena_cb_time_anchor2"], LolzenUIcfg.unitframes.arena["uf_arena_cb_time_posx"], LolzenUIcfg.unitframes.arena["uf_arena_cb_time_posy"])
	self.Castbar.Time:SetFont(LSM:Fetch("font", LolzenUIcfg.unitframes.arena["uf_arena_cb_font"]), LolzenUIcfg.unitframes.arena["uf_arena_cb_font_size"], LolzenUIcfg.unitframes.arena["uf_arena_cb_font_flag"])
	self.Castbar.Time:SetTextColor(LolzenUIcfg.unitframes.arena["uf_arena_cb_font_color"][1], LolzenUIcfg.unitframes.arena["uf_arena_cb_font_color"][2], LolzenUIcfg.unitframes.arena["uf_arena_cb_font_color"][3])

	self.Castbar.Text:SetPoint(LolzenUIcfg.unitframes.arena["uf_arena_cb_text_anchor1"], self.Castbar, LolzenUIcfg.unitframes.arena["uf_arena_cb_text_anchor2"], LolzenUIcfg.unitframes.arena["uf_arena_cb_text_posx"], LolzenUIcfg.unitframes.arena["uf_arena_cb_text_posy"])
	self.Castbar.Text:SetFont(LSM:Fetch("font", LolzenUIcfg.unitframes.arena["uf_arena_cb_font"]), LolzenUIcfg.unitframes.arena["uf_arena_cb_font_size"], LolzenUIcfg.unitframes.arena["uf_arena_cb_font_flag"])
	self.Castbar.Text:SetTextColor(LolzenUIcfg.unitframes.arena["uf_arena_cb_font_color"][1], LolzenUIcfg.unitframes.arena["uf_arena_cb_font_color"][2], LolzenUIcfg.unitframes.arena["uf_arena_cb_font_color"][3])

	ns.AddInfoPanel(self, unit)
	self.Level:SetPoint("LEFT", self.Health, "LEFT", 2, -18) 
	self.Name:SetPoint("RIGHT", self.Health, "RIGHT", -2, -18)

	ns.AddRaidMark(self, unit)

	ns.SetUFArenaSize = function()
		for i, v in pairs(oUF.objects) do
			if v.origUnit == "arena1" or v.origUnit == "arena2" or v.origUnit == "arena3" or v.origUnit == "arena4" or v.origUnit == "arena5" then
				v:SetSize(LolzenUIcfg.unitframes.arena["uf_arena_width"], LolzenUIcfg.unitframes.arena["uf_arena_height"])
			end
		end
	end

	ns.SetUFArenaOwnFont = function()
		if LolzenUIcfg.unitframes.arena["uf_arena_use_own_hp_font_settings"] == true then
			for i, v in pairs(oUF.objects) do
				if v.origUnit == "arena1" or v.origUnit == "arena2" or v.origUnit == "arena3" or v.origUnit == "arena4" or v.origUnit == "arena5" then
					v.Health.value:SetFont(LSM:Fetch("font", LolzenUIcfg.unitframes.arena["uf_arena_hp_font"]), LolzenUIcfg.unitframes.arena["uf_arena_hp_font_size"], LolzenUIcfg.unitframes.arena["uf_arena_hp_font_flag"])
					v.Health.value:ClearAllPoints()
					v.Health.value:SetPoint(LolzenUIcfg.unitframes.arena["uf_arena_hp_anchor"], LolzenUIcfg.unitframes.arena["uf_arena_hp_posx"], LolzenUIcfg.unitframes.arena["uf_arena_hp_posy"])
				end
			end
		else
			for i, v in pairs(oUF.objects) do
				if v.origUnit == "arena1" or v.origUnit == "arena2" or v.origUnit == "arena3" or v.origUnit == "arena4" or v.origUnit == "arena5" then
					v.Health.value:SetFont(LSM:Fetch("font", LolzenUIcfg.unitframes.general["uf_general_hp_font"]), LolzenUIcfg.unitframes.general["uf_general_hp_font_size"], LolzenUIcfg.unitframes.general["uf_general_hp_font_flag"])
					v.Health.value:ClearAllPoints()
					v.Health.value:SetPoint(LolzenUIcfg.unitframes.general["uf_general_hp_anchor"], LolzenUIcfg.unitframes.general["uf_general_hp_posx"], LolzenUIcfg.unitframes.general["uf_general_hp_posy"])
				end
			end
		end
	end

	ns.SetUFArenaHPFont = function()
		if LolzenUIcfg.unitframes.arena["uf_arena_use_own_hp_font_settings"] == true then
			for i, v in pairs(oUF.objects) do
				if v.origUnit == "arena1" or v.origUnit == "arena2" or v.origUnit == "arena3" or v.origUnit == "arena4" or v.origUnit == "arena5" then
					v.Health.value:SetFont(LSM:Fetch("font", LolzenUIcfg.unitframes.arena["uf_arena_hp_font"]), LolzenUIcfg.unitframes.arena["uf_arena_hp_font_size"], LolzenUIcfg.unitframes.arena["uf_arena_hp_font_flag"])
				end
			end
		end
	end

	ns.SetUFArenaHPPos = function()
		if LolzenUIcfg.unitframes.arena["uf_arena_use_own_hp_font_settings"] == true then
			for i, v in pairs(oUF.objects) do
				if v.origUnit == "arena1" or v.origUnit == "arena2" or v.origUnit == "arena3" or v.origUnit == "arena4" or v.origUnit == "arena5" then
					v.Health.value:ClearAllPoints()
					v.Health.value:SetPoint(LolzenUIcfg.unitframes.arena["uf_arena_hp_anchor"], LolzenUIcfg.unitframes.arena["uf_arena_hp_posx"], LolzenUIcfg.unitframes.arena["uf_arena_hp_posy"])
				end
			end
		end
	end

	ns.SetUFArenaPowerFont = function()
		for i, v in pairs(oUF.objects) do
			if v.origUnit == "arena1" or v.origUnit == "arena2" or v.origUnit == "arena3" or v.origUnit == "arena4" or v.origUnit == "arena5" then
				v.Power.value:SetFont(LSM:Fetch("font", LolzenUIcfg.unitframes.arena["uf_arena_pp_font"]), LolzenUIcfg.unitframes.arena["uf_arena_pp_font_size"], LolzenUIcfg.unitframes.arena["uf_arena_pp_font_flag"])
			end
		end
	end

	ns.SetUFArenaPowerPos = function()
		for i, v in pairs(oUF.objects) do
			if v.origUnit == "arena1" or v.origUnit == "arena2" or v.origUnit == "arena3" or v.origUnit == "arena4" or v.origUnit == "arena5" then
				v.Power.value:ClearAllPoints()
				if LolzenUIcfg.unitframes.arena["uf_arena_pp_parent"] == "hp" then
					v.Power.value:SetPoint(LolzenUIcfg.unitframes.arena["uf_arena_pp_anchor"], v.Health.value, LolzenUIcfg.unitframes.arena["uf_arena_pp_anchor2"], LolzenUIcfg.unitframes.arena["uf_arena_pp_posx"], LolzenUIcfg.unitframes.arena["uf_arena_pp_posy"])
				elseif LolzenUIcfg.unitframes.arena["uf_arena_pp_parent"] == "self" then
					v.Power.value:SetPoint(LolzenUIcfg.unitframes.arena["uf_arena_pp_anchor"], v, LolzenUIcfg.unitframes.arena["uf_arena_pp_anchor2"], LolzenUIcfg.unitframes.arena["uf_arena_pp_posx"], LolzenUIcfg.unitframes.arena["uf_arena_pp_posy"])
				end
			end
		end
	end

	ns.SetUFArenaAuraType = function()
		if LolzenUIcfg.unitframes.arena["uf_arena_aura_show_type"] == "Buffs" then
			for i, v in pairs(oUF.objects) do
				if v.origUnit == "arena1" or v.origUnit == "arena2" or v.origUnit == "arena3" or v.origUnit == "arena4" or v.origUnit == "arena5" then
					v.Buffs:SetPoint(LolzenUIcfg.unitframes.arena["uf_arena_aura_anchor1"], v, LolzenUIcfg.unitframes.arena["uf_arena_aura_anchor2"], LolzenUIcfg.unitframes.arena["uf_arena_aura_posx"], LolzenUIcfg.unitframes.arena["uf_arena_aura_posy"])
					v.Buffs.numBuffs = LolzenUIcfg.unitframes.arena["uf_arena_aura_maxnum"]
					if LolzenUIcfg.unitframes.arena["uf_arena_aura_show_only_player"] == true then
						v.Buffs.onlyShowPlayer = true
					end
					v.Buffs["growth-x"] = LolzenUIcfg.unitframes.arena["uf_arena_aura_growth_x"]
					v.Buffs["growth-y"] = LolzenUIcfg.unitframes.arena["uf_arena_aura_growth_y"]
					v.Debuffs:Hide()
					v.Auras:Hide()
					v.Buffs:Show()
				end
			end
		elseif LolzenUIcfg.unitframes.arena["uf_arena_aura_show_type"] == "Debuffs" then
			for i, v in pairs(oUF.objects) do
				if v.origUnit == "arena1" or v.origUnit == "arena2" or v.origUnit == "arena3" or v.origUnit == "arena4" or v.origUnit == "arena5" then
					v.Debuffs:SetPoint(LolzenUIcfg.unitframes.arena["uf_arena_aura_anchor1"], v, LolzenUIcfg.unitframes.arena["uf_arena_aura_anchor2"], LolzenUIcfg.unitframes.arena["uf_arena_aura_posx"], LolzenUIcfg.unitframes.arena["uf_arena_aura_posy"])
					v.Debuffs.numDebuffs = LolzenUIcfg.unitframes.arena["uf_arena_aura_maxnum"]
					if LolzenUIcfg.unitframes.arena["uf_arena_aura_show_only_player"] == true then
						v.Debuffs.onlyShowPlayer = true
					end
					v.Debuffs["growth-x"] = LolzenUIcfg.unitframes.arena["uf_arena_aura_growth_x"]
					v.Debuffs["growth-y"] = LolzenUIcfg.unitframes.arena["uf_arena_aura_growth_y"]
					v.Buffs:Hide()
					v.Auras:Hide()
					v.Debuffs:Show()
				end
			end
		elseif LolzenUIcfg.unitframes.arena["uf_arena_aura_show_type"] == "Both" then
			for i, v in pairs(oUF.objects) do
				if v.origUnit == "arena1" or v.origUnit == "arena2" or v.origUnit == "arena3" or v.origUnit == "arena4" or v.origUnit == "arena5" then
					v.Auras:SetPoint(LolzenUIcfg.unitframes.arena["uf_arena_aura_anchor1"], v, LolzenUIcfg.unitframes.arena["uf_arena_aura_anchor2"], LolzenUIcfg.unitframes.arena["uf_arena_aura_posx"], LolzenUIcfg.unitframes.arena["uf_arena_aura_posy"])
					v.Auras.numTotal = LolzenUIcfg.unitframes.arena["uf_arena_aura_maxnum"]
					if LolzenUIcfg.unitframes.arena["uf_arena_aura_show_only_player"] == true then
						v.Auras.onlyShowPlayer = true
					end
					v.Auras["growth-x"] = LolzenUIcfg.unitframes.arena["uf_arena_aura_growth_x"]
					v.Auras["growth-y"] = LolzenUIcfg.unitframes.arena["uf_arena_aura_growth_y"]
					v.Buffs:Hide()
					v.Debuffs:Hide()
					v.Auras:Show()
				end
			end
		else
			for i, v in pairs(oUF.objects) do
				if v.origUnit == "arena1" or v.origUnit == "arena2" or v.origUnit == "arena3" or v.origUnit == "arena4" or v.origUnit == "arena5" then
					v.Buffs:Hide()
					v.Debuffs:Hide()
					v.Auras:Hide()
				end
			end
		end
	end

	ns.SetUFArenaAuraNum = function()
		for i, v in pairs(oUF.objects) do
			if v.origUnit == "arena1" or v.origUnit == "arena2" or v.origUnit == "arena3" or v.origUnit == "arena4" or v.origUnit == "arena5" then
				v.Buffs.num = LolzenUIcfg.unitframes.arena["uf_arena_aura_maxnum"]
				v.Debuffs.num = LolzenUIcfg.unitframes.arena["uf_arena_aura_maxnum"]
				v.Auras.numTotal = LolzenUIcfg.unitframes.arena["uf_arena_aura_maxnum"]
				v:UpdateAllElements('RefreshUnit')
			end
		end
	end

	ns.SetUFArenaAuraSpacing = function()
		for i, v in pairs(oUF.objects) do
			if v.origUnit == "arena1" or v.origUnit == "arena2" or v.origUnit == "arena3" or v.origUnit == "arena4" or v.origUnit == "arena5" then
				v.Buffs.spacing = LolzenUIcfg.unitframes.arena["uf_arena_aura_spacing"]
				v.Debuffs.spacing = LolzenUIcfg.unitframes.arena["uf_arena_aura_spacing"]
				v.Auras.spacing = LolzenUIcfg.unitframes.arena["uf_arena_aura_spacing"]
				v.Buffs:ForceUpdate()
				v.Debuffs:ForceUpdate()
				v.Auras:ForceUpdate()
			end
		end
	end

	ns.SetUFArenaAuraSize = function()
		for i, v in pairs(oUF.objects) do
			if v.origUnit == "arena1" or v.origUnit == "arena2" or v.origUnit == "arena3" or v.origUnit == "arena4" or v.origUnit == "arena5" then
				v.Buffs.size = LolzenUIcfg.unitframes.arena["uf_arena_aura_size"]
				v.Debuffs.size = LolzenUIcfg.unitframes.arena["uf_arena_aura_size"]
				v.Auras.size = LolzenUIcfg.unitframes.arena["uf_arena_aura_size"]
				v:UpdateAllElements('RefreshUnit')
			end
		end
	end

	ns.SetUFArenaAuraPos = function()
		for i, v in pairs(oUF.objects) do
			if v.origUnit == "arena1" or v.origUnit == "arena2" or v.origUnit == "arena3" or v.origUnit == "arena4" or v.origUnit == "arena5" then
				v.Buffs:ClearAllPoints()
				v.Debuffs:ClearAllPoints()
				v.Auras:ClearAllPoints()
				v.Buffs:SetPoint(LolzenUIcfg.unitframes.arena["uf_arena_aura_anchor1"], v, LolzenUIcfg.unitframes.arena["uf_arena_aura_anchor2"], LolzenUIcfg.unitframes.arena["uf_arena_aura_posx"], LolzenUIcfg.unitframes.arena["uf_arena_aura_posy"])
				v.Debuffs:SetPoint(LolzenUIcfg.unitframes.arena["uf_arena_aura_anchor1"], v, LolzenUIcfg.unitframes.arena["uf_arena_aura_anchor2"], LolzenUIcfg.unitframes.arena["uf_arena_aura_posx"], LolzenUIcfg.unitframes.arena["uf_arena_aura_posy"])
				v.Auras:SetPoint(LolzenUIcfg.unitframes.arena["uf_arena_aura_anchor1"], v, LolzenUIcfg.unitframes.arena["uf_arena_aura_anchor2"], LolzenUIcfg.unitframes.arena["uf_arena_aura_posx"], LolzenUIcfg.unitframes.arena["uf_arena_aura_posy"])
			end
		end
	end

	ns.SetUFArenaAuraGrowth = function()
		for i, v in pairs(oUF.objects) do
			if v.origUnit == "arena1" or v.origUnit == "arena2" or v.origUnit == "arena3" or v.origUnit == "arena4" or v.origUnit == "arena5" then
				v.Buffs["growth-x"] = LolzenUIcfg.unitframes.arena["uf_arena_aura_growth_x"]
				v.Buffs["growth-y"] = LolzenUIcfg.unitframes.arena["uf_arena_aura_growth_y"]
				v.Debuffs["growth-x"] = LolzenUIcfg.unitframes.arena["uf_arena_aura_growth_x"]
				v.Debuffs["growth-y"] = LolzenUIcfg.unitframes.arena["uf_arena_aura_growth_y"]
				v.Auras["growth-x"] = LolzenUIcfg.unitframes.arena["uf_arena_aura_growth_x"]
				v.Auras["growth-y"] = LolzenUIcfg.unitframes.arena["uf_arena_aura_growth_y"]
				v.Buffs:ForceUpdate()
				v.Debuffs:ForceUpdate()
				v.Auras:ForceUpdate()
			end
		end
	end

	ns.SetUFArenaAuraShowOnlyPlayerAuras = function()
		for i, v in pairs(oUF.objects) do
			if v.origUnit == "arena1" or v.origUnit == "arena2" or v.origUnit == "arena3" or v.origUnit == "arena4" or v.origUnit == "arena5" then
				if LolzenUIcfg.unitframes.arena["uf_arena_aura_show_only_player"] then
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

	ns.SetUFArenaAuraDesatureNonPlayerAuras = function()
		for i, v in pairs(oUF.objects) do
			if v.origUnit == "arena1" or v.origUnit == "arena2" or v.origUnit == "arena3" or v.origUnit == "arena4" or v.origUnit == "arena5" then
				v.Auras.PostUpdateIcon(v.Auras)
				v.Auras:ForceUpdate()
			end
		end
	end

	ns.SetUFArenaCBColor = function()
		for i, v in pairs(oUF.objects) do
			if v.origUnit == "arena1" or v.origUnit == "arena2" or v.origUnit == "arena3" or v.origUnit == "arena4" or v.origUnit == "arena5" then
				v.Castbar:SetStatusBarColor(LolzenUIcfg.unitframes.arena["uf_arena_cb_color"][1], LolzenUIcfg.unitframes.arena["uf_arena_cb_color"][2], LolzenUIcfg.unitframes.arena["uf_arena_cb_color"][3], LolzenUIcfg.unitframes.arena["uf_arena_cb_alpha"])
			end
		end
	end

	ns.SetUFArenaCBIconPos = function()
		for i, v in pairs(oUF.objects) do
			if v.origUnit == "arena1" or v.origUnit == "arena2" or v.origUnit == "arena3" or v.origUnit == "arena4" or v.origUnit == "arena5" then
				v.Castbar.Icon:ClearAllPoints()
				v.Castbar.Icon:SetPoint(LolzenUIcfg.unitframes.arena["uf_arena_cb_icon_anchor1"], self.Castbar, LolzenUIcfg.unitframes.arena["uf_arena_cb_icon_anchor2"], LolzenUIcfg.unitframes.arena["uf_arena_cb_icon_posx"], LolzenUIcfg.unitframes.arena["uf_arena_cb_icon_posy"])
			end
		end
	end

	ns.SetUFArenaCBIconCutAndSize = function()
		for i, v in pairs(oUF.objects) do
			if v.origUnit == "arena1" or v.origUnit == "arena2" or v.origUnit == "arena3" or v.origUnit == "arena4" or v.origUnit == "arena5" then
				v.Castbar.Icon:SetWidth(LolzenUIcfg.unitframes.arena["uf_arena_cb_icon_size"])
				if LolzenUIcfg.unitframes.arena["uf_arena_cb_icon_cut"] == true then
					v.Castbar.Icon:SetHeight(LolzenUIcfg.unitframes.arena["uf_arena_height"])
					-- Get the % point of the texture to show
					-- We calculate the percentage of the icon which has to be cut, depending on icon size, and unitframe size which are both variables
					local p1 = (LolzenUIcfg.unitframes.arena["uf_arena_cb_icon_size"]-LolzenUIcfg.unitframes.arena["uf_arena_height"])/2
					local p2 = p1+LolzenUIcfg.unitframes.arena["uf_arena_height"]
					v.Castbar.Icon:SetTexCoord(0.1, 0.9, 1/(LolzenUIcfg.unitframes.arena["uf_arena_cb_icon_size"]/p1), 0.9/(0.1+(LolzenUIcfg.unitframes.arena["uf_arena_cb_icon_size"]/p2)))
				else
					v.Castbar.Icon:SetHeight(LolzenUIcfg.unitframes.arena["uf_arena_cb_icon_size"])
					v.Castbar.Icon:SetTexCoord(.07, .93, .07, .93)
				end
			end
		end
	end

	ns.SetUFArenaCBTimePos = function()
		for i, v in pairs(oUF.objects) do
			if v.origUnit == "arena1" or v.origUnit == "arena2" or v.origUnit == "arena3" or v.origUnit == "arena4" or v.origUnit == "arena5" then
				v.Castbar.Text:ClearAllPoints()
				v.Castbar.Time:SetPoint(LolzenUIcfg.unitframes.arena["uf_arena_cb_time_anchor1"], self.Castbar.Icon, LolzenUIcfg.unitframes.arena["uf_arena_cb_time_anchor2"], LolzenUIcfg.unitframes.arena["uf_arena_cb_time_posx"], LolzenUIcfg.unitframes.arena["uf_arena_cb_time_posy"])
			end
		end
	end

	ns.SetUFArenaCBTextPos = function()
		for i, v in pairs(oUF.objects) do
			if v.origUnit == "arena1" or v.origUnit == "arena2" or v.origUnit == "arena3" or v.origUnit == "arena4" or v.origUnit == "arena5" then
				v.Castbar.Text:ClearAllPoints()
				v.Castbar.Text:SetPoint(LolzenUIcfg.unitframes.arena["uf_arena_cb_text_anchor1"], self.Castbar, LolzenUIcfg.unitframes.arena["uf_arena_cb_text_anchor2"], LolzenUIcfg.unitframes.arena["uf_arena_cb_text_posx"], LolzenUIcfg.unitframes.arena["uf_arena_cb_text_posy"])
			end
		end
	end

	ns.SetUFArenaCBTextFont = function()
		for i, v in pairs(oUF.objects) do
			if v.origUnit == "arena1" or v.origUnit == "arena2" or v.origUnit == "arena3" or v.origUnit == "arena4" or v.origUnit == "arena5" then
				v.Castbar.Text:SetFont(LSM:Fetch("font", LolzenUIcfg.unitframes.arena["uf_arena_cb_font"]), LolzenUIcfg.unitframes.arena["uf_arena_cb_font_size"], LolzenUIcfg.unitframes.arena["uf_arena_cb_font_flag"])
				v.Castbar.Time:SetFont(LSM:Fetch("font", LolzenUIcfg.unitframes.arena["uf_arena_cb_font"]), LolzenUIcfg.unitframes.arena["uf_arena_cb_font_size"], LolzenUIcfg.unitframes.arena["uf_arena_cb_font_flag"])
			end
		end
	end

	ns.SetUFArenaCBTextColor = function()
		for i, v in pairs(oUF.objects) do
			if v.origUnit == "arena1" or v.origUnit == "arena2" or v.origUnit == "arena3" or v.origUnit == "arena4" or v.origUnit == "arena5" then
				v.Castbar.Text:SetTextColor(LolzenUIcfg.unitframes.arena["uf_arena_cb_font_color"][1], LolzenUIcfg.unitframes.arena["uf_arena_cb_font_color"][2], LolzenUIcfg.unitframes.arena["uf_arena_cb_font_color"][3])
				v.Castbar.Time:SetTextColor(LolzenUIcfg.unitframes.arena["uf_arena_cb_font_color"][1], LolzenUIcfg.unitframes.arena["uf_arena_cb_font_color"][2], LolzenUIcfg.unitframes.arena["uf_arena_cb_font_color"][3])
			end
		end
	end
end