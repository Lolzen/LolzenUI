local _, ns = ...
local LSM = LibStub("LibSharedMedia-3.0")
local oUF = ns.oUF

ns.shared = function(self, unit)
	self.colors.power["MANA"] = LolzenUIcfg.unitframes.powercolors[0]
	self.colors.power["RAGE"] = LolzenUIcfg.unitframes.powercolors[1]
	self.colors.power["FOCUS"] = LolzenUIcfg.unitframes.powercolors[2]
	self.colors.power["ENERGY"] = LolzenUIcfg.unitframes.powercolors[3]
	self.colors.power["COMBO_POINTS"] = LolzenUIcfg.unitframes.powercolors[4]
	self.colors.power["RUNES"] = LolzenUIcfg.unitframes.powercolors[5]
	self.colors.power["RUNIC_POWER"] = LolzenUIcfg.unitframes.powercolors[6]
	self.colors.power["SOUL_SHARDS"] = LolzenUIcfg.unitframes.powercolors[7]
	self.colors.power["LUNAR_POWER"] = LolzenUIcfg.unitframes.powercolors[8]
	self.colors.power["HOLY_POWER"] = LolzenUIcfg.unitframes.powercolors[9]
	self.colors.power["MAELSTROM"] = LolzenUIcfg.unitframes.powercolors[11]
	self.colors.power["CHI"] = LolzenUIcfg.unitframes.powercolors[12]
	self.colors.power["INSANITY"] = LolzenUIcfg.unitframes.powercolors[13]
	self.colors.power["ARCANE_CHARGES"] = LolzenUIcfg.unitframes.powercolors[16]
	self.colors.power["FURY"] = LolzenUIcfg.unitframes.powercolors[17]
	self.colors.power["PAIN"] = LolzenUIcfg.unitframes.powercolors[18]

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