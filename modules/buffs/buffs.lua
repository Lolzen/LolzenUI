--// buffs // --

local addon, ns = ...

local f = CreateFrame("Frame")
f:RegisterEvent("ADDON_LOADED")
f:SetScript("OnEvent", function(self, event, addon)
	if addon == "LolzenUI" then
		if LolzenUIcfg["buffs"] == false then return end

		-- Change the position
		BuffFrame:ClearAllPoints()
		BuffFrame:SetPoint("TOPRIGHT", Minimap, "TOPLEFT", -15, 2)

		local function StyleBuffs(buttonName, index)
			local button = _G[buttonName..index]

			-- Debuffborder
			local border = _G[buttonName..index.."Border"]
			if border and not border.modded == true then
				border:SetParent(button)
				border:SetTexture("Interface\\AddOns\\LolzenUI\\media\\debuffborder")
				border:SetPoint("TOPRIGHT", button, 0, 0)
				border:SetPoint("BOTTOMLEFT", button, 0, 0)
				border:SetTexCoord(0, 1, 0, 1)
				border.modded = true
			end

			-- Auraborder
			local skin = _G[buttonName..index.."Skin"]
			if button and not skin and not border and not button.modded == true then
				local overlay = CreateFrame("Frame", buttonName..index.."Skin", button)
				overlay:SetAllPoints(button)
				overlay:SetParent(button)

				local texture = overlay:CreateTexture(nil, "BORDER")
				texture:SetParent(button)
				texture:SetTexture("Interface\\AddOns\\LolzenUI\\media\\auraborder")
				texture:SetPoint("TOPRIGHT", overlay, 0, 0)
				texture:SetPoint("BOTTOMLEFT", overlay, 0, 0)
				texture:SetVertexColor(0, 0, 0)
				button.modded = true
			end
	
			--Change the look of the Icon slightly
			local icon = _G[buttonName..index.."Icon"]
			if icon and not icon.modded == true then
				icon:SetTexCoord(0.1, 0.9, 0.1, 0.9)
				icon:SetPoint("TOPLEFT", button ,"TOPLEFT", 2, -2)
				icon:SetPoint("BOTTOMRIGHT", button ,"BOTTOMRIGHT", -2, 2)
				icon.modded = true
			end

			-- Reposition BuffTimeduration
			local duration = _G[buttonName..index.."Duration"]
			if duration and not duration.modded == true then
				duration:ClearAllPoints()
				duration:SetPoint("CENTER", button, "BOTTOM", 0, 3)
				duration:SetFont("Fonts\\ARIALN.ttf", 12, "OUTLINE")
				duration:SetDrawLayer("OVERLAY")
				duration.modded = true
			end

			-- Reposition buffcounters
			local count = _G[buttonName..index.."Count"]
			if count and not count.modded == true then
				count:ClearAllPoints()
				count:SetPoint("TOPRIGHT", button)
				count:SetFont("Fonts\\ARIALN.ttf", 17, "OUTLINE")
				count:SetDrawLayer("OVERLAY")
				count.modded = true
			end
		end

		local function UpdateBuff()
			for i = 1, BUFF_ACTUAL_DISPLAY do
				StyleBuffs("BuffButton", i, false)
			end
			for i = 1, 3 do
				StyleBuffs("TempEnchant", i, false)
			end
		end

		local function UpdateDebuff(buttonName, index)
			StyleBuffs(buttonName, index, true)
		end

		hooksecurefunc("BuffFrame_UpdateAllBuffAnchors", UpdateBuff)
		hooksecurefunc("DebuffButton_UpdateAnchors", UpdateDebuff)

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
				text = (m == 0 and format("|cffffff00%d", s))
			else
				hr = floor(time / 3600)
				m = floor(mod(time, 3600) / 60)
				text = format("%d:%2d", hr, m)
			end
			return text
		end
	end
end)