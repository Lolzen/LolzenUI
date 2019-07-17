--// unitframes: player // --

local _, ns = ...
local LSM = LibStub("LibSharedMedia-3.0")

local UpdateThreat = function(self, event, unit)
	local status = UnitThreatSituation(unit)
	if status and status > 0 then
		local r, g, b = GetThreatStatusColor(status)
		self.Glow:SetBackdropBorderColor(r, g, b, 1)
	else
		self.Glow:SetBackdropBorderColor(0, 0, 0, 0)
	end
end

local PostUpdateClassPower = function(element, power, maxPower, maxPowerChanged)
	if not maxPower or not maxPowerChanged then return end

	for i = 1, maxPower do
		local parent = element[i]:GetParent()
		element[i]:SetSize((parent:GetWidth()/maxPower) - ((LolzenUIcfg.unitframes.player["uf_player_classpower_spacing"]*maxPower-1)/(maxPower+1)), 8)
	end
end

ns.SetupPlayer = function(self, ...)
	ns.shared(self, ...)

	if LolzenUIcfg.unitframes.player["uf_player_use_own_hp_font_settings"] == true then
		self.Health.value:SetFont(LSM:Fetch("font", LolzenUIcfg.unitframes.player["uf_player_hp_font"]), LolzenUIcfg.unitframes.player["uf_player_hp_font_size"], LolzenUIcfg.unitframes.player["uf_player_hp_font_flag"])
		self.Health.value:SetPoint(LolzenUIcfg.unitframes.player["uf_player_hp_anchor"], LolzenUIcfg.unitframes.player["uf_player_hp_posx"], LolzenUIcfg.unitframes.player["uf_player_hp_posy"])
	end

	self.Border:SetPoint("TOPLEFT", self, -3, 3)
	self.Border:SetPoint("BOTTOMRIGHT", self, 3, -2)

	self:SetSize(LolzenUIcfg.unitframes.player["uf_player_width"], LolzenUIcfg.unitframes.player["uf_player_height"])

	self.Power:SetPoint("LEFT")
	self.Power:SetPoint("RIGHT")
	self.Power:SetPoint("TOP", self.Health, "BOTTOM", 0, 2)

	self.PowerDivider:SetSize(self:GetWidth(), 1)
	self.PowerDivider:SetPoint("TOPLEFT", self.Power, 0, 1)
	self.PowerDivider:SetDrawLayer("BACKGROUND", 1)

	if LolzenUIcfg.unitframes.player["uf_player_pp_parent"] == "hp" then
		self.Power.value:SetPoint(LolzenUIcfg.unitframes.player["uf_player_pp_anchor"], self.Health.value, LolzenUIcfg.unitframes.player["uf_player_pp_anchor2"], LolzenUIcfg.unitframes.player["uf_player_pp_posx"], LolzenUIcfg.unitframes.player["uf_player_pp_posy"])
	elseif LolzenUIcfg.unitframes.player["uf_player_pp_parent"] == "self" then
		self.Power.value:SetPoint(LolzenUIcfg.unitframes.player["uf_player_pp_anchor"], self, LolzenUIcfg.unitframes.player["uf_player_pp_anchor2"], LolzenUIcfg.unitframes.player["uf_player_pp_posx"], LolzenUIcfg.unitframes.player["uf_player_pp_posy"])
	end
	self.Power.value:SetFont(LSM:Fetch("font", LolzenUIcfg.unitframes.player["uf_player_pp_font"]), LolzenUIcfg.unitframes.player["uf_player_pp_font_size"], LolzenUIcfg.unitframes.player["uf_player_pp_font_flag"])

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
	self.Castbar.Text:SetTextColor(LolzenUIcfg.unitframes.player["uf_player_cb_font_color"][1], LolzenUIcfg.unitframes.player["uf_player_cb_font_color"][2], LolzenUIcfg.unitframes.player["uf_player_cb_font_color"][3])-- ClassPower (Combo Points, etc)
	local ClassPower = {}
	for i=1, 10 do
		ClassPower[i] = CreateFrame("StatusBar", "ClassPower"..i.."Bar", self)
		ClassPower[i]:SetStatusBarTexture(LSM:Fetch("statusbar", LolzenUIcfg.unitframes.general["uf_statusbar_texture"]))
		if i == 1 then
			ClassPower[i]:SetPoint(LolzenUIcfg.unitframes.player["uf_player_classpower_anchor1"], self, LolzenUIcfg.unitframes.player["uf_player_classpower_anchor2"], LolzenUIcfg.unitframes.player["uf_player_classpower_posx"], LolzenUIcfg.unitframes.player["uf_player_classpower_posy"])
		else
			ClassPower[i]:SetPoint("LEFT", ClassPower[i-1], "RIGHT", LolzenUIcfg.unitframes.player["uf_player_classpower_spacing"], 0)
		end

		ClassPower[i].border = CreateFrame("Frame", nil, ClassPower[i])
		ClassPower[i].border:SetBackdrop({
			edgeFile = LSM:Fetch("border", LolzenUIcfg.unitframes.player["uf_player_classpower_border"]),
			tile=true, tileSize=4, edgeSize=4,
			insets={left=0.5, right=0.5, top=0.5, bottom=0.5}
		})
		ClassPower[i].border:SetPoint("TOPLEFT", ClassPower[i], -1.5, 1.5)
		ClassPower[i].border:SetPoint("BOTTOMRIGHT", ClassPower[i], 1, -1)
		ClassPower[i].border:SetBackdropBorderColor(0, 0, 0)
		ClassPower[i].border:SetFrameLevel(3)
	end
	self.ClassPower = ClassPower

	if select(2, UnitClass('player')) == "DEATHKNIGHT" then
		-- Runes
		local Runes = {}
		for i = 1, 6 do
			Runes[i] = CreateFrame("StatusBar", "Rune"..i.."Bar", self)
			Runes[i]:SetStatusBarTexture(LSM:Fetch("statusbar", LolzenUIcfg.unitframes.general["uf_statusbar_texture"]))
			Runes[i]:SetSize((self:GetWidth()/6) - ((LolzenUIcfg.unitframes.player["uf_player_classpower_spacing"]*5)/(6)), 8)
			if i == 1 then
				Runes[i]:SetPoint(LolzenUIcfg.unitframes.player["uf_player_classpower_anchor1"], self, LolzenUIcfg.unitframes.player["uf_player_classpower_anchor2"], LolzenUIcfg.unitframes.player["uf_player_classpower_posx"], LolzenUIcfg.unitframes.player["uf_player_classpower_posy"])
			else
				Runes[i]:SetPoint("LEFT", Runes[i-1], "RIGHT", LolzenUIcfg.unitframes.player["uf_player_classpower_spacing"], 0)
			end

			Runes[i].border = CreateFrame("Frame", nil, Runes[i])
			Runes[i].border:SetBackdrop({
				edgeFile = LSM:Fetch("border", LolzenUIcfg.unitframes.player["uf_player_classpower_border"]),
				tile=true, tileSize=4, edgeSize=4,
				--insets={left=0, right=1, top=0, bottom=0}
			})
			Runes[i].border:SetPoint("TOPLEFT", Runes[i], -1.5, 1.5)
			Runes[i].border:SetPoint("BOTTOMRIGHT", Runes[i], 1, -1)
			Runes[i].border:SetBackdropBorderColor(0, 0, 0)
			Runes[i].border:SetFrameLevel(3)
		end
		self.Runes = Runes
	end

	if select(2, UnitClass('player')) == "MONK" then
		--stagger
		local Stagger = CreateFrame('StatusBar', nil, self)
		Stagger:SetSize(LolzenUIcfg.unitframes.player["uf_player_width"], 8)
		Stagger:SetStatusBarTexture(LSM:Fetch("statusbar", LolzenUIcfg.unitframes.general["uf_statusbar_texture"]))
		Stagger:SetPoint(LolzenUIcfg.unitframes.player["uf_player_classpower_anchor1"], self, LolzenUIcfg.unitframes.player["uf_player_classpower_anchor2"], LolzenUIcfg.unitframes.player["uf_player_classpower_posx"], LolzenUIcfg.unitframes.player["uf_player_classpower_posy"])

		Stagger.border = CreateFrame("Frame", nil, Stagger)
		Stagger.border:SetBackdrop({
			edgeFile = LSM:Fetch("border", LolzenUIcfg.unitframes.player["uf_player_classpower_border"]),
			tile=true, tileSize=4, edgeSize=4,
			--insets={left=0, right=1, top=0, bottom=0}
		})
		Stagger.border:SetPoint("TOPLEFT", Stagger, -1.5, 1.5)
		Stagger.border:SetPoint("BOTTOMRIGHT", Stagger, 1, -1)
		Stagger.border:SetBackdropBorderColor(0, 0, 0)
		Stagger.border:SetFrameLevel(3)

		self.Stagger = Stagger
	end

	local Glow = CreateFrame("Frame", nil, self)
	Glow:SetBackdrop({
		edgeFile ="Interface\\AddOns\\LolzenUI\\media\\glow", edgeSize = 5,
		insets = {left = 4, right = 4, top = 4, bottom = 4}
	})
	Glow:SetPoint("TOPLEFT", self, -5, 5)
	Glow:SetPoint("BOTTOMRIGHT", self, 5, -5)
	Glow:SetFrameLevel(2)
	self.Glow = Glow
	table.insert(self.__elements, UpdateThreat)
	self:RegisterEvent("UNIT_THREAT_SITUATION_UPDATE", UpdateThreat)
	self:RegisterEvent("UNIT_THREAT_LIST_UPDATE", UpdateThreat)

	ClassPower.PostUpdate = PostUpdateClassPower
end