﻿--// core //--

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
	title = ns[module]:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
	title:SetPoint("TOPLEFT", ns[module], 16, -16)
	title:SetText("|cff5599ff"..string.upper(string.sub(ns[module].name, 1, 1))..string.sub(ns[module].name, 2).." module Options|r")
	return title
end

-- description
ns.createDescription = function(module, text)
	desc = ns[module]:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
	desc:SetText(text)
	return desc
end

-- header
ns.createHeader = function(module, text)
	header = ns[module]:CreateFontString(nil, "ARTWORK", "GameFontHighlight")
	header:SetText("|cff5599ff"..text.."|r")
	return header
end

-- generic fontstring
ns.createFonstring = function(module, text)
	genstr = ns[module]:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
	genstr:SetText(text)
	return genstr
end

-- inputbox
ns.createInputbox = function(module, width, height, num)
	box = CreateFrame("EditBox", nil, ns[module], "InputBoxTemplate")
	box:SetSize(width, height)
	box:SetAutoFocus(false)
	box:ClearFocus()
	box:SetNumber(num)
	box:SetCursorPosition(0)
	return box
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
	local obj
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
	name = CreateFrame("Button", name, ns[module], "UIDropDownMenuTemplate")
	obj = name
	name:Show()
	local function OnClick(name)
		UIDropDownMenu_SetSelectedID(obj, name:GetID())
	end
	local function initialize(name, level)
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
	UIDropDownMenu_Initialize(name, initialize)
	UIDropDownMenu_SetWidth(name, width)
	UIDropDownMenu_SetButtonWidth(name, 124)
	UIDropDownMenu_SetSelectedID(name, selectedNum)
	UIDropDownMenu_JustifyText(name, "LEFT")
	return name
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