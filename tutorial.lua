-- One time tutorial

local stepdesc = {
	[1] = "Welcome to LolzenUI!\nThis is the Tutorial, which will guide you to the most crucial things.",
	[2] = "You may notice the missing Minimap Icon for missions.\nThey can be accessed by clicking the topleft ClassIcon on the OrderHallClassBar (On the very top left)",
	[3] = "Next to the ClassIcon is an area which tracks currencies.\nPress \"C\" -> Currency -> Select a currency of interest -> Tick \"Show on Backpack\"",
	[4] = "In the Topcenter, the Zonename along with Coordinates will be shown",
	[5] = "On the Topright you can see a clock.\nMouseover to see a list of Addons with current memory usage.\nHINT: the most \"hungry\" Addon will ALWAYS be red, no matter how tiny the footprint actually is!",
	[6] = "On the Minimap you do have an indicator of which day it is.\nClick on it to open the CalendarFrame.",
	[7] = "This bar indicates your Artifact Level.\nHover over it to show the text.",
	[8] = "This bar indicates your Experience/Reputation/Honor.\nIt will not prioritize honor in BGs, and reputation if a faction is watched\nTo watch a faction press \"C\" -> Reputation -> Select a faction -> Tick \"Show as Experience Bar\"\nHover over it to show the text.",
	[9] = "Whetever you have DBM or BigWigs installed, /pull is built-in along with a visual timer.",
	[10] = "For a vast amount of options open up the Optionpanel with /lolzen or /lolzenui\n\nClick next to open up the Optionpanel. (Requires LolzenUI_Options)",
	[11] = "Click \"Skip\" to end the tuorial\n\nThis tutorial will not show again."
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
			helpframe.text:SetText("Click the Class Icon")
		elseif num == 3 then
			helpframe:Show()
			helpframe:ClearAllPoints()
			helpframe:SetPoint("TOPLEFT", UIParent, "TOPLEFT", 230, 2)
			helpframe:SetSize(30, 30)
			tex:SetTexture("Interface\\AddOns\\LolzenUI\\media\\arrow-left")
			tex:SetAllPoints(helpframe)
			helpframe.box:SetPoint("TOPLEFT", helpframe, "BOTTOM", -30, 0)
			helpframe.box:SetSize(265, 50)
			helpframe.text:SetText("In this area currencies will be shown")
		elseif num == 4 then
			helpframe:Show()
			helpframe:ClearAllPoints()
			helpframe:SetPoint("TOPLEFT", UIParent, "TOPLEFT", GetScreenWidth()/2, -30)
			helpframe:SetSize(30, 30)
			tex:SetTexture("Interface\\AddOns\\LolzenUI\\media\\arrow-up")
			tex:SetAllPoints(helpframe)
			helpframe.box:SetPoint("TOPLEFT", helpframe, "BOTTOM", 0, 0)
			helpframe.box:SetSize(110, 50)
			helpframe.text:SetText("Zone [X/Y]")
		elseif num == 5 then
			helpframe:Show()
			helpframe:ClearAllPoints()
			helpframe:SetPoint("TOPRIGHT", UIParent, "TOPRIGHT", -100, 2)
			helpframe:SetSize(30, 30)
			tex:SetTexture("Interface\\AddOns\\LolzenUI\\media\\arrow-right")
			tex:SetAllPoints(helpframe)
			helpframe.box:SetPoint("TOPLEFT", helpframe, "BOTTOM", -140, 0)
			helpframe.box:SetSize(250, 50)
			helpframe.text:SetText("Mouseover to see some stats")
		elseif num == 6 then
			helpframe:Show()
			helpframe:ClearAllPoints()
			helpframe:SetPoint("TOPRIGHT", UIParent, "TOPRIGHT", -150, -150)
			helpframe:SetSize(30, 30)
			tex:SetTexture("Interface\\AddOns\\LolzenUI\\media\\arrow-right")
			tex:SetAllPoints(helpframe)
			helpframe.box:SetPoint("TOPLEFT", helpframe, "BOTTOM", -140, 0)
			helpframe.box:SetSize(300, 50)
			helpframe.text:SetText("Click on the number to open the Calendar")
		elseif num == 7 then
			helpframe:Show()
			helpframe:ClearAllPoints()
			helpframe:SetPoint("BOTTOM", UIParent, "BOTTOM", -220, 107)
			helpframe:SetSize(30, 30)
			tex:SetTexture("Interface\\AddOns\\LolzenUI\\media\\arrow-right")
			tex:SetAllPoints(helpframe)
			helpframe.box:SetPoint("TOPLEFT", helpframe, "BOTTOM", -140, 0)
			helpframe.box:SetSize(290, 50)
			helpframe.text:SetText("Mouseover this bar to show the text")
		elseif num == 8 then
			helpframe:Show()
			helpframe:ClearAllPoints()
			helpframe:SetPoint("BOTTOM", UIParent, "BOTTOM", -220, -5)
			helpframe:SetSize(30, 30)
			tex:SetTexture("Interface\\AddOns\\LolzenUI\\media\\arrow-right")
			tex:SetAllPoints(helpframe)
			helpframe.box:SetPoint("TOPLEFT", helpframe, "TOP", -140, 50)
			helpframe.box:SetSize(290, 50)
			helpframe.text:SetText("Mouseover this bar to show the text")
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
				helpframe.text:SetText("LolzenUI is marked - press \"+\"")
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
	tf.nbutton:SetText("Next")
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
	tf.pbutton:SetText("Previous")
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
	tf.sbutton:SetText("Skip")
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