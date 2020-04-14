--// buffwatcher // --

local _, ns = ...
local L = ns.L

ns.RegisterModule("buffwatcher", L["desc_buffwatcher"], true)

local f = CreateFrame("Frame")
f:RegisterEvent("ADDON_LOADED")
f:SetScript("OnEvent", function(self, event, addon)
	if addon == "LolzenUI" then
		if LolzenUIcfg.modules["buffwatcher"] == false then return end

		-- add character to buffwatchlist
		if not LolzenUIcfg.buffwatcher["buffwatchlist"][UnitName("player")] then
			LolzenUIcfg.buffwatcher["buffwatchlist"][UnitName("player")] = {}
			print(UnitName("player").." added to buffwatchlist")
		end

		local anchor = CreateFrame("Frame", "AnchorFrame", UIParent)
		anchor:SetSize(((#LolzenUIcfg.buffwatcher["buffwatchlist"][UnitName("player")] * LolzenUIcfg.buffwatcher["buffwatch_icon_size"]) + (#LolzenUIcfg.buffwatcher["buffwatchlist"][UnitName("player")] * LolzenUIcfg.buffwatcher["buffwatch_icon_spacing"])) - LolzenUIcfg.buffwatcher["buffwatch_icon_spacing"], 1)
		anchor:SetPoint("CENTER", UIParent, "CENTER", LolzenUIcfg.buffwatcher["buffwatch_pos_x"], LolzenUIcfg.buffwatcher["buffwatch_pos_y"])

		local icon = {}
		ns.BuffWatcherUpdate = function ()
			anchor:SetSize(((#LolzenUIcfg.buffwatcher["buffwatchlist"][UnitName("player")] * LolzenUIcfg.buffwatcher["buffwatch_icon_size"]) + (#LolzenUIcfg.buffwatcher["buffwatchlist"][UnitName("player")] * LolzenUIcfg.buffwatcher["buffwatch_icon_spacing"])) - LolzenUIcfg.buffwatcher["buffwatch_icon_spacing"], 1)
			for i=1, #LolzenUIcfg.buffwatcher["buffwatchlist"][UnitName("player")] do
				-- icons
				if not icon[i] then
					icon[i] = anchor:CreateTexture(nil, "OVERLAY")
					icon[i]:SetTexCoord(.04, .94, .04, .94)
					icon[i]:SetTexture(GetSpellTexture(LolzenUIcfg.buffwatcher["buffwatchlist"][UnitName("player")][i]))
					icon[i]:SetSize(LolzenUIcfg.buffwatcher["buffwatch_icon_size"], LolzenUIcfg.buffwatcher["buffwatch_icon_size"])
				else
					icon[i]:SetTexture(GetSpellTexture(LolzenUIcfg.buffwatcher["buffwatchlist"][UnitName("player")][i]))
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

				-- time
				if not icon[i].time then
					icon[i].time = icon[i].border:CreateFontString(nil, "OVERLAY")
					icon[i].time:SetPoint("TOP", icon[i], "BOTTOM", 0, 7)
					icon[i].time:SetFont("Interface\\AddOns\\LolzenUI\\fonts\\DroidSansBold.ttf", 12 ,"OUTLINE")
					icon[i].time:SetTextColor(1, 1, 1)
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
					icon[i].name = GetSpellInfo(LolzenUIcfg.buffwatcher["buffwatchlist"][UnitName("player")][i])
				else
					icon[i].name = GetSpellInfo(LolzenUIcfg.buffwatcher["buffwatchlist"][UnitName("player")][i])
				end

				-- timer
				if not icon[i].timer then
					icon[i].timer = icon[i]:CreateAnimationGroup()
					icon[i].timerAnim = icon[i].timer:CreateAnimation()
					icon[i].timerAnim:SetDuration(0.1)

					-- do the timer stuff when Play() is called
					icon[i].timer:SetScript("OnPlay", function(self)
						local name, _, count, _, _, expirationTime =  AuraUtil.FindAuraByName(icon[i].name, "player")
						if name then
							if icon[i]:GetAlpha() ~= 1 then
								icon[i]:SetAlpha(1)
								icon[i].border:SetAlpha(1)
							end
							if expirationTime and expirationTime - GetTime() > 4 then
								icon[i].time:SetFormattedText("%.1f", expirationTime - GetTime())
							elseif expirationTime and expirationTime - GetTime() > 0 then
								icon[i].time:SetFormattedText("|cffff0000 %.1f |r", expirationTime - GetTime())
							end
							if count and count > 0 then
								icon[i].count:SetText(count)
							end
						end
					end)

					-- hide icons when the Stop() is called
					icon[i].timer:SetScript("OnStop", function(self)
						if icon[i]:GetAlpha() ~= 0 then
							icon[i]:SetAlpha(0)
							icon[i].border:SetAlpha(0)
							icon[i].time:SetText(nil)
							icon[i].count:SetText(nil)
						end
					end)

					--repeat until Stop() is requested
					icon[i].timer:SetScript("OnFinished", function(self, requested)
						if not requested then
							self:Play()
						end
					end)
				end
			end
		end
		ns.BuffWatcherUpdate()

		local function AuraDetect()
			for i=1, #LolzenUIcfg.buffwatcher["buffwatchlist"][UnitName("player")] do
				if not icon[i] then return end
				if AuraUtil.FindAuraByName(icon[i].name, "player") then
					icon[i].timer:Play()
				else
					icon[i].timer:Stop()
				end
			end
		end

		local function AuraOnLoad(self, event, ...)
			AuraDetect()
			-- hide the buttons and their children if they aren't active
			for i=1, #LolzenUIcfg.buffwatcher["buffwatchlist"][UnitName("player")] do
				local name, _, count, _, _, expirationTime =  AuraUtil.FindAuraByName(icon[i].name, "player")
				if not expirationTime then
					if icon[i]:GetAlpha() ~= 0 then
						icon[i]:SetAlpha(0)
						icon[i].border:SetAlpha(0)
						icon[i].time:SetText(nil)
						icon[i].count:SetText(nil)
					end
				end
			end
		end

		local eF = CreateFrame("Frame")
		eF:RegisterEvent("PLAYER_LOGIN")
		eF:RegisterEvent("UNIT_AURA")
		eF:SetScript("OnEvent", AuraOnLoad)

		ns.SetBuffWatcherPosition = function()
			anchor:SetPoint("CENTER", UIParent, "CENTER", LolzenUIcfg.buffwatcher["buffwatch_pos_x"], LolzenUIcfg.buffwatcher["buffwatch_pos_y"])
		end
	end
end)