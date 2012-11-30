--[[	lolBuff
]]--	by Lolzen

-- Change the position
BuffFrame:ClearAllPoints()
BuffFrame:SetPoint("TOPRIGHT", Minimap, "TOPLEFT", -15, 2)

local _G = getfenv(0)

hooksecurefunc("AuraButton_Update", function(buttonName, index, filter)
	local button = _G[buttonName..index]

	-- Debuffborder
	local border = _G[buttonName..index.."Border"]
	if border then
		border:SetParent(button)
		border:SetTexture("Interface\\AddOns\\LolzenUI\\media\\debuffborder")
		border:SetPoint("TOPRIGHT", button, 0, 0)
		border:SetPoint("BOTTOMLEFT", button, 0, 0)
		border:SetTexCoord(0, 1, 0, 1)
	end
	
	-- Auraborder
	local skin = _G[buttonName..index.."Skin"]
	if button and not skin and not border then
		local overlay = CreateFrame("Frame", buttonName..index.."Skin", button)
		overlay:SetAllPoints(button)
		overlay:SetParent(button)

		local texture = overlay:CreateTexture(nil, "BORDER")
		texture:SetParent(button)
		texture:SetTexture("Interface\\AddOns\\LolzenUI\\media\\auraborder")
		texture:SetPoint("TOPRIGHT", overlay, 0, 0)
		texture:SetPoint("BOTTOMLEFT", overlay, 0, 0)
		texture:SetVertexColor(0, 0, 0)
	end
	
	--Change the look of the Icon slightly
	local icon = _G[buttonName..index.."Icon"]
	if icon then
		icon:SetTexCoord(0.1, 0.9, 0.1, 0.9)
		icon:SetPoint("TOPLEFT", button ,"TOPLEFT", 2, -2)
		icon:SetPoint("BOTTOMRIGHT", button ,"BOTTOMRIGHT", -2, 2)
	end

	-- Reposition BuffTimeduration
	local duration = _G[buttonName..index.."Duration"]
	if duration then
		duration:ClearAllPoints()
		duration:SetPoint("CENTER", button, "BOTTOM", 0, 3)
		duration:SetFont("Fonts\\ARIALN.ttf", 10, "OUTLINE")
		duration:SetDrawLayer("OVERLAY")
	end

	-- Reposition buffcounters
	local count = _G[buttonName..index.."Count"]
	if count then
		count:ClearAllPoints()
		count:SetPoint("TOPRIGHT", button)
		count:SetFont("Fonts\\ARIALN.ttf", 17, "OUTLINE")
		count:SetDrawLayer("OVERLAY")
	end
end)

-- We want to change the look of TempEnchants too
for i = 1, 2 do 
	local button = _G["TempEnchant"..i]

	local icon = _G["TempEnchant"..i.."Icon"]
	icon:SetTexCoord(0.1, 0.9, 0.1, 0.9)
	icon:SetPoint("TOPLEFT", button ,"TOPLEFT", 2, -2)
	icon:SetPoint("BOTTOMRIGHT", button ,"BOTTOMRIGHT", -2, 2)

	local duration = _G["TempEnchant"..i.."Duration"]
	duration:ClearAllPoints()
	duration:SetPoint("CENTER", button, "BOTTOM", 0, 3)
	duration:SetFont("Fonts\\ARIALN.ttf", 10, "OUTLINE")
	duration:SetDrawLayer("OVERLAY")

	local border = _G["TempEnchant"..i.."Border"]
	border:SetTexture("Interface\\AddOns\\LolzenUI\\media\\debuffborder")
	border:ClearAllPoints()
	border:SetPoint("TOPRIGHT", button, 0, 0)
	border:SetPoint("BOTTOMLEFT", button, 0, 0)
	border:SetTexCoord(0, 1, 0, 1)
	border:SetVertexColor(0.9, 0.25, 0.9)
end

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
		text = (m == 0 and format("|cffff0000%d", s))
	else
		hr = floor(time / 3600)
		m = floor(mod(time, 3600) / 60)
		text = format("%d:%2d", hr, m)
	end
	return text
end