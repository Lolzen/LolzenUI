--// unitframes // --

local _, ns = ...
local LSM = LibStub("LibSharedMedia-3.0")
local oUF = ns.oUF

ns.RegisterModule("unitframes")

local f = CreateFrame("Frame")
f:RegisterEvent("ADDON_LOADED")
f:SetScript("OnEvent", function(self, event, addon)
	if addon == "LolzenUI" then
		if LolzenUIcfg.modules["unitframes"] == false then return end

		local siValue = function(val)
			if val >= 1e6 then
				return ('%.1f'):format(val / 1e6):gsub('%.', 'm')
			elseif val >= 1e4 then
				return ("%.1f"):format(val / 1e3):gsub('%.', 'k')
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

		-- change power colors to user defined values
		for k, v in pairs(LolzenUIcfg.unitframes["uf_power_colors"]) do
			oUF.colors.power[tonumber(k)] = v
		end

		local PostCastStart = function(Castbar, unit, spell, spellrank)
			local name = Castbar:GetParent().Name
			if name then
				Castbar:GetParent().Name:SetText(spell)
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

		local PostUpdateThreat = function(Threat, unit)
			local Glow = Threat:GetParent()
			local status = UnitThreatSituation(unit)
			if status and status > 0 then
				Glow:Show()
			else
				Glow:Hide()
			end
		end

		local PostUpdateClassPower = function(element, power, maxPower, maxPowerChanged)
			if not maxPower or not maxPowerChanged then return end

			for i = 1, maxPower do
				local parent = element[i]:GetParent()
				element[i]:SetSize((parent:GetWidth()/maxPower) - ((5*maxPower-1)/(maxPower+1)), 8)
			end
		end

		local PostUpdatePower = function(Power, unit, min, max)
			local color = oUF.colors.power[UnitPowerType(unit)]

			--power.colorPower won't overtake the custom power colors set earlier
			Power:SetStatusBarColor(color[1], color[2], color[3])
			Power.value:SetTextColor(color[1], color[2], color[3])
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

			local overlay = button.overlay
			overlay.SetVertexColor = overlayProxy
			overlay:Hide()
			overlay.Show = overlay.Hide
			overlay.Hide = overlayHide
		end

		local PostUpdateIcon
		do
			local playerUnits = {
				player = true,
				pet = true,
				vehicle = true,
			}

			PostUpdateIcon = function(icons, unit, icon, index, offset, filter, isDebuff)
				local texture = icon.icon
				if(playerUnits[icon.caster]) then
					texture:SetDesaturated(false)
				else
					texture:SetDesaturated(true)
				end
			end
		end

		local CreateAura = function(self, num)
			local size = 23
			local Auras = CreateFrame("Frame", nil, self)

			Auras:SetSize(num * (size + 4), size)
			Auras.num = num
			Auras.size = size
			Auras.spacing = 4

			Auras.PostCreateIcon = PostCreateIcon

			return Auras
		end

		local shared = function(self, unit, isSingle)
			self:SetScript("OnEnter", UnitFrame_OnEnter)
			self:SetScript("OnLeave", UnitFrame_OnLeave)

			self:RegisterForClicks("AnyUp")

			local Border = CreateFrame("Frame", nil, self)
			Border:SetBackdrop({
				edgeFile = "Interface\\AddOns\\LolzenUI\\media\\border", edgeSize = 12,
				insets = {left = 4, right = 4, top = 4, bottom = 4},
			})
			Border:SetPoint("TOPLEFT", self, -3, 3)
			Border:SetPoint("BOTTOMRIGHT", self, 3, -2)
			Border:SetBackdropBorderColor(0, 0, 0)
			Border:SetFrameLevel(3)

			local Health = CreateFrame("StatusBar", nil, self)
			Health:SetStatusBarTexture(LSM:Fetch("statusbar", LolzenUIcfg.unitframes["uf_statusbar_texture"]))

			Health.frequentUpdates = true
			Health.colorTapping = true
			Health.colorClass = true
			Health.colorReaction = true

			Health:SetPoint("TOP")
			Health:SetPoint("LEFT")
			Health:SetPoint("RIGHT")

			self.Health = Health

			local HealthPoints = Health:CreateFontString(nil, "OVERLAY")
			HealthPoints:SetFont("Interface\\AddOns\\LolzenUI\\fonts\\DroidSansBold.ttf", 24, "THINOUTLINE")
			HealthPoints:SetPoint("RIGHT", -2, 8)
			self:Tag(HealthPoints, "[|cffc41f3b>dead<|r][|cff999999>offline<|r][lolzen:health]") 

			Health.value = HealthPoints

			local bg = self:CreateTexture(nil, "BORDER")
			bg:SetAllPoints(self)
			bg:SetTexture("Interface\\AddOns\\LolzenUI\\media\\"..LolzenUIcfg.unitframes["uf_statusbar_texture"])
			bg:SetVertexColor(0.3, 0.3, 0.3)
			bg:SetAlpha(1)

			local RaidTargetIndicator = Health:CreateTexture(nil, "OVERLAY")
			RaidTargetIndicator:SetSize(LolzenUIcfg.unitframes["uf_ri_size"], LolzenUIcfg.unitframes["uf_ri_size"])
			RaidTargetIndicator:SetPoint(LolzenUIcfg.unitframes["uf_ri_anchor"], Health, LolzenUIcfg.unitframes["uf_ri_posx"], LolzenUIcfg.unitframes["uf_ri_posy"])
			self.RaidTargetIndicator = RaidTargetIndicator

			local lead = Health:CreateTexture(nil, "OVERLAY")
			lead:SetSize(LolzenUIcfg.unitframes["uf_lead_size"], LolzenUIcfg.unitframes["uf_lead_size"])
			lead:SetPoint(LolzenUIcfg.unitframes["uf_lead_anchor"], Health, LolzenUIcfg.unitframes["uf_lead_posx"], LolzenUIcfg.unitframes["uf_lead_posy"])
			self.LeaderIndicator = lead

			if(isSingle) then
				self:SetSize(220, 21)
			end

			if LolzenUIcfg.unitframes["uf_fade_outofreach"] == true then
				self.Range = {
					insideAlpha = 1,
					outsideAlpha = LolzenUIcfg.unitframes["uf_fade_outofreach_alpha"],
				}
			end

			Health.PostUpdate = PostUpdateHealth
		end

		local UnitSpecific = {
			player = function(self, ...)
				shared(self, ...)

				self.Health.value:SetFont("Interface\\AddOns\\LolzenUI\\fonts\\DroidSansBold.ttf", 24, "THINOUTLINE")
				self.Health.value:SetPoint("RIGHT", -2, 8)

				local Power = CreateFrame("StatusBar", nil, self)
				Power:SetHeight(2)
				Power:SetStatusBarTexture(LSM:Fetch("statusbar", LolzenUIcfg.unitframes["uf_statusbar_texture"]))
				Power:SetFrameStrata("HIGH")

				Power.frequentUpdates = true
				

				Power:SetPoint("LEFT")
				Power:SetPoint("RIGHT")
				Power:SetPoint("TOP", self.Health, "BOTTOM", 0, 2)

				self.Power = Power

				local PowerDivider = Power:CreateTexture(nil, "OVERLAY")
				PowerDivider:SetSize(self:GetWidth(), 1)
				PowerDivider:SetPoint("TOPLEFT", Power, 0, 1)
				PowerDivider:SetTexture("Interface\\AddOns\\LolzenUI\\media\\"..LolzenUIcfg.unitframes["uf_statusbar_texture"])
				PowerDivider:SetVertexColor(0, 0, 0)
				self.PowerDivider = PowerDivider

				local PowerPoints = Power:CreateFontString(nil, "OVERLAY")
				PowerPoints:SetPoint("RIGHT", self.Health.value, "LEFT", 0, 0)
				PowerPoints:SetFont("Interface\\AddOns\\LolzenUI\\fonts\\DroidSansBold.ttf", 18, "THINOUTLINE")
				PowerPoints:SetTextColor(1, 1, 1)
				Power.value = PowerPoints
				self:Tag(PowerPoints, "[lolzen:power]")

				-- ClassPower (Combo Points, etc)
				local ClassPower = {}
				local spacing = 5
				for i=1, 10 do
					ClassPower[i] = CreateFrame("StatusBar", "ClassPower"..i.."Bar", self)
					ClassPower[i]:SetStatusBarTexture(LSM:Fetch("statusbar", LolzenUIcfg.unitframes["uf_statusbar_texture"]))
					if i == 1 then
						ClassPower[i]:SetPoint("TOPLEFT", self, "BOTTOMLEFT", 0, -5)
					else
						ClassPower[i]:SetPoint("LEFT", ClassPower[i-1], "RIGHT", spacing, 0)
					end

					local border = CreateFrame("Frame", nil, ClassPower[i])
					border:SetBackdrop({
					--edgeFile = "Interface\\AddOns\\LolzenUI\\media\\border", edgeSize = 12,
					--insets = {left = 0, right = 0, top = 0, bottom = 0},
						edgeFile=[[Interface/Tooltips/UI-Tooltip-Border]],
						tile=true, tileSize=4, edgeSize=4,
						insets={left=0.5,right=0.5,top=0.5,bottom=0.5}
					})
					border:SetPoint("TOPLEFT", ClassPower[i], -1, 1.5)
					border:SetPoint("BOTTOMRIGHT", ClassPower[i], 1.5, -1)
					border:SetBackdropBorderColor(0, 0, 0)
					border:SetFrameLevel(3)
				end
				self.ClassPower = ClassPower

				local Glow = CreateFrame("Frame", nil, self)
				Glow:SetBackdrop({
					edgeFile ="Interface\\AddOns\\LolzenUI\\media\\glow", edgeSize = 5,
					insets = {left = 4, right = 4, top = 4, bottom = 4}
				})
				Glow:SetPoint("TOPLEFT", self, -5, 5)
				Glow:SetPoint("BOTTOMRIGHT", self, 5, -5)
				Glow:SetBackdropBorderColor(6, 0, 0)
				Glow:SetFrameLevel(2)

				-- workaround so we can actually have an glow border
				local threat = Glow:CreateTexture(nil, "OVERLAY")
				self.ThreatIndicator = threat

				local Castbar = CreateFrame("StatusBar", nil, self)
				Castbar:SetStatusBarTexture(LSM:Fetch("statusbar", LolzenUIcfg.unitframes["uf_statusbar_texture"]))
				Castbar:SetAllPoints(self.Health)
				Castbar:SetStatusBarColor(0.8, 0, 0, 0.2)
				Castbar:SetFrameStrata("HIGH")
				self.Castbar = Castbar

				local Spark = Castbar:CreateTexture(nil, "OVERLAY")
				Spark:SetSize(8, 23)
				Spark:SetBlendMode("ADD")
				Spark:SetParent(Castbar)
				self.Castbar.Spark = Spark

				local icon = Castbar:CreateTexture(nil, "BACKGROUND")
				icon:SetHeight(33)
				icon:SetWidth(33)
				icon:SetTexCoord(.07, .93, .07, .93)
				icon:SetPoint("RIGHT", self.Health, "LEFT", -14, 6)
				self.Castbar.Icon = icon

				local iconborder = CreateFrame("Frame")
				iconborder:SetBackdrop({
					edgeFile = "Interface\\AddOns\\LolzenUI\\media\\border", edgeSize = 12,
					insets = {left = 4, right = 4, top = 4, bottom = 4},
				})
				iconborder:SetParent(Castbar)
				iconborder:SetPoint("TOPLEFT", icon, -2, 3)
				iconborder:SetPoint("BOTTOMRIGHT", icon, 3, -2)
				iconborder:SetBackdropBorderColor(0, 0, 0)
				iconborder:SetFrameLevel(3)
				self.Castbar.Iconborder = iconborder

				local Time = Castbar:CreateFontString(nil, "OVERLAY")
				Time:SetPoint("TOPLEFT", icon, "TOPRIGHT", 13, 2)
				Time:SetFont("Interface\\AddOns\\LolzenUI\\fonts\\DroidSansBold.ttf", 12 ,"OUTLINE")
				Time:SetTextColor(1, 1, 1)
				self.Castbar.Time = Time

				local cbtext = Castbar:CreateFontString(nil, "OVERLAY")
				cbtext:SetPoint("LEFT", self.Health, "LEFT", 2, 0)
				cbtext:SetFont("Interface\\AddOns\\LolzenUI\\fonts\\DroidSans.ttf", 14 ,"OUTLINE")
				cbtext:SetTextColor(1, 1, 1)
				self.Castbar.Text = cbtext

				local Shield = Castbar:CreateTexture(nil, "ARTWORK")
				Shield:SetSize(100, 100)
				Shield:SetPoint("CENTER", icon, 17, 0)
				Shield:SetTexture("Interface\\CastingBar\\UI-CastingBar-Arena-Shield")
				self.Castbar.Shield = Shield

				Power.PostUpdate = PostUpdatePower
				threat.PostUpdate = PostUpdateThreat
				Castbar.PostChannelStart = PostCastStart
				Castbar.PostCastStart = PostCastStart
				ClassPower.PostUpdate = PostUpdateClassPower
			end,

			target = function(self, ...)
				shared(self, ...)

				self.Health.value:SetFont("Interface\\AddOns\\LolzenUI\\fonts\\DroidSansBold.ttf", 24, "THINOUTLINE")
				self.Health.value:SetPoint("RIGHT", -2, 8)

				local Power = CreateFrame("StatusBar", nil, self)
				Power:SetHeight(2)
				Power:SetStatusBarTexture(LSM:Fetch("statusbar", LolzenUIcfg.unitframes["uf_statusbar_texture"]))
				Power:SetFrameStrata("HIGH")

				Power.frequentUpdates = true

				Power:SetPoint("LEFT")
				Power:SetPoint("RIGHT")
				Power:SetPoint("TOP", self.Health, "BOTTOM", 0, 2)

				self.Power = Power

				local PowerDivider = Power:CreateTexture(nil, "OVERLAY")
				PowerDivider:SetSize(self:GetWidth(), 1)
				PowerDivider:SetPoint("TOPLEFT", Power, 0, 1)
				PowerDivider:SetTexture("Interface\\AddOns\\LolzenUI\\media\\"..LolzenUIcfg.unitframes["uf_statusbar_texture"])
				PowerDivider:SetVertexColor(0, 0, 0)
				self.PowerDivider = PowerDivider

				local PowerPoints = Power:CreateFontString(nil, "OVERLAY")
				PowerPoints:SetPoint("RIGHT", self.Health.value, "LEFT", 0, 0)
				PowerPoints:SetFont("Interface\\AddOns\\LolzenUI\\fonts\\DroidSansBold.ttf", 18, "THINOUTLINE")
				PowerPoints:SetTextColor(1, 1, 1)
				self:Tag(PowerPoints, "[lolzen:power]")
				self.Power.value = PowerPoints

				local Castbar = CreateFrame("StatusBar", nil, self)
				Castbar:SetStatusBarTexture(LSM:Fetch("statusbar", LolzenUIcfg.unitframes["uf_statusbar_texture"]))
				Castbar:SetAllPoints(self.Health)
				Castbar:SetStatusBarColor(0.8, 0, 0, 0.2)
				Castbar:SetFrameStrata("HIGH")
				self.Castbar = Castbar

				local Spark = Castbar:CreateTexture(nil, "OVERLAY")
				Spark:SetSize(8, 23)
				Spark:SetBlendMode("ADD")
				Spark:SetParent(Castbar)
				self.Castbar.Spark = Spark

				local icon = Castbar:CreateTexture(nil, "BACKGROUND")
				icon:SetHeight(33)
				icon:SetWidth(33)
				icon:SetTexCoord(.07, .93, .07, .93)
				icon:SetPoint("RIGHT", self.Health, "LEFT", -14, 6)
				self.Castbar.Icon = icon

				local iconborder = CreateFrame("Frame")
				iconborder:SetBackdrop({
					edgeFile = "Interface\\AddOns\\LolzenUI\\media\\border", edgeSize = 12,
					insets = {left = 4, right = 4, top = 4, bottom = 4},
				})
				iconborder:SetParent(Castbar)
				iconborder:SetPoint("TOPLEFT", icon, -2, 3)
				iconborder:SetPoint("BOTTOMRIGHT", icon, 3, -2)
				iconborder:SetBackdropBorderColor(0, 0, 0)
				iconborder:SetFrameLevel(3)
				self.Castbar.Iconborder = iconborder

				local Time = Castbar:CreateFontString(nil, "OVERLAY")
				Time:SetPoint("TOPLEFT", icon, "TOPRIGHT", 13, 2)
				Time:SetFont("Interface\\AddOns\\LolzenUI\\fonts\\DroidSansBold.ttf", 12 ,"OUTLINE")
				Time:SetTextColor(1, 1, 1)
				self.Castbar.Time = Time

				local cbtext = Castbar:CreateFontString(nil, "OVERLAY")
				cbtext:SetPoint("LEFT", self.Health, "LEFT", 2, 0)
				cbtext:SetFont("Interface\\AddOns\\LolzenUI\\fonts\\DroidSans.ttf", 14 ,"OUTLINE")
				cbtext:SetTextColor(1, 1, 1)
				self.Castbar.Text = cbtext

				local Shield = Castbar:CreateTexture(nil, "ARTWORK")
				Shield:SetSize(100, 100)
				Shield:SetPoint("CENTER", icon, 17, 0)
				Shield:SetTexture("Interface\\CastingBar\\UI-CastingBar-Arena-Shield")
				self.Castbar.Shield = Shield

				local Debuffs = CreateAura(self, 8)
				Debuffs:SetPoint("TOP", self, "BOTTOM", 0, -30)
				Debuffs.showDebuffType = true
				Debuffs.onlyShowPlayer = true
				Debuffs.PostUpdateIcon = PostUpdateIcon

				self.Debuffs = Debuffs

				local panel = CreateFrame("Frame")
				panel:SetBackdrop({
					bgFile = "Interface\\AddOns\\LolzenUI\\media\\"..LolzenUIcfg.unitframes["uf_statusbar_texture"],
					edgeFile=[[Interface/Tooltips/UI-Tooltip-Border]],
						tile=true, tileSize=4, edgeSize=4,
						insets={left=0.5,right=0.5,top=0.5,bottom=0.5}
				})
				panel:SetParent(self)
				panel:SetSize(self:GetWidth()+2, 18)
				panel:SetPoint("TOP", self.Health, "BOTTOM", 0, -2)
				panel:SetBackdropBorderColor(0, 0, 0)
				panel:SetFrameLevel(3)
				panel:SetBackdropColor(0, 0, 0, 0.8)

				local level = self.Health:CreateFontString(nil, "OVERLAY")
				level:SetPoint("LEFT", self.Health, "LEFT", 2, -21) 
				level:SetFont("Interface\\AddOns\\LolzenUI\\fonts\\DroidSans.ttf", 12, "THINOUTLINE")
				self.Level = level
				self:Tag(level, "[lolzen:level][shortclassification]")

				local name = self.Health:CreateFontString(nil, "OVERLAY")
				name:SetPoint("RIGHT", self.Health, "RIGHT", -2, -21)
				name:SetFont("Interface\\AddOns\\LolzenUI\\fonts\\DroidSans.ttf", 12, "THINOUTLINE")
				name:SetTextColor(1, 1, 1)
				self.Name = name
				self:Tag(name, "[name]")

				Power.PostUpdate = PostUpdatePower
				Castbar.PostChannelStart = PostCastStart
				Castbar.PostCastStart = PostCastStart
			end,

			targettarget = function(self, ...)
				shared(self, ...)

				self.Health.value:SetFont("Interface\\AddOns\\LolzenUI\\fonts\\DroidSansBold.ttf", 18, "THINOUTLINE")
				self.Health.value:SetPoint("RIGHT", -2, 8)

				self:SetSize(120, 18)
			end,

			party = function(self, ...)
				shared(self, ...)

				self.Health.value:SetPoint("LEFT", 5, 0)
				self.Health.value:SetFont("Interface\\AddOns\\LolzenUI\\fonts\\DroidSansBold.ttf", 13, "THINOUTLINE")

				local role = self.Health:CreateTexture(nil, "OVERLAY")
				role:SetSize(16, 16)
				role:SetPoint("RIGHT", self.Health,  0, 0)
				self.GroupRoleIndicator = role

				local rc = self.Health:CreateTexture(nil, "OVERLAY")
				rc:SetSize(16, 16)
				rc:SetPoint("LEFT", self.Health, 10, 10)
				self.ReadyCheckIndicator = rc
			end,

			raid = function(self, ...)
				shared(self, ...)

				self.Health.value:SetPoint("LEFT", 5, 0)
				self.Health.value:SetFont("Interface\\AddOns\\LolzenUI\\fonts\\DroidSansBold.ttf", 13, "THINOUTLINE")

				local role = self.Health:CreateTexture(nil, "OVERLAY")
				role:SetSize(16, 16)
				role:SetPoint("RIGHT", self.Health,  0, 0)
				self.RaidRoleIndicator = role

				local rc = self.Health:CreateTexture(nil, "OVERLAY")
				rc:SetSize(16, 16)
				rc:SetPoint("LEFT", self.Health, 10, 10)
				self.ReadyCheckIndicator = rc
			end,

			pet = function(self, ...)
				shared(self, ...)

				self.Health.value:SetFont("Interface\\AddOns\\LolzenUI\\fonts\\DroidSansBold.ttf", 18, "THINOUTLINE")
				self.Health.value:SetPoint("RIGHT", -2, 8)

				local Castbar = CreateFrame("StatusBar", nil, self)
				Castbar:SetStatusBarTexture(LSM:Fetch("statusbar", LolzenUIcfg.unitframes["uf_statusbar_texture"]))
				Castbar:SetAllPoints(self.Health)
				Castbar:SetStatusBarColor(0.8, 0, 0, 0.2)
				Castbar:SetFrameStrata("HIGH")
				self.Castbar = Castbar

				local Spark = Castbar:CreateTexture(nil, "OVERLAY")
				Spark:SetSize(8, 23)
				Spark:SetBlendMode("ADD")
				Spark:SetParent(Castbar)
				self.Castbar.Spark = Spark

				local icon = Castbar:CreateTexture(nil, "BACKGROUND")
				icon:SetHeight(33)
				icon:SetWidth(33)
				icon:SetTexCoord(.07, .93, .07, .93)
				icon:SetPoint("RIGHT", self.Health, "LEFT", -14, 6)
				self.Castbar.Icon = icon

				local iconborder = CreateFrame("Frame")
				iconborder:SetBackdrop({
					edgeFile = "Interface\\AddOns\\LolzenUI\\media\\border", edgeSize = 12,
					insets = {left = 4, right = 4, top = 4, bottom = 4},
				})
				iconborder:SetParent(Castbar)
				iconborder:SetPoint("TOPLEFT", icon, -2, 3)
				iconborder:SetPoint("BOTTOMRIGHT", icon, 3, -2)
				iconborder:SetBackdropBorderColor(0, 0, 0)
				iconborder:SetFrameLevel(3)
				self.Castbar.Iconborder = iconborder

				local Time = Castbar:CreateFontString(nil, "OVERLAY")
				Time:SetPoint("TOPLEFT", icon, "TOPRIGHT", 13, 2)
				Time:SetFont("Interface\\AddOns\\LolzenUI\\fonts\\DroidSansBold.ttf", 12 ,"OUTLINE")
				Time:SetTextColor(1, 1, 1)
				self.Castbar.Time = Time

				local cbtext = Castbar:CreateFontString(nil, "OVERLAY")
				cbtext:SetPoint("LEFT", self.Health, "LEFT", 2, 0)
				cbtext:SetFont("Interface\\AddOns\\LolzenUI\\fonts\\DroidSans.ttf", 14 ,"OUTLINE")
				cbtext:SetTextColor(1, 1, 1)
				self.Castbar.Text = cbtext

				local Shield = Castbar:CreateTexture(nil, "ARTWORK")
				Shield:SetSize(100, 100)
				Shield:SetPoint("CENTER", icon, 17, 0)
				Shield:SetTexture("Interface\\CastingBar\\UI-CastingBar-Arena-Shield")
				self.Castbar.Shield = Shield

				self:SetSize(120, 19)

				Castbar.PostChannelStart = PostCastStart
				Castbar.PostCastStart = PostCastStart
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
		local frame = CreateFrame("Frame", nil, UIParent)
		frame:RegisterEvent("PLAYER_ENTERING_WORLD")
		frame:SetScript("OnEvent", function(self, event)
			CompactRaidFrameManager:UnregisterAllEvents()
			CompactRaidFrameManager:Hide()
			CompactRaidFrameContainer:UnregisterAllEvents()
			CompactRaidFrameContainer:Hide()
		end)

		oUF:Factory(function(self)
		--	local base = 100
		--	spawnHelper(self, 'focus', "BOTTOM", 0, base + (40 * 1))
			spawnHelper(self, 'pet', "CENTER", -300, -177)
			spawnHelper(self, 'player', "CENTER", -250, -200)
			spawnHelper(self, 'target', "CENTER", 250, -200)
			spawnHelper(self, 'targettarget', "CENTER", 300, -177)

			for n=1, MAX_BOSS_FRAMES or 5 do
				spawnHelper(self, "boss" .. n, "CENTER", 0, -240 + (40 * n))
			end

			self:SetActiveStyle("Lolzen - Party")

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
				--'point', "TOP",
				'groupFilter', '1,2,3,4,5,6,7,8',
				'groupingOrder', '8,7,6,5,4,3,2,1',
				'sortMethod', 'NAME',
				'groupBy', 'GROUP',
				'maxColumns', 8,
				'unitsPerColumn', 5,
				'columnSpacing', 7,
				'columnAnchorPoint', "RIGHT"
			)
			raid:SetPoint("LEFT", UIParent, "LEFT", 20, 0)
		end)
	end
end)