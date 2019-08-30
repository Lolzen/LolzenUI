local _, ns = ...
local LSM = LibStub("LibSharedMedia-3.0")

ns.SetupPlayer = function(self, unit)
	ns.shared(self, unit)

	self:SetSize(LolzenUIcfg.unitframes.player["uf_player_width"], LolzenUIcfg.unitframes.player["uf_player_height"])

	if LolzenUIcfg.unitframes.player["uf_player_use_own_hp_font_settings"] == true then
		self.Health.value:SetFont(LSM:Fetch("font", LolzenUIcfg.unitframes.player["uf_player_hp_font"]), LolzenUIcfg.unitframes.player["uf_player_hp_font_size"], LolzenUIcfg.unitframes.player["uf_player_hp_font_flag"])
		self.Health.value:SetPoint(LolzenUIcfg.unitframes.player["uf_player_hp_anchor"], LolzenUIcfg.unitframes.player["uf_player_hp_posx"], LolzenUIcfg.unitframes.player["uf_player_hp_posy"])
	end

	self.Border:SetPoint("TOPLEFT", self, -3, 3)
	self.Border:SetPoint("BOTTOMRIGHT", self, 3, -2)

	ns.AddPowerBar(self, unit)

	ns.AddPowerPoints(self, unit)
	if LolzenUIcfg.unitframes.player["uf_player_pp_parent"] == "hp" then
		self.Power.value:SetPoint(LolzenUIcfg.unitframes.player["uf_player_pp_anchor"], self.Health.value, LolzenUIcfg.unitframes.player["uf_player_pp_anchor2"], LolzenUIcfg.unitframes.player["uf_player_pp_posx"], LolzenUIcfg.unitframes.player["uf_player_pp_posy"])
	elseif LolzenUIcfg.unitframes.player["uf_player_pp_parent"] == "self" then
		self.Power.value:SetPoint(LolzenUIcfg.unitframes.player["uf_player_pp_anchor"], self, LolzenUIcfg.unitframes.player["uf_player_pp_anchor2"], LolzenUIcfg.unitframes.player["uf_player_pp_posx"], LolzenUIcfg.unitframes.player["uf_player_pp_posy"])
	end
	self.Power.value:SetFont(LSM:Fetch("font", LolzenUIcfg.unitframes.player["uf_player_pp_font"]), LolzenUIcfg.unitframes.player["uf_player_pp_font_size"], LolzenUIcfg.unitframes.player["uf_player_pp_font_flag"])

	ns.AddCastBar(self, unit)
	if LolzenUIcfg.unitframes.player["uf_player_cb_standalone"] == true then
		self.Castbar:SetPoint(LolzenUIcfg.unitframes.player["uf_player_cb_anchor1"], UIParent, LolzenUIcfg.unitframes.player["uf_player_cb_anchor2"], LolzenUIcfg.unitframes.player["uf_player_cb_posx"], LolzenUIcfg.unitframes.player["uf_player_cb_posy"])
		self.Castbar:SetSize(LolzenUIcfg.unitframes.player["uf_player_cb_width"], LolzenUIcfg.unitframes.player["uf_player_cb_height"])
		self.Castbar.background:SetAllPoints(self.Castbar)
		self.Castbar.border:SetPoint("TOPLEFT", self.Castbar, -2, 3)
		self.Castbar.border:SetPoint("BOTTOMRIGHT", self.Castbar, 3, -2)
	else
		self.Castbar:SetAllPoints(self.Health)
	end
	self.Castbar:SetStatusBarColor(LolzenUIcfg.unitframes.player["uf_player_cb_color"][1], LolzenUIcfg.unitframes.player["uf_player_cb_color"][2], LolzenUIcfg.unitframes.player["uf_player_cb_color"][3], LolzenUIcfg.unitframes.player["uf_player_cb_alpha"])

	self.Castbar.Spark:SetSize(self:GetWidth()/27.5, self:GetHeight()*2)

	if LolzenUIcfg.unitframes.player["uf_player_cb_icon_cut"] == true then
		self.Castbar.Icon:SetHeight(LolzenUIcfg.unitframes.player["uf_player_height"])
		-- Get the % point of the texture to show
		-- We calculate the percentage of the icon which has to be cut, depending on icon size, and unitframe size which are both variables
		local p1 = (LolzenUIcfg.unitframes.player["uf_player_cb_icon_size"]-LolzenUIcfg.unitframes.player["uf_player_height"])/2
		local p2 = p1+LolzenUIcfg.unitframes.player["uf_player_height"]
		self.Castbar.Icon:SetTexCoord(0.1, 0.9, 1/(LolzenUIcfg.unitframes.player["uf_player_cb_icon_size"]/p1), 0.9/(0.1+(LolzenUIcfg.unitframes.player["uf_player_cb_icon_size"]/p2)))
	else
		self.Castbar.Icon:SetHeight(LolzenUIcfg.unitframes.player["uf_player_cb_icon_size"])
		self.Castbar.Icon:SetTexCoord(.07, .93, .07, .93)

		self.Castbar.Shield:SetSize(self.Castbar.Icon:GetWidth()*3, self.Castbar.Icon:GetHeight()*3)
		self.Castbar.Shield:SetPoint("CENTER", self.Castbar.Icon, 0, 0)
	end

	self.Castbar.Icon:SetWidth(LolzenUIcfg.unitframes.player["uf_player_cb_icon_size"])
	self.Castbar.Icon:SetPoint(LolzenUIcfg.unitframes.player["uf_player_cb_icon_anchor1"], self.Castbar, LolzenUIcfg.unitframes.player["uf_player_cb_icon_anchor2"], LolzenUIcfg.unitframes.player["uf_player_cb_icon_posx"], LolzenUIcfg.unitframes.player["uf_player_cb_icon_posy"])

	self.Castbar.Time:SetPoint(LolzenUIcfg.unitframes.player["uf_player_cb_time_anchor1"], self.Castbar.Icon, LolzenUIcfg.unitframes.player["uf_player_cb_time_anchor2"], LolzenUIcfg.unitframes.player["uf_player_cb_time_posx"], LolzenUIcfg.unitframes.player["uf_player_cb_time_posy"])
	self.Castbar.Time:SetFont(LSM:Fetch("font", LolzenUIcfg.unitframes.player["uf_player_cb_font"]), LolzenUIcfg.unitframes.player["uf_player_cb_font_size"], LolzenUIcfg.unitframes.player["uf_player_cb_font_flag"])
	self.Castbar.Time:SetTextColor(LolzenUIcfg.unitframes.player["uf_player_cb_font_color"][1], LolzenUIcfg.unitframes.player["uf_player_cb_font_color"][2], LolzenUIcfg.unitframes.player["uf_player_cb_font_color"][3])

	self.Castbar.Text:SetPoint(LolzenUIcfg.unitframes.player["uf_player_cb_text_anchor1"], self.Castbar, LolzenUIcfg.unitframes.player["uf_player_cb_text_anchor2"], LolzenUIcfg.unitframes.player["uf_player_cb_text_posx"], LolzenUIcfg.unitframes.player["uf_player_cb_text_posy"])
	self.Castbar.Text:SetFont(LSM:Fetch("font", LolzenUIcfg.unitframes.player["uf_player_cb_font"]), LolzenUIcfg.unitframes.player["uf_player_cb_font_size"], LolzenUIcfg.unitframes.player["uf_player_cb_font_flag"])
	self.Castbar.Text:SetTextColor(LolzenUIcfg.unitframes.player["uf_player_cb_font_color"][1], LolzenUIcfg.unitframes.player["uf_player_cb_font_color"][2], LolzenUIcfg.unitframes.player["uf_player_cb_font_color"][3])

--	ns.AddClassPower(self, unit)

--	if select(2, UnitClass('player')) == "DEATHKNIGHT" then
--		ns.AddRunes(self, unit)
--	end

--	if select(2, UnitClass('player')) == "MONK" then
--		ns.AddStagger(self, unit)
--	end

--	ns.AddThreatBorder(self, unit)
--	ns.AddDebuffHighlight(self, unit)
	ns.AddCombatFade(self, unit)
	ns.AddRaidMark(self, unit)
	ns.AddLeadIndicator(self, unit)
	
	if LolzenUIcfg.unitframes.player["uf_player_show_restingindicator"] == true then
		ns.AddRestedIndicator(self, unit)
	end
end