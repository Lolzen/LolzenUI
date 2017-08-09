--// buffs // --

local addon, ns = ...

local f = CreateFrame("Frame")
f:RegisterEvent("ADDON_LOADED")
f:SetScript("OnEvent", function(self, event, addon)
	if addon == "LolzenUI" then
		if LolzenUIcfg.modules["buffs"] == false then return end

		-- Change the position
		BuffFrame:ClearAllPoints()
		BuffFrame:SetPoint(LolzenUIcfg.buffs["buff_anchor1"], LolzenUIcfg.buffs["buff_parent"], LolzenUIcfg.buffs["buff_anchor2"], LolzenUIcfg.buffs["buff_posx"], LolzenUIcfg.buffs["buff_posy"])
		BuffFrame.SetPoint = function() end
		
		local function StyleBuffs(buttonName, index)
			local button = _G[buttonName..index]
			if button and not button.modded then

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
					border:SetTexture("Interface\\AddOns\\LolzenUI\\media\\"..LolzenUIcfg.buffs["buff_debuff_texture"])
					border:SetAllPoints(button)
					border:SetTexCoord(0, 1, 0, 1)
				else
					-- Auraborder
					if not button.border then
						button.border = button:CreateTexture(nil, "BORDER")
						button.border:SetTexture("Interface\\AddOns\\LolzenUI\\media\\"..LolzenUIcfg.buffs["buff_aura_texture"])
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
				button.duration:SetFont("Interface\\AddOns\\LolzenUI\\fonts\\"..LolzenUIcfg.buffs["buff_duration_font"], LolzenUIcfg.buffs["buff_duration_font_size"], LolzenUIcfg.buffs["buff_duration_font_flag"])
				button.duration:SetDrawLayer("OVERLAY")

				-- Reposition buffcounters
				button.count:ClearAllPoints()
				button.count:SetPoint(LolzenUIcfg.buffs["buff_counter_anchor"], button, LolzenUIcfg.buffs["buff_counter_posx"], LolzenUIcfg.buffs["buff_counter_posy"])
				button.count:SetFont("Interface\\AddOns\\LolzenUI\\fonts\\"..LolzenUIcfg.buffs["buff_counter_font"], LolzenUIcfg.buffs["buff_counter_size"], LolzenUIcfg.buffs["buff_counter_font_flag"])
				button.count:SetDrawLayer("OVERLAY")
				
				button.modded = true
			end
		end

		local function UpdateAura()
			for i = 1, BUFF_ACTUAL_DISPLAY do
				StyleBuffs("BuffButton", i)
			--		if i == 1 then
			--			_G["BuffButton"..i]:SetPoint(LolzenUIcfg.buffs["buff_anchor1"], LolzenUIcfg.buffs["buff_parent"], LolzenUIcfg.buffs["buff_anchor2"], LolzenUIcfg.buffs["buff_posx"], LolzenUIcfg.buffs["buff_posy"])
				--	else
				--		_G["BuffButton"..i]:SetPoint("RIGHT", _G["BuffButton"..i-1], "LEFT", LolzenUIcfg.buffs["buff_spacing_horizontal"], 0)
				--	end
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
			-- Change the timer
			SecondsToTimeAbbrev = function(time)
				local hr, m, s, text
				if time <= 0 then 
					text = ""
				elseif(time < 3600 and time > 40) then
					m = floor(time / 60)
					s = mod(time, 60)
					text = (m == 0 and format("|cffffffff%d", s)) or format("|cffffffff%d:%02d", m, s)
				elseif time < 60 then
					m = floor(time / 60)
					s = mod(time, 60)
					text = (m == 0 and format("|cffffffff%d", s))
				else
					hr = floor(time / 3600)
					m = floor(mod(time, 3600) / 60)
					text = format("%d:%2d", hr, m)
				end
				return text
			end
		end
	end
end)