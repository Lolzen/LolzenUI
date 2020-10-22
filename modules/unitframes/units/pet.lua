local _, ns = ...
local LSM = LibStub("LibSharedMedia-3.0")

ns.SetupPet = function(self, unit)
	ns.shared(self, unit)

	self:SetSize(LolzenUIcfg.unitframes.pet["uf_pet_width"], LolzenUIcfg.unitframes.pet["uf_pet_height"])

	if LolzenUIcfg.unitframes.pet["uf_pet_use_own_hp_font_settings"] == true then
		self.Health.value:SetFont(LSM:Fetch("font", LolzenUIcfg.unitframes.pet["uf_pet_hp_font"]), LolzenUIcfg.unitframes.pet["uf_pet_hp_font_size"], LolzenUIcfg.unitframes.pet["uf_pet_hp_font_flag"])
		self.Health.value:SetPoint(LolzenUIcfg.unitframes.pet["uf_pet_hp_anchor"], LolzenUIcfg.unitframes.pet["uf_pet_hp_posx"], LolzenUIcfg.unitframes.pet["uf_pet_hp_posy"])
	end

	self.Border:SetPoint("TOPLEFT", self, -3, 3)
	self.Border:SetPoint("BOTTOMRIGHT", self, 3, -3)

	ns.AddCastBar(self, unit)
	self.Castbar:SetAllPoints(self.Health)
	self.Castbar:SetStatusBarColor(LolzenUIcfg.unitframes.pet["uf_pet_cb_color"][1], LolzenUIcfg.unitframes.pet["uf_pet_cb_color"][2], LolzenUIcfg.unitframes.pet["uf_pet_cb_color"][3], LolzenUIcfg.unitframes.pet["uf_pet_cb_alpha"])

	self.Castbar.Spark:SetSize(self:GetWidth()/27.5, self:GetHeight()*2)

	if LolzenUIcfg.unitframes.pet["uf_pet_cb_icon_cut"] == true then
		self.Castbar.Icon:SetHeight(LolzenUIcfg.unitframes.pet["uf_pet_height"])
		-- Get the % point of the texture to show
		-- We calculate the percentage of the icon which has to be cut, depending on icon size, and unitframe size which are both variables
		local p1 = (LolzenUIcfg.unitframes.pet["uf_pet_cb_icon_size"]-LolzenUIcfg.unitframes.pet["uf_pet_height"])/2
		local p2 = p1+LolzenUIcfg.unitframes.pet["uf_pet_height"]
		self.Castbar.Icon:SetTexCoord(0.1, 0.9, 1/(LolzenUIcfg.unitframes.pet["uf_pet_cb_icon_size"]/p1), 0.9/(0.1+(LolzenUIcfg.unitframes.pet["uf_pet_cb_icon_size"]/p2)))
	else
		self.Castbar.Icon:SetHeight(LolzenUIcfg.unitframes.pet["uf_pet_cb_icon_size"])
		self.Castbar.Icon:SetTexCoord(.07, .93, .07, .93)

		self.Castbar.Shield:SetSize(self.Castbar.Icon:GetWidth()*3, self.Castbar.Icon:GetHeight()*3)
		self.Castbar.Shield:SetPoint("CENTER", self.Castbar.Icon, 0, 0)
	end

	self.Castbar.Icon:SetWidth(LolzenUIcfg.unitframes.pet["uf_pet_cb_icon_size"])
	self.Castbar.Icon:SetPoint(LolzenUIcfg.unitframes.pet["uf_pet_cb_icon_anchor1"], self.Castbar, LolzenUIcfg.unitframes.pet["uf_pet_cb_icon_anchor2"], LolzenUIcfg.unitframes.pet["uf_pet_cb_icon_posx"], LolzenUIcfg.unitframes.pet["uf_pet_cb_icon_posy"])

	self.Castbar.Time:SetPoint(LolzenUIcfg.unitframes.pet["uf_pet_cb_time_anchor1"], self.Castbar.Icon, LolzenUIcfg.unitframes.pet["uf_pet_cb_time_anchor2"], LolzenUIcfg.unitframes.pet["uf_pet_cb_time_posx"], LolzenUIcfg.unitframes.pet["uf_pet_cb_time_posy"])
	self.Castbar.Time:SetFont(LSM:Fetch("font", LolzenUIcfg.unitframes.pet["uf_pet_cb_font"]), LolzenUIcfg.unitframes.pet["uf_pet_cb_font_size"], LolzenUIcfg.unitframes.pet["uf_pet_cb_font_flag"])
	self.Castbar.Time:SetTextColor(LolzenUIcfg.unitframes.pet["uf_pet_cb_font_color"][1], LolzenUIcfg.unitframes.pet["uf_pet_cb_font_color"][2], LolzenUIcfg.unitframes.pet["uf_pet_cb_font_color"][3])

	self.Castbar.Text:SetPoint(LolzenUIcfg.unitframes.pet["uf_pet_cb_text_anchor1"], self.Castbar, LolzenUIcfg.unitframes.pet["uf_pet_cb_text_anchor2"], LolzenUIcfg.unitframes.pet["uf_pet_cb_text_posx"], LolzenUIcfg.unitframes.pet["uf_pet_cb_text_posy"])
	self.Castbar.Text:SetFont(LSM:Fetch("font", LolzenUIcfg.unitframes.pet["uf_pet_cb_font"]), LolzenUIcfg.unitframes.pet["uf_pet_cb_font_size"], LolzenUIcfg.unitframes.pet["uf_pet_cb_font_flag"])
	self.Castbar.Text:SetTextColor(LolzenUIcfg.unitframes.pet["uf_pet_cb_font_color"][1], LolzenUIcfg.unitframes.pet["uf_pet_cb_font_color"][2], LolzenUIcfg.unitframes.pet["uf_pet_cb_font_color"][3])

	ns.AddCombatFade(self, unit)

	ns.SetUFPetSize = function()
		self:SetSize(LolzenUIcfg.unitframes.pet["uf_pet_width"], LolzenUIcfg.unitframes.pet["uf_pet_height"])
	end

	ns.SetUFPetOwnFont = function()
		if LolzenUIcfg.unitframes.pet["uf_pet_use_own_hp_font_settings"] == true then
			self.Health.value:SetFont(LSM:Fetch("font", LolzenUIcfg.unitframes.pet["uf_pet_hp_font"]), LolzenUIcfg.unitframes.pet["uf_pet_hp_font_size"], LolzenUIcfg.unitframes.pet["uf_pet_hp_font_flag"])
			self.Health.value:ClearAllPoints()
			self.Health.value:SetPoint(LolzenUIcfg.unitframes.pet["uf_pet_hp_anchor"], LolzenUIcfg.unitframes.pet["uf_pet_hp_posx"], LolzenUIcfg.unitframes.pet["uf_pet_hp_posy"])
		else
			self.Health.value:SetFont(LSM:Fetch("font", LolzenUIcfg.unitframes.general["uf_general_hp_font"]), LolzenUIcfg.unitframes.general["uf_general_hp_font_size"], LolzenUIcfg.unitframes.general["uf_general_hp_font_flag"])
			self.Health.value:ClearAllPoints()
			self.Health.value:SetPoint(LolzenUIcfg.unitframes.general["uf_general_hp_anchor"], LolzenUIcfg.unitframes.general["uf_general_hp_posx"], LolzenUIcfg.unitframes.general["uf_general_hp_posy"])
		end
	end

	ns.SetUFPetHPFont = function()
		if LolzenUIcfg.unitframes.pet["uf_pet_use_own_hp_font_settings"] == true then
			self.Health.value:SetFont(LSM:Fetch("font", LolzenUIcfg.unitframes.pet["uf_pet_hp_font"]), LolzenUIcfg.unitframes.pet["uf_pet_hp_font_size"], LolzenUIcfg.unitframes.pet["uf_pet_hp_font_flag"])
		end
	end

	ns.SetUFPetHPPos = function()
		if LolzenUIcfg.unitframes.pet["uf_pet_use_own_hp_font_settings"] == true then
			self.Health.value:ClearAllPoints()
			self.Health.value:SetPoint(LolzenUIcfg.unitframes.pet["uf_pet_hp_anchor"], LolzenUIcfg.unitframes.pet["uf_pet_hp_posx"], LolzenUIcfg.unitframes.pet["uf_pet_hp_posy"])
		end
	end

	ns.SetUFPetCBColor = function()
		self.Castbar:SetStatusBarColor(LolzenUIcfg.unitframes.pet["uf_pet_cb_color"][1], LolzenUIcfg.unitframes.pet["uf_pet_cb_color"][2], LolzenUIcfg.unitframes.pet["uf_pet_cb_color"][3], LolzenUIcfg.unitframes.pet["uf_pet_cb_alpha"])
	end

	ns.SetUFPetCBIconPos = function()
		self.Castbar.Icon:ClearAllPoints()
		self.Castbar.Icon:SetPoint(LolzenUIcfg.unitframes.pet["uf_pet_cb_icon_anchor1"], self.Castbar, LolzenUIcfg.unitframes.pet["uf_pet_cb_icon_anchor2"], LolzenUIcfg.unitframes.pet["uf_pet_cb_icon_posx"], LolzenUIcfg.unitframes.pet["uf_pet_cb_icon_posy"])
	end

	ns.SetUFPetCBIconCutAndSize = function()
		self.Castbar.Icon:SetWidth(LolzenUIcfg.unitframes.pet["uf_pet_cb_icon_size"])
		if LolzenUIcfg.unitframes.pet["uf_pet_cb_icon_cut"] == true then
			self.Castbar.Icon:SetHeight(LolzenUIcfg.unitframes.pet["uf_pet_height"])
			-- Get the % point of the texture to show
			-- We calculate the percentage of the icon which has to be cut, depending on icon size, and unitframe size which are both variables
			local p1 = (LolzenUIcfg.unitframes.pet["uf_pet_cb_icon_size"]-LolzenUIcfg.unitframes.pet["uf_pet_height"])/2
			local p2 = p1+LolzenUIcfg.unitframes.pet["uf_pet_height"]
			self.Castbar.Icon:SetTexCoord(0.1, 0.9, 1/(LolzenUIcfg.unitframes.pet["uf_pet_cb_icon_size"]/p1), 0.9/(0.1+(LolzenUIcfg.unitframes.pet["uf_pet_cb_icon_size"]/p2)))
		else
			self.Castbar.Icon:SetHeight(LolzenUIcfg.unitframes.pet["uf_pet_cb_icon_size"])
			self.Castbar.Icon:SetTexCoord(.07, .93, .07, .93)

			self.Castbar.Shield:SetSize(self.Castbar.Icon:GetWidth()*3, self.Castbar.Icon:GetHeight()*3)
			self.Castbar.Shield:SetPoint("CENTER", self.Castbar.Icon, 0, 0)
		end
	end

	ns.SetUFPetCBTimePos = function()
		self.Castbar.Text:ClearAllPoints()
		self.Castbar.Time:SetPoint(LolzenUIcfg.unitframes.pet["uf_pet_cb_time_anchor1"], self.Castbar.Icon, LolzenUIcfg.unitframes.pet["uf_pet_cb_time_anchor2"], LolzenUIcfg.unitframes.pet["uf_pet_cb_time_posx"], LolzenUIcfg.unitframes.pet["uf_pet_cb_time_posy"])
	end

	ns.SetUFPetCBTextPos = function()
		self.Castbar.Text:ClearAllPoints()
		self.Castbar.Text:SetPoint(LolzenUIcfg.unitframes.pet["uf_pet_cb_text_anchor1"], self.Castbar, LolzenUIcfg.unitframes.pet["uf_pet_cb_text_anchor2"], LolzenUIcfg.unitframes.pet["uf_pet_cb_text_posx"], LolzenUIcfg.unitframes.pet["uf_pet_cb_text_posy"])
	end

	ns.SetUFPetCBTextFont = function()
		self.Castbar.Time:SetFont(LSM:Fetch("font", LolzenUIcfg.unitframes.pet["uf_pet_cb_font"]), LolzenUIcfg.unitframes.pet["uf_pet_cb_font_size"], LolzenUIcfg.unitframes.pet["uf_pet_cb_font_flag"])
		self.Castbar.Text:SetFont(LSM:Fetch("font", LolzenUIcfg.unitframes.pet["uf_pet_cb_font"]), LolzenUIcfg.unitframes.pet["uf_pet_cb_font_size"], LolzenUIcfg.unitframes.pet["uf_pet_cb_font_flag"])
	end

	ns.SetUFPetCBTextColor = function()
		self.Castbar.Time:SetTextColor(LolzenUIcfg.unitframes.pet["uf_pet_cb_font_color"][1], LolzenUIcfg.unitframes.pet["uf_pet_cb_font_color"][2], LolzenUIcfg.unitframes.pet["uf_pet_cb_font_color"][3])
		self.Castbar.Text:SetTextColor(LolzenUIcfg.unitframes.pet["uf_pet_cb_font_color"][1], LolzenUIcfg.unitframes.pet["uf_pet_cb_font_color"][2], LolzenUIcfg.unitframes.pet["uf_pet_cb_font_color"][3])
	end
end