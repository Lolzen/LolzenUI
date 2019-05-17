-- One time tutorial

local addon, ns = ...
local L = ns.L

local stepdesc = {
	[1] = L["step1"],
	[2] = L["step2"],
	[3] = L["step3"],
	[4] = L["step4"],
	[5] = L["step5"],
	[6] = L["step6"],
	[7] = L["step7"],
	[8] = L["step8"],
	[9] = L["step9"],
	[10] = L["step10"],
	[11] = L["step11"],
}

local steps = 1

-- helper widgets
local helpframe, tex
helpframe = CreateFrame("Frame", nil, UIParent)
helpframe:SetFrameStrata("TOOLTIP")
tex = helpframe:CreateTexture(nil, "BACKGROUND")
helpframe.box = CreateFrame("Frame", nil, helpframe)
helpframe.box:SetBackdrop({
	bgFile = "Interface\\FrameGeneral\\UI-Background-Rock",
	edgeFile = "Interface\\DialogFrame\\UI-DialogBox-Border",
	insets = { left = 4, right = 4, top = 4, bottom = 4 }
})
helpframe.text = helpframe.box:CreateFontString(nil, "OVERLAY", "GameTooltipText")
helpframe.text:SetPoint("TOP", helpframe.box, "TOP", 0, -18)

