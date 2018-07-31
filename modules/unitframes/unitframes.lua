--// unitframes // --

local _, ns = ...
local LSM = LibStub("LibSharedMedia-3.0")
local oUF = ns.oUF

ns.RegisterModule("unitframes", "Highly customizable unitframes based on oUF", true)

local f = CreateFrame("Frame")
f:RegisterEvent("ADDON_LOADED")
f:SetScript("OnEvent", function(self, event, addon)
	if addon == "LolzenUI" then
		if LolzenUIcfg.modules["unitframes"] == false then return end

		local siValue = function(val)
			if val >= 1e6 then
				if LolzenUIcfg.unitframes["uf_use_dot_format"] == true then
					return ("%.1fm"):format(val / 1e6)
				else
					return ("%.1f"):format(val / 1e6):gsub('%.', 'm')
				end
			elseif val >= 1e4 then
				if LolzenUIcfg.unitframes["uf_use_dot_format"] == true then
					return ("%.1fk"):format(val / 1e3)
				else
					return ("%.1f"):format(val / 1e3):gsub('%.', 'k')
				end
			else
				return val
			end
		end

		-- tags
		local tags = oUF.Tags.Methods or oUF.Tags
		local tagevents = oUF.TagEvents or oUF.Tags.Events

		tags["lolzen:health"] = function(unit)
			if not UnitIsConnected(unit) or UnitIsDead(unit) or UnitIsGhost(unit) then return end

			local min, max = UnitHealth(unit), UnitHealthMax(unit)
			if LolzenUIcfg.unitframes["uf_use_sivalue"] == true then
				return siValue(min)
			else
				return min
			end
		end

		tags["lolzen:perhp"] = function(unit)
			if not UnitIsConnected(unit) or UnitIsDead(unit) or UnitIsGhost(unit) then return end
			
			local min, max = UnitHealth(unit), UnitHealthMax(unit)
			return math.floor(UnitHealth(unit) / max * 100 + 0.5).."%"
		end

		tags["lolzen:power"] = function(unit)
			local min, max = UnitPower(unit), UnitPowerMax(unit)
			if min == 0 or max == 0 or not UnitIsConnected(unit) or UnitIsDead(unit) or UnitIsGhost(unit) then return end

			if LolzenUIcfg.unitframes["uf_use_sivalue"] == true then
				return siValue(min)
			else
				return min
			end
		end
		tagevents["lolzen:power"] = tagevents.missingpp

		tags["lolzen:level"] = function(unit)
			if not UnitLevel(unit) or UnitLevel(unit) == -1 then
				return "|cffff0000??|r "
			else
				return ("|cff%02x%02x%02x%d|r"):format(GetQuestDifficultyColor(UnitLevel(unit)).r*255, GetQuestDifficultyColor(UnitLevel(unit)).g*255, GetQuestDifficultyColor(UnitLevel(unit)).b*255, UnitLevel(unit))
			end
		end
		-- tags end

		local PostCastStart = function(Castbar, unit, spell, spellrank)
			Castbar.Text:SetText(spell)
			if Castbar.notInterruptible then
				Castbar.Icon:SetDesaturated(true)
			else
				Castbar.Icon:SetDesaturated(false)
			end
		end

		local PostUpdateHealth = function(Health, unit, min, max)
			if UnitIsDead(unit) then
				Health:SetValue(0)
			elseif UnitIsGhost(unit) then
				Health:SetValue(0)
			end
			local gradient = {1, 1, 0, 0, 1, 1, 0, 0, 1, 0}

			local r, g, b = oUF.ColorGradient(min / max, unpack(gradient))
			Health.value:SetTextColor(r,g,b)
		end

		local UpdateThreat = function(self, event, unit)
			local status = UnitThreatSituation(unit)
			if status and status > 0 then
				if not self.Glow:IsShown() then
					self.Glow:Show()
				end
			else
				if self.Glow:IsShown() then
					self.Glow:Hide()
				end
			end
		end

		local PostUpdateClassPower = function(element, power, maxPower, maxPowerChanged)
			if not maxPower or not maxPowerChanged then return end

			for i = 1, maxPower do
				local parent = element[i]:GetParent()
				element[i]:SetSize((parent:GetWidth()/maxPower) - ((LolzenUIcfg.unitframes["uf_player_classpower_spacing"]*maxPower-1)/(maxPower+1)), 8)
			end
		end

		local PostUpdatePower = function(Power, unit, min, max)
			-- use custom power colors
			local r, g, b = unpack(LolzenUIcfg.unitframes["uf_power_colors"][UnitPowerType(unit)])

			Power:SetStatusBarColor(r, g, b)
			Power.value:SetTextColor(r, g, b)
			local parent = Power:GetParent()
			if parent.PowerDivider then
				if min > 0 then
					parent.PowerDivider:Show()
				else
					parent.PowerDivider:Hide()
				end
			end
		end

		local PostCreateIcon = function(Auras, button)
			local count = button.count
			count:ClearAllPoints()
			count:SetPoint"BOTTOM"

			button.icon:SetTexCoord(.07, .93, .07, .93)

			local iconborder = CreateFrame("Frame")
			iconborder:SetBackdrop({
				edgeFile = "Interface\\AddOns\\LolzenUI\\media\\border", edgeSize = 12,
				insets = {left = 4, right = 4, top = 4, bottom = 4},
			})
			iconborder:SetParent(button)
			iconborder:SetPoint("TOPLEFT", button, -2, 3)
			iconborder:SetPoint("BOTTOMRIGHT", button, 3, -2)
			iconborder:SetBackdropBorderColor(0, 0, 0)
			iconborder:SetFrameLevel(3)

			--[[
			local overlay = button.overlay
			overlay.SetVertexColor = overlayProxy
			overlay:SetTexture("Interface\\AddOns\\LolzenUI\\media\\auraborder")
			overlay:SetTexCoord(.07, .93, .07, .93)
			]]
		end

		local PostUpdateIcon = function(icons, unit, button, index, offset, filter, isDebuff)
			if LolzenUIcfg.unitframes["uf_"..unit.."_aura_desature_nonplayer_auras"] == true then
				local texture = button.icon
				if button.isPlayer then
					texture:SetDesaturated(false)
				else
					texture:SetDesaturated(true)
				end
			end
		end

		local CreateAura = function(self, num)
			local Auras = CreateFrame("Frame", nil, self)
			--local unit = gsub(self.unit, "(%d)", "")
			local unit = self.unit

			-- check if SVs exist, otherwise do nothing
			if LolzenUIcfg.unitframes["uf_"..unit.."_aura_size"] then
				Auras:SetSize(num * (LolzenUIcfg.unitframes["uf_"..unit.."_aura_size"] + 4), LolzenUIcfg.unitframes["uf_"..unit.."_aura_size"])
				Auras.size = LolzenUIcfg.unitframes["uf_"..unit.."_aura_size"]
			-- create a fallback to prevent getting errors in BfA
			else
				Auras:SetSize(num * (23 + 4) , 23)
				Auras.size = 23
			end
			if LolzenUIcfg.unitframes["uf_"..unit.."_aura_spacing"] then
				Auras.spacing = LolzenUIcfg.unitframes["uf_"..unit.."_aura_spacing"]
			end

			Auras.PostCreateIcon = PostCreateIcon

			return Auras
		end

		local shared = function(self, unit, isSingle)
			self:SetScript("OnEnter", UnitFrame_OnEnter)
			self:SetScript("OnLeave", UnitFrame_OnLeave)

			self:RegisterForClicks("AnyUp")

			local Border = CreateFrame("Frame", nil, self)
			Border:SetBackdrop({
				edgeFile = LSM:Fetch("border", LolzenUIcfg.unitframes["uf_border"]), edgeSize = 12,
				insets = {left = 4, right = 4, top = 4, bottom = 4},
			})
			Border:SetPoint("TOPLEFT", self, -3, 3)
			Border:SetPoint("BOTTOMRIGHT", self, 3, -3)
			Border:SetBackdropBorderColor(0, 0, 0)
			Border:SetFrameLevel(3)
			self.Border = Border

			local Health = CreateFrame("StatusBar", nil, self)
			Health:SetStatusBarTexture(LSM:Fetch("statusbar", LolzenUIcfg.unitframes["uf_statusbar_texture"]))
			Health:SetFrameStrata("LOW")

			Health.frequentUpdates = true
			Health.colorTapping = true
			Health.colorClass = true
			Health.colorReaction = true

			Health:SetPoint("TOP")
			Health:SetPoint("LEFT")
			Health:SetPoint("RIGHT")

			self.Health = Health

			local HealthPoints = Health:CreateFontString(nil, "OVERLAY")
			HealthPoints:SetFont(LSM:Fetch("font", LolzenUIcfg.unitframes["uf_general_hp_font"]), LolzenUIcfg.unitframes["uf_general_hp_font_size"], LolzenUIcfg.unitframes["uf_general_hp_font_flag"])
			HealthPoints:SetPoint(LolzenUIcfg.unitframes["uf_general_hp_anchor"], LolzenUIcfg.unitframes["uf_general_hp_posx"], LolzenUIcfg.unitframes["uf_general_hp_posy"])
			if LolzenUIcfg.unitframes["uf_use_val_and_perc"] == true then
				if LolzenUIcfg.unitframes["uf_perc_first"] == true then
					self:Tag(HealthPoints, "[|cffc41f3b>dead<|r][|cff999999>offline<|r][lolzen:perhp]"..LolzenUIcfg.unitframes["uf_val_perc_divider"].."[lolzen:health]")
				else
					self:Tag(HealthPoints, "[|cffc41f3b>dead<|r][|cff999999>offline<|r][lolzen:health]"..LolzenUIcfg.unitframes["uf_val_perc_divider"].."[lolzen:perhp]")
				end
			elseif LolzenUIcfg.unitframes["uf_use_hp_percent"] == true and LolzenUIcfg.unitframes["uf_use_val_and_perc"] == false then
				self:Tag(HealthPoints, "[|cffc41f3b>dead<|r][|cff999999>offline<|r][lolzen:perhp]")
			else
				self:Tag(HealthPoints, "[|cffc41f3b>dead<|r][|cff999999>offline<|r][lolzen:health]")
			end

			Health.value = HealthPoints

			local Power = CreateFrame("StatusBar", nil, self)
			Power:SetHeight(2)
			Power:SetStatusBarTexture(LSM:Fetch("statusbar", LolzenUIcfg.unitframes["uf_statusbar_texture"]))
			Power:SetFrameStrata("MEDIUM")

			Power.frequentUpdates = true

			self.Power = Power

			local PowerDivider = Power:CreateTexture(nil, "OVERLAY")
			PowerDivider:SetTexture("Interface\\AddOns\\LolzenUI\\media\\statusbar")
			PowerDivider:SetVertexColor(0, 0, 0)
			self.PowerDivider = PowerDivider

			local PowerPoints = Power:CreateFontString(nil, "OVERLAY")
			PowerPoints:SetFont("Interface\\AddOns\\LolzenUI\\fonts\\DroidSansBold.ttf", 18, "THINOUTLINE")
			self:Tag(PowerPoints, "[lolzen:power]")
			self.Power.value = PowerPoints

			local bg = self:CreateTexture(nil, "BORDER")
			bg:SetAllPoints(self)
			bg:SetTexture(LSM:Fetch("statusbar", LolzenUIcfg.unitframes["uf_statusbar_texture"]))
			bg:SetVertexColor(0.3, 0.3, 0.3)
			bg:SetAlpha(1)
			self.Background = bg

			local RaidTargetIndicator = Health:CreateTexture(nil, "OVERLAY")
			RaidTargetIndicator:SetSize(LolzenUIcfg.unitframes["uf_ri_size"], LolzenUIcfg.unitframes["uf_ri_size"])
			RaidTargetIndicator:SetPoint(LolzenUIcfg.unitframes["uf_ri_anchor"], Health, LolzenUIcfg.unitframes["uf_ri_posx"], LolzenUIcfg.unitframes["uf_ri_posy"])
			self.RaidTargetIndicator = RaidTargetIndicator

			local lead = Health:CreateTexture(nil, "OVERLAY")
			lead:SetSize(LolzenUIcfg.unitframes["uf_lead_size"], LolzenUIcfg.unitframes["uf_lead_size"])
			lead:SetPoint(LolzenUIcfg.unitframes["uf_lead_anchor"], Health, LolzenUIcfg.unitframes["uf_lead_posx"], LolzenUIcfg.unitframes["uf_lead_posy"])
			self.LeaderIndicator = lead

			local Castbar = CreateFrame("StatusBar", nil, self)
			Castbar:SetStatusBarTexture(LSM:Fetch("statusbar", LolzenUIcfg.unitframes["uf_statusbar_texture"]))
			Castbar:SetFrameStrata("MEDIUM")
			Castbar:SetParent(self)
			self.Castbar = Castbar

			local cbbg = Castbar:CreateTexture(nil, "BORDER")
			cbbg:SetTexture(LSM:Fetch("statusbar", LolzenUIcfg.unitframes["uf_statusbar_texture"]))
			cbbg:SetVertexColor(0.3, 0.3, 0.3)
			cbbg:SetAlpha(1)
			self.Castbar.background = cbbg

			local cbborder = CreateFrame("Frame")
			cbborder:SetBackdrop({
				edgeFile = LSM:Fetch("border", LolzenUIcfg.unitframes["uf_border"]), edgeSize = 12,
				insets = {left = 4, right = 4, top = 4, bottom = 4},
			})
			cbborder:SetParent(Castbar)
			cbborder:SetBackdropBorderColor(0, 0, 0)
			cbborder:SetFrameLevel(3)
			self.Castbar.border = cbborder

			local Spark = Castbar:CreateTexture(nil, "OVERLAY")
			Spark:SetBlendMode("ADD")
			self.Castbar.Spark = Spark

			local icon = Castbar:CreateTexture(nil, "BACKGROUND")
			icon:SetDrawLayer("OVERLAY", 0)
			self.Castbar.Icon = icon

			local iconborder = CreateFrame("Frame")
			iconborder:SetBackdrop({
				edgeFile = LSM:Fetch("border", LolzenUIcfg.unitframes["uf_border"]), edgeSize = 12,
				insets = {left = 4, right = 4, top = 4, bottom = 4},
			})
			iconborder:SetParent(Castbar)
			iconborder:SetPoint("TOPLEFT", icon, -2, 3)
			iconborder:SetPoint("BOTTOMRIGHT", icon, 3, -2)
			iconborder:SetBackdropBorderColor(0, 0, 0)
			iconborder:SetFrameLevel(3)
			self.Castbar.Iconborder = iconborder

			local Time = Castbar:CreateFontString(nil, "OVERLAY")
			Time:SetFont("Interface\\AddOns\\LolzenUI\\fonts\\DroidSansBold.ttf", 12, "OUTLINE")
			self.Castbar.Time = Time

			local cbtext = Castbar:CreateFontString(nil, "OVERLAY")
			cbtext:SetFont("Interface\\AddOns\\LolzenUI\\fonts\\DroidSansBold.ttf", 12, "OUTLINE")
			self.Castbar.Text = cbtext

			local Shield = Castbar:CreateTexture(nil, "ARTWORK")
			Shield:SetTexture("Interface\\AddOns\\LolzenUI\\media\\shield")
			self.Castbar.Shield = Shield

			local Buffs = CreateAura(self, 8)
			self.Buffs = Buffs

			local Debuffs = CreateAura(self, 8)
			self.Debuffs = Debuffs

			local Auras = CreateAura(self, 8)
			self.Auras = Auras

			local panel = CreateFrame("Frame")
			panel:SetParent(self)
			panel:SetFrameLevel(3)
			self.Panel = panel

			local Panelborder = CreateFrame("Frame", nil, self)
			Panelborder:SetBackdrop({
				bgFile = "Interface\\AddOns\\LolzenUI\\media\\statusbar",
				edgeFile = LSM:Fetch("border", LolzenUIcfg.unitframes["uf_border"]), edgeSize = 12,
				insets = {left = 2, right = 2, top = 3, bottom = 2},
			})
			Panelborder:SetPoint("TOPLEFT", panel, -3, 3)
			Panelborder:SetPoint("BOTTOMRIGHT", panel, 3, -1)
			Panelborder:SetBackdropBorderColor(0, 0, 0)
			Panelborder:SetFrameLevel(3)
			Panelborder:SetBackdropColor(0, 0, 0, 0.8)

			local level = Health:CreateFontString(nil, "OVERLAY")
			level:SetFont("Interface\\AddOns\\LolzenUI\\fonts\\DroidSans.ttf", 12, "THINOUTLINE")
			self:Tag(level, "[lolzen:level][shortclassification]")
			self.Level = level

			local name = Health:CreateFontString(nil, "OVERLAY")
			name:SetFont("Interface\\AddOns\\LolzenUI\\fonts\\DroidSans.ttf", 12, "THINOUTLINE")
			name:SetTextColor(1, 1, 1)
			self:Tag(name, "[name]")
			self.Name = name

			local role = Health:CreateTexture(nil, "OVERLAY")
			self.GroupRoleIndicator = role

			local rc = Health:CreateTexture(nil, "OVERLAY")
			self.ReadyCheckIndicator = rc

			if(isSingle) then
				self:SetSize(220, 21)
			end

			if LolzenUIcfg.unitframes["uf_fade_outofreach"] == true then
				self.Range = {
					insideAlpha = 1,
					outsideAlpha = LolzenUIcfg.unitframes["uf_fade_outofreach_alpha"],
				}
			end

			if LolzenUIcfg.unitframes["uf_fade_combat"] == true then
				if unit ~= "party" and unit ~= "raid" then
					self.CombatFade = {
						incombatAlpha = LolzenUIcfg.unitframes["uf_fade_combat_incombat"],
						outofcombatAlpha = LolzenUIcfg.unitframes["uf_fade_combat_outofcombat"],
						elements = {Health, Power, Border, bg, panel},
					}
				end
			end

			Health.PostUpdate = PostUpdateHealth
			Power.PostUpdate = PostUpdatePower
			Castbar.PostChannelStart = PostCastStart
			Castbar.PostCastStart = PostCastStart
			Buffs.PostUpdateIcon = PostUpdateIcon
			Debuffs.PostUpdateIcon = PostUpdateIcon
			Auras.PostUpdateIcon = PostUpdateIcon
		end

		local UnitSpecific = {
			player = function(self, ...)
				shared(self, ...)

				if LolzenUIcfg.unitframes["uf_player_use_own_hp_font_settings"] == true then
					self.Health.value:SetFont(LSM:Fetch("font", LolzenUIcfg.unitframes["uf_player_hp_font"]), LolzenUIcfg.unitframes["uf_player_hp_font_size"], LolzenUIcfg.unitframes["uf_player_hp_font_flag"])
					self.Health.value:SetPoint(LolzenUIcfg.unitframes["uf_player_hp_anchor"], LolzenUIcfg.unitframes["uf_player_hp_posx"], LolzenUIcfg.unitframes["uf_player_hp_posy"])
				end

				self.Border:SetPoint("TOPLEFT", self, -3, 3)
				self.Border:SetPoint("BOTTOMRIGHT", self, 3, -2)

				self:SetSize(LolzenUIcfg.unitframes["uf_player_width"], LolzenUIcfg.unitframes["uf_player_height"])

				self.Power:SetPoint("LEFT")
				self.Power:SetPoint("RIGHT")
				self.Power:SetPoint("TOP", self.Health, "BOTTOM", 0, 2)

				self.PowerDivider:SetSize(self:GetWidth(), 1)
				self.PowerDivider:SetPoint("TOPLEFT", self.Power, 0, 1)
				self.PowerDivider:SetDrawLayer("BACKGROUND", 1)

				if LolzenUIcfg.unitframes["uf_player_pp_parent"] == "hp" then
					self.Power.value:SetPoint(LolzenUIcfg.unitframes["uf_player_pp_anchor"], self.Health.value, LolzenUIcfg.unitframes["uf_player_pp_anchor2"], LolzenUIcfg.unitframes["uf_player_pp_posx"], LolzenUIcfg.unitframes["uf_player_pp_posy"])
				elseif LolzenUIcfg.unitframes["uf_player_pp_parent"] == "self" then
					self.Power.value:SetPoint(LolzenUIcfg.unitframes["uf_player_pp_anchor"], self, LolzenUIcfg.unitframes["uf_player_pp_anchor2"], LolzenUIcfg.unitframes["uf_player_pp_posx"], LolzenUIcfg.unitframes["uf_player_pp_posy"])
				end
				self.Power.value:SetFont(LSM:Fetch("font", LolzenUIcfg.unitframes["uf_player_pp_font"]), LolzenUIcfg.unitframes["uf_player_pp_font_size"], LolzenUIcfg.unitframes["uf_player_pp_font_flag"])

				if LolzenUIcfg.unitframes["uf_player_cb_standalone"] == true then
					self.Castbar:SetPoint(LolzenUIcfg.unitframes["uf_player_cb_anchor1"], UIParent, LolzenUIcfg.unitframes["uf_player_cb_anchor2"], LolzenUIcfg.unitframes["uf_player_cb_posx"], LolzenUIcfg.unitframes["uf_player_cb_posy"])
					self.Castbar:SetSize(LolzenUIcfg.unitframes["uf_player_cb_width"], LolzenUIcfg.unitframes["uf_player_cb_height"])
					self.Castbar.background:SetAllPoints(self.Castbar)
					self.Castbar.border:SetPoint("TOPLEFT", self.Castbar, -2, 3)
					self.Castbar.border:SetPoint("BOTTOMRIGHT", self.Castbar, 3, -2)
				else
					self.Castbar:SetAllPoints(self.Health)
				end
				self.Castbar:SetStatusBarColor(LolzenUIcfg.unitframes["uf_player_cb_color"][1], LolzenUIcfg.unitframes["uf_player_cb_color"][2], LolzenUIcfg.unitframes["uf_player_cb_color"][3], LolzenUIcfg.unitframes["uf_player_cb_alpha"])

				self.Castbar.Spark:SetSize(self:GetWidth()/27.5, self:GetHeight()*2)

				if LolzenUIcfg.unitframes["uf_player_cb_icon_cut"] == true then
					self.Castbar.Icon:SetHeight(LolzenUIcfg.unitframes["uf_player_height"])
					-- Get the % point of the texture to show
					-- We calculate the percentage of the icon which has to be cut, depending on icon size, and unitframe size which are both variables
					local p1 = (LolzenUIcfg.unitframes["uf_player_cb_icon_size"]-LolzenUIcfg.unitframes["uf_player_height"])/2
					local p2 = p1+LolzenUIcfg.unitframes["uf_player_height"]
					self.Castbar.Icon:SetTexCoord(0.1, 0.9, 1/(LolzenUIcfg.unitframes["uf_player_cb_icon_size"]/p1), 0.9/(0.1+(LolzenUIcfg.unitframes["uf_player_cb_icon_size"]/p2)))
				else
					self.Castbar.Icon:SetHeight(LolzenUIcfg.unitframes["uf_player_cb_icon_size"])
					self.Castbar.Icon:SetTexCoord(.07, .93, .07, .93)

					self.Castbar.Shield:SetSize(self.Castbar.Icon:GetWidth()*3, self.Castbar.Icon:GetHeight()*3)
					self.Castbar.Shield:SetPoint("CENTER", self.Castbar.Icon, 0, 0)
				end

				self.Castbar.Icon:SetWidth(LolzenUIcfg.unitframes["uf_player_cb_icon_size"])
				self.Castbar.Icon:SetPoint(LolzenUIcfg.unitframes["uf_player_cb_icon_anchor1"], self.Castbar, LolzenUIcfg.unitframes["uf_player_cb_icon_anchor2"], LolzenUIcfg.unitframes["uf_player_cb_icon_posx"], LolzenUIcfg.unitframes["uf_player_cb_icon_posy"])

				self.Castbar.Time:SetPoint(LolzenUIcfg.unitframes["uf_player_cb_time_anchor1"], self.Castbar.Icon, LolzenUIcfg.unitframes["uf_player_cb_time_anchor2"], LolzenUIcfg.unitframes["uf_player_cb_time_posx"], LolzenUIcfg.unitframes["uf_player_cb_time_posy"])
				self.Castbar.Time:SetFont(LSM:Fetch("font", LolzenUIcfg.unitframes["uf_player_cb_font"]), LolzenUIcfg.unitframes["uf_player_cb_font_size"], LolzenUIcfg.unitframes["uf_player_cb_font_flag"])
				self.Castbar.Time:SetTextColor(LolzenUIcfg.unitframes["uf_player_cb_font_color"][1], LolzenUIcfg.unitframes["uf_player_cb_font_color"][2], LolzenUIcfg.unitframes["uf_player_cb_font_color"][3])

				self.Castbar.Text:SetPoint(LolzenUIcfg.unitframes["uf_player_cb_text_anchor1"], self.Castbar, LolzenUIcfg.unitframes["uf_player_cb_text_anchor2"], LolzenUIcfg.unitframes["uf_player_cb_text_posx"], LolzenUIcfg.unitframes["uf_player_cb_text_posy"])
				self.Castbar.Text:SetFont(LSM:Fetch("font", LolzenUIcfg.unitframes["uf_player_cb_font"]), LolzenUIcfg.unitframes["uf_player_cb_font_size"], LolzenUIcfg.unitframes["uf_player_cb_font_flag"])
				self.Castbar.Text:SetTextColor(LolzenUIcfg.unitframes["uf_player_cb_font_color"][1], LolzenUIcfg.unitframes["uf_player_cb_font_color"][2], LolzenUIcfg.unitframes["uf_player_cb_font_color"][3])

				-- ClassPower (Combo Points, etc)
				local ClassPower = {}
				for i=1, 10 do
					ClassPower[i] = CreateFrame("StatusBar", "ClassPower"..i.."Bar", self)
					ClassPower[i]:SetStatusBarTexture(LSM:Fetch("statusbar", LolzenUIcfg.unitframes["uf_statusbar_texture"]))
					if i == 1 then
						ClassPower[i]:SetPoint(LolzenUIcfg.unitframes["uf_player_classpower_anchor1"], self, LolzenUIcfg.unitframes["uf_player_classpower_anchor2"], LolzenUIcfg.unitframes["uf_player_classpower_posx"], LolzenUIcfg.unitframes["uf_player_classpower_posy"])
					else
						ClassPower[i]:SetPoint("LEFT", ClassPower[i-1], "RIGHT", LolzenUIcfg.unitframes["uf_player_classpower_spacing"], 0)
					end

					ClassPower[i].border = CreateFrame("Frame", nil, ClassPower[i])
					ClassPower[i].border:SetBackdrop({
						edgeFile = LSM:Fetch("border", LolzenUIcfg.unitframes["uf_player_classpower_border"]),
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
						Runes[i]:SetStatusBarTexture(LSM:Fetch("statusbar", LolzenUIcfg.unitframes["uf_statusbar_texture"]))
						Runes[i]:SetSize((self:GetWidth()/6) - ((LolzenUIcfg.unitframes["uf_player_classpower_spacing"]*5)/(6)), 8)
						if i == 1 then
							Runes[i]:SetPoint(LolzenUIcfg.unitframes["uf_player_classpower_anchor1"], self, LolzenUIcfg.unitframes["uf_player_classpower_anchor2"], LolzenUIcfg.unitframes["uf_player_classpower_posx"], LolzenUIcfg.unitframes["uf_player_classpower_posy"])
						else
							Runes[i]:SetPoint("LEFT", Runes[i-1], "RIGHT", LolzenUIcfg.unitframes["uf_player_classpower_spacing"], 0)
						end

						Runes[i].border = CreateFrame("Frame", nil, Runes[i])
						Runes[i].border:SetBackdrop({
							edgeFile = LSM:Fetch("border", LolzenUIcfg.unitframes["uf_player_classpower_border"]),
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

				local Glow = CreateFrame("Frame", nil, self)
				Glow:SetBackdrop({
					edgeFile ="Interface\\AddOns\\LolzenUI\\media\\glow", edgeSize = 5,
					insets = {left = 4, right = 4, top = 4, bottom = 4}
				})
				Glow:SetPoint("TOPLEFT", self, -5, 5)
				Glow:SetPoint("BOTTOMRIGHT", self, 5, -5)
				Glow:SetBackdropBorderColor(6, 0, 0)
				Glow:SetFrameLevel(2)
				self.Glow = Glow
				table.insert(self.__elements, UpdateThreat)
				self:RegisterEvent("UNIT_THREAT_SITUATION_UPDATE", UpdateThreat)
				self:RegisterEvent("UNIT_THREAT_LIST_UPDATE", UpdateThreat)

				ClassPower.PostUpdate = PostUpdateClassPower
			end,

			target = function(self, ...)
				shared(self, ...)

				if LolzenUIcfg.unitframes["uf_target_use_own_hp_font_settings"] == true then
					self.Health.value:SetFont(LSM:Fetch("font", LolzenUIcfg.unitframes["uf_target_hp_font"]), LolzenUIcfg.unitframes["uf_target_hp_font_size"], LolzenUIcfg.unitframes["uf_target_hp_font_flag"])
					self.Health.value:SetPoint(LolzenUIcfg.unitframes["uf_target_hp_anchor"], LolzenUIcfg.unitframes["uf_target_hp_posx"], LolzenUIcfg.unitframes["uf_target_hp_posy"])
				end

				self.Border:SetPoint("TOPLEFT", self, -3, 3)
				self.Border:SetPoint("BOTTOMRIGHT", self, 3, -2)

				self:SetSize(LolzenUIcfg.unitframes["uf_target_width"], LolzenUIcfg.unitframes["uf_target_height"])

				self.Power:SetPoint("LEFT")
				self.Power:SetPoint("RIGHT")
				self.Power:SetPoint("TOP", self.Health, "BOTTOM", 0, 2)

				self.PowerDivider:SetSize(self:GetWidth(), 1)
				self.PowerDivider:SetPoint("TOPLEFT", self.Power, 0, 1)
				self.PowerDivider:SetDrawLayer("BACKGROUND", 1)

				if LolzenUIcfg.unitframes["uf_target_pp_parent"] == "hp" then
					self.Power.value:SetPoint(LolzenUIcfg.unitframes["uf_target_pp_anchor"], self.Health.value, LolzenUIcfg.unitframes["uf_target_pp_anchor2"], LolzenUIcfg.unitframes["uf_target_pp_posx"], LolzenUIcfg.unitframes["uf_target_pp_posy"])
				elseif LolzenUIcfg.unitframes["uf_target_pp_parent"] == "self" then
					self.Power.value:SetPoint(LolzenUIcfg.unitframes["uf_target_pp_anchor"], self, LolzenUIcfg.unitframes["uf_target_pp_anchor2"], LolzenUIcfg.unitframes["uf_target_pp_posx"], LolzenUIcfg.unitframes["uf_target_pp_posy"])
				end
				self.Power.value:SetFont(LSM:Fetch("font", LolzenUIcfg.unitframes["uf_target_pp_font"]), LolzenUIcfg.unitframes["uf_target_pp_font_size"], LolzenUIcfg.unitframes["uf_target_pp_font_flag"])

				if LolzenUIcfg.unitframes["uf_target_cb_standalone"] == true then
					self.Castbar:SetPoint(LolzenUIcfg.unitframes["uf_target_cb_anchor1"], UIParent, LolzenUIcfg.unitframes["uf_target_cb_anchor2"], LolzenUIcfg.unitframes["uf_target_cb_posx"], LolzenUIcfg.unitframes["uf_target_cb_posy"])
					self.Castbar:SetSize(LolzenUIcfg.unitframes["uf_target_cb_width"], LolzenUIcfg.unitframes["uf_target_cb_height"])
					self.Castbar.background:SetAllPoints(self.Castbar)
					self.Castbar.border:SetPoint("TOPLEFT", self.Castbar, -2, 3)
					self.Castbar.border:SetPoint("BOTTOMRIGHT", self.Castbar, 3, -2)
				else
					self.Castbar:SetAllPoints(self.Health)
				end
				self.Castbar:SetStatusBarColor(LolzenUIcfg.unitframes["uf_target_cb_color"][1], LolzenUIcfg.unitframes["uf_target_cb_color"][2], LolzenUIcfg.unitframes["uf_target_cb_color"][3], LolzenUIcfg.unitframes["uf_target_cb_alpha"])

				self.Castbar.Spark:SetSize(self:GetWidth()/27.5, self:GetHeight()*2)

				if LolzenUIcfg.unitframes["uf_target_cb_icon_cut"] == true then
					self.Castbar.Icon:SetHeight(LolzenUIcfg.unitframes["uf_target_height"])
					-- Get the % point of the texture to show
					-- We calculate the percentage of the icon which has to be cut, depending on icon size, and unitframe size which are both variables
					local p1 = (LolzenUIcfg.unitframes["uf_target_cb_icon_size"]-LolzenUIcfg.unitframes["uf_target_height"])/2
					local p2 = p1+LolzenUIcfg.unitframes["uf_target_height"]
					self.Castbar.Icon:SetTexCoord(0.1, 0.9, 1/(LolzenUIcfg.unitframes["uf_target_cb_icon_size"]/p1), 0.9/(0.1+(LolzenUIcfg.unitframes["uf_target_cb_icon_size"]/p2)))
				else
					self.Castbar.Icon:SetHeight(LolzenUIcfg.unitframes["uf_target_cb_icon_size"])
					self.Castbar.Icon:SetTexCoord(.07, .93, .07, .93)

					self.Castbar.Shield:SetSize(self.Castbar.Icon:GetWidth()*3, self.Castbar.Icon:GetHeight()*3)
					self.Castbar.Shield:SetPoint("CENTER", self.Castbar.Icon, 0, 0)
				end

				self.Castbar.Icon:SetWidth(LolzenUIcfg.unitframes["uf_target_cb_icon_size"])
				self.Castbar.Icon:SetPoint(LolzenUIcfg.unitframes["uf_target_cb_icon_anchor1"], self.Castbar, LolzenUIcfg.unitframes["uf_target_cb_icon_anchor2"], LolzenUIcfg.unitframes["uf_target_cb_icon_posx"], LolzenUIcfg.unitframes["uf_target_cb_icon_posy"])

				self.Castbar.Time:SetPoint(LolzenUIcfg.unitframes["uf_target_cb_time_anchor1"], self.Castbar.Icon, LolzenUIcfg.unitframes["uf_target_cb_time_anchor2"], LolzenUIcfg.unitframes["uf_target_cb_time_posx"], LolzenUIcfg.unitframes["uf_target_cb_time_posy"])
				self.Castbar.Time:SetFont(LSM:Fetch("font", LolzenUIcfg.unitframes["uf_target_cb_font"]), LolzenUIcfg.unitframes["uf_target_cb_font_size"], LolzenUIcfg.unitframes["uf_target_cb_font_flag"])
				self.Castbar.Time:SetTextColor(LolzenUIcfg.unitframes["uf_target_cb_font_color"][1], LolzenUIcfg.unitframes["uf_target_cb_font_color"][2], LolzenUIcfg.unitframes["uf_target_cb_font_color"][3])

				self.Castbar.Text:SetPoint(LolzenUIcfg.unitframes["uf_target_cb_text_anchor1"], self.Castbar, LolzenUIcfg.unitframes["uf_target_cb_text_anchor2"], LolzenUIcfg.unitframes["uf_target_cb_text_posx"], LolzenUIcfg.unitframes["uf_target_cb_text_posy"])
				self.Castbar.Text:SetFont(LSM:Fetch("font", LolzenUIcfg.unitframes["uf_target_cb_font"]), LolzenUIcfg.unitframes["uf_target_cb_font_size"], LolzenUIcfg.unitframes["uf_target_cb_font_flag"])
				self.Castbar.Text:SetTextColor(LolzenUIcfg.unitframes["uf_target_cb_font_color"][1], LolzenUIcfg.unitframes["uf_target_cb_font_color"][2], LolzenUIcfg.unitframes["uf_target_cb_font_color"][3])

				if LolzenUIcfg.unitframes["uf_target_aura_show_type"] == "Buffs" then
					self.Buffs:SetPoint(LolzenUIcfg.unitframes["uf_target_aura_anchor1"], self, LolzenUIcfg.unitframes["uf_target_aura_anchor2"], LolzenUIcfg.unitframes["uf_target_aura_posx"], LolzenUIcfg.unitframes["uf_target_aura_posy"])
					self.Buffs.numBuffs = LolzenUIcfg.unitframes["uf_target_aura_maxnum"]
					if LolzenUIcfg.unitframes["uf_target_aura_show_only_player"] == true then
						self.Buffs.onlyShowPlayer = true
					end
					--self.Buffs.showBuffType = true
					self.Buffs["growth-x"] = LolzenUIcfg.unitframes["uf_target_aura_growth_x"]
					self.Buffs["growth-y"] = LolzenUIcfg.unitframes["uf_target_aura_growth_y"]
				elseif LolzenUIcfg.unitframes["uf_target_aura_show_type"] == "Debuffs" then
					self.Debuffs:SetPoint(LolzenUIcfg.unitframes["uf_target_aura_anchor1"], self, LolzenUIcfg.unitframes["uf_target_aura_anchor2"], LolzenUIcfg.unitframes["uf_target_aura_posx"], LolzenUIcfg.unitframes["uf_target_aura_posy"])
					self.Debuffs.numDebuffs = LolzenUIcfg.unitframes["uf_target_aura_maxnum"]
					if LolzenUIcfg.unitframes["uf_target_aura_show_only_player"] == true then
						self.Debuffs.onlyShowPlayer = true
					end
					--self.Debuffs.showDebuffType = true
					self.Debuffs["growth-x"] = LolzenUIcfg.unitframes["uf_target_aura_growth_x"]
					self.Debuffs["growth-y"] = LolzenUIcfg.unitframes["uf_target_aura_growth_y"]
				elseif LolzenUIcfg.unitframes["uf_target_aura_show_type"] == "Both" then
					self.Auras:SetPoint(LolzenUIcfg.unitframes["uf_target_aura_anchor1"], self, LolzenUIcfg.unitframes["uf_target_aura_anchor2"], LolzenUIcfg.unitframes["uf_target_aura_posx"], LolzenUIcfg.unitframes["uf_target_aura_posy"])
					self.Auras.numTotal = LolzenUIcfg.unitframes["uf_target_aura_maxnum"]
					if LolzenUIcfg.unitframes["uf_target_aura_show_only_player"] == true then
						self.Auras.onlyShowPlayer = true
					end
					--self.Auras.showBuffType = true
					--self.Auras.showDebuffType = true
					self.Auras["growth-x"] = LolzenUIcfg.unitframes["uf_target_aura_growth_x"]
					self.Auras["growth-y"] = LolzenUIcfg.unitframes["uf_target_aura_growth_y"]
				end

				self.Panel:SetSize(self:GetWidth(), 20)
				self.Panel:SetPoint("TOP", self.Health, "BOTTOM", 0, -4)

				self.Level:SetPoint("LEFT", self.Health, "LEFT", 2, -23) 

				self.Name:SetPoint("RIGHT", self.Health, "RIGHT", -2, -23)
			end,

			targettarget = function(self, ...)
				shared(self, ...)

				if LolzenUIcfg.unitframes["uf_targettarget_use_own_hp_font_settings"] == true then
					self.Health.value:SetFont(LSM:Fetch("font", LolzenUIcfg.unitframes["uf_targettarget_hp_font"]), LolzenUIcfg.unitframes["uf_targettarget_hp_font_size"], LolzenUIcfg.unitframes["uf_targettarget_hp_font_flag"])
					self.Health.value:SetPoint(LolzenUIcfg.unitframes["uf_targettarget_hp_anchor"], LolzenUIcfg.unitframes["uf_targettarget_hp_posx"], LolzenUIcfg.unitframes["uf_targettarget_hp_posy"])
				end

				self.Border:SetPoint("TOPLEFT", self, -3, 3)
				self.Border:SetPoint("BOTTOMRIGHT", self, 3, -3)

				self:SetSize(LolzenUIcfg.unitframes["uf_targettarget_width"], LolzenUIcfg.unitframes["uf_targettarget_height"])
			end,

			party = function(self, ...)
				shared(self, ...)

				if LolzenUIcfg.unitframes["uf_party_use_own_hp_font_settings"] == true then
					self.Health.value:SetFont(LSM:Fetch("font", LolzenUIcfg.unitframes["uf_party_hp_font"]), LolzenUIcfg.unitframes["uf_party_hp_font_size"], LolzenUIcfg.unitframes["uf_party_hp_font_flag"])
					self.Health.value:SetPoint(LolzenUIcfg.unitframes["uf_party_hp_anchor"], LolzenUIcfg.unitframes["uf_party_hp_posx"], LolzenUIcfg.unitframes["uf_party_hp_posy"])
				end

				self.Border:SetPoint("TOPLEFT", self, -3, 3)
				self.Border:SetPoint("BOTTOMRIGHT", self, 3, -3)

				self:SetSize(LolzenUIcfg.unitframes["uf_party_width"], LolzenUIcfg.unitframes["uf_party_height"])

				if LolzenUIcfg.unitframes["uf_party_showroleindicator"] == true then
					self.GroupRoleIndicator:SetSize(LolzenUIcfg.unitframes["uf_party_ri_size"], LolzenUIcfg.unitframes["uf_party_ri_size"])
					self.GroupRoleIndicator:SetPoint(LolzenUIcfg.unitframes["uf_party_ri_anchor"], self.Health, LolzenUIcfg.unitframes["uf_party_ri_posx"], LolzenUIcfg.unitframes["uf_party_ri_posy"])
				end

				self.ReadyCheckIndicator:SetSize(LolzenUIcfg.unitframes["uf_party_rc_size"], LolzenUIcfg.unitframes["uf_party_rc_size"])
				self.ReadyCheckIndicator:SetPoint(LolzenUIcfg.unitframes["uf_party_rc_anchor"], self.Health, LolzenUIcfg.unitframes["uf_party_rc_posx"], LolzenUIcfg.unitframes["uf_party_rc_posy"])
			end,

			raid = function(self, ...)
				shared(self, ...)

				if LolzenUIcfg.unitframes["uf_raid_use_own_hp_font_settings"] == true then
					self.Health.value:SetFont(LSM:Fetch("font", LolzenUIcfg.unitframes["uf_raid_hp_font"]), LolzenUIcfg.unitframes["uf_raid_hp_font_size"], LolzenUIcfg.unitframes["uf_raid_hp_font_flag"])
					self.Health.value:SetPoint(LolzenUIcfg.unitframes["uf_raid_hp_anchor"], LolzenUIcfg.unitframes["uf_raid_hp_posx"], LolzenUIcfg.unitframes["uf_raid_hp_posy"])
				end

				self.Border:SetPoint("TOPLEFT", self, -3, 3)
				self.Border:SetPoint("BOTTOMRIGHT", self, 3, -2)

				self:SetSize(LolzenUIcfg.unitframes["uf_raid_width"], LolzenUIcfg.unitframes["uf_raid_height"])

				if LolzenUIcfg.unitframes["uf_raid_showroleindicator"] == true then
					self.GroupRoleIndicator:SetSize(LolzenUIcfg.unitframes["uf_raid_ri_size"], LolzenUIcfg.unitframes["uf_raid_ri_size"])
					self.GroupRoleIndicator:SetPoint(LolzenUIcfg.unitframes["uf_raid_ri_anchor"], self.Health, LolzenUIcfg.unitframes["uf_raid_ri_posx"], LolzenUIcfg.unitframes["uf_raid_ri_posy"])
				end

				self.ReadyCheckIndicator:SetSize(LolzenUIcfg.unitframes["uf_raid_rc_size"], LolzenUIcfg.unitframes["uf_raid_rc_size"])
				self.ReadyCheckIndicator:SetPoint(LolzenUIcfg.unitframes["uf_raid_rc_anchor"], self.Health, LolzenUIcfg.unitframes["uf_raid_rc_posx"], LolzenUIcfg.unitframes["uf_raid_rc_posy"])
			end,

			pet = function(self, ...)
				shared(self, ...)

				if LolzenUIcfg.unitframes["uf_pet_use_own_hp_font_settings"] == true then
					self.Health.value:SetFont(LSM:Fetch("font", LolzenUIcfg.unitframes["uf_pet_hp_font"]), LolzenUIcfg.unitframes["uf_pet_hp_font_size"], LolzenUIcfg.unitframes["uf_pet_hp_font_flag"])
					self.Health.value:SetPoint(LolzenUIcfg.unitframes["uf_pet_hp_anchor"], LolzenUIcfg.unitframes["uf_pet_hp_posx"], LolzenUIcfg.unitframes["uf_pet_hp_posy"])
				end

				self.Border:SetPoint("TOPLEFT", self, -3, 3)
				self.Border:SetPoint("BOTTOMRIGHT", self, 3, -3)

				self:SetSize(LolzenUIcfg.unitframes["uf_pet_width"], LolzenUIcfg.unitframes["uf_pet_height"])

				self.Castbar:SetAllPoints(self.Health)
				self.Castbar:SetStatusBarColor(LolzenUIcfg.unitframes["uf_pet_cb_color"][1], LolzenUIcfg.unitframes["uf_pet_cb_color"][2], LolzenUIcfg.unitframes["uf_pet_cb_color"][3], LolzenUIcfg.unitframes["uf_pet_cb_alpha"])

				self.Castbar.Spark:SetSize(self:GetWidth()/27.5, self:GetHeight()*2)

				if LolzenUIcfg.unitframes["uf_pet_cb_icon_cut"] == true then
					self.Castbar.Icon:SetHeight(LolzenUIcfg.unitframes["uf_pet_height"])
					-- Get the % point of the texture to show
					-- We calculate the percentage of the icon which has to be cut, depending on icon size, and unitframe size which are both variables
					local p1 = (LolzenUIcfg.unitframes["uf_pet_cb_icon_size"]-LolzenUIcfg.unitframes["uf_pet_height"])/2
					local p2 = p1+LolzenUIcfg.unitframes["uf_pet_height"]
					self.Castbar.Icon:SetTexCoord(0.1, 0.9, 1/(LolzenUIcfg.unitframes["uf_pet_cb_icon_size"]/p1), 0.9/(0.1+(LolzenUIcfg.unitframes["uf_pet_cb_icon_size"]/p2)))
				else
					self.Castbar.Icon:SetHeight(LolzenUIcfg.unitframes["uf_pet_cb_icon_size"])
					self.Castbar.Icon:SetTexCoord(.07, .93, .07, .93)

					self.Castbar.Shield:SetSize(self.Castbar.Icon:GetWidth()*3, self.Castbar.Icon:GetHeight()*3)
					self.Castbar.Shield:SetPoint("CENTER", self.Castbar.Icon, 0, 0)
				end

				self.Castbar.Icon:SetWidth(LolzenUIcfg.unitframes["uf_pet_cb_icon_size"])
				self.Castbar.Icon:SetPoint(LolzenUIcfg.unitframes["uf_pet_cb_icon_anchor1"], self.Castbar, LolzenUIcfg.unitframes["uf_pet_cb_icon_anchor2"], LolzenUIcfg.unitframes["uf_pet_cb_icon_posx"], LolzenUIcfg.unitframes["uf_pet_cb_icon_posy"])

				self.Castbar.Time:SetPoint(LolzenUIcfg.unitframes["uf_pet_cb_time_anchor1"], self.Castbar.Icon, LolzenUIcfg.unitframes["uf_pet_cb_time_anchor2"], LolzenUIcfg.unitframes["uf_pet_cb_time_posx"], LolzenUIcfg.unitframes["uf_pet_cb_time_posy"])
				self.Castbar.Time:SetFont(LSM:Fetch("font", LolzenUIcfg.unitframes["uf_pet_cb_font"]), LolzenUIcfg.unitframes["uf_pet_cb_font_size"], LolzenUIcfg.unitframes["uf_pet_cb_font_flag"])
				self.Castbar.Time:SetTextColor(LolzenUIcfg.unitframes["uf_pet_cb_font_color"][1], LolzenUIcfg.unitframes["uf_pet_cb_font_color"][2], LolzenUIcfg.unitframes["uf_pet_cb_font_color"][3])

				self.Castbar.Text:SetPoint(LolzenUIcfg.unitframes["uf_pet_cb_text_anchor1"], self.Castbar, LolzenUIcfg.unitframes["uf_pet_cb_text_anchor2"], LolzenUIcfg.unitframes["uf_pet_cb_text_posx"], LolzenUIcfg.unitframes["uf_pet_cb_text_posy"])
				self.Castbar.Text:SetFont(LSM:Fetch("font", LolzenUIcfg.unitframes["uf_pet_cb_font"]), LolzenUIcfg.unitframes["uf_pet_cb_font_size"], LolzenUIcfg.unitframes["uf_pet_cb_font_flag"])
				self.Castbar.Text:SetTextColor(LolzenUIcfg.unitframes["uf_pet_cb_font_color"][1], LolzenUIcfg.unitframes["uf_pet_cb_font_color"][2], LolzenUIcfg.unitframes["uf_pet_cb_font_color"][3])
			end,

			boss = function(self, ...)
				shared(self, ...)
			
				if LolzenUIcfg.unitframes["uf_boss_use_own_hp_font_settings"] == true then
					self.Health.value:SetFont(LSM:Fetch("font", LolzenUIcfg.unitframes["uf_boss_hp_font"]), LolzenUIcfg.unitframes["uf_boss_hp_font_size"], LolzenUIcfg.unitframes["uf_boss_hp_font_flag"])
					self.Health.value:SetPoint(LolzenUIcfg.unitframes["uf_boss_hp_anchor"], LolzenUIcfg.unitframes["uf_boss_hp_posx"], LolzenUIcfg.unitframes["uf_boss_hp_posy"])
				end

				self.Border:SetPoint("TOPLEFT", self, -3, 3)
				self.Border:SetPoint("BOTTOMRIGHT", self, 3, -2)

				self:SetSize(LolzenUIcfg.unitframes["uf_boss_width"], LolzenUIcfg.unitframes["uf_boss_height"])

				if LolzenUIcfg.unitframes["uf_boss_show_power"] == true then
					self.Power:SetPoint("LEFT")
					self.Power:SetPoint("RIGHT")
					self.Power:SetPoint("TOP", self.Health, "BOTTOM", 0, 2)

					self.PowerDivider:SetSize(self:GetWidth(), 1)
					self.PowerDivider:SetPoint("TOPLEFT", self.Power, 0, 1)
					self.PowerDivider:SetDrawLayer("BACKGROUND", 1)

					if LolzenUIcfg.unitframes["uf_boss_pp_parent"] == "hp" then
						self.Power.value:SetPoint(LolzenUIcfg.unitframes["uf_boss_pp_anchor"], self.Health.value, LolzenUIcfg.unitframes["uf_boss_pp_anchor2"], LolzenUIcfg.unitframes["uf_boss_pp_posx"], LolzenUIcfg.unitframes["uf_boss_pp_posy"])
					elseif LolzenUIcfg.unitframes["uf_boss_pp_parent"] == "self" then
						self.Power.value:SetPoint(LolzenUIcfg.unitframes["uf_boss_pp_anchor"], self, LolzenUIcfg.unitframes["uf_boss_pp_anchor2"], LolzenUIcfg.unitframes["uf_boss_pp_posx"], LolzenUIcfg.unitframes["uf_boss_pp_posy"])
					end
					self.Power.value:SetFont(LSM:Fetch("font", LolzenUIcfg.unitframes["uf_boss_pp_font"]), LolzenUIcfg.unitframes["uf_boss_pp_font_size"], LolzenUIcfg.unitframes["uf_boss_pp_font_flag"])
				end

				if LolzenUIcfg.unitframes["uf_boss_aura_show_type"] == "Buffs" then
					self.Buffs:SetPoint(LolzenUIcfg.unitframes["uf_boss_aura_anchor1"], self, LolzenUIcfg.unitframes["uf_boss_aura_anchor2"], LolzenUIcfg.unitframes["uf_boss_aura_posx"], LolzenUIcfg.unitframes["uf_boss_aura_posy"])
					self.Buffs.numBuffs = LolzenUIcfg.unitframes["uf_boss_aura_maxnum"]
					if LolzenUIcfg.unitframes["uf_boss_aura_show_only_player"] == true then
						self.Buffs.onlyShowPlayer = true
					end
					--self.Buffs.showBuffType = true
					self.Buffs["growth-x"] = LolzenUIcfg.unitframes["uf_boss_aura_growth_x"]
					self.Buffs["growth-y"] = LolzenUIcfg.unitframes["uf_boss_aura_growth_y"]
				elseif LolzenUIcfg.unitframes["uf_boss_aura_show_type"] == "Debuffs" then
					self.Debuffs:SetPoint(LolzenUIcfg.unitframes["uf_boss_aura_anchor1"], self, LolzenUIcfg.unitframes["uf_boss_aura_anchor2"], LolzenUIcfg.unitframes["uf_boss_aura_posx"], LolzenUIcfg.unitframes["uf_boss_aura_posy"])
					self.Debuffs.numDebuffs = LolzenUIcfg.unitframes["uf_boss_aura_maxnum"]
					if LolzenUIcfg.unitframes["uf_boss_aura_show_only_player"] == true then
						self.Debuffs.onlyShowPlayer = true
					end
					--self.Debuffs.showDebuffType = true
					self.Debuffs["growth-x"] = LolzenUIcfg.unitframes["uf_boss_aura_growth_x"]
					self.Debuffs["growth-y"] = LolzenUIcfg.unitframes["uf_boss_aura_growth_y"]
				elseif LolzenUIcfg.unitframes["uf_boss_aura_show_type"] == "Both" then
					self.Auras:SetPoint(LolzenUIcfg.unitframes["uf_boss_aura_anchor1"], self, LolzenUIcfg.unitframes["uf_boss_aura_anchor2"], LolzenUIcfg.unitframes["uf_boss_aura_posx"], LolzenUIcfg.unitframes["uf_boss_aura_posy"])
					self.Auras.numTotal = LolzenUIcfg.unitframes["uf_boss_aura_maxnum"]
					if LolzenUIcfg.unitframes["uf_boss_aura_show_only_player"] == true then
						self.Auras.onlyShowPlayer = true
					end
					--self.Auras.showBuffType = true
					--self.Auras.showDebuffType = true
					self.Auras["growth-x"] = LolzenUIcfg.unitframes["uf_boss_aura_growth_x"]
					self.Auras["growth-y"] = LolzenUIcfg.unitframes["uf_boss_aura_growth_y"]
				end

				self.Castbar:SetAllPoints(self.Health)
				self.Castbar:SetStatusBarColor(LolzenUIcfg.unitframes["uf_boss_cb_color"][1], LolzenUIcfg.unitframes["uf_boss_cb_color"][2], LolzenUIcfg.unitframes["uf_boss_cb_color"][3], LolzenUIcfg.unitframes["uf_boss_cb_alpha"])

				self.Castbar.Spark:SetSize(self:GetWidth()/27.5, self:GetHeight()*2)

				if LolzenUIcfg.unitframes["uf_boss_cb_icon_cut"] == true then
					self.Castbar.Icon:SetHeight(LolzenUIcfg.unitframes["uf_boss_height"])
					-- Get the % point of the texture to show
					-- We calculate the percentage of the icon which has to be cut, depending on icon size, and unitframe size which are both variables
					local p1 = (LolzenUIcfg.unitframes["uf_boss_cb_icon_size"]-LolzenUIcfg.unitframes["uf_boss_height"])/2
					local p2 = p1+LolzenUIcfg.unitframes["uf_boss_height"]
					self.Castbar.Icon:SetTexCoord(0.1, 0.9, 1/(LolzenUIcfg.unitframes["uf_boss_cb_icon_size"]/p1), 0.9/(0.1+(LolzenUIcfg.unitframes["uf_boss_cb_icon_size"]/p2)))
				else
					self.Castbar.Icon:SetHeight(LolzenUIcfg.unitframes["uf_boss_cb_icon_size"])
					self.Castbar.Icon:SetTexCoord(.07, .93, .07, .93)

					self.Castbar.Shield:SetSize(self.Castbar.Icon:GetWidth()*3, self.Castbar.Icon:GetHeight()*3)
					self.Castbar.Shield:SetPoint("CENTER", self.Castbar.Icon, 0, 0)
				end

				self.Castbar.Icon:SetWidth(LolzenUIcfg.unitframes["uf_boss_cb_icon_size"])
				self.Castbar.Icon:SetPoint(LolzenUIcfg.unitframes["uf_boss_cb_icon_anchor1"], self.Castbar, LolzenUIcfg.unitframes["uf_boss_cb_icon_anchor2"], LolzenUIcfg.unitframes["uf_boss_cb_icon_posx"], LolzenUIcfg.unitframes["uf_boss_cb_icon_posy"])

				self.Castbar.Time:SetPoint(LolzenUIcfg.unitframes["uf_boss_cb_time_anchor1"], self.Castbar.Icon, LolzenUIcfg.unitframes["uf_boss_cb_time_anchor2"], LolzenUIcfg.unitframes["uf_boss_cb_time_posx"], LolzenUIcfg.unitframes["uf_boss_cb_time_posy"])
				self.Castbar.Time:SetFont(LSM:Fetch("font", LolzenUIcfg.unitframes["uf_boss_cb_font"]), LolzenUIcfg.unitframes["uf_boss_cb_font_size"], LolzenUIcfg.unitframes["uf_boss_cb_font_flag"])
				self.Castbar.Time:SetTextColor(LolzenUIcfg.unitframes["uf_boss_cb_font_color"][1], LolzenUIcfg.unitframes["uf_boss_cb_font_color"][2], LolzenUIcfg.unitframes["uf_boss_cb_font_color"][3])

				self.Castbar.Text:SetPoint(LolzenUIcfg.unitframes["uf_boss_cb_text_anchor1"], self.Castbar, LolzenUIcfg.unitframes["uf_boss_cb_text_anchor2"], LolzenUIcfg.unitframes["uf_boss_cb_text_posx"], LolzenUIcfg.unitframes["uf_boss_cb_text_posy"])
				self.Castbar.Text:SetFont(LSM:Fetch("font", LolzenUIcfg.unitframes["uf_boss_cb_font"]), LolzenUIcfg.unitframes["uf_boss_cb_font_size"], LolzenUIcfg.unitframes["uf_boss_cb_font_flag"])
				self.Castbar.Text:SetTextColor(LolzenUIcfg.unitframes["uf_boss_cb_font_color"][1], LolzenUIcfg.unitframes["uf_boss_cb_font_color"][2], LolzenUIcfg.unitframes["uf_boss_cb_font_color"][3])

				self.Panel:SetSize(self:GetWidth(), 20)
				self.Panel:SetPoint("TOP", self.Health, "BOTTOM", 0, -4)

				self.Level:SetPoint("LEFT", self.Health, "LEFT", 2, -18) 

				self.Name:SetPoint("RIGHT", self.Health, "RIGHT", -2, -18)
			end,

			focus = function(self, ...)
				shared(self, ...)

				if LolzenUIcfg.unitframes["uf_focus_use_own_hp_font_settings"] == true then
					self.Health.value:SetFont(LSM:Fetch("font", LolzenUIcfg.unitframes["uf_focus_hp_font"]), LolzenUIcfg.unitframes["uf_focus_hp_font_size"], LolzenUIcfg.unitframes["uf_focus_hp_font_flag"])
					self.Health.value:SetPoint(LolzenUIcfg.unitframes["uf_focus_hp_anchor"], LolzenUIcfg.unitframes["uf_focus_hp_posx"], LolzenUIcfg.unitframes["uf_focus_hp_posy"])
				end

				self.Border:SetPoint("TOPLEFT", self, -3, 3)
				self.Border:SetPoint("BOTTOMRIGHT", self, 3, -2)

				self:SetSize(LolzenUIcfg.unitframes["uf_focus_width"], LolzenUIcfg.unitframes["uf_focus_height"])
				
				self.Power:SetPoint("LEFT")
				self.Power:SetPoint("RIGHT")
				self.Power:SetPoint("TOP", self.Health, "BOTTOM", 0, 2)

				self.PowerDivider:SetSize(self:GetWidth(), 1)
				self.PowerDivider:SetPoint("TOPLEFT", self.Power, 0, 1)
				self.PowerDivider:SetDrawLayer("BACKGROUND", 1)

				if LolzenUIcfg.unitframes["uf_focus_pp_parent"] == "hp" then
					self.Power.value:SetPoint(LolzenUIcfg.unitframes["uf_focus_pp_anchor"], self.Health.value, LolzenUIcfg.unitframes["uf_focus_pp_anchor2"], LolzenUIcfg.unitframes["uf_focus_pp_posx"], LolzenUIcfg.unitframes["uf_focus_pp_posy"])
				elseif LolzenUIcfg.unitframes["uf_focus_pp_parent"] == "self" then
					self.Power.value:SetPoint(LolzenUIcfg.unitframes["uf_focus_pp_anchor"], self, LolzenUIcfg.unitframes["uf_focus_pp_anchor2"], LolzenUIcfg.unitframes["uf_focus_pp_posx"], LolzenUIcfg.unitframes["uf_focus_pp_posy"])
				end
				self.Power.value:SetFont(LSM:Fetch("font", LolzenUIcfg.unitframes["uf_focus_pp_font"]), LolzenUIcfg.unitframes["uf_focus_pp_font_size"], LolzenUIcfg.unitframes["uf_focus_pp_font_flag"])

				if LolzenUIcfg.unitframes["uf_focus_aura_show_type"] == "Buffs" then
					self.Buffs:SetPoint(LolzenUIcfg.unitframes["uf_focus_aura_anchor1"], self, LolzenUIcfg.unitframes["uf_focus_aura_anchor2"], LolzenUIcfg.unitframes["uf_focus_aura_posx"], LolzenUIcfg.unitframes["uf_focus_aura_posy"])
					self.Buffs.numBuffs = LolzenUIcfg.unitframes["uf_focus_aura_maxnum"]
					if LolzenUIcfg.unitframes["uf_focus_aura_show_only_player"] == true then
						self.Buffs.onlyShowPlayer = true
					end
					--self.Buffs.showBuffType = true
					self.Buffs["growth-x"] = LolzenUIcfg.unitframes["uf_focus_aura_growth_x"]
					self.Buffs["growth-y"] = LolzenUIcfg.unitframes["uf_focus_aura_growth_y"]
				elseif LolzenUIcfg.unitframes["uf_focus_aura_show_type"] == "Debuffs" then
					self.Debuffs:SetPoint(LolzenUIcfg.unitframes["uf_focus_aura_anchor1"], self, LolzenUIcfg.unitframes["uf_focus_aura_anchor2"], LolzenUIcfg.unitframes["uf_focus_aura_posx"], LolzenUIcfg.unitframes["uf_focus_aura_posy"])
					self.Debuffs.numDebuffs = LolzenUIcfg.unitframes["uf_focus_aura_maxnum"]
					if LolzenUIcfg.unitframes["uf_focus_aura_show_only_player"] == true then
						self.Debuffs.onlyShowPlayer = true
					end
					--self.Debuffs.showDebuffType = true
					self.Debuffs["growth-x"] = LolzenUIcfg.unitframes["uf_focus_aura_growth_x"]
					self.Debuffs["growth-y"] = LolzenUIcfg.unitframes["uf_focus_aura_growth_y"]
				elseif LolzenUIcfg.unitframes["uf_focus_aura_show_type"] == "Both" then
					self.Auras:SetPoint(LolzenUIcfg.unitframes["uf_focus_aura_anchor1"], self, LolzenUIcfg.unitframes["uf_focus_aura_anchor2"], LolzenUIcfg.unitframes["uf_focus_aura_posx"], LolzenUIcfg.unitframes["uf_focus_aura_posy"])
					self.Auras.numTotal = LolzenUIcfg.unitframes["uf_focus_aura_maxnum"]
					if LolzenUIcfg.unitframes["uf_focus_aura_show_only_player"] == true then
						self.Auras.onlyShowPlayer = true
					end
					--self.Auras.showBuffType = true
					--self.Auras.showDebuffType = true
					self.Auras["growth-x"] = LolzenUIcfg.unitframes["uf_focus_aura_growth_x"]
					self.Auras["growth-y"] = LolzenUIcfg.unitframes["uf_focus_aura_growth_y"]
				end

				self.Castbar:SetAllPoints(self.Health)
				self.Castbar:SetStatusBarColor(LolzenUIcfg.unitframes["uf_focus_cb_color"][1], LolzenUIcfg.unitframes["uf_focus_cb_color"][2], LolzenUIcfg.unitframes["uf_focus_cb_color"][3], LolzenUIcfg.unitframes["uf_focus_cb_alpha"])

				self.Castbar.Spark:SetSize(self:GetWidth()/27.5, self:GetHeight()*2)

				if LolzenUIcfg.unitframes["uf_focus_cb_icon_cut"] == true then
					self.Castbar.Icon:SetHeight(LolzenUIcfg.unitframes["uf_focus_height"])
					-- Get the % point of the texture to show
					-- We calculate the percentage of the icon which has to be cut, depending on icon size, and unitframe size which are both variables
					local p1 = (LolzenUIcfg.unitframes["uf_focus_cb_icon_size"]-LolzenUIcfg.unitframes["uf_focus_height"])/2
					local p2 = p1+LolzenUIcfg.unitframes["uf_focus_height"]
					self.Castbar.Icon:SetTexCoord(0.1, 0.9, 1/(LolzenUIcfg.unitframes["uf_focus_cb_icon_size"]/p1), 0.9/(0.1+(LolzenUIcfg.unitframes["uf_focus_cb_icon_size"]/p2)))
				else
					self.Castbar.Icon:SetHeight(LolzenUIcfg.unitframes["uf_focus_cb_icon_size"])
					self.Castbar.Icon:SetTexCoord(.07, .93, .07, .93)

					self.Castbar.Shield:SetSize(self.Castbar.Icon:GetWidth()*3, self.Castbar.Icon:GetHeight()*3)
					self.Castbar.Shield:SetPoint("CENTER", self.Castbar.Icon, 0, 0)
				end

				self.Castbar.Icon:SetWidth(LolzenUIcfg.unitframes["uf_focus_cb_icon_size"])
				self.Castbar.Icon:SetPoint(LolzenUIcfg.unitframes["uf_focus_cb_icon_anchor1"], self.Castbar, LolzenUIcfg.unitframes["uf_focus_cb_icon_anchor2"], LolzenUIcfg.unitframes["uf_focus_cb_icon_posx"], LolzenUIcfg.unitframes["uf_focus_cb_icon_posy"])

				self.Castbar.Time:SetPoint(LolzenUIcfg.unitframes["uf_focus_cb_time_anchor1"], self.Castbar.Icon, LolzenUIcfg.unitframes["uf_focus_cb_time_anchor2"], LolzenUIcfg.unitframes["uf_focus_cb_time_posx"], LolzenUIcfg.unitframes["uf_focus_cb_time_posy"])
				self.Castbar.Time:SetFont(LSM:Fetch("font", LolzenUIcfg.unitframes["uf_focus_cb_font"]), LolzenUIcfg.unitframes["uf_focus_cb_font_size"], LolzenUIcfg.unitframes["uf_focus_cb_font_flag"])
				self.Castbar.Time:SetTextColor(LolzenUIcfg.unitframes["uf_focus_cb_font_color"][1], LolzenUIcfg.unitframes["uf_focus_cb_font_color"][2], LolzenUIcfg.unitframes["uf_focus_cb_font_color"][3])

				self.Castbar.Text:SetPoint(LolzenUIcfg.unitframes["uf_focus_cb_text_anchor1"], self.Castbar, LolzenUIcfg.unitframes["uf_focus_cb_text_anchor2"], LolzenUIcfg.unitframes["uf_focus_cb_text_posx"], LolzenUIcfg.unitframes["uf_focus_cb_text_posy"])
				self.Castbar.Text:SetFont(LSM:Fetch("font", LolzenUIcfg.unitframes["uf_focus_cb_font"]), LolzenUIcfg.unitframes["uf_focus_cb_font_size"], LolzenUIcfg.unitframes["uf_focus_cb_font_flag"])
				self.Castbar.Text:SetTextColor(LolzenUIcfg.unitframes["uf_focus_cb_font_color"][1], LolzenUIcfg.unitframes["uf_focus_cb_font_color"][2], LolzenUIcfg.unitframes["uf_focus_cb_font_color"][3])

				self.Panel:SetSize(self:GetWidth(), 20)
				self.Panel:SetPoint("TOP", self.Health, "BOTTOM", 0, -4)

				self.Level:SetPoint("LEFT", self.Health, "LEFT", 2, -18) 

				self.Name:SetPoint("RIGHT", self.Health, "RIGHT", -2, -18)
			end,
		}

		-- A small helper to change the style into a unit specific, if it exists.
		local spawnHelper = function(self, unit, ...)
			if(UnitSpecific[unit]) then
				self:SetActiveStyle('Lolzen - ' .. unit:gsub("^%l", string.upper))
			elseif(UnitSpecific[unit:match('%D+')]) then -- boss1 -> boss
				self:SetActiveStyle('Lolzen - ' .. unit:match('%D+'):gsub("^%l", string.upper))
			else
				self:SetActiveStyle'Lolzen'
			end

			local object = self:Spawn(unit)
			object:SetPoint(...)
			return object
		end

		oUF:RegisterStyle("Lolzen", shared)
		for unit,layout in next, UnitSpecific do
			-- Capitalize the unit name, so it looks better.
			oUF:RegisterStyle('Lolzen - ' .. unit:gsub("^%l", string.upper), layout)
		end

		-- Hide the standard raid frames
		if LolzenUIcfg.unitframes["uf_raid_enabled"] == true then
			local frame = CreateFrame("Frame", nil, UIParent)
			frame:RegisterEvent("PLAYER_ENTERING_WORLD")
			frame:SetScript("OnEvent", function(self, event)
				if CompactRaidFrameManager then
					CompactRaidFrameManager:UnregisterAllEvents()
					CompactRaidFrameManager:Hide()
				end
				if CompactRaidFrameContainer then
					CompactRaidFrameContainer:UnregisterAllEvents()
					CompactRaidFrameContainer:Hide()
				end
			end)
		end

		oUF:Factory(function(self)
			spawnHelper(self, "focus", "CENTER", -250, -230)
			spawnHelper(self, "pet", "CENTER", -300, -177)
			spawnHelper(self, "player", "CENTER", -250, -200)
			spawnHelper(self, "target", "CENTER", 250, -200)
			spawnHelper(self, "targettarget", "CENTER", 300, -177)

			for n=1, MAX_BOSS_FRAMES or 5 do
				if LolzenUIcfg.unitframes["uf_boss_additional_pos"] == "ABOVE" then
					spawnHelper(self, "boss" .. n, "CENTER", 0, -200 - LolzenUIcfg.unitframes["uf_boss_height"] + (LolzenUIcfg.unitframes["uf_boss_height"] * n) - LolzenUIcfg.unitframes["uf_boss_additional_spacing"] + (LolzenUIcfg.unitframes["uf_boss_additional_spacing"] * n))
				elseif LolzenUIcfg.unitframes["uf_boss_additional_pos"] == "BELOW" then
					spawnHelper(self, "boss" .. n, "CENTER", 0, -200 + LolzenUIcfg.unitframes["uf_boss_height"] - (LolzenUIcfg.unitframes["uf_boss_height"] * n) + LolzenUIcfg.unitframes["uf_boss_additional_spacing"] - (LolzenUIcfg.unitframes["uf_boss_additional_spacing"] * n))
				elseif 	LolzenUIcfg.unitframes["uf_boss_additional_pos"] == "LEFT" then
					spawnHelper(self, "boss" .. n, "CENTER", (0 + LolzenUIcfg.unitframes["uf_boss_width"]) - (LolzenUIcfg.unitframes["uf_boss_width"] * n) + LolzenUIcfg.unitframes["uf_boss_additional_spacing"] - (LolzenUIcfg.unitframes["uf_boss_additional_spacing"] * n), -200)
				elseif 	LolzenUIcfg.unitframes["uf_boss_additional_pos"] == "RIGHT" then
					spawnHelper(self, "boss" .. n, "CENTER", (0 - LolzenUIcfg.unitframes["uf_boss_width"]) + (LolzenUIcfg.unitframes["uf_boss_width"] * n) - LolzenUIcfg.unitframes["uf_boss_additional_spacing"] + (LolzenUIcfg.unitframes["uf_boss_additional_spacing"] * n), -200)
				end
			end

			if LolzenUIcfg.unitframes["uf_party_enabled"] == true then
				self:SetActiveStyle("Lolzen - Party")

				if LolzenUIcfg.unitframes["uf_party_use_vertical_layout"] == true then
					local party = self:SpawnHeader(
						nil, nil, 'party,solo',
						'showParty', true,
						'showPlayer', true,
						'showSolo', false,
						'xOffset', 0,
						'yoffset', 0,
						'oUF-initialConfigFunction', [[
							self:SetHeight(19)
							self:SetWidth(70)
						]],
						'maxColumns', 5,
						'unitsperColumn', 1,
						'columnSpacing', 5,
						'columnAnchorPoint', "TOP"
					)
					party:SetPoint("BOTTOM", UIParent, 0, 140)
				else
					local party = self:SpawnHeader(
						nil, nil, 'party,solo',
						'showParty', true,
						'showPlayer', true,
						'showSolo', false,
						'xOffset', 7,
						'yoffset', 0,
						'oUF-initialConfigFunction', [[
							self:SetHeight(19)
							self:SetWidth(70)
						]],
						'maxColumns', 5,
						'unitsperColumn', 1,
						'columnSpacing', 7,
						'columnAnchorPoint', "RIGHT"
					)
					party:SetPoint("BOTTOM", UIParent, 0, 140)
				end
			end

			if LolzenUIcfg.unitframes["uf_raid_enabled"] == true then
				self:SetActiveStyle("Lolzen - Raid")

				local raid = self:SpawnHeader(
					nil, nil, 'raid,party,solo',
					'showPlayer', true,
					'showSolo', false,
					'showParty', false,
					'showRaid', true,
					'xoffset', 7,
					'yOffset', -5,
					'oUF-initialConfigFunction', [[
						self:SetHeight(19)
						self:SetWidth(50)
					]],
					'groupFilter', '1,2,3,4,5,6,7,8',
					'groupingOrder', '8,7,6,5,4,3,2,1',
					'sortMethod', 'NAME',
					'groupBy', 'GROUP',
					'maxColumns', 8,
					'unitsPerColumn', 5,
					'columnSpacing', 7,
					'columnAnchorPoint', "RIGHT"
				)
				raid:SetPoint("LEFT", UIParent, 20, 0)
			end
		end)
	end
end)