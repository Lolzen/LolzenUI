-- One time tutorial

local _, ns = ...
local L = ns.L

-- arrow texture, arrow point and help box layout for the steps which point at something
local ARROW = "Interface\\AddOns\\LolzenUI\\media\\arrow-"
local helpers = {
	[2] = {dir = "up", point = {"TOPLEFT", UIParent, "TOPLEFT", 15, -30}, box = {"TOPLEFT", "BOTTOM", -30, 0}, size = {200, 50}},
	[3] = {dir = "left", point = {"TOPLEFT", UIParent, "TOPLEFT", 230, 2}, box = {"TOPLEFT", "BOTTOM", -30, 0}, size = {265, 50}},
	[4] = {dir = "up", point = function() return "TOPLEFT", UIParent, "TOPLEFT", GetScreenWidth() / 2, -30 end, box = {"TOPLEFT", "BOTTOM", 0, 0}, size = {110, 50}},
	[5] = {dir = "right", point = {"TOPRIGHT", UIParent, "TOPRIGHT", -100, 2}, box = {"TOPLEFT", "BOTTOM", -140, 0}, size = {250, 50}},
	[6] = {dir = "right", point = {"TOPRIGHT", UIParent, "TOPRIGHT", -150, -150}, box = {"TOPLEFT", "BOTTOM", -140, 0}, size = {300, 50}},
	[7] = {dir = "right", point = {"BOTTOM", UIParent, "BOTTOM", -220, 107}, box = {"TOPLEFT", "BOTTOM", -140, 0}, size = {290, 50}},
	[8] = {dir = "right", point = {"BOTTOM", UIParent, "BOTTOM", -220, -5}, box = {"TOPLEFT", "TOP", -140, 50}, size = {290, 50}},
}

local NUM_STEPS = 11
local tutorialFrame, helpFrame
local step = 1

local function createBackdropFrame(parent)
	local frame = CreateFrame("Frame", nil, parent, "BackdropTemplate")
	frame:SetBackdrop({
		bgFile = "Interface\\FrameGeneral\\UI-Background-Rock",
		edgeFile = "Interface\\DialogFrame\\UI-DialogBox-Border",
		insets = {left = 4, right = 4, top = 4, bottom = 4},
	})
	return frame
end

local function createHelpFrame()
	helpFrame = CreateFrame("Frame", nil, UIParent)
	helpFrame:SetFrameStrata("TOOLTIP")
	helpFrame:SetSize(30, 30)
	helpFrame.arrow = helpFrame:CreateTexture(nil, "BACKGROUND")
	helpFrame.arrow:SetAllPoints()
	helpFrame.box = createBackdropFrame(helpFrame)
	helpFrame.text = helpFrame.box:CreateFontString(nil, "OVERLAY", "GameTooltipText")
	helpFrame.text:SetPoint("TOP", helpFrame.box, "TOP", 0, -18)
end

local function finish()
	LolzenUIcfg["hasSeenTutorial"] = true
	tutorialFrame:Hide()
	if helpFrame then
		helpFrame:Hide()
	end
end

local function setStep(num)
	step = num
	if num > NUM_STEPS then
		return finish()
	end

	tutorialFrame.steps:SetText(("%d/%d"):format(num, NUM_STEPS))
	tutorialFrame.text:SetText(L["step"..num])
	tutorialFrame.prev:SetEnabled(num > 1)
	tutorialFrame.next:SetEnabled(num < NUM_STEPS)

	local helper = helpers[num]
	if helper then
		if not helpFrame then
			createHelpFrame()
		end
		helpFrame:ClearAllPoints()
		if type(helper.point) == "function" then
			helpFrame:SetPoint(helper.point())
		else
			helpFrame:SetPoint(unpack(helper.point))
		end
		helpFrame.arrow:SetTexture(ARROW..helper.dir)
		helpFrame.box:ClearAllPoints()
		helpFrame.box:SetPoint(helper.box[1], helpFrame, helper.box[2], helper.box[3], helper.box[4])
		helpFrame.box:SetSize(helper.size[1], helper.size[2])
		helpFrame.text:SetText(L["step"..num.."_help"])
		helpFrame:Show()
	elseif helpFrame then
		helpFrame:Hide()
	end

	if num == NUM_STEPS then
		ns.OpenSettings()
	end
end

local function createButton(text, point, relative, relPoint, x, y, onClick)
	local button = CreateFrame("Button", nil, tutorialFrame, "UIPanelButtonTemplate")
	button:SetSize(120, 23)
	button:SetText(text)
	button:SetPoint(point, relative, relPoint, x, y)
	button:SetScript("OnClick", onClick)
	return button
end

function ns.ShowTutorial()
	if not tutorialFrame then
		tutorialFrame = createBackdropFrame(UIParent)
		tutorialFrame:SetSize(700, 200)
		tutorialFrame:SetPoint("CENTER")
		tutorialFrame:SetFrameStrata("DIALOG")

		tutorialFrame.text = tutorialFrame:CreateFontString(nil, "OVERLAY", "GameTooltipText")
		tutorialFrame.text:SetPoint("CENTER")

		local header = tutorialFrame:CreateFontString(nil, "OVERLAY", "GameTooltipText")
		header:SetPoint("TOPLEFT", 20, -20)
		header:SetText("LolzenUI: Tutorial")

		tutorialFrame.steps = tutorialFrame:CreateFontString(nil, "OVERLAY", "GameTooltipText")
		tutorialFrame.steps:SetPoint("TOPRIGHT", -20, -20)

		tutorialFrame.next = createButton(L["next_button_text"], "BOTTOMLEFT", tutorialFrame, "BOTTOMLEFT", 18, 13, function()
			setStep(step + 1)
		end)
		tutorialFrame.prev = createButton(L["previous_button_text"], "LEFT", tutorialFrame.next, "RIGHT", 15, 0, function()
			setStep(math.max(1, step - 1))
		end)
		createButton(L["skip_button_text"], "BOTTOMRIGHT", tutorialFrame, "BOTTOMRIGHT", -18, 13, finish)
	end
	tutorialFrame:Show()
	setStep(1)
end

ns.OnLogin(nil, function()
	if not LolzenUIcfg["hasSeenTutorial"] then
		ns.ShowTutorial()
	end
end)
