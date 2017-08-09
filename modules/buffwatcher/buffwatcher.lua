--// buffwatcher // --

local addon, ns = ...

local f = CreateFrame("Frame")
f:RegisterEvent("ADDON_LOADED")
f:SetScript("OnEvent", function(self, event, addon)
	if addon == "LolzenUI" then
		if LolzenUIcfg.modules["buffwatcher"] == false then return end

		local anchor = CreateFrame("Frame", "AnchorFrame", UIParent)
		anchor:SetSize(((#LolzenUIcfg.buffwatcher["buffwatchlist"] * LolzenUIcfg.buffwatcher["buffwatch_icon_size"]) + (#LolzenUIcfg.buffwatcher["buffwatchlist"] * LolzenUIcfg.buffwatcher["buffwatch_icon_spacing"])) - LolzenUIcfg.buffwatcher["buffwatch_icon_spacing"], 1)
		anchor:SetPoint("CENTER", UIParent, "CENTER", LolzenUIcfg.buffwatcher["buffwatch_pos_x"], LolzenUIcfg.buffwatcher["buffwatch_pos_y"])

		local icon = {}
		for i=1, #LolzenUIcfg.buffwatcher["buffwatchlist"] do
			-- icons
			if not icon[i] then
				icon[i] = anchor:CreateTexture(nil, "OVERLAY")
				icon[i]:SetTexCoord(.04, .94, .04, .94)
				icon[i]:SetTexture(GetSpellTexture(LolzenUIcfg.buffwatcher["buffwatchlist"][i]))
				icon[i]:SetSize(LolzenUIcfg.buffwatcher["buffwatch_icon_size"], LolzenUIcfg.buffwatcher["buffwatch_icon_size"])
			end
			if i == 1 then
				icon[i]:SetPoint("LEFT", anchor, "LEFT")
			else
				icon[i]:SetPoint("LEFT", icon[i-1], "RIGHT", LolzenUIcfg.buffwatcher["buffwatch_icon_spacing"], 0)
			end
			-- border
			if not icon[i].border then
				icon[i].border = CreateFrame("Frame")
				icon[i].border:SetBackdrop({
					edgeFile = "Interface\\AddOns\\LolzenUI\\media\\darkborder", edgeSize = 12,
					insets = {left = 4, right = 4, top = 4, bottom = 4},
				})
				icon[i].border:SetPoint("TOPLEFT", icon[i], -2, 3)
				icon[i].border:SetPoint("BOTTOMRIGHT", icon[i], 3, -2)
				icon[i].border:SetBackdropBorderColor(0, 0, 0)
				icon[i].border:SetFrameLevel(3)
			end
			-- timer
			if not icon[i].timer then
				icon[i].timer = icon[i].border:CreateFontString(nil, "OVERLAY")
				icon[i].timer:SetPoint("TOP", icon[i], "BOTTOM", 0, 7)
				icon[i].timer:SetFont("Interface\\AddOns\\LolzenUI\\fonts\\DroidSansBold.ttf", 12 ,"OUTLINE")
				icon[i].timer:SetTextColor(1, 1, 1)
			end
			-- counter
			if not icon[i].count then
			icon[i].count = icon[i].border:CreateFontString(nil, "OVERLAY")
			icon[i].count:SetPoint("CENTER", icon[i], "CENTER")
			icon[i].count:SetFont("Interface\\AddOns\\LolzenUI\\fonts\\DroidSansBold.ttf", 18 ,"OUTLINE")
			icon[i].count:SetTextColor(1, 1, 1)
			end
			-- identifier
			if not icon[i].name then
				icon[i].name = GetSpellInfo(LolzenUIcfg.buffwatcher["buffwatchlist"][i])
			end
		end

		local last = 0
		anchor:SetScript("OnUpdate", function(self, elapsed)
			last = last + elapsed
			if last > 0.1 then
				for i=1, #LolzenUIcfg.buffwatcher["buffwatchlist"] do
					local name, _, _, count, _, _, expirationTime = UnitBuff("player", icon[i].name)
					if name then
						if icon[i]:GetAlpha() ~= 1 then
							icon[i]:SetAlpha(1)
							icon[i].border:SetAlpha(1)
						end
						if expirationTime and expirationTime - GetTime() > 4 then
							icon[i].timer:SetFormattedText("%.1f", expirationTime - GetTime())
						elseif expirationTime and expirationTime - GetTime() > 0 then
							icon[i].timer:SetFormattedText("|cffff0000 %.1f |r", expirationTime - GetTime())
						end
						if count and count > 0 then
							icon[i].count:SetText(count)
						end
					else
						if icon[i]:GetAlpha() ~= 0 then
							icon[i]:SetAlpha(0)
							icon[i].border:SetAlpha(0)
							icon[i].timer:SetText(nil)
							icon[i].count:SetText(nil)
						end
					end
				end
				last = 0
			end
		end)
	end
end)