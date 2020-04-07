--// buffs // --

local _, ns = ...
local L = ns.L
local LSM = LibStub("LibSharedMedia-3.0")
local LBT = LibStub("LibButtonTexture-1.0")

ns.RegisterModule("buffs", L["desc_buffs"], true)

local f = CreateFrame("Frame")
f:RegisterEvent("ADDON_LOADED")
f:SetScript("OnEvent", function(self, event, addon)
	if addon == "LolzenUI" then
		if LolzenUIcfg.modules["buffs"] == false then return end

		local GetFormattedTime = function(seconds)
			-- Change the timer
			-- original code from tekkub https://github.com/TekNoLogic/tekBuffTimers
			if seconds <= 0 then
				return "" 
			end

			local days = seconds / 12960000
			if days >= 1 then
				return string.format("|cffffffff%.1fd|r", days)
			end

			local hours = seconds / 3600
			if hours >= 1 then
				return string.format("|cffffffff%.02fh|r", hours)
			end

			local minutes = seconds / 60
			local seconds = seconds % 60
			if minutes >= 1 then return string.format("|cffffffff%d:%02d|r", minutes, seconds) end
			return string.format("|cffffffff%ds|r", seconds)
		end

		-- Change the position
		local function BuffFramePosition()
			BuffFrame:ClearAllPoints()
			BuffFrame:SetPoint(LolzenUIcfg.buffs["buff_anchor1"], LolzenUIcfg.buffs["buff_parent"], LolzenUIcfg.buffs["buff_anchor2"], LolzenUIcfg.buffs["buff_posx"], LolzenUIcfg.buffs["buff_posy"])
		end  
		hooksecurefunc("UIParent_UpdateTopFramePositions", BuffFramePosition)

		local function StyleBuffs(buttonName, index)
			local button = _G[buttonName..index]
			if not button or button.modded then return end

			-- Size
			if buttonName == "BuffButton" then
				button:SetSize(LolzenUIcfg.buffs["buff_size"], LolzenUIcfg.buffs["buff_size"])
			elseif buttonName == "DebuffButton" then
				button:SetSize(LolzenUIcfg.buffs["buff_debuff_size"], LolzenUIcfg.buffs["buff_debuff_size"])
			elseif buttonName == "TempEnchant" then
				button:SetSize(LolzenUIcfg.buffs["buff_tempenchant_size"], LolzenUIcfg.buffs["buff_tempenchant_size"])
			end

			-- Border
			local border = _G[buttonName..index.."Border"]
			if border then
				-- Debuffborder
				border:SetParent(button)
				border:SetTexture(LBT:Fetch("debuff", LolzenUIcfg.buffs["buff_debuff_texture"]))
				border:SetAllPoints(button)
				border:SetTexCoord(0, 1, 0, 1)
			else
				-- Auraborder
				if not button.border then
					button.border = button:CreateTexture(nil, "BORDER")
					button.border:SetTexture(LBT:Fetch("buff", LolzenUIcfg.buffs["buff_aura_texture"]))
					button.border:SetAllPoints(button)
					button.border:SetVertexColor(0, 0, 0)
				end
			end

			-- Change the look of the Icon slightly
			local icon = _G[buttonName..index.."Icon"]
			if icon then
				icon:SetTexCoord(0.1, 0.9, 0.1, 0.9)
				icon:SetPoint("TOPLEFT", button ,"TOPLEFT", 2, -2)
				icon:SetPoint("BOTTOMRIGHT", button ,"BOTTOMRIGHT", -2, 2)
			end

			-- Reposition BuffTimeduration
			button.duration:ClearAllPoints()
			button.duration:SetPoint(LolzenUIcfg.buffs["buff_duration_anchor1"], button, LolzenUIcfg.buffs["buff_duration_anchor2"], LolzenUIcfg.buffs["buff_duration_posx"], LolzenUIcfg.buffs["buff_duration_posy"])
			button.duration:SetFont(LSM:Fetch("font", LolzenUIcfg.buffs["buff_duration_font"]), LolzenUIcfg.buffs["buff_duration_font_size"], LolzenUIcfg.buffs["buff_duration_font_flag"])
			button.duration:SetDrawLayer("OVERLAY")

			-- Create a timer for the buff duration, as the AuraButton_UpdateDuration() function is overwritten further below
			-- this proved to be a more efficient way of updating the buff duration, due to not using onUpdate
			if LolzenUIcfg.buffs["buff_duration_detailed"] == true then
				if not button.timer then
					button.timer = button:CreateAnimationGroup()
					button.timerAnim = button.timer:CreateAnimation()
					button.timerAnim:SetDuration(0.1)

					button.timer:SetScript("OnFinished", function(self, requested)
						if not requested then
							if button.timeLeft then
								button.duration:SetFormattedText(GetFormattedTime(button.timeLeft))
							else
								self:Stop()
							end
							self:Play()
						end
					end)
					button.timer:Play()
				end
			end

			-- Reposition buffcounters
			button.count:ClearAllPoints()
			button.count:SetPoint(LolzenUIcfg.buffs["buff_counter_anchor"], button, LolzenUIcfg.buffs["buff_counter_posx"], LolzenUIcfg.buffs["buff_counter_posy"])
			button.count:SetFont(LSM:Fetch("font", LolzenUIcfg.buffs["buff_counter_font"]), LolzenUIcfg.buffs["buff_counter_size"], LolzenUIcfg.buffs["buff_counter_font_flag"])
			button.count:SetDrawLayer("OVERLAY")

			button.modded = true
		end

		local function UpdateAura()
			for i = 1, BUFF_ACTUAL_DISPLAY do
				StyleBuffs("BuffButton", i)
			end
			for i = 1, DEBUFF_MAX_DISPLAY do
				StyleBuffs("DebuffButton", i)
			end
			for i = 1, NUM_TEMP_ENCHANT_FRAMES do
				StyleBuffs("TempEnchant", i)
			end
		end

		hooksecurefunc("BuffFrame_UpdateAllBuffAnchors", UpdateAura)
		hooksecurefunc("DebuffButton_UpdateAnchors", UpdateAura)
		if LolzenUIcfg.buffs["buff_duration_detailed"] == true then
			-- disable blizz update duration function
			AuraButton_UpdateDuration = function() end
		end
	end
end)