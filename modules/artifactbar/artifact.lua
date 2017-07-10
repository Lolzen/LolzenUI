--// artifactbar // --

local addon, ns = ...

local f = CreateFrame("Frame")
f:RegisterEvent("ADDON_LOADED")
f:SetScript("OnEvent", function(self, event, addon)
	if addon == "LolzenUI" then
		if LolzenUIcfg["artifactbar"] == false then return end

		-- first let us create our bar
		local afbar = CreateFrame("StatusBar", "bar4artifactpower", UIParent)
		afbar:SetPoint("BOTTOM", UIParent, 0, 120)
		afbar:SetHeight(4)
		afbar:SetWidth(378)
		afbar:SetStatusBarTexture("Interface\\AddOns\\LolzenUI\\media\\statusbar")
		afbar:SetAlpha(0.4)
		afbar:SetStatusBarColor(1, 1, 0.7)

		--Background for our bar
		local bg = afbar:CreateTexture(nil, "BACKGROUND")
		bg:SetAllPoints(afbar)
		bg:SetTexture("Interface\\AddOns\\LolzenUI\\media\\statusbar")
		bg:SetVertexColor(0, 0, 0, 0.5)

		local line = afbar:CreateTexture(nil, "OVERLAY")
		line:SetPoint("TOPLEFT", afbar, 0, 1)
		line:SetPoint("TOPRIGHT", afbar, 0, 1)
		line:SetHeight(1)
		line:SetTexture(0, 0, 0, 1)

		local line2 = afbar:CreateTexture(nil, "OVERLAY")
		line2:SetPoint("BOTTOMLEFT", afbar, 0, -1)
		line2:SetPoint("BOTTOMRIGHT", afbar, 0, -1)
		line2:SetHeight(1)
		line2:SetTexture(0, 0, 0, 1)

		-- fontstring
		local xptext = afbar:CreateFontString(nil, "OVERLAY")
		xptext:SetPoint("BOTTOM", afbar, "TOP", 0, -2)
		xptext:SetParent(UIParent)
		xptext:SetFont("Interface\\AddOns\\LolzenUI\\fonts\\DroidSansBold.ttf", 10, "THINOUTLINE")
		xptext:SetTextColor(1,1,1)

		-- get artifact power data
		function afbar:ARTIFACT_XP_UPDATE()
			local hasArtifact = HasArtifactEquipped("player")
			if hasArtifact then
				local _, _, _, _, totalXP, pointsSpent, _, _, _, _, _, _, artifactTier = C_ArtifactUI.GetEquippedArtifactInfo()
				local numPoints, artifactXP, xpForNextPoint = MainMenuBar_GetNumArtifactTraitsPurchasableFromXP(pointsSpent, totalXP, artifactTier)
				afbar:SetMinMaxValues(0, xpForNextPoint)
				afbar:SetValue(artifactXP)
				afbar:SetAlpha(0.4)
				-- use tostring to prevent integer overflow
				xptext:SetFormattedText("%s / %s (%.0f%%)", tostring(artifactXP), tostring(xpForNextPoint), tostring(artifactXP/xpForNextPoint*100) )
			else
				afbar:SetAlpha(0)
			end
		end
		afbar.PLAYER_ENTERING_WORLD = afbar.ARTIFACT_XP_UPDATE
		afbar.UNIT_INVENTORY_CHANGED = afbar.ARTIFACT_XP_UPDATE

		afbar:RegisterEvent("ARTIFACT_XP_UPDATE")
		afbar:RegisterEvent("UNIT_INVENTORY_CHANGED")
		afbar:RegisterEvent("PLAYER_ENTERING_WORLD")
		afbar:SetScript("OnEvent", function(self, event, ...) self[event](self, event, ...) end)
	end
end)
