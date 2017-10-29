--// core //--

local addon, ns = ...

-- Create an empty table which will be filled by modules
ns.modules = {}

ns.RegisterModule = function(module)
	if not ns.modules[module] then
		tinsert(ns.modules, module)
	end
end

--/ Provide functions to easily create options for modules /--

-- title
ns.createTitle = function(module)
	local title = ns[module]:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
	title:SetPoint("TOPLEFT", ns[module], 16, -16)
	title:SetText("|cff5599ff"..string.upper(string.sub(ns[module].name, 1, 1))..string.sub(ns[module].name, 2).." module Options|r")
	return title
end

-- description
ns.createDescription = function(module, text)
	local desc = ns[module]:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
	desc:SetText(text)
	return desc
end

-- header
ns.createHeader = function(module, text)
	local header = ns[module]:CreateFontString(nil, "ARTWORK", "GameFontHighlight")
	header:SetText("|cff5599ff"..text.."|r")
	return header
end

-- generic fontstring
ns.createFonstring = function(module, text)
	local genstr = ns[module]:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
	genstr:SetText(text)
	return genstr
end

-- inputbox
ns.createInputbox = function(module, width, height, num)
	local box = CreateFrame("EditBox", nil, ns[module], "InputBoxTemplate")
	box:SetSize(width, height)
	box:SetAutoFocus(false)
	box:ClearFocus()
	if num ~= nil then
		box:SetNumber(num)
	end
	box:SetCursorPosition(0)
	return box
end

-- checkbox
ns.createCheckBox = function(module, name, text, checkedVar)
	local checkbox = CreateFrame("CheckButton", name, ns[module], "ChatConfigCheckButtonTemplate")
	_G[checkbox:GetName().."Text"]:SetText(text)
	if checkedVar == true then
		checkbox:SetChecked(true)
	else
		checkbox:SetChecked(false)
	end
	return checkbox
end

-- button texture
ns.createButtonTexture = function(module, size, texture)
	local buttonTex = ns[module]:CreateTexture(nil, "TEXTURE")
	buttonTex:SetSize(size, size)
	buttonTex:SetTexture(texture)
	buttonTex:SetTexCoord(.04, .94, .04, .94)
	return buttonTex
end

-- button overlay texture
ns.createButtonOverlay = function(module, parent, texture)
	local buttonOverlay = ns[module]:CreateTexture(nil, "OVERLAY")
	buttonOverlay:SetTexture("Interface\\AddOns\\LolzenUI\\media\\"..texture)
	buttonOverlay:SetPoint("TOPLEFT", parent, "TOPLEFT", -2, 2)
	buttonOverlay:SetPoint("BOTTOMRIGHT", parent, "BOTTOMRIGHT", 2, -2)
	return buttonOverlay
end

-- picker
ns.picker_alpha = {
	1,
	0.9,
	0.8,
	0.7,
	0.6,
	0.5,
	0.4,
	0.3,
	0.2,
	0.1,
}

ns.picker_anchor = {
	"BOTTOM",
	"BOTTOMLEFT",
	"BOTTOMRIGHT",
	"TOP",
	"TOPLEFT",
	"TOPRIGHT",
	"CENTER",
	"LEFT",
	"RIGHT",
}

ns.picker_fonts = {
	"DroidSans.ttf",
	"DroidSansBold.ttf",
	"SEMPRG.ttf"
}

ns.picker_flags = {
	"OUTLINE",
	"THINOUTLINE",
	"MONOCHROME",
	"",
}

ns.createPicker = function(module, pickertype, name, width, selected)
	local t
	if pickertype == "alpha" then
		t = ns.picker_alpha
	elseif pickertype == "anchor" then
		t = ns.picker_anchor
	elseif pickertype == "font" then
		t = ns.picker_fonts
	elseif pickertype == "flag" then
		t = ns.picker_flags
	end
	local selectedNum
	local picker = CreateFrame("Button", name, ns[module], "UIDropDownMenuTemplate")
	picker:Show()
	local function OnClick(name)
		UIDropDownMenu_SetSelectedID(picker, name:GetID())
	end
	local function initialize(picker, level)
		local info = UIDropDownMenu_CreateInfo()
		for k,v in pairs(t) do
			if v == selected then
				selectedNum = k
			end
			info = UIDropDownMenu_CreateInfo()
			info.text = v
			info.value = v
			info.func = OnClick
			UIDropDownMenu_AddButton(info, level)
		end
	end
	UIDropDownMenu_Initialize(picker, initialize)
	UIDropDownMenu_SetWidth(picker, width)
	UIDropDownMenu_SetButtonWidth(picker, 124)
	UIDropDownMenu_SetSelectedID(picker, selectedNum)
	UIDropDownMenu_JustifyText(picker, "LEFT")
	return picker
end

-- color texture
ns.createColorTexture = function(module, width, height, colorVars, texture)
	local colorTex = ns[module]:CreateTexture(nil, "ARTWORK")
	colorTex:SetSize(width, height)
	colorTex:SetVertexColor(unpack(colorVars))
	colorTex:SetTexture("Interface\\AddOns\\LolzenUI\\media\\"..texture)
	return colorTex
end

-- colorPicker
ns.createColorPicker = function(module, colorRect, colorVars)
	local function afbarSetNewColor()
		r, g, b = ColorPickerFrame:GetColorRGB()
		colorRect:SetVertexColor(r, g, b)
	end

	local function restorePreviousColor()
		colorRect:SetVertexColor(unpack(ColorPickerFrame.previousValues))
	end

	local colorpickerframe = CreateFrame("Frame", nil, ns[module])
	colorpickerframe:SetFrameStrata("HIGH")
	colorpickerframe:EnableMouse(true)
	colorpickerframe:SetScript("OnMouseDown", function(self)
		-- clear previous values
		ColorPickerFrame.previousValues = nil
		ColorPickerFrame.cancelFunc = nil
		ColorPickerFrame.func = nil
		-- and fill with the relevant ones
		ColorPickerFrame.previousValues = colorVars
		ColorPickerFrame:SetColorRGB(unpack(colorVars))
		ColorPickerFrame.cancelFunc = restorePreviousColor
		ColorPickerFrame.func = afbarSetNewColor
		ColorPickerFrame:Show()
	end)
	return colorpickerframe
end