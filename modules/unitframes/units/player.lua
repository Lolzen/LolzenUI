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

	self.Castbar.Spark:SetSize(self.Castbar:GetWidth()/27.5, self.Castbar:GetHeight()*2)

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
	end

	self.Castbar.Shield:SetAlpha(0)

	self.Castbar.Icon:SetWidth(LolzenUIcfg.unitframes.player["uf_player_cb_icon_size"])
	self.Castbar.Icon:SetPoint(LolzenUIcfg.unitframes.player["uf_player_cb_icon_anchor1"], self.Castbar, LolzenUIcfg.unitframes.player["uf_player_cb_icon_anchor2"], LolzenUIcfg.unitframes.player["uf_player_cb_icon_posx"], LolzenUIcfg.unitframes.player["uf_player_cb_icon_posy"])

	self.Castbar.Time:SetPoint(LolzenUIcfg.unitframes.player["uf_player_cb_time_anchor1"], self.Castbar.Icon, LolzenUIcfg.unitframes.player["uf_player_cb_time_anchor2"], LolzenUIcfg.unitframes.player["uf_player_cb_time_posx"], LolzenUIcfg.unitframes.player["uf_player_cb_time_posy"])
	self.Castbar.Time:SetFont(LSM:Fetch("font", LolzenUIcfg.unitframes.player["uf_player_cb_font"]), LolzenUIcfg.unitframes.player["uf_player_cb_font_size"], LolzenUIcfg.unitframes.player["uf_player_cb_font_flag"])
	self.Castbar.Time:SetTextColor(LolzenUIcfg.unitframes.player["uf_player_cb_font_color"][1], LolzenUIcfg.unitframes.player["uf_player_cb_font_color"][2], LolzenUIcfg.unitframes.player["uf_player_cb_font_color"][3])

	self.Castbar.Text:SetPoint(LolzenUIcfg.unitframes.player["uf_player_cb_text_anchor1"], self.Castbar, LolzenUIcfg.unitframes.player["uf_player_cb_text_anchor2"], LolzenUIcfg.unitframes.player["uf_player_cb_text_posx"], LolzenUIcfg.unitframes.player["uf_player_cb_text_posy"])
	self.Castbar.Text:SetFont(LSM:Fetch("font", LolzenUIcfg.unitframes.player["uf_player_cb_font"]), LolzenUIcfg.unitframes.player["uf_player_cb_font_size"], LolzenUIcfg.unitframes.player["uf_player_cb_font_flag"])
	self.Castbar.Text:SetTextColor(LolzenUIcfg.unitframes.player["uf_player_cb_font_color"][1], LolzenUIcfg.unitframes.player["uf_player_cb_font_color"][2], LolzenUIcfg.unitframes.player["uf_player_cb_font_color"][3])

	ns.AddClassPower(self, unit)

	if select(2, UnitClass('player')) == "DEATHKNIGHT" then
		ns.AddRunes(self, unit)
	end

	if select(2, UnitClass('player')) == "MONK" then
		ns.AddStagger(self, unit)
	end

	ns.AddThreatBorder(self, unit)
	ns.AddDebuffHighlight(self, unit)
	ns.AddCombatFade(self, unit)
	ns.AddRaidMark(self, unit)
	ns.AddLeadIndicator(self, unit)
	ns.AddRestedIndicator(self, unit)
	
	if LolzenUIcfg.unitframes.player["uf_player_show_restingindicator"] == false then
		self.RestingIndicator:SetAlpha(0)
	end

	ns.SetUFPlayerSize = function()
		self:SetSize(LolzenUIcfg.unitframes.player["uf_player_width"], LolzenUIcfg.unitframes.player["uf_player_height"])
	end

	ns.SetUFPlayerOwnFont = function()
		if LolzenUIcfg.unitframes.player["uf_player_use_own_hp_font_settings"] == true then
			self.Health.value:SetFont(LSM:Fetch("font", LolzenUIcfg.unitframes.player["uf_player_hp_font"]), LolzenUIcfg.unitframes.player["uf_player_hp_font_size"], LolzenUIcfg.unitframes.player["uf_player_hp_font_flag"])
			self.Health.value:ClearAllPoints()
			self.Health.value:SetPoint(LolzenUIcfg.unitframes.player["uf_player_hp_anchor"], LolzenUIcfg.unitframes.player["uf_player_hp_posx"], LolzenUIcfg.unitframes.player["uf_player_hp_posy"])
		else
			self.Health.value:SetFont(LSM:Fetch("font", LolzenUIcfg.unitframes.general["uf_general_hp_font"]), LolzenUIcfg.unitframes.general["uf_general_hp_font_size"], LolzenUIcfg.unitframes.general["uf_general_hp_font_flag"])
			self.Health.value:ClearAllPoints()
			self.Health.value:SetPoint(LolzenUIcfg.unitframes.general["uf_general_hp_anchor"], LolzenUIcfg.unitframes.general["uf_general_hp_posx"], LolzenUIcfg.unitframes.general["uf_general_hp_posy"])
		end
	end

	ns.SetUFPlayerHPFont = function()
		if LolzenUIcfg.unitframes.player["uf_player_use_own_hp_font_settings"] == true then
			self.Health.value:SetFont(LSM:Fetch("font", LolzenUIcfg.unitframes.player["uf_player_hp_font"]), LolzenUIcfg.unitframes.player["uf_player_hp_font_size"], LolzenUIcfg.unitframes.player["uf_player_hp_font_flag"])
		end
	end

	ns.SetUFPlayerHPPos = function()
		if LolzenUIcfg.unitframes.player["uf_player_use_own_hp_font_settings"] == true then
			self.Health.value:ClearAllPoints()
			self.Health.value:SetPoint(LolzenUIcfg.unitframes.player["uf_player_hp_anchor"], LolzenUIcfg.unitframes.player["uf_player_hp_posx"], LolzenUIcfg.unitframes.player["uf_player_hp_posy"])
		end
	end

	ns.SetUFPlayerPowerFont = function()
		self.Power.value:SetFont(LSM:Fetch("font", LolzenUIcfg.unitframes.player["uf_player_pp_font"]), LolzenUIcfg.unitframes.player["uf_player_pp_font_size"], LolzenUIcfg.unitframes.player["uf_player_pp_font_flag"])
	end

	ns.SetUFPlayerPowerPos = function()
		self.Power.value:ClearAllPoints()
		if LolzenUIcfg.unitframes.player["uf_player_pp_parent"] == "hp" then
			self.Power.value:SetPoint(LolzenUIcfg.unitframes.player["uf_player_pp_anchor"], self.Health.value, LolzenUIcfg.unitframes.player["uf_player_pp_anchor2"], LolzenUIcfg.unitframes.player["uf_player_pp_posx"], LolzenUIcfg.unitframes.player["uf_player_pp_posy"])
		elseif LolzenUIcfg.unitframes.player["uf_player_pp_parent"] == "self" then
			self.Power.value:SetPoint(LolzenUIcfg.unitframes.player["uf_player_pp_anchor"], self, LolzenUIcfg.unitframes.player["uf_player_pp_anchor2"], LolzenUIcfg.unitframes.player["uf_player_pp_posx"], LolzenUIcfg.unitframes.player["uf_player_pp_posy"])
		end
	end

	ns.SetUFPlayerClassPowerPos = function()
		for i=1, 10 do
			self.ClassPower[i]:ClearAllPoints()
			if i == 1 then
				self.ClassPower[i]:SetPoint(LolzenUIcfg.unitframes.player["uf_player_classpower_anchor1"], self, LolzenUIcfg.unitframes.player["uf_player_classpower_anchor2"], LolzenUIcfg.unitframes.player["uf_player_classpower_posx"], LolzenUIcfg.unitframes.player["uf_player_classpower_posy"])
			else
				self.ClassPower[i]:SetPoint("LEFT", self.ClassPower[i-1], "RIGHT", LolzenUIcfg.unitframes.player["uf_player_classpower_spacing"], 0)
			end
		end
	end

	ns.SetUFPlayerClassPowerBorder = function()
		for i=1, 10 do
			self.ClassPower[i].border:SetBackdrop({
				edgeFile = LSM:Fetch("border", LolzenUIcfg.unitframes.player["uf_player_classpower_border"]),
				tile=true, tileSize=4, edgeSize=4,
				insets={left=0.5, right=0.5, top=0.5, bottom=0.5}
			})
		end
	end

	ns.SetUFPlayerCBStandalone = function()
		self.Castbar:ClearAllPoints()
		if LolzenUIcfg.unitframes.player["uf_player_cb_standalone"] == true then
			self.Castbar:SetPoint(LolzenUIcfg.unitframes.player["uf_player_cb_anchor1"], UIParent, LolzenUIcfg.unitframes.player["uf_player_cb_anchor2"], LolzenUIcfg.unitframes.player["uf_player_cb_posx"], LolzenUIcfg.unitframes.player["uf_player_cb_posy"])
			self.Castbar:SetSize(LolzenUIcfg.unitframes.player["uf_player_cb_width"], LolzenUIcfg.unitframes.player["uf_player_cb_height"])
			self.Castbar.background:SetAllPoints(self.Castbar)
			self.Castbar.border:SetPoint("TOPLEFT", self.Castbar, -2, 3)
			self.Castbar.border:SetPoint("BOTTOMRIGHT", self.Castbar, 3, -2)
		else
			self.Castbar:SetAllPoints(self.Health)
			self.Castbar.background:ClearAllPoints()
			self.Castbar.border:ClearAllPoints()
		end
	end

	ns.SetUFPlayerCBPos = function()
		self.Castbar:ClearAllPoints()
		self.Castbar:SetPoint(LolzenUIcfg.unitframes.player["uf_player_cb_anchor1"], UIParent, LolzenUIcfg.unitframes.player["uf_player_cb_anchor2"], LolzenUIcfg.unitframes.player["uf_player_cb_posx"], LolzenUIcfg.unitframes.player["uf_player_cb_posy"])
	end

	ns.SetUFPlayerCBSize = function()
		self.Castbar:SetSize(LolzenUIcfg.unitframes.player["uf_player_cb_width"], LolzenUIcfg.unitframes.player["uf_player_cb_height"])
		self.Castbar.Spark:SetSize(self.Castbar:GetWidth()/27.5, self.Castbar:GetHeight()*2)
	end

	ns.SetUFPlayerCBColor = function()
		self.Castbar:SetStatusBarColor(LolzenUIcfg.unitframes.player["uf_player_cb_color"][1], LolzenUIcfg.unitframes.player["uf_player_cb_color"][2], LolzenUIcfg.unitframes.player["uf_player_cb_color"][3], LolzenUIcfg.unitframes.player["uf_player_cb_alpha"])
	end

	ns.SetUFPlayerCBIconPos = function()
		self.Castbar.Icon:ClearAllPoints()
		self.Castbar.Icon:SetPoint(LolzenUIcfg.unitframes.player["uf_player_cb_icon_anchor1"], self.Castbar, LolzenUIcfg.unitframes.player["uf_player_cb_icon_anchor2"], LolzenUIcfg.unitframes.player["uf_player_cb_icon_posx"], LolzenUIcfg.unitframes.player["uf_player_cb_icon_posy"])
	end

	ns.SetUFPlayerCBIconCutAndSize = function()
		self.Castbar.Icon:SetWidth(LolzenUIcfg.unitframes.player["uf_player_cb_icon_size"])
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
		end
	end

	ns.SetUFPlayerCBTimePos = function()
		self.Castbar.Text:ClearAllPoints()
		self.Castbar.Time:SetPoint(LolzenUIcfg.unitframes.player["uf_player_cb_time_anchor1"], self.Castbar.Icon, LolzenUIcfg.unitframes.player["uf_player_cb_time_anchor2"], LolzenUIcfg.unitframes.player["uf_player_cb_time_posx"], LolzenUIcfg.unitframes.player["uf_player_cb_time_posy"])
	end

	ns.SetUFPlayerCBTimeFont = function()
		self.Castbar.Time:SetFont(LSM:Fetch("font", LolzenUIcfg.unitframes.player["uf_player_cb_font"]), LolzenUIcfg.unitframes.player["uf_player_cb_font_size"], LolzenUIcfg.unitframes.player["uf_player_cb_font_flag"])
	end

	ns.SetUFPlayerCBTextPos = function()
		self.Castbar.Text:ClearAllPoints()
		self.Castbar.Text:SetPoint(LolzenUIcfg.unitframes.player["uf_player_cb_text_anchor1"], self.Castbar, LolzenUIcfg.unitframes.player["uf_player_cb_text_anchor2"], LolzenUIcfg.unitframes.player["uf_player_cb_text_posx"], LolzenUIcfg.unitframes.player["uf_player_cb_text_posy"])
	end

	ns.SetUFPlayerCBTextFont = function()
		self.Castbar.Text:SetFont(LSM:Fetch("font", LolzenUIcfg.unitframes.player["uf_player_cb_font"]), LolzenUIcfg.unitframes.player["uf_player_cb_font_size"], LolzenUIcfg.unitframes.player["uf_player_cb_font_flag"])
	end

	ns.SetUFPlayerCBTextColor = function()
		self.Castbar.Text:SetTextColor(LolzenUIcfg.unitframes.player["uf_player_cb_font_color"][1], LolzenUIcfg.unitframes.player["uf_player_cb_font_color"][2], LolzenUIcfg.unitframes.player["uf_player_cb_font_color"][3])
		self.Castbar.Time:SetTextColor(LolzenUIcfg.unitframes.player["uf_player_cb_font_color"][1], LolzenUIcfg.unitframes.player["uf_player_cb_font_color"][2], LolzenUIcfg.unitframes.player["uf_player_cb_font_color"][3])
	end

	ns.SetUFPlayerRestingIndicator = function()
		if LolzenUIcfg.unitframes.player["uf_player_show_restingindicator"] == true then
			self.RestingIndicator:SetAlpha(1)
		else
			self.RestingIndicator:SetAlpha(0)
		end
	end

	ns.SetUFPlayerRISize = function()
		self.RestingIndicator:SetSize(LolzenUIcfg.unitframes.player["uf_player_resting_size"], LolzenUIcfg.unitframes.player["uf_player_resting_size"])
	end

	ns.SetUFPlayerRIPos = function()
		self.RestingIndicator:ClearAllPoints()
		self.RestingIndicator:SetPoint(LolzenUIcfg.unitframes.player["uf_player_resting_anchor"], self.Health, LolzenUIcfg.unitframes.player["uf_player_resting_posx"], LolzenUIcfg.unitframes.player["uf_player_resting_posy"])
	end
end