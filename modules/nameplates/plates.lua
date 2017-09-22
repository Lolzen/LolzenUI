--// nameplates // --

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
			nameplateSelectedScale = 1.2,
			nameplateSelfScale = 1,
		}

		local PostUpdateThreat = function(Threat, unit)
			local Glow = Threat:GetParent()
			local status = UnitThreatSituation("player", unit)
			if status and status > 0 then
				Glow:Show()
			else
				Glow:Hide()
			end
		end

		local PostCastStart = function(Castbar, unit, spell, spellrank)
			if not unit == "targettarget" then
				Castbar:GetParent().Name:SetText(spell)
			end
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
				health:SetStatusBarTexture("Interface\\AddOns\\LolzenUI\\media\\statusbar")
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
				levelname:SetPoint("CENTER", health, 0, 3) 
				levelname:SetFont("Interface\\AddOns\\LolzenUI\\fonts\\DroidSans.ttf", 6, "THINOUTLINE")
				frame.Level = levelname
				frame:Tag(levelname, '[lolzen:nplevel][shortclassification] [lolzen:npname]')

				local Castbar = CreateFrame("StatusBar", nil, health)
				Castbar:SetStatusBarTexture("Interface\\AddOns\\LolzenUI\\media\\statusbar")
				Castbar:SetPoint("TOP", health, "BOTTOM", 0, 1)
				Castbar:SetSize(100, 1)			
				Castbar:SetStatusBarColor(1, 1, 1, 1)
				frame.Castbar = Castbar

				local Spark = Castbar:CreateTexture(nil, "OVERLAY")
				Spark:SetSize(6, 4)
				Spark:SetBlendMode("ADD")
				Spark:SetParent(Castbar)
				frame.Castbar.Spark = Spark

				local icon = Castbar:CreateTexture(nil, "OVERLAY")
				icon:SetHeight(8)
				icon:SetWidth(8)
				icon:SetTexCoord(.07, .93, .07, .93)
				icon:SetPoint("RIGHT", health, "LEFT", -4, 0)
				frame.Castbar.Icon = icon

				local Time = Castbar:CreateFontString(nil, "OVERLAY")
				Time:SetPoint("LEFT", Castbar, "LEFT", 2, -5)
				Time:SetFont("Interface\\AddOns\\LolzenUI\\fonts\\DroidSansBold.ttf", 6 ,"OUTLINE")
				Time:SetTextColor(1, 1, 1)
				frame.Castbar.Time = Time

				local cbtext = Castbar:CreateFontString(nil, "OVERLAY")
				cbtext:SetPoint("RIGHT", Castbar, "RIGHT", -2, -5)
				cbtext:SetFont("Interface\\AddOns\\LolzenUI\\fonts\\DroidSans.ttf", 6 ,"OUTLINE")
				cbtext:SetTextColor(1, 1, 1)
				frame.Castbar.Text = cbtext

				local Shield = Castbar:CreateTexture(nil, 'OVERLAY')
				Shield:SetSize(20, 20)
				Shield:SetPoint("CENTER", icon, 2, 5)
				frame.Castbar.Shield = Shield

				local RaidTargetIndicator = health:CreateTexture(nil, 'OVERLAY')
				RaidTargetIndicator:SetSize(16, 16)
				RaidTargetIndicator:SetPoint('TOPRIGHT', health, -2, 14)
				frame.RaidTargetIndicator = RaidTargetIndicator

				local Glow = CreateFrame("Frame", nil, frame)
				Glow:SetBackdrop({
					edgeFile ="Interface\\AddOns\\LolzenUI\\media\\glow", edgeSize = 5,
					insets = {left = 4, right = 4, top = 4, bottom = 4}
				})
				Glow:SetPoint("TOPLEFT", health, -5, 5)
				Glow:SetPoint("BOTTOMRIGHT", health, 5, -5)
				Glow:SetBackdropBorderColor(6, 0, 0)
				
				local targetindicator = health:CreateTexture(nil, 'OVERLAY')
				targetindicator:SetPoint("LEFT", health, 20, -3)
				targetindicator:SetTexture("Interface\\AddOns\\LolzenUI\\media\\target-glow")
				targetindicator:SetSize(100*cvars.nameplateSelectedScale, 5*cvars.nameplateSelectedScale)
				targetindicator:SetVertexColor(48/255, 113/255, 191/255)
				
				if UnitIsUnit(unit, "target") then
					targetindicator:SetAlpha(1)
				else
					targetindicator:SetAlpha(0)
				end

				-- workaround so we can actually have an glow border
				local threat = Glow:CreateTexture(nil, "OVERLAY")
				frame.ThreatIndicator = threat

				-- set size and points
				frame:SetSize(100, 4)
				frame:SetPoint("CENTER", 0, 0)

				Castbar.PostChannelStart = PostCastStart
				Castbar.PostCastStart = PostCastStart

				threat.PostUpdate = PostUpdateThreat
			end
		end)
		oUF:SpawnNamePlates(nil, nil, cvars)
	end
end)