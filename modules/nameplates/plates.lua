--// nameplates // --

local _, ns = ...
local L = ns.L
local LSM = LibStub("LibSharedMedia-3.0")
local oUF = ns.oUF

ns.RegisterModule("nameplates", L["desc_nameplates"], true)

local f = CreateFrame("Frame")
f:RegisterEvent("ADDON_LOADED")
f:SetScript("OnEvent", function(self, event, addon)
	if addon == "LolzenUI" then
		if LolzenUIcfg.modules["nameplates"] == false then return end

		local cvars = {
			-- important, strongly recommend to set these to 1
			nameplateGlobalScale = 1,
			NamePlateHorizontalScale = 1,
			NamePlateVerticalScale = 1,
			-- optional, you may use any values
			nameplateLargerScale = 1,
			nameplateMaxScale = 1,
			nameplateMinScale = 1,
			nameplateSelectedScale = LolzenUIcfg.nameplates.general["np_selected_scale"],
			nameplateSelfScale = 1,
		}

		local UpdateTargetIndicator = function(frame, event)
			-- prevent bar from showing
			if ClassNameplateManaBarFrame then
				ClassNameplateManaBarFrame:Hide()
			end
			if not frame then return end
			if LolzenUIcfg.nameplates.general["np_targetindicator"] == true and UnitIsUnit(frame.unit, "target") then
				frame.Targetindicator:SetAlpha(1)
			else
				frame.Targetindicator:SetAlpha(0)
			end
		end

		local UpdateThreat = function(frame, event, unit)
			if LolzenUIcfg.nameplates.general["np_threatindicator"] == true then
				local status = UnitThreatSituation("player", unit)
				-- do a different behaviour on Tank specc
				local _, _, _, _, role = GetSpecializationInfoByID(GetInspectSpecialization("player"))
				if UnitGroupRolesAssigned("player") == "TANK" or role == "TANK" then
					if status and status > 0 then
						frame.Glow:Show()
						-- tanking securely
						if status == 3 then
							frame.Glow:SetBackdropBorderColor(0, 6, 0, 1)
						--insecurely tanking
						elseif status == 2 then
							frame.Glow:SetBackdropBorderColor(6, 6, 0, 1)
						--not tanking
						elseif status == 1 then
							frame.Glow:SetBackdropBorderColor(6, 0, 0, 1)
						-- infight, not tanking
						elseif status == 0 then
							frame.Glow:SetBackdropBorderColor(1, 1, 1, 1)
						end
					else
						frame.Glow:SetBackdropBorderColor(0, 0, 0, 0)
					end
				else
					if status and status > 0 then
						frame.Glow:SetBackdropBorderColor(1, 0, 0, 1)
					else
						frame.Glow:SetBackdropBorderColor(0, 0, 0, 0)
					end
				end
			else
				frame.Glow:SetBackdropBorderColor(0, 0, 0, 0)
			end
		end

		local UpdateExplosiveAndPRD = function(frame, unit)
			if not frame then return end
			if UnitName(frame.unit) == "Explosives" then
				frame.Health:SetStatusBarTexture("Interface\\AddOns\\LolzenUI\\media\\stripes")
				frame.exploGlow:SetBackdropBorderColor(0.2, 0.2, 1, 1)
			else
				frame.Health:SetStatusBarTexture(LSM:Fetch("statusbar", LolzenUIcfg.nameplates.general["np_texture"]))
				frame.exploGlow:SetBackdropBorderColor(0, 0, 0, 0)
			end
			
			-- show power on Personal Resource Display only
			if UnitName(frame.unit) == UnitName("player") then
				frame.Power:Show()
			else
				frame.Power:Hide()
			end
		end

		local UpdateRaidMarks = function(frame)
			if LolzenUIcfg.nameplates.general["np_raidtargetindicator"] == true then
				frame.RaidTargetIndicator:SetAlpha(1)
			else
				frame.RaidTargetIndicator:SetAlpha(0)
			end
		end

		local PostCastStart = function(Castbar, unit, spell, spellrank)
			if not unit == "targettarget" then
				Castbar:GetParent().Name:SetText(spell)
			end
		end

		local function UpdateAuraTimer(self, elapsed)
			if self.expiration then
				self.expiration = math.max(self.expiration - elapsed, 0)

				if self.expiration > 0 and self.expiration <= 60 then
					self.Duration:SetFormattedText("%d", self.expiration)
				else
					self.Duration:SetText("")
				end
			end
		end

		local PostCreateIcon = function(Auras, button)
			button.spacing = LolzenUIcfg.nameplates.general["np_aura_spacing"]
			
			--TODO: create own options & variables for this
			button.count:ClearAllPoints()
			button.count:SetPoint("BOTTOMRIGHT")
			button.count:SetFont(LSM:Fetch("font", LolzenUIcfg.nameplates.general["np_lvlname_font"]), 7, LolzenUIcfg.nameplates.general["np_lvlname_font_flag"])

			button.icon:SetTexCoord(.07, .93, .07, .93)

			local iconborder = CreateFrame("Frame", nil, button, "BackdropTemplate")
			iconborder:SetBackdrop({
				edgeFile = "Interface\\AddOns\\LolzenUI\\media\\border", edgeSize = 12,
				insets = {left = 4, right = 4, top = 4, bottom = 4},
			})
			iconborder:SetParent(button)
			iconborder:SetPoint("TOPLEFT", button, -2, 2)
			iconborder:SetPoint("BOTTOMRIGHT", button, 2, -2)
			iconborder:SetBackdropBorderColor(0, 0, 0)
			iconborder:SetFrameLevel(3)

			button.overlay:SetTexture("Interface\\AddOns\\LolzenUI\\media\\auraborder")
			button.overlay:SetTexCoord(.07, .93, .07, .93)
			button.overlay.Hide = function(self)
				self:SetVertexColor(0, 0, 0)
			end

			-- hide the fuckhuge numbers
			button.cd:SetHideCountdownNumbers(true)
			
			-- and replace with a custom timer
			local AuraDuration = CreateFrame("Frame", nil, button)
			AuraDuration:SetFrameLevel(20)
			
			local Duration = AuraDuration:CreateFontString(nil, "OVERLAY")
			--TODO: create own options & variables for this
			Duration:SetFont(LSM:Fetch("font", LolzenUIcfg.nameplates.general["np_lvlname_font"]), 8, LolzenUIcfg.nameplates.general["np_lvlname_font_flag"])
			Duration:SetPoint("TOPLEFT", button, 0, 0)
			button.Duration = Duration
	
			button:HookScript("OnUpdate", UpdateAuraTimer)
		end

		local PostUpdateIcon = function(icons, unit, button, index, position, duration, expiration, debuffType, isStealable)
			if(duration and duration > 0 and duration <= 60) then
				button.expiration = expiration - GetTime()
			end

			if LolzenUIcfg.nameplates.general["np_aura_desature_nonplayer_auras"] == true then 
				if button.isPlayer then
					button.icon:SetDesaturated(false)
				else
					button.icon:SetDesaturated(true)
				end
			else
				button.icon:SetDesaturated(false)
			end
		end

		local CreateAura = function(self, num)
			local Auras = CreateFrame("Frame", nil, self)

			Auras:SetSize(num * (LolzenUIcfg.nameplates.general["np_aura_size"] + 4), LolzenUIcfg.nameplates.general["np_aura_size"])
			if LolzenUIcfg.nameplates.general["np_aura_show_type"] == "Both" then
				Auras.numTotal = num
			else
				Auras.num = num
			end
			Auras.size = LolzenUIcfg.nameplates.general["np_aura_size"]
			Auras.spacing = LolzenUIcfg.nameplates.general["np_aura_spacing"]

			Auras.PostCreateIcon = PostCreateIcon

			return Auras
		end

		oUF:RegisterStyle("Lolzen - Nameplates", function(frame, unit)
			if unit:match("nameplate") then
				-- health bar
				local health = CreateFrame("StatusBar", nil, frame)
				health:SetAllPoints()
				health.colorHealth = true
				health.colorTapping = true
				health.colorDisconnected = true
				health.frequentUpdates = true
				health.colorClass = true
				health.colorReaction = true
				frame.Health = health

				local Power = CreateFrame("StatusBar", nil, frame)
				Power:SetHeight(1)
				Power:SetStatusBarTexture(LSM:Fetch("statusbar", LolzenUIcfg.nameplates.general["np_texture"]))
				Power:SetAlpha(1)
				Power:SetPoint("LEFT")
				Power:SetPoint("RIGHT")
				Power:SetPoint("TOP", frame.Health, "BOTTOM", 0, 1)

				Power.colorPower = true
				Power.frequentUpdates = true

				frame.Power = Power

				-- frame background
				local bg = frame:CreateTexture(nil, "BACKGROUND")
				bg:SetAllPoints()
				bg:SetColorTexture(0, 0, 0, 0.5)

				local levelname = health:CreateFontString(nil, "OVERLAY")
				levelname:SetPoint(LolzenUIcfg.nameplates.general["np_lvlname_anchor"], health, LolzenUIcfg.nameplates.general["np_lvlname_posx"], LolzenUIcfg.nameplates.general["np_lvlname_posy"]) 
				levelname:SetFont(LSM:Fetch("font", LolzenUIcfg.nameplates.general["np_lvlname_font"]), LolzenUIcfg.nameplates.general["np_lvlname_font_size"], LolzenUIcfg.nameplates.general["np_lvlname_font_flag"])
				frame:Tag(levelname, '[difficulty][level][shortclassification]'..' |cffffffff[name]|r')
				frame.Level = levelname

				local Castbar = CreateFrame("StatusBar", nil, health)
				Castbar:SetStatusBarTexture(LSM:Fetch("statusbar", LolzenUIcfg.nameplates.castbar["np_cb_texture"]))
				Castbar:SetPoint(LolzenUIcfg.nameplates.castbar["np_cb_anchor"], health, LolzenUIcfg.nameplates.castbar["np_cb_anchor2"], LolzenUIcfg.nameplates.castbar["np_cb_posx"], LolzenUIcfg.nameplates.castbar["np_cb_posy"])
				Castbar:SetSize(LolzenUIcfg.nameplates.castbar["np_cb_width"], LolzenUIcfg.nameplates.castbar["np_cb_height"])			
				Castbar:SetStatusBarColor(1, 1, 1, 1)
				frame.Castbar = Castbar

				local Spark = Castbar:CreateTexture(nil, "OVERLAY")
				Spark:SetSize(LolzenUIcfg.nameplates.castbar["np_spark_width"], LolzenUIcfg.nameplates.castbar["np_spark_height"])
				Spark:SetBlendMode("ADD")
				Spark:SetParent(Castbar)
				frame.Castbar.Spark = Spark

				local icon = Castbar:CreateTexture(nil, "BACKGROUND")
				icon:SetSize(LolzenUIcfg.nameplates.castbar["np_cbicon_size"], LolzenUIcfg.nameplates.castbar["np_cbicon_size"])
				icon:SetTexCoord(.07, .93, .07, .93)
				icon:SetPoint(LolzenUIcfg.nameplates.castbar["np_cbicon_anchor"], health, LolzenUIcfg.nameplates.castbar["np_cbicon_anchor2"], LolzenUIcfg.nameplates.castbar["np_cbicon_posx"], LolzenUIcfg.nameplates.castbar["np_cbicon_posy"])
				frame.Castbar.Icon = icon

				local Time = Castbar:CreateFontString(nil, "OVERLAY")
				Time:SetPoint(LolzenUIcfg.nameplates.castbar["np_cbtime_anchor"], Castbar, LolzenUIcfg.nameplates.castbar["np_cbtime_anchor2"], LolzenUIcfg.nameplates.castbar["np_cbtime_posx"], LolzenUIcfg.nameplates.castbar["np_cbtime_posy"])
				Time:SetFont(LSM:Fetch("font", LolzenUIcfg.nameplates.castbar["np_cbtime_font"]), LolzenUIcfg.nameplates.castbar["np_cbtime_font_size"], LolzenUIcfg.nameplates.castbar["np_cbtime_font_flag"])
				Time:SetTextColor(1, 1, 1)
				frame.Castbar.Time = Time

				local cbtext = Castbar:CreateFontString(nil, "OVERLAY")
				cbtext:SetPoint(LolzenUIcfg.nameplates.castbar["np_cbtext_anchor"], Castbar, LolzenUIcfg.nameplates.castbar["np_cbtext_anchor2"], LolzenUIcfg.nameplates.castbar["np_cbtext_posx"], LolzenUIcfg.nameplates.castbar["np_cbtext_posy"])
				cbtext:SetFont(LSM:Fetch("font", LolzenUIcfg.nameplates.castbar["np_cbtext_font"]), LolzenUIcfg.nameplates.castbar["np_cbtext_font_size"], LolzenUIcfg.nameplates.castbar["np_cbtext_font_flag"])
				cbtext:SetTextColor(1, 1, 1)
				frame.Castbar.Text = cbtext

				local Shield = Castbar:CreateTexture(nil, 'OVERLAY')
				Shield:SetSize(20, 20)
				Shield:SetTexture("Interface\\AddOns\\LolzenUI\\media\\shield")
				Shield:SetPoint("CENTER", icon, 0, 0)
				frame.Castbar.Shield = Shield

				local RaidTargetIndicator = health:CreateTexture(nil, 'OVERLAY')
				RaidTargetIndicator:SetSize(LolzenUIcfg.nameplates.general["np_raidmark_size"], LolzenUIcfg.nameplates.general["np_raidmark_size"])
				RaidTargetIndicator:SetPoint(LolzenUIcfg.nameplates.general["np_raidmark_anchor"], health, LolzenUIcfg.nameplates.general["np_raidmark_posx"], LolzenUIcfg.nameplates.general["np_raidmark_posy"])
				frame.RaidTargetIndicator = RaidTargetIndicator
				table.insert(frame.__elements, UpdateRaidMarks)
				frame:RegisterEvent("PLAYER_TARGET_CHANGED", UpdateRaidMarks, true)

				local targetindicator = health:CreateTexture(nil, 'OVERLAY')
				targetindicator:SetPoint("LEFT", health, 0, -3)
				targetindicator:SetTexture("Interface\\AddOns\\LolzenUI\\media\\target-glow")
				targetindicator:SetSize(LolzenUIcfg.nameplates.general["np_width"], 5*cvars.nameplateSelectedScale)
				targetindicator:SetVertexColor(48/255, 113/255, 191/255)
				frame.Targetindicator = targetindicator
				frame:RegisterEvent("PLAYER_TARGET_CHANGED", UpdateTargetIndicator, true)

				local Glow = CreateFrame("Frame", nil, frame, "BackdropTemplate")
				Glow:SetBackdrop({
					edgeFile ="Interface\\AddOns\\LolzenUI\\media\\glow", edgeSize = 5,
					insets = {left = 4, right = 4, top = 4, bottom = 4}
				})
				Glow:SetPoint("TOPLEFT", health, -5, 5)
				Glow:SetPoint("BOTTOMRIGHT", health, 5, -5)
				Glow:SetBackdropBorderColor(6, 0, 0)
				frame.Glow = Glow

				frame.ThreatIndicator = {
					IsObjectType = function() end,
					Override = UpdateThreat,
				}

				local exploGlow = CreateFrame("Frame", nil, frame, "BackdropTemplate")
				exploGlow:SetBackdrop({
					edgeFile ="Interface\\AddOns\\LolzenUI\\media\\glow", edgeSize = 5,
					insets = {left = 4, right = 4, top = 4, bottom = 4}
				})
				exploGlow:SetPoint("TOPLEFT", health, -5, 5)
				exploGlow:SetPoint("BOTTOMRIGHT", health, 5, -5)
				exploGlow:SetBackdropBorderColor(6, 0, 0)
				frame.exploGlow = exploGlow

				local explo = health:CreateTexture(nil, 'OVERLAY')
				frame.explosive = explo
				table.insert(frame.__elements, UpdateExplosiveAndPRD)
				frame:RegisterEvent("UNIT_NAME_UPDATE", UpdateExplosiveAndPRD)

				local Buffs = CreateAura(frame, LolzenUIcfg.nameplates.general["np_aura_maxnum"])
				frame.Buffs = Buffs
				
				local Debuffs = CreateAura(frame, LolzenUIcfg.nameplates.general["np_aura_maxnum"])
				Debuffs.showDebuffType = true
				frame.Debuffs = Debuffs
				
				local Auras = CreateAura(frame, LolzenUIcfg.nameplates.general["np_aura_maxnum"])
				Auras.showDebuffType = true
				Auras.gap = true
				frame.Auras = Auras
				
				if LolzenUIcfg.nameplates.general["np_aura_show_type"] == "Buffs" then
					frame.Buffs:SetPoint(LolzenUIcfg.nameplates.general["np_aura_anchor1"], frame, LolzenUIcfg.nameplates.general["np_aura_anchor2"], LolzenUIcfg.nameplates.general["np_aura_posx"], LolzenUIcfg.nameplates.general["np_aura_posy"])
					if LolzenUIcfg.nameplates.general["np_aura_show_only_player"] == true then
						frame.Buffs.onlyShowPlayer = true
					end
					frame.Buffs["growth-x"] = LolzenUIcfg.nameplates.general["np_aura_growth_x"]
					frame.Buffs["growth-y"] = LolzenUIcfg.nameplates.general["np_aura_growth_y"]
				elseif LolzenUIcfg.nameplates.general["np_aura_show_type"] == "Debuffs" then
					frame.Debuffs:SetPoint(LolzenUIcfg.nameplates.general["np_aura_anchor1"], frame, LolzenUIcfg.nameplates.general["np_aura_anchor2"], LolzenUIcfg.nameplates.general["np_aura_posx"], LolzenUIcfg.nameplates.general["np_aura_posy"])
					if LolzenUIcfg.nameplates.general["np_aura_show_only_player"] == true then
						frame.Debuffs.onlyShowPlayer = true
					end
					frame.Debuffs["growth-x"] = LolzenUIcfg.nameplates.general["np_aura_growth_x"]
					frame.Debuffs["growth-y"] = LolzenUIcfg.nameplates.general["np_aura_growth_y"]
				elseif LolzenUIcfg.nameplates.general["np_aura_show_type"] == "Both" then
					frame.Auras:SetPoint(LolzenUIcfg.nameplates.general["np_aura_anchor1"], frame, LolzenUIcfg.nameplates.general["np_aura_anchor2"], LolzenUIcfg.nameplates.general["np_aura_posx"], LolzenUIcfg.nameplates.general["np_aura_posy"])
					if LolzenUIcfg.nameplates.general["np_aura_show_only_player"] == true then
						frame.Auras.onlyShowPlayer = true
					end
					frame.Auras["growth-x"] = LolzenUIcfg.nameplates.general["np_aura_growth_x"]
					frame.Auras["growth-y"] = LolzenUIcfg.nameplates.general["np_aura_growth_y"]
				end

				-- set size and points
				frame:SetSize(LolzenUIcfg.nameplates.general["np_width"], LolzenUIcfg.nameplates.general["np_height"])
				frame:SetPoint("CENTER", 0, 0)

				Castbar.PostChannelStart = PostCastStart
				Castbar.PostCastStart = PostCastStart
				Buffs.PostUpdateIcon = PostUpdateIcon
				Debuffs.PostUpdateIcon = PostUpdateIcon
				Auras.PostUpdateIcon = PostUpdateIcon
			end
		end)
		oUF:SpawnNamePlates("Lolzen - Nameplates", UpdateTargetIndicator, cvars)

		-- General Nameplate option functions

		ns.setNPTargetIndicator = function()
			for i, v in pairs(oUF.objects) do
				if v.unit:match("nameplate") then
					UpdateTargetIndicator(v)
				end
			end
		end

		ns.setNPSize = function()
			SetCVar("nameplateSelectedScale", LolzenUIcfg.nameplates.general["np_selected_scale"])
			for i, v in pairs(oUF.objects) do
				if v.unit:match("nameplate") then
					v:SetSize(LolzenUIcfg.nameplates.general["np_width"], LolzenUIcfg.nameplates.general["np_height"])
				end
			end
		end

		ns.setNPTexture = function()
			for i, v in pairs(oUF.objects) do
				if v.unit:match("nameplate") then
					UpdateExplosiveAndPRD(v, v.unit)
				end
			end
		end

		ns.setNPLevelFont = function()
			for i, v in pairs(oUF.objects) do
				if v.unit:match("nameplate") then
					v.Level:SetFont(LSM:Fetch("font", LolzenUIcfg.nameplates.general["np_lvlname_font"]), LolzenUIcfg.nameplates.general["np_lvlname_font_size"], LolzenUIcfg.nameplates.general["np_lvlname_font_flag"])
				end
			end
		end

		ns.setNPLevelFontPos = function()
			for i, v in pairs(oUF.objects) do
				if v.unit:match("nameplate") then
					v.Level:ClearAllPoints()
					v.Level:SetPoint(LolzenUIcfg.nameplates.general["np_lvlname_anchor"], v.Health, LolzenUIcfg.nameplates.general["np_lvlname_posx"], LolzenUIcfg.nameplates.general["np_lvlname_posy"]) 
				end
			end
		end

		ns.setNPRaidMarks = function()
			for i, v in pairs(oUF.objects) do
				if v.unit:match("nameplate") then
					UpdateRaidMarks(v)
				end
			end
		end

		ns.setNPRaidMarkSize = function()
			for i, v in pairs(oUF.objects) do
				if v.unit:match("nameplate") then
					v.RaidTargetIndicator:SetSize(LolzenUIcfg.nameplates.general["np_raidmark_size"], LolzenUIcfg.nameplates.general["np_raidmark_size"])
				end
			end
		end

		ns.setNPRaidMarkPos = function()
			for i, v in pairs(oUF.objects) do
				if v.unit:match("nameplate") then
					v.RaidTargetIndicator:ClearAllPoints()
					v.RaidTargetIndicator:SetPoint(LolzenUIcfg.nameplates.general["np_raidmark_anchor"], v.Health, LolzenUIcfg.nameplates.general["np_raidmark_posx"], LolzenUIcfg.nameplates.general["np_raidmark_posy"])
				end
			end
		end
		
		ns.setNPAuraType = function()
			for i, v in pairs(oUF.objects) do
				if v.unit:match("nameplate") then
					if LolzenUIcfg.nameplates.general["np_aura_show_type"] == "Buffs" then
						if v.Debuffs then
							v.Debuffs:Hide()
						elseif v.Auras then
							v.Auras:Hide()
						end
						v.Buffs:Show()
					elseif LolzenUIcfg.nameplates.general["np_aura_show_type"] == "Debuffs" then
						if v.Buffs then
							v.Buffs:Hide()
						elseif v.Auras then
							v.Auras:Hide()
						end
						v.Debuffs:Show()
					elseif LolzenUIcfg.nameplates.general["np_aura_show_type"] == "Both" then
						if v.Buffs then
							v.Buffs:Hide()
						elseif v.Debuffs then
							v.Debuffs:Hide()
						end
						v.Auras:Show()
					else
						if v.Buffs then
							v.Buffs:Hide()
						elseif v.Debuffs then
							v.Debuffs:Hide()
						elseif v.Auras then
							v.Auras:Hide()
						end
					end
				end
			end
			self:UpdateAllElements('RefreshUnit')
		end

		ns.setNPAuraMaxNum = function()
			for i, v in pairs(oUF.objects) do
				if v.unit:match("nameplate") then
					v.Buffs.num = LolzenUIcfg.nameplates.general["np_aura_maxnum"]
					v.Debuffs.num = LolzenUIcfg.nameplates.general["np_aura_maxnum"]
					v.Auras.numTotal = LolzenUIcfg.nameplates.general["np_aura_maxnum"]
					v:UpdateAllElements('RefreshUnit')
				end
			end
		end

		ns.setNPAuraSpacing = function()
			for i, v in pairs(oUF.objects) do
				if v.unit:match("nameplate") then
					v.Buffs.spacing = LolzenUIcfg.nameplates.general["np_aura_spacing"]
					v.Debuffs.spacing = LolzenUIcfg.nameplates.general["np_aura_spacing"]
					v.Auras.spacing = LolzenUIcfg.nameplates.general["np_aura_spacing"]
					v.Buffs:ForceUpdate()
					v.Debuffs:ForceUpdate()
					v.Auras:ForceUpdate()
				end
			end
		end

		ns.setNPAuraSize = function()
			for i, v in pairs(oUF.objects) do
				if v.unit:match("nameplate") then
					v.Buffs.size = LolzenUIcfg.nameplates.general["np_aura_size"]
					v.Debuffs.size = LolzenUIcfg.nameplates.general["np_aura_size"]
					v.Auras.size = LolzenUIcfg.nameplates.general["np_aura_size"]
					v:UpdateAllElements('RefreshUnit')
				end
			end
		end

		ns.setNPAuraPos = function()
			for i, v in pairs(oUF.objects) do
				if v.unit:match("nameplate") then
					if LolzenUIcfg.nameplates.general["np_aura_show_type"] == "Buffs" then
						v.Buffs:ClearAllPoints()
						v.Buffs:SetPoint(LolzenUIcfg.nameplates.general["np_aura_anchor1"], v, LolzenUIcfg.nameplates.general["np_aura_anchor2"], LolzenUIcfg.nameplates.general["np_aura_posx"], LolzenUIcfg.nameplates.general["np_aura_posy"])
					elseif LolzenUIcfg.nameplates.general["np_aura_show_type"] == "Debuffs" then
						v.Debuffs:ClearAllPoints()
						v.Debuffs:SetPoint(LolzenUIcfg.nameplates.general["np_aura_anchor1"], v, LolzenUIcfg.nameplates.general["np_aura_anchor2"], LolzenUIcfg.nameplates.general["np_aura_posx"], LolzenUIcfg.nameplates.general["np_aura_posy"])
					elseif LolzenUIcfg.nameplates.general["np_aura_show_type"] == "Both" then
						v.Auras:ClearAllPoints()
						v.Auras:SetPoint(LolzenUIcfg.nameplates.general["np_aura_anchor1"], v, LolzenUIcfg.nameplates.general["np_aura_anchor2"], LolzenUIcfg.nameplates.general["np_aura_posx"], LolzenUIcfg.nameplates.general["np_aura_posy"])
					end
				end
			end
		end

		ns.setNPAuraAxis = function()
			for i, v in pairs(oUF.objects) do
				if v.unit:match("nameplate") then
					v.Buffs["growth-x"] = LolzenUIcfg.nameplates.general["np_aura_growth_x"]
					v.Buffs["growth-y"] = LolzenUIcfg.nameplates.general["np_aura_growth_y"]
					v.Debuffs["growth-x"] = LolzenUIcfg.nameplates.general["np_aura_growth_x"]
					v.Debuffs["growth-y"] = LolzenUIcfg.nameplates.general["np_aura_growth_y"]
					v.Auras["growth-x"] = LolzenUIcfg.nameplates.general["np_aura_growth_x"]
					v.Auras["growth-y"] = LolzenUIcfg.nameplates.general["np_aura_growth_y"]
					v.Buffs:ForceUpdate()
					v.Debuffs:ForceUpdate()
					v.Auras:ForceUpdate()
				end
			end
		end

		ns.setNPAuraShowOnlyPlayer = function()
			for i, v in pairs(oUF.objects) do
				if v.unit:match("nameplate") then
					if LolzenUIcfg.nameplates.general["np_aura_show_only_player"] == true then
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

		ns.setNPAuraDesatured = function()
			for i, v in pairs(oUF.objects) do
				if v.unit:match("nameplate") then
					PostUpdateIcon(v.Buffs)
					PostUpdateIcon(v.Debuffs)
					PostUpdateIcon(v.Auras)
				end
			end
		end

		-- Castbar Nameplate option functions

		ns.setNP_CBPos = function()
			for i, v in pairs(oUF.objects) do
				if v.unit:match("nameplate") then
					v.Castbar:ClearAllPoints()
					v.Castbar:SetPoint(LolzenUIcfg.nameplates.castbar["np_cb_anchor"], v.Health, LolzenUIcfg.nameplates.castbar["np_cb_anchor2"], LolzenUIcfg.nameplates.castbar["np_cb_posx"], LolzenUIcfg.nameplates.castbar["np_cb_posy"])
				end
			end
		end

		ns.setNP_CBSize = function()
			for i, v in pairs(oUF.objects) do
				if v.unit:match("nameplate") then
					v.Castbar:SetSize(LolzenUIcfg.nameplates.castbar["np_cb_width"], LolzenUIcfg.nameplates.castbar["np_cb_height"])
				end
			end
		end

		ns.setNP_CBTexture = function()
			for i, v in pairs(oUF.objects) do
				if v.unit:match("nameplate") then
					v.Castbar:SetStatusBarTexture(LSM:Fetch("statusbar", LolzenUIcfg.nameplates.castbar["np_cb_texture"]))
				end
			end
		end

		ns.setNP_CBSparkSize = function()
			for i, v in pairs(oUF.objects) do
				if v.unit:match("nameplate") then
					v.Castbar.Spark:SetSize(LolzenUIcfg.nameplates.castbar["np_spark_width"], LolzenUIcfg.nameplates.castbar["np_spark_height"])
				end
			end
		end

		ns.setNP_CBIconPos = function()
			for i, v in pairs(oUF.objects) do
				if v.unit:match("nameplate") then
					v.Castbar.Icon:ClearAllPoints()
					v.Castbar.Icon:SetPoint(LolzenUIcfg.nameplates.castbar["np_cbicon_anchor"], v.Health, LolzenUIcfg.nameplates.castbar["np_cbicon_anchor2"], LolzenUIcfg.nameplates.castbar["np_cbicon_posx"], LolzenUIcfg.nameplates.castbar["np_cbicon_posy"])
				end
			end
		end

		ns.setNP_CBIconSize = function()
			for i, v in pairs(oUF.objects) do
				if v.unit:match("nameplate") then
					v.Castbar.Icon:SetSize(LolzenUIcfg.nameplates.castbar["np_cbicon_size"], LolzenUIcfg.nameplates.castbar["np_cbicon_size"])
				end
			end
		end

		ns.setNP_CBTimeFont = function()
			for i, v in pairs(oUF.objects) do
				if v.unit:match("nameplate") then
					v.Castbar.Time:SetFont(LSM:Fetch("font", LolzenUIcfg.nameplates.castbar["np_cbtime_font"]), LolzenUIcfg.nameplates.castbar["np_cbtime_font_size"], LolzenUIcfg.nameplates.castbar["np_cbtime_font_flag"])
				end
			end
		end

		ns.setNP_CBTimePos = function()
			for i, v in pairs(oUF.objects) do
				if v.unit:match("nameplate") then
					v.Castbar.Time:ClearAllPoints()
					v.Castbar.Time:SetPoint(LolzenUIcfg.nameplates.castbar["np_cbtime_anchor"], v.Castbar, LolzenUIcfg.nameplates.castbar["np_cbtime_anchor2"], LolzenUIcfg.nameplates.castbar["np_cbtime_posx"], LolzenUIcfg.nameplates.castbar["np_cbtime_posy"])
				end
			end
		end

		ns.setNP_CBTextFont = function()
			for i, v in pairs(oUF.objects) do
				if v.unit:match("nameplate") then
					v.Castbar.Text:SetFont(LSM:Fetch("font", LolzenUIcfg.nameplates.castbar["np_cbtext_font"]), LolzenUIcfg.nameplates.castbar["np_cbtext_font_size"], LolzenUIcfg.nameplates.castbar["np_cbtext_font_flag"])
				end
			end
		end

		ns.setNP_CBTextPos = function()
			for i, v in pairs(oUF.objects) do
				if v.unit:match("nameplate") then
					v.Castbar.Text:ClearAllPoints()
					v.Castbar.Text:SetPoint(LolzenUIcfg.nameplates.castbar["np_cbtext_anchor"], v.Castbar, LolzenUIcfg.nameplates.castbar["np_cbtext_anchor2"], LolzenUIcfg.nameplates.castbar["np_cbtext_posx"], LolzenUIcfg.nameplates.castbar["np_cbtext_posy"])
				end
			end
		end
	end
end)