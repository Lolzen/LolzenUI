--// nameplates // --

local _, ns = ...
local LSM = LibStub("LibSharedMedia-3.0")
local oUF = ns.oUF

ns.RegisterModule("nameplates", true)

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
			nameplateSelectedScale = LolzenUIcfg.nameplates["np_selected_scale"],
			nameplateSelfScale = 1,
		}

		local UpdateTargetIndicator = function(frame, event)
			if UnitIsUnit(frame.unit, "target") then
				frame.Targetindicator:SetAlpha(1)
			else
				frame.Targetindicator:SetAlpha(0)
			end
		end

		local UpdateThreat = function(frame, event, unit)
			local status = UnitThreatSituation("player", unit)
			if status and status > 0 then
				if not frame.Glow:IsShown() then
					frame.Glow:Show()
				end
			else
				if frame.Glow:IsShown() then
					frame.Glow:Hide()
				end
			end
		end

		local PostCastStart = function(Castbar, unit, spell, spellrank)
			if not unit == "targettarget" then
				Castbar:GetParent().Name:SetText(spell)
			end
		end

		local PostCreateIcon = function(Auras, button)
		--	local count = button.count
		--	count:ClearAllPoints()
		--	count:SetPoint"BOTTOM"
			--button.count:SetFont(LSM:Fetch("font", LolzenUIcfg.nameplates["np_cbtime_font"]), 2, LolzenUIcfg.nameplates["np_cbtime_font_flag"])

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
			if LolzenUIcfg.nameplates["np_aura_desature_nonplayer_auras"] == true then
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

			Auras:SetSize(num * (LolzenUIcfg.nameplates["np_aura_size"] + 4), LolzenUIcfg.nameplates["np_aura_size"])
			if LolzenUIcfg.nameplates["np_aura_show_type"] == "Both" then
				Auras.numTotal = num
			else
				Auras.num = num
			end
			Auras.size = LolzenUIcfg.nameplates["np_aura_size"]
			Auras.spacing = LolzenUIcfg.nameplates["np_aura_spacing"]

			Auras.PostCreateIcon = PostCreateIcon

			return Auras
		end

		local tags = oUF.Tags.Methods or oUF.Tags
		local tagevents = oUF.TagEvents or oUF.Tags.Events

		tags["lolzen:nplevel"] = function(unit)
			if not UnitLevel(unit) or UnitLevel(unit) == -1 then
				return "|cffff0000??|r "
			else
				return ("|cff%02x%02x%02x%d|r"):format(GetQuestDifficultyColor(UnitLevel(unit)).r*255, GetQuestDifficultyColor(UnitLevel(unit)).g*255, GetQuestDifficultyColor(UnitLevel(unit)).b*255, UnitLevel(unit))
			end
		end

		tags["lolzen:npname"] = function(unit)
			return UnitName(unit)
		end

		oUF:RegisterStyle("Lolzen - Nameplates", function(frame, unit)
			if unit:match("nameplate") then
				-- health bar
				local health = CreateFrame("StatusBar", nil, frame)
				health:SetAllPoints()
				health:SetStatusBarTexture(LSM:Fetch("statusbar", LolzenUIcfg.nameplates["np_texture"]))
				health.colorHealth = true
				health.colorTapping = true
				health.colorDisconnected = true
				health.frequentUpdates = true
				health.colorClass = true
				health.colorReaction = true
				frame.Health = health

				-- frame background
				local bg = frame:CreateTexture(nil, "BACKGROUND")
				bg:SetAllPoints()
				bg:SetColorTexture(0, 0, 0, 0.5)

				local levelname = health:CreateFontString(nil, "OVERLAY")
				levelname:SetPoint(LolzenUIcfg.nameplates["np_lvlname_anchor"], health, LolzenUIcfg.nameplates["np_lvlname_posx"], LolzenUIcfg.nameplates["np_lvlname_posy"]) 
				levelname:SetFont(LSM:Fetch("font", LolzenUIcfg.nameplates["np_lvlname_font"]), LolzenUIcfg.nameplates["np_lvlname_font_size"], LolzenUIcfg.nameplates["np_lvlname_font_flag"])
				frame:Tag(levelname, '[lolzen:nplevel][shortclassification] [lolzen:npname]')
				frame.Level = levelname

				local Castbar = CreateFrame("StatusBar", nil, health)
				Castbar:SetStatusBarTexture(LSM:Fetch("statusbar", LolzenUIcfg.nameplates["np_cb_texture"]))
				Castbar:SetPoint(LolzenUIcfg.nameplates["np_cb_anchor"], health, LolzenUIcfg.nameplates["np_cb_anchor2"], LolzenUIcfg.nameplates["np_cb_posx"], LolzenUIcfg.nameplates["np_cb_posy"])
				Castbar:SetSize(LolzenUIcfg.nameplates["np_cb_width"], LolzenUIcfg.nameplates["np_cb_height"])			
				Castbar:SetStatusBarColor(1, 1, 1, 1)
				frame.Castbar = Castbar

				local Spark = Castbar:CreateTexture(nil, "OVERLAY")
				Spark:SetSize(LolzenUIcfg.nameplates["np_spark_width"], LolzenUIcfg.nameplates["np_spark_height"])
				Spark:SetBlendMode("ADD")
				Spark:SetParent(Castbar)
				frame.Castbar.Spark = Spark

				local icon = Castbar:CreateTexture(nil, "BACKGROUND")
				icon:SetSize(LolzenUIcfg.nameplates["np_cbicon_size"], LolzenUIcfg.nameplates["np_cbicon_size"])
				icon:SetTexCoord(.07, .93, .07, .93)
				icon:SetPoint(LolzenUIcfg.nameplates["np_cbicon_anchor"], health, LolzenUIcfg.nameplates["np_cbicon_anchor2"], LolzenUIcfg.nameplates["np_cbicon_posx"], LolzenUIcfg.nameplates["np_cbicon_posy"])
				frame.Castbar.Icon = icon

				local Time = Castbar:CreateFontString(nil, "OVERLAY")
				Time:SetPoint(LolzenUIcfg.nameplates["np_cbtime_anchor"], Castbar, LolzenUIcfg.nameplates["np_cbtime_anchor2"], LolzenUIcfg.nameplates["np_cbtime_posx"], LolzenUIcfg.nameplates["np_cbtime_posy"])
				Time:SetFont(LSM:Fetch("font", LolzenUIcfg.nameplates["np_cbtime_font"]), LolzenUIcfg.nameplates["np_cbtime_font_size"], LolzenUIcfg.nameplates["np_cbtime_font_flag"])
				Time:SetTextColor(1, 1, 1)
				frame.Castbar.Time = Time

				local cbtext = Castbar:CreateFontString(nil, "OVERLAY")
				cbtext:SetPoint(LolzenUIcfg.nameplates["np_cbtext_anchor"], Castbar, LolzenUIcfg.nameplates["np_cbtext_anchor2"], LolzenUIcfg.nameplates["np_cbtext_posx"], LolzenUIcfg.nameplates["np_cbtext_posy"])
				cbtext:SetFont(LSM:Fetch("font", LolzenUIcfg.nameplates["np_cbtext_font"]), LolzenUIcfg.nameplates["np_cbtext_font_size"], LolzenUIcfg.nameplates["np_cbtext_font_flag"])
				cbtext:SetTextColor(1, 1, 1)
				frame.Castbar.Text = cbtext

				local Shield = Castbar:CreateTexture(nil, 'OVERLAY')
				Shield:SetSize(20, 20)
				Shield:SetTexture("Interface\\AddOns\\LolzenUI\\media\\shield")
				Shield:SetPoint("CENTER", icon, 0, 0)
				frame.Castbar.Shield = Shield

				if LolzenUIcfg.nameplates["np_raidtargetindicator"] == true then
					local RaidTargetIndicator = health:CreateTexture(nil, 'OVERLAY')
					RaidTargetIndicator:SetSize(LolzenUIcfg.nameplates["np_raidmark_size"], LolzenUIcfg.nameplates["np_raidmark_size"])
					RaidTargetIndicator:SetPoint(LolzenUIcfg.nameplates["np_raidmark_anchor"], health, LolzenUIcfg.nameplates["np_raidmark_posx"], LolzenUIcfg.nameplates["np_raidmark_posy"])
					frame.RaidTargetIndicator = RaidTargetIndicator
				end

				if LolzenUIcfg.nameplates["np_targetindicator"] == true then
					local targetindicator = health:CreateTexture(nil, 'OVERLAY')
					targetindicator:SetPoint("LEFT", health, 0, -3)
					targetindicator:SetTexture("Interface\\AddOns\\LolzenUI\\media\\target-glow")
					targetindicator:SetSize(LolzenUIcfg.nameplates["np_width"], 5*cvars.nameplateSelectedScale)
					targetindicator:SetVertexColor(48/255, 113/255, 191/255)
					frame.Targetindicator = targetindicator
					frame:RegisterEvent("PLAYER_TARGET_CHANGED", UpdateTargetIndicator)
				end

				if LolzenUIcfg.nameplates["np_threatindicator"] == true then
					local Glow = CreateFrame("Frame", nil, frame)
					Glow:SetBackdrop({
						edgeFile ="Interface\\AddOns\\LolzenUI\\media\\glow", edgeSize = 5,
						insets = {left = 4, right = 4, top = 4, bottom = 4}
					})
					Glow:SetPoint("TOPLEFT", health, -5, 5)
					Glow:SetPoint("BOTTOMRIGHT", health, 5, -5)
					Glow:SetBackdropBorderColor(6, 0, 0)
					frame.Glow = Glow
					table.insert(frame.__elements, UpdateThreat)
					frame:RegisterEvent("UNIT_THREAT_SITUATION_UPDATE", UpdateThreat)
					frame:RegisterEvent("UNIT_THREAT_LIST_UPDATE", UpdateThreat)
				end

				local Buffs = CreateAura(frame, LolzenUIcfg.nameplates["np_aura_maxnum"])
				frame.Buffs = Buffs
				
				local Debuffs = CreateAura(frame, LolzenUIcfg.nameplates["np_aura_maxnum"])
				frame.Debuffs = Debuffs
				
				local Auras = CreateAura(frame, LolzenUIcfg.nameplates["np_aura_maxnum"])
				frame.Auras = Auras
				
				if LolzenUIcfg.nameplates["np_aura_show_type"] == "Buffs" then
					frame.Buffs:SetPoint(LolzenUIcfg.nameplates["np_aura_anchor1"], frame, LolzenUIcfg.nameplates["np_aura_anchor2"], LolzenUIcfg.nameplates["np_aura_posx"], LolzenUIcfg.nameplates["np_aura_posy"])
					if LolzenUIcfg.nameplates["np_aura_show_only_player"] == true then
						frame.Buffs.onlyShowPlayer = true
					end
					--frame.Buffs.showBuffType = true
					frame.Buffs["growth-x"] = LolzenUIcfg.nameplates["np_aura_growth_x"]
					frame.Buffs["growth-y"] = LolzenUIcfg.nameplates["np_aura_growth_y"]
				elseif LolzenUIcfg.nameplates["np_aura_show_type"] == "Debuffs" then
					frame.Debuffs:SetPoint(LolzenUIcfg.nameplates["np_aura_anchor1"], frame, LolzenUIcfg.nameplates["np_aura_anchor2"], LolzenUIcfg.nameplates["np_aura_posx"], LolzenUIcfg.nameplates["np_aura_posy"])
					if LolzenUIcfg.nameplates["np_aura_show_only_player"] == true then
						frame.Debuffs.onlyShowPlayer = true
					end
					--frame.Debuffs.showDebuffType = true
					frame.Debuffs["growth-x"] = LolzenUIcfg.nameplates["np_aura_growth_x"]
					frame.Debuffs["growth-y"] = LolzenUIcfg.nameplates["np_aura_growth_y"]
				elseif LolzenUIcfg.nameplates["np_aura_show_type"] == "Both" then
					frame.Auras:SetPoint(LolzenUIcfg.nameplates["np_aura_anchor1"], frame, LolzenUIcfg.nameplates["np_aura_anchor2"], LolzenUIcfg.nameplates["np_aura_posx"], LolzenUIcfg.nameplates["np_aura_posy"])
					if LolzenUIcfg.nameplates["np_aura_show_only_player"] == true then
						frame.Auras.onlyShowPlayer = true
					end
					--frame.Auras.showBuffType = true
					--frame.Auras.showDebuffType = true
					frame.Auras["growth-x"] = LolzenUIcfg.nameplates["np_aura_growth_x"]
					frame.Auras["growth-y"] = LolzenUIcfg.nameplates["np_aura_growth_y"]
				end

				-- set size and points
				frame:SetSize(LolzenUIcfg.nameplates["np_width"], LolzenUIcfg.nameplates["np_height"])
				frame:SetPoint("CENTER", 0, 0)

				Castbar.PostChannelStart = PostCastStart
				Castbar.PostCastStart = PostCastStart
				Buffs.PostUpdateIcon = PostUpdateIcon
				Debuffs.PostUpdateIcon = PostUpdateIcon
				Auras.PostUpdateIcon = PostUpdateIcon
			end
		end)
		oUF:SetActiveStyle("Lolzen - Nameplates")
		oUF:SpawnNamePlates(nil, UpdateTargetIndicator, cvars)
	end
end)