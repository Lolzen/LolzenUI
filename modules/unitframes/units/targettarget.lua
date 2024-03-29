local _, ns = ...
local LSM = LibStub("LibSharedMedia-3.0")

ns.SetupTargetTarget = function(self, unit)
	ns.shared(self, unit)

	self:SetSize(LolzenUIcfg.unitframes.targettarget["uf_targettarget_width"], LolzenUIcfg.unitframes.targettarget["uf_targettarget_height"])

	if LolzenUIcfg.unitframes.targettarget["uf_targettarget_use_own_hp_font_settings"] == true then
		self.Health.value:SetFont(LSM:Fetch("font", LolzenUIcfg.unitframes.targettarget["uf_targettarget_hp_font"]), LolzenUIcfg.unitframes.targettarget["uf_targettarget_hp_font_size"], LolzenUIcfg.unitframes.targettarget["uf_targettarget_hp_font_flag"])
		self.Health.value:SetPoint(LolzenUIcfg.unitframes.targettarget["uf_targettarget_hp_anchor"], LolzenUIcfg.unitframes.targettarget["uf_targettarget_hp_posx"], LolzenUIcfg.unitframes.targettarget["uf_targettarget_hp_posy"])
	end

	self.Border:SetPoint("TOPLEFT", self, -3, 3)
	self.Border:SetPoint("BOTTOMRIGHT", self, 3, -3)

	ns.AddCombatFade(self, unit)
	ns.AddRaidMark(self, unit)

	ns.SetUFToTSize = function()
		self:SetSize(LolzenUIcfg.unitframes.targettarget["uf_targettarget_width"], LolzenUIcfg.unitframes.targettarget["uf_targettarget_height"])
	end

	ns.SetUFToTOwnFont = function()
		if LolzenUIcfg.unitframes.targettarget["uf_targettarget_use_own_hp_font_settings"] == true then
			self.Health.value:SetFont(LSM:Fetch("font", LolzenUIcfg.unitframes.targettarget["uf_targettarget_hp_font"]), LolzenUIcfg.unitframes.targettarget["uf_targettarget_hp_font_size"], LolzenUIcfg.unitframes.targettarget["uf_targettarget_hp_font_flag"])
			self.Health.value:ClearAllPoints()
			self.Health.value:SetPoint(LolzenUIcfg.unitframes.targettarget["uf_targettarget_hp_anchor"], LolzenUIcfg.unitframes.targettarget["uf_targettarget_hp_posx"], LolzenUIcfg.unitframes.targettarget["uf_targettarget_hp_posy"])
		else
			self.Health.value:SetFont(LSM:Fetch("font", LolzenUIcfg.unitframes.general["uf_general_hp_font"]), LolzenUIcfg.unitframes.general["uf_general_hp_font_size"], LolzenUIcfg.unitframes.general["uf_general_hp_font_flag"])
			self.Health.value:ClearAllPoints()
			self.Health.value:SetPoint(LolzenUIcfg.unitframes.general["uf_general_hp_anchor"], LolzenUIcfg.unitframes.general["uf_general_hp_posx"], LolzenUIcfg.unitframes.general["uf_general_hp_posy"])
		end
	end

	ns.SetUFToTHPFont = function()
		if LolzenUIcfg.unitframes.targettarget["uf_targettarget_use_own_hp_font_settings"] == true then
			self.Health.value:SetFont(LSM:Fetch("font", LolzenUIcfg.unitframes.targettarget["uf_targettarget_hp_font"]), LolzenUIcfg.unitframes.targettarget["uf_targettarget_hp_font_size"], LolzenUIcfg.unitframes.targettarget["uf_targettarget_hp_font_flag"])
		end
	end

	ns.SetUFToTHPPos = function()
		if LolzenUIcfg.unitframes.targettarget["uf_targettarget_use_own_hp_font_settings"] == true then
			self.Health.value:ClearAllPoints()
			self.Health.value:SetPoint(LolzenUIcfg.unitframes.targettarget["uf_targettarget_hp_anchor"], LolzenUIcfg.unitframes.targettarget["uf_targettarget_hp_posx"], LolzenUIcfg.unitframes.targettarget["uf_targettarget_hp_posy"])
		end
	end
end