local function setTutoalStep(tf, text, steptext, num)
	steptext:SetText("Step "..num.."/"..#stepdesc)
	-- disable "prevButton" if there is no previous step
	if num == 1 then
		tf.pbutton:Disable()
	else
		tf.pbutton:Enable()
	end
	-- disable "nextButton" if there is no next step
	if num == #stepdesc then
		tf.nbutton:Disable()
	else
		tf.nbutton:Enable()
	end
	if num == #stepdesc+1 then
		tf:Hide()
		LolzenUIcfg["hasSeenTutorial"] = true
	else
		text:SetText(stepdesc[num])
		if num == 2 then
			helpframe:Show()
			helpframe:ClearAllPoints()
			helpframe:SetPoint("TOPLEFT", UIParent, "TOPLEFT", 15, -30)
			helpframe:SetSize(30, 30)
			tex:SetTexture("Interface\\AddOns\\LolzenUI\\media\\arrow-up")
			tex:SetAllPoints(helpframe)
			helpframe.box:SetPoint("TOPLEFT", helpframe, "BOTTOM", -30, 0)
			helpframe.box:SetSize(200, 50)
			helpframe.text:SetText(L["step2_help"])
		elseif num == 3 then
			helpframe:Show()
			helpframe:ClearAllPoints()
			helpframe:SetPoint("TOPLEFT", UIParent, "TOPLEFT", 230, 2)
			helpframe:SetSize(30, 30)
			tex:SetTexture("Interface\\AddOns\\LolzenUI\\media\\arrow-left")
			tex:SetAllPoints(helpframe)
			helpframe.box:SetPoint("TOPLEFT", helpframe, "BOTTOM", -30, 0)
			helpframe.box:SetSize(265, 50)
			helpframe.text:SetText(L["step3_help"])
		elseif num == 4 then
			helpframe:Show()
			helpframe:ClearAllPoints()
			helpframe:SetPoint("TOPLEFT", UIParent, "TOPLEFT", GetScreenWidth()/2, -30)
			helpframe:SetSize(30, 30)
			tex:SetTexture("Interface\\AddOns\\LolzenUI\\media\\arrow-up")
			tex:SetAllPoints(helpframe)
			helpframe.box:SetPoint("TOPLEFT", helpframe, "BOTTOM", 0, 0)
			helpframe.box:SetSize(110, 50)
			helpframe.text:SetText(L["step4_help"])
		elseif num == 5 then
			helpframe:Show()
			helpframe:ClearAllPoints()
			helpframe:SetPoint("TOPRIGHT", UIParent, "TOPRIGHT", -100, 2)
			helpframe:SetSize(30, 30)
			tex:SetTexture("Interface\\AddOns\\LolzenUI\\media\\arrow-right")
			tex:SetAllPoints(helpframe)
			helpframe.box:SetPoint("TOPLEFT", helpframe, "BOTTOM", -140, 0)
			helpframe.box:SetSize(250, 50)
			helpframe.text:SetText(L["step5_help"])
		elseif num == 6 then
			helpframe:Show()
			helpframe:ClearAllPoints()
			helpframe:SetPoint("TOPRIGHT", UIParent, "TOPRIGHT", -150, -150)
			helpframe:SetSize(30, 30)
			tex:SetTexture("Interface\\AddOns\\LolzenUI\\media\\arrow-right")
			tex:SetAllPoints(helpframe)
			helpframe.box:SetPoint("TOPLEFT", helpframe, "BOTTOM", -140, 0)
			helpframe.box:SetSize(300, 50)
			helpframe.text:SetText(L["step6_help"])
		elseif num == 7 then
			helpframe:Show()
			helpframe:ClearAllPoints()
			helpframe:SetPoint("BOTTOM", UIParent, "BOTTOM", -220, 107)
			helpframe:SetSize(30, 30)
			tex:SetTexture("Interface\\AddOns\\LolzenUI\\media\\arrow-right")
			tex:SetAllPoints(helpframe)
			helpframe.box:SetPoint("TOPLEFT", helpframe, "BOTTOM", -140, 0)
			helpframe.box:SetSize(290, 50)
			helpframe.text:SetText(L["step7_help"])
		elseif num == 8 then
			helpframe:Show()
			helpframe:ClearAllPoints()
			helpframe:SetPoint("BOTTOM", UIParent, "BOTTOM", -220, -5)
			helpframe:SetSize(30, 30)
			tex:SetTexture("Interface\\AddOns\\LolzenUI\\media\\arrow-right")
			tex:SetAllPoints(helpframe)
			helpframe.box:SetPoint("TOPLEFT", helpframe, "TOP", -140, 50)
			helpframe.box:SetSize(290, 50)
			helpframe.text:SetText(L["step8_help"])
		elseif num == 11 then
			LoadAddOn("LolzenUI_Options")
			InterfaceOptionsFrame_OpenToCategory("LolzenUI")
			InterfaceOptionsFrame_OpenToCategory("LolzenUI")
			if IsAddOnLoaded("LolzenUI_Options") then
				helpframe:Show()
				helpframe:ClearAllPoints()
				helpframe:SetPoint("BOTTOM", UIParent, "BOTTOM", -450, GetScreenHeight()/2)
				helpframe:SetSize(30, 30)
				tex:SetTexture("Interface\\AddOns\\LolzenUI\\media\\arrow-right")
				tex:SetAllPoints(helpframe)
				helpframe.box:SetPoint("TOPLEFT", helpframe, "BOTTOM", -280, 0)
				helpframe.box:SetSize(290, 50)
				helpframe.text:SetText(L["step11_help"])
			end
		else
			helpframe:Hide()
		end
	end
end

local function showTutorial()
	local tf = CreateFrame("Frame", "LolzenUITutorialFrame", UIParent)
	tf:SetSize(700, 200)
	tf:SetPoint("CENTER")
	tf:SetBackdrop({
		bgFile = "Interface\\FrameGeneral\\UI-Background-Rock",
		edgeFile = "Interface\\DialogFrame\\UI-DialogBox-Border",
		insets = { left = 4, right = 4, top = 4, bottom = 4 }
	})
	
	-- text
	local tftext = tf:CreateFontString(nil, "OVERLAY", "GameTooltipText")
	tftext:SetPoint("CENTER", tf)

	-- header
	local tftex = tf:CreateTexture(nil, "BACKGROUND")
	tftex:SetTexture("Interface\\DialogFrame\\UI-DialogBox-Header")
	tftex:SetPoint("BOTTOM", tf, "TOP", 0, -30)

	local headertext = tf:CreateFontString(nil, "OVERLAY", "GameTooltipText")
	headertext:SetPoint("TOP", tftex, "TOP", 0, -15)
	headertext:SetText("LolzenUI: Tutorial")

	--step counter header
	local steptex = tf:CreateTexture(nil, "BACKGROUND")
	steptex:SetTexture("Interface\\DialogFrame\\UI-DialogBox-Header")
	steptex:SetPoint("BOTTOM", tf, "TOPRIGHT", -80, -30)

	local stepheadertext = tf:CreateFontString(nil, "OVERLAY", "GameTooltipText")
	stepheadertext:SetPoint("TOP", steptex, "TOP", 0, -15)

	-- next button
	tf.nbutton = CreateFrame("Button", "LolzenUI_TutorialNextButton", tf, "UIPanelButtonTemplate")
	tf.nbutton:SetSize(120, 23) -- width, height
	tf.nbutton:SetText(L["next_button_text"])
	tf.nbutton:SetPoint("BOTTOMLEFT", tf, "BOTTOMLEFT", 18, 13)
	tf.nbutton:SetScript("OnClick", function()
		-- increase step counter
		if steps <= #stepdesc then
			steps = steps + 1
		end
		setTutoalStep(tf, tftext, stepheadertext, steps)
	end)
	
	-- previous button
	tf.pbutton = CreateFrame("Button", "LolzenUI_TutorialNextButton", tf, "UIPanelButtonTemplate")
	tf.pbutton:SetSize(120, 23) -- width, height
	tf.pbutton:SetText(L["previous_button_text"])
	tf.pbutton:SetPoint("LEFT", tf.nbutton, "RIGHT", 15, 0)
	tf.pbutton:SetScript("OnClick", function()
		-- decrease step counter
		if steps > 1 then
			steps = steps - 1
		end
		setTutoalStep(tf, tftext, stepheadertext, steps)
	end)
	
	-- skip button
	tf.sbutton = CreateFrame("Button", "LolzenUI_TutorialSkipButton", tf, "UIPanelButtonTemplate")
	tf.sbutton:SetSize(120, 23) -- width, height
	tf.sbutton:SetText(L["skip_button_text"])
	tf.sbutton:SetPoint("BOTTOMRIGHT", tf, "BOTTOMRIGHT", -18, 13)
	tf.sbutton:SetScript("OnClick", function()
		LolzenUIcfg["hasSeenTutorial"] = true
		tf:Hide()
		helpframe:Hide()
	end)
	
	--set first tutorial step
	setTutoalStep(tf, tftext, stepheadertext, steps)
end

local f = CreateFrame("Frame")
f:SetScript("OnEvent", function(self, event, addon)
	if addon == "LolzenUI" then
		if LolzenUIcfg == nil then
			showTutorial()
		else
			if LolzenUIcfg["hasSeenTutorial"] == true then return end
			showTutorial()
		end
	end
end)
f:RegisterEvent("ADDON_LOADED")