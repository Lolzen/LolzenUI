--// options for actionbars //--

local addon, ns = ...

if not ns.modules["actionabars"] then
	tinsert(ns.modules, "actionbars")
end

local f = CreateFrame("Frame")
f:RegisterEvent("ADDON_LOADED")
f:SetScript("OnEvent", function(self, event, addon)
	if addon == "LolzenUI" and LolzenUIcfg.modules["actionbars"] == true then

		local title = ns["actionbars"]:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
		title:SetPoint("TOPLEFT", ns["actionbars"], 16, -16)
		title:SetText("|cff5599ff"..ns["actionbars"].name.."|r")

		local about = ns["actionbars"]:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
		about:SetPoint("TOPLEFT", title, "BOTTOMLEFT", 0, -8)
		about:SetText("Options for the Actionbars")

		-- // normaltexture buttonpreview // --

		local button = ns["actionbars"]:CreateTexture(nil, "TEXTURE")
		button:SetTexture(select(3, GetSpellInfo(214815)))
		button:SetSize(LolzenUIcfg.actionbar["actionbar_button_size"], LolzenUIcfg.actionbar["actionbar_button_size"])
		button:SetPoint("TOPLEFT", about, "BOTTOMLEFT", 0, -20)
		button:SetTexCoord(.04, .94, .04, .94)

		local normaltex = ns["actionbars"]:CreateTexture(nil, "OVERLAY")
		normaltex:SetTexture("Interface\\AddOns\\LolzenUI\\media\\"..LolzenUIcfg.actionbar["actionbar_normal_texture"])
		normaltex:SetPoint("TOPLEFT", button, "TOPLEFT", -2, 2)
		normaltex:SetPoint("BOTTOMRIGHT", button, "BOTTOMRIGHT", 2, -2)

		local normaltex_path_text = ns["actionbars"]:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
		normaltex_path_text:SetPoint("TOPLEFT", button, "BOTTOMLEFT", 0, -8)
		normaltex_path_text:SetText("|cff5599ffnormal texture:|r Interface/AddOns/LolzenUI/media/")

		local normaltex_path = CreateFrame("EditBox", nil, ns["actionbars"], "InputBoxTemplate")
		normaltex_path:SetPoint("LEFT", normaltex_path_text, "RIGHT", 10, 0)
		normaltex_path:SetSize(80, 20)
		normaltex_path:SetAutoFocus(false)
		normaltex_path:ClearFocus()
		normaltex_path:SetText(LolzenUIcfg.actionbar["actionbar_normal_texture"])
		normaltex_path:SetCursorPosition(0)

		-- // flashtexture buttonpreview // --

		local button2 = ns["actionbars"]:CreateTexture(nil, "TEXTURE")
		button2:SetTexture(select(3, GetSpellInfo(214815)))
		button2:SetSize(LolzenUIcfg.actionbar["actionbar_button_size"], LolzenUIcfg.actionbar["actionbar_button_size"])
		button2:SetPoint("LEFT", button, "RIGHT", LolzenUIcfg.actionbar["actionbar_button_spacing"], 0)
		button2:SetTexCoord(.04, .94, .04, .94)

		local flashtex = ns["actionbars"]:CreateTexture(nil, "OVERLAY")
		flashtex:SetTexture("Interface\\AddOns\\LolzenUI\\media\\"..LolzenUIcfg.actionbar["actionbar_flash_texture"])
		flashtex:SetPoint("TOPLEFT", button2, "TOPLEFT", -2, 2)
		flashtex:SetPoint("BOTTOMRIGHT", button2, "BOTTOMRIGHT", 2, -2)

		local flashtex_path_text = ns["actionbars"]:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
		flashtex_path_text:SetPoint("TOPLEFT", normaltex_path_text, "BOTTOMLEFT", 0, -10)
		flashtex_path_text:SetText("|cff5599ffflash texture:|r Interface/AddOns/LolzenUI/media/")

		local flashtex_path = CreateFrame("EditBox", nil, ns["actionbars"], "InputBoxTemplate")
		flashtex_path:SetPoint("LEFT", flashtex_path_text, "RIGHT", 10, 0)
		flashtex_path:SetSize(80, 20)
		flashtex_path:SetAutoFocus(false)
		flashtex_path:ClearFocus()
		flashtex_path:SetText(LolzenUIcfg.actionbar["actionbar_flash_texture"])
		flashtex_path:SetCursorPosition(0)

		-- // checkedtexture buttonpreview // --

		local button3 = ns["actionbars"]:CreateTexture(nil, "TEXTURE")
		button3:SetTexture(select(3, GetSpellInfo(214815)))
		button3:SetSize(LolzenUIcfg.actionbar["actionbar_button_size"], LolzenUIcfg.actionbar["actionbar_button_size"])
		button3:SetPoint("LEFT", button2, "RIGHT", LolzenUIcfg.actionbar["actionbar_button_spacing"], 0)
		button3:SetTexCoord(.04, .94, .04, .94)

		local checkedtex = ns["actionbars"]:CreateTexture(nil, "OVERLAY")
		checkedtex:SetTexture("Interface\\AddOns\\LolzenUI\\media\\"..LolzenUIcfg.actionbar["actionbar_checked_texture"])
		checkedtex:SetPoint("TOPLEFT", button3, "TOPLEFT", -2, 2)
		checkedtex:SetPoint("BOTTOMRIGHT", button3, "BOTTOMRIGHT", 2, -2)

		local checkedtex_path_text = ns["actionbars"]:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
		checkedtex_path_text:SetPoint("TOPLEFT", flashtex_path_text, "BOTTOMLEFT", 0, -10)
		checkedtex_path_text:SetText("|cff5599ffchecked texture:|r Interface/AddOns/LolzenUI/media/")

		local checkedtex_path = CreateFrame("EditBox", nil, ns["actionbars"], "InputBoxTemplate")
		checkedtex_path:SetPoint("LEFT", checkedtex_path_text, "RIGHT", 10, 0)
		checkedtex_path:SetSize(80, 20)
		checkedtex_path:SetAutoFocus(false)
		checkedtex_path:ClearFocus()
		checkedtex_path:SetText(LolzenUIcfg.actionbar["actionbar_checked_texture"])
		checkedtex_path:SetCursorPosition(0)

		-- // hovertexture buttonpreview // --

		local button4 = ns["actionbars"]:CreateTexture(nil, "TEXTURE")
		button4:SetTexture(select(3, GetSpellInfo(214815)))
		button4:SetSize(LolzenUIcfg.actionbar["actionbar_button_size"], LolzenUIcfg.actionbar["actionbar_button_size"])
		button4:SetPoint("LEFT", button3, "RIGHT", LolzenUIcfg.actionbar["actionbar_button_spacing"], 0)
		button4:SetTexCoord(.04, .94, .04, .94)

		local hovertex = ns["actionbars"]:CreateTexture(nil, "OVERLAY")
		hovertex:SetTexture("Interface\\AddOns\\LolzenUI\\media\\"..LolzenUIcfg.actionbar["actionbar_hover_texture"])
		hovertex:SetPoint("TOPLEFT", button4, "TOPLEFT", -2, 2)
		hovertex:SetPoint("BOTTOMRIGHT", button4, "BOTTOMRIGHT", 2, -2)

		local hovertex_path_text = ns["actionbars"]:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
		hovertex_path_text:SetPoint("TOPLEFT", checkedtex_path_text, "BOTTOMLEFT", 0, -10)
		hovertex_path_text:SetText("|cff5599ffhover texture:|r Interface/AddOns/LolzenUI/media/")

		local hovertex_path = CreateFrame("EditBox", nil, ns["actionbars"], "InputBoxTemplate")
		hovertex_path:SetPoint("LEFT", hovertex_path_text, "RIGHT", 10, 0)
		hovertex_path:SetSize(80, 20)
		hovertex_path:SetAutoFocus(false)
		hovertex_path:ClearFocus()
		hovertex_path:SetText(LolzenUIcfg.actionbar["actionbar_hover_texture"])
		hovertex_path:SetCursorPosition(0)

		-- // pushedtexture buttonpreview // --

		local button5 = ns["actionbars"]:CreateTexture(nil, "TEXTURE")
		button5:SetTexture(select(3, GetSpellInfo(214815)))
		button5:SetSize(LolzenUIcfg.actionbar["actionbar_button_size"], LolzenUIcfg.actionbar["actionbar_button_size"])
		button5:SetPoint("LEFT", button4, "RIGHT", LolzenUIcfg.actionbar["actionbar_button_spacing"], 0)
		button5:SetTexCoord(.04, .94, .04, .94)

		local pushedtex = ns["actionbars"]:CreateTexture(nil, "OVERLAY")
		pushedtex:SetTexture("Interface\\AddOns\\LolzenUI\\media\\"..LolzenUIcfg.actionbar["actionbar_pushed_texture"])
		pushedtex:SetPoint("TOPLEFT", button5, "TOPLEFT", -2, 2)
		pushedtex:SetPoint("BOTTOMRIGHT", button5, "BOTTOMRIGHT", 2, -2)

		local pushedtex_path_text = ns["actionbars"]:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
		pushedtex_path_text:SetPoint("TOPLEFT", hovertex_path_text, "BOTTOMLEFT", 0, -10)
		pushedtex_path_text:SetText("|cff5599ffpushed texture:|r Interface/AddOns/LolzenUI/media/")

		local pushedtex_path = CreateFrame("EditBox", nil, ns["actionbars"], "InputBoxTemplate")
		pushedtex_path:SetPoint("LEFT", pushedtex_path_text, "RIGHT", 10, 0)
		pushedtex_path:SetSize(80, 20)
		pushedtex_path:SetAutoFocus(false)
		pushedtex_path:ClearFocus()
		pushedtex_path:SetText(LolzenUIcfg.actionbar["actionbar_pushed_texture"])
		pushedtex_path:SetCursorPosition(0)

		-- // size // --

		local size_text = ns["actionbars"]:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
		size_text:SetPoint("TOPLEFT", pushedtex_path_text, "BOTTOMLEFT", 0, -20)
		size_text:SetText("button size:")

		local size = CreateFrame("EditBox", nil, ns["actionbars"], "InputBoxTemplate")
		size:SetPoint("LEFT", size_text, "RIGHT", 10, 0)
		size:SetSize(30, 20)
		size:SetAutoFocus(false)
		size:ClearFocus()
		size:SetNumber(LolzenUIcfg.actionbar["actionbar_button_size"])
		size:SetCursorPosition(0)

		local spacing_text = ns["actionbars"]:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
		spacing_text:SetPoint("LEFT", size, "RIGHT", 10, 0)
		spacing_text:SetText("button spacing:")

		local spacing = CreateFrame("EditBox", nil, ns["actionbars"], "InputBoxTemplate")
		spacing:SetPoint("LEFT", spacing_text, "RIGHT", 10, 0)
		spacing:SetSize(30, 20)
		spacing:SetAutoFocus(false)
		spacing:ClearFocus()
		spacing:SetNumber(LolzenUIcfg.actionbar["actionbar_button_spacing"])
		spacing:SetCursorPosition(0)

		local bars_pos_text = ns["actionbars"]:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
		bars_pos_text:SetPoint("TOPLEFT", size_text, "BOTTOMLEFT", 0, -20)
		bars_pos_text:SetText("Bar positions: (scheme = |cff5599ffanchor1, parent point, anchor2, x, y|r)")

		-- // Main Menu Bar // --

		local mmb_text = ns["actionbars"]:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
		mmb_text:SetPoint("TOPLEFT", bars_pos_text, "BOTTOMLEFT", 0, -10)
		mmb_text:SetText("Main Menu Bar:")

		local mmb_anchor1 = CreateFrame("EditBox", nil, ns["actionbars"], "InputBoxTemplate")
		mmb_anchor1:SetPoint("LEFT", mmb_text, "RIGHT", 10, 0)
		mmb_anchor1:SetSize(100, 20)
		mmb_anchor1:SetAutoFocus(false)
		mmb_anchor1:ClearFocus()
		mmb_anchor1:SetText(LolzenUIcfg.actionbar["actionbar_mmb_anchor1"])
		mmb_anchor1:SetCursorPosition(0)

		local mmb_parent = CreateFrame("EditBox", nil, ns["actionbars"], "InputBoxTemplate")
		mmb_parent:SetPoint("LEFT", mmb_anchor1, "RIGHT", 10, 0)
		mmb_parent:SetSize(160, 20)
		mmb_parent:SetAutoFocus(false)
		mmb_parent:ClearFocus()
		mmb_parent:SetText(LolzenUIcfg.actionbar["actionbar_mmb_parent"])
		mmb_parent:SetCursorPosition(0)

		local mmb_anchor2 = CreateFrame("EditBox", nil, ns["actionbars"], "InputBoxTemplate")
		mmb_anchor2:SetPoint("LEFT", mmb_parent, "RIGHT", 10, 0)
		mmb_anchor2:SetSize(100, 20)
		mmb_anchor2:SetAutoFocus(false)
		mmb_anchor2:ClearFocus()
		mmb_anchor2:SetText(LolzenUIcfg.actionbar["actionbar_mmb_anchor2"])
		mmb_anchor2:SetCursorPosition(0)

		local mmb_pos_x = CreateFrame("EditBox", nil, ns["actionbars"], "InputBoxTemplate")
		mmb_pos_x:SetPoint("LEFT", mmb_anchor2, "RIGHT", 10, 0)
		mmb_pos_x:SetSize(30, 20)
		mmb_pos_x:SetAutoFocus(false)
		mmb_pos_x:ClearFocus()
		mmb_pos_x:SetNumber(LolzenUIcfg.actionbar["actionbar_mmb_posx"])
		mmb_pos_x:SetCursorPosition(0)

		local mmb_pos_y = CreateFrame("EditBox", nil, ns["actionbars"], "InputBoxTemplate")
		mmb_pos_y:SetPoint("LEFT", mmb_pos_x, "RIGHT", 10, 0)
		mmb_pos_y:SetSize(30, 20)
		mmb_pos_y:SetAutoFocus(false)
		mmb_pos_y:ClearFocus()
		mmb_pos_y:SetNumber(LolzenUIcfg.actionbar["actionbar_mmb_posy"])
		mmb_pos_y:SetCursorPosition(0)

		-- // Multi Bar Bottom Left // --

		local mbbl_text = ns["actionbars"]:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
		mbbl_text:SetPoint("TOPLEFT", mmb_text, "BOTTOMLEFT", 0, -10)
		mbbl_text:SetText("Multi Bar Bottom Left:")

		local mbbl_anchor1 = CreateFrame("EditBox", nil, ns["actionbars"], "InputBoxTemplate")
		mbbl_anchor1:SetPoint("LEFT", mbbl_text, "RIGHT", 10, 0)
		mbbl_anchor1:SetSize(100, 20)
		mbbl_anchor1:SetAutoFocus(false)
		mbbl_anchor1:ClearFocus()
		mbbl_anchor1:SetText(LolzenUIcfg.actionbar["actionbar_mbbl_anchor1"])
		mbbl_anchor1:SetCursorPosition(0)

		local mbbl_parent = CreateFrame("EditBox", nil, ns["actionbars"], "InputBoxTemplate")
		mbbl_parent:SetPoint("LEFT", mbbl_anchor1, "RIGHT", 10, 0)
		mbbl_parent:SetSize(160, 20)
		mbbl_parent:SetAutoFocus(false)
		mbbl_parent:ClearFocus()
		mbbl_parent:SetText(LolzenUIcfg.actionbar["actionbar_mbbl_parent"])
		mbbl_parent:SetCursorPosition(0)

		local mbbl_anchor2 = CreateFrame("EditBox", nil, ns["actionbars"], "InputBoxTemplate")
		mbbl_anchor2:SetPoint("LEFT", mbbl_parent, "RIGHT", 10, 0)
		mbbl_anchor2:SetSize(100, 20)
		mbbl_anchor2:SetAutoFocus(false)
		mbbl_anchor2:ClearFocus()
		mbbl_anchor2:SetText(LolzenUIcfg.actionbar["actionbar_mbbl_anchor2"])
		mbbl_anchor2:SetCursorPosition(0)

		local mbbl_pos_x = CreateFrame("EditBox", nil, ns["actionbars"], "InputBoxTemplate")
		mbbl_pos_x:SetPoint("LEFT", mbbl_anchor2, "RIGHT", 10, 0)
		mbbl_pos_x:SetSize(30, 20)
		mbbl_pos_x:SetAutoFocus(false)
		mbbl_pos_x:ClearFocus()
		mbbl_pos_x:SetNumber(LolzenUIcfg.actionbar["actionbar_mbbl_posx"])
		mbbl_pos_x:SetCursorPosition(0)

		local mbbl_pos_y = CreateFrame("EditBox", nil, ns["actionbars"], "InputBoxTemplate")
		mbbl_pos_y:SetPoint("LEFT", mbbl_pos_x, "RIGHT", 10, 0)
		mbbl_pos_y:SetSize(30, 20)
		mbbl_pos_y:SetAutoFocus(false)
		mbbl_pos_y:ClearFocus()
		mbbl_pos_y:SetNumber(LolzenUIcfg.actionbar["actionbar_mbbl_posy"])
		mbbl_pos_y:SetCursorPosition(0)

		-- // Multi Bar Bottom Right // --

		local mbbr_text = ns["actionbars"]:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
		mbbr_text:SetPoint("TOPLEFT", mbbl_text, "BOTTOMLEFT", 0, -10)
		mbbr_text:SetText("Multi Bar Bottom Right:")

		local mbbr_anchor1 = CreateFrame("EditBox", nil, ns["actionbars"], "InputBoxTemplate")
		mbbr_anchor1:SetPoint("LEFT", mbbr_text, "RIGHT", 10, 0)
		mbbr_anchor1:SetSize(100, 20)
		mbbr_anchor1:SetAutoFocus(false)
		mbbr_anchor1:ClearFocus()
		mbbr_anchor1:SetText(LolzenUIcfg.actionbar["actionbar_mbbr_anchor1"])
		mbbr_anchor1:SetCursorPosition(0)

		local mbbr_parent = CreateFrame("EditBox", nil, ns["actionbars"], "InputBoxTemplate")
		mbbr_parent:SetPoint("LEFT", mbbr_anchor1, "RIGHT", 10, 0)
		mbbr_parent:SetSize(160, 20)
		mbbr_parent:SetAutoFocus(false)
		mbbr_parent:ClearFocus()
		mbbr_parent:SetText(LolzenUIcfg.actionbar["actionbar_mbbr_parent"])
		mbbr_parent:SetCursorPosition(0)

		local mbbr_anchor2 = CreateFrame("EditBox", nil, ns["actionbars"], "InputBoxTemplate")
		mbbr_anchor2:SetPoint("LEFT", mbbr_parent, "RIGHT", 10, 0)
		mbbr_anchor2:SetSize(100, 20)
		mbbr_anchor2:SetAutoFocus(false)
		mbbr_anchor2:ClearFocus()
		mbbr_anchor2:SetText(LolzenUIcfg.actionbar["actionbar_mbbr_anchor2"])
		mbbr_anchor2:SetCursorPosition(0)

		local mbbr_pos_x = CreateFrame("EditBox", nil, ns["actionbars"], "InputBoxTemplate")
		mbbr_pos_x:SetPoint("LEFT", mbbr_anchor2, "RIGHT", 10, 0)
		mbbr_pos_x:SetSize(30, 20)
		mbbr_pos_x:SetAutoFocus(false)
		mbbr_pos_x:ClearFocus()
		mbbr_pos_x:SetNumber(LolzenUIcfg.actionbar["actionbar_mbbr_posx"])
		mbbr_pos_x:SetCursorPosition(0)

		local mbbr_pos_y = CreateFrame("EditBox", nil, ns["actionbars"], "InputBoxTemplate")
		mbbr_pos_y:SetPoint("LEFT", mbbr_pos_x, "RIGHT", 10, 0)
		mbbr_pos_y:SetSize(30, 20)
		mbbr_pos_y:SetAutoFocus(false)
		mbbr_pos_y:ClearFocus()
		mbbr_pos_y:SetNumber(LolzenUIcfg.actionbar["actionbar_mbbr_posy"])
		mbbr_pos_y:SetCursorPosition(0)

		-- // Multi Bar Left // --

		local mbl_text = ns["actionbars"]:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
		mbl_text:SetPoint("TOPLEFT", mbbr_text, "BOTTOMLEFT", 0, -10)
		mbl_text:SetText("Multi Bar Left:")

		local mbl_anchor1 = CreateFrame("EditBox", nil, ns["actionbars"], "InputBoxTemplate")
		mbl_anchor1:SetPoint("LEFT", mbl_text, "RIGHT", 10, 0)
		mbl_anchor1:SetSize(100, 20)
		mbl_anchor1:SetAutoFocus(false)
		mbl_anchor1:ClearFocus()
		mbl_anchor1:SetText(LolzenUIcfg.actionbar["actionbar_mbl_anchor1"])
		mbl_anchor1:SetCursorPosition(0)

		local mbl_parent = CreateFrame("EditBox", nil, ns["actionbars"], "InputBoxTemplate")
		mbl_parent:SetPoint("LEFT", mbl_anchor1, "RIGHT", 10, 0)
		mbl_parent:SetSize(160, 20)
		mbl_parent:SetAutoFocus(false)
		mbl_parent:ClearFocus()
		mbl_parent:SetText(LolzenUIcfg.actionbar["actionbar_mbl_parent"])
		mbl_parent:SetCursorPosition(0)

		local mbl_anchor2 = CreateFrame("EditBox", nil, ns["actionbars"], "InputBoxTemplate")
		mbl_anchor2:SetPoint("LEFT", mbl_parent, "RIGHT", 10, 0)
		mbl_anchor2:SetSize(100, 20)
		mbl_anchor2:SetAutoFocus(false)
		mbl_anchor2:ClearFocus()
		mbl_anchor2:SetText(LolzenUIcfg.actionbar["actionbar_mbl_anchor2"])
		mbl_anchor2:SetCursorPosition(0)

		local mbl_pos_x = CreateFrame("EditBox", nil, ns["actionbars"], "InputBoxTemplate")
		mbl_pos_x:SetPoint("LEFT", mbl_anchor2, "RIGHT", 10, 0)
		mbl_pos_x:SetSize(30, 20)
		mbl_pos_x:SetAutoFocus(false)
		mbl_pos_x:ClearFocus()
		mbl_pos_x:SetNumber(LolzenUIcfg.actionbar["actionbar_mbl_posx"])
		mbl_pos_x:SetCursorPosition(0)

		local mbl_pos_y = CreateFrame("EditBox", nil, ns["actionbars"], "InputBoxTemplate")
		mbl_pos_y:SetPoint("LEFT", mbl_pos_x, "RIGHT", 10, 0)
		mbl_pos_y:SetSize(30, 20)
		mbl_pos_y:SetAutoFocus(false)
		mbl_pos_y:ClearFocus()
		mbl_pos_y:SetNumber(LolzenUIcfg.actionbar["actionbar_mbl_posy"])
		mbl_pos_y:SetCursorPosition(0)

		-- // Multi Bar Right // --

		local mbr_text = ns["actionbars"]:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
		mbr_text:SetPoint("TOPLEFT", mbl_text, "BOTTOMLEFT", 0, -10)
		mbr_text:SetText("Multi Bar Right:")

		local mbr_anchor1 = CreateFrame("EditBox", nil, ns["actionbars"], "InputBoxTemplate")
		mbr_anchor1:SetPoint("LEFT", mbr_text, "RIGHT", 10, 0)
		mbr_anchor1:SetSize(100, 20)
		mbr_anchor1:SetAutoFocus(false)
		mbr_anchor1:ClearFocus()
		mbr_anchor1:SetText(LolzenUIcfg.actionbar["actionbar_mbr_anchor1"])
		mbr_anchor1:SetCursorPosition(0)

		local mbr_parent = CreateFrame("EditBox", nil, ns["actionbars"], "InputBoxTemplate")
		mbr_parent:SetPoint("LEFT", mbr_anchor1, "RIGHT", 10, 0)
		mbr_parent:SetSize(160, 20)
		mbr_parent:SetAutoFocus(false)
		mbr_parent:ClearFocus()
		mbr_parent:SetText(LolzenUIcfg.actionbar["actionbar_mbr_parent"])
		mbr_parent:SetCursorPosition(0)

		local mbr_anchor2 = CreateFrame("EditBox", nil, ns["actionbars"], "InputBoxTemplate")
		mbr_anchor2:SetPoint("LEFT", mbr_parent, "RIGHT", 10, 0)
		mbr_anchor2:SetSize(100, 20)
		mbr_anchor2:SetAutoFocus(false)
		mbr_anchor2:ClearFocus()
		mbr_anchor2:SetText(LolzenUIcfg.actionbar["actionbar_mbr_anchor2"])
		mbr_anchor2:SetCursorPosition(0)

		local mbr_pos_x = CreateFrame("EditBox", nil, ns["actionbars"], "InputBoxTemplate")
		mbr_pos_x:SetPoint("LEFT", mbr_anchor2, "RIGHT", 10, 0)
		mbr_pos_x:SetSize(30, 20)
		mbr_pos_x:SetAutoFocus(false)
		mbr_pos_x:ClearFocus()
		mbr_pos_x:SetNumber(LolzenUIcfg.actionbar["actionbar_mbr_posx"])
		mbr_pos_x:SetCursorPosition(0)

		local mbr_pos_y = CreateFrame("EditBox", nil, ns["actionbars"], "InputBoxTemplate")
		mbr_pos_y:SetPoint("LEFT", mbr_pos_x, "RIGHT", 10, 0)
		mbr_pos_y:SetSize(30, 20)
		mbr_pos_y:SetAutoFocus(false)
		mbr_pos_y:ClearFocus()
		mbr_pos_y:SetNumber(LolzenUIcfg.actionbar["actionbar_mbr_posy"])
		mbr_pos_y:SetCursorPosition(0)

		-- // Pet Bar // --

		local petb_text = ns["actionbars"]:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
		petb_text:SetPoint("TOPLEFT", mbr_text, "BOTTOMLEFT", 0, -10)
		petb_text:SetText("Pet Bar:")

		local petb_anchor1 = CreateFrame("EditBox", nil, ns["actionbars"], "InputBoxTemplate")
		petb_anchor1:SetPoint("LEFT", petb_text, "RIGHT", 10, 0)
		petb_anchor1:SetSize(100, 20)
		petb_anchor1:SetAutoFocus(false)
		petb_anchor1:ClearFocus()
		petb_anchor1:SetText(LolzenUIcfg.actionbar["actionbar_petb_anchor1"])
		petb_anchor1:SetCursorPosition(0)

		local petb_parent = CreateFrame("EditBox", nil, ns["actionbars"], "InputBoxTemplate")
		petb_parent:SetPoint("LEFT", petb_anchor1, "RIGHT", 10, 0)
		petb_parent:SetSize(160, 20)
		petb_parent:SetAutoFocus(false)
		petb_parent:ClearFocus()
		petb_parent:SetText(LolzenUIcfg.actionbar["actionbar_petb_parent"])
		petb_parent:SetCursorPosition(0)

		local petb_anchor2 = CreateFrame("EditBox", nil, ns["actionbars"], "InputBoxTemplate")
		petb_anchor2:SetPoint("LEFT", petb_parent, "RIGHT", 10, 0)
		petb_anchor2:SetSize(100, 20)
		petb_anchor2:SetAutoFocus(false)
		petb_anchor2:ClearFocus()
		petb_anchor2:SetText(LolzenUIcfg.actionbar["actionbar_petb_anchor2"])
		petb_anchor2:SetCursorPosition(0)

		local petb_pos_x = CreateFrame("EditBox", nil, ns["actionbars"], "InputBoxTemplate")
		petb_pos_x:SetPoint("LEFT", petb_anchor2, "RIGHT", 10, 0)
		petb_pos_x:SetSize(30, 20)
		petb_pos_x:SetAutoFocus(false)
		petb_pos_x:ClearFocus()
		petb_pos_x:SetNumber(LolzenUIcfg.actionbar["actionbar_petb_posx"])
		petb_pos_x:SetCursorPosition(0)

		local petb_pos_y = CreateFrame("EditBox", nil, ns["actionbars"], "InputBoxTemplate")
		petb_pos_y:SetPoint("LEFT", petb_pos_x, "RIGHT", 10, 0)
		petb_pos_y:SetSize(30, 20)
		petb_pos_y:SetAutoFocus(false)
		petb_pos_y:ClearFocus()
		petb_pos_y:SetNumber(LolzenUIcfg.actionbar["actionbar_petb_posy"])
		petb_pos_y:SetCursorPosition(0)

		-- // Possess Bar // --

		local pb_text = ns["actionbars"]:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
		pb_text:SetPoint("TOPLEFT", petb_text, "BOTTOMLEFT", 0, -10)
		pb_text:SetText("Possess Bar:")

		local pb_anchor1 = CreateFrame("EditBox", nil, ns["actionbars"], "InputBoxTemplate")
		pb_anchor1:SetPoint("LEFT", pb_text, "RIGHT", 10, 0)
		pb_anchor1:SetSize(100, 20)
		pb_anchor1:SetAutoFocus(false)
		pb_anchor1:ClearFocus()
		pb_anchor1:SetText(LolzenUIcfg.actionbar["actionbar_pb_anchor1"])
		pb_anchor1:SetCursorPosition(0)

		local pb_parent = CreateFrame("EditBox", nil, ns["actionbars"], "InputBoxTemplate")
		pb_parent:SetPoint("LEFT", pb_anchor1, "RIGHT", 10, 0)
		pb_parent:SetSize(160, 20)
		pb_parent:SetAutoFocus(false)
		pb_parent:ClearFocus()
		pb_parent:SetText(LolzenUIcfg.actionbar["actionbar_pb_parent"])
		pb_parent:SetCursorPosition(0)

		local pb_anchor2 = CreateFrame("EditBox", nil, ns["actionbars"], "InputBoxTemplate")
		pb_anchor2:SetPoint("LEFT", pb_parent, "RIGHT", 10, 0)
		pb_anchor2:SetSize(100, 20)
		pb_anchor2:SetAutoFocus(false)
		pb_anchor2:ClearFocus()
		pb_anchor2:SetText(LolzenUIcfg.actionbar["actionbar_pb_anchor2"])
		pb_anchor2:SetCursorPosition(0)

		local pb_pos_x = CreateFrame("EditBox", nil, ns["actionbars"], "InputBoxTemplate")
		pb_pos_x:SetPoint("LEFT", pb_anchor2, "RIGHT", 10, 0)
		pb_pos_x:SetSize(30, 20)
		pb_pos_x:SetAutoFocus(false)
		pb_pos_x:ClearFocus()
		pb_pos_x:SetNumber(LolzenUIcfg.actionbar["actionbar_pb_posx"])
		pb_pos_x:SetCursorPosition(0)

		local pb_pos_y = CreateFrame("EditBox", nil, ns["actionbars"], "InputBoxTemplate")
		pb_pos_y:SetPoint("LEFT", pb_pos_x, "RIGHT", 10, 0)
		pb_pos_y:SetSize(30, 20)
		pb_pos_y:SetAutoFocus(false)
		pb_pos_y:ClearFocus()
		pb_pos_y:SetNumber(LolzenUIcfg.actionbar["actionbar_pb_posy"])
		pb_pos_y:SetCursorPosition(0)

		ns["actionbars"].okay = function(self)
			LolzenUIcfg.actionbar["actionbar_normal_texture"] = normaltex_path:GetText()
			LolzenUIcfg.actionbar["actionbar_flash_texture"] = flashtex_path:GetText()
			LolzenUIcfg.actionbar["actionbar_checked_texture"] = checkedtex_path:GetText()
			LolzenUIcfg.actionbar["actionbar_hover_texture"] = hovertex_path:GetText()
			LolzenUIcfg.actionbar["actionbar_pushed_texture"] = pushedtex_path:GetText()
			LolzenUIcfg.actionbar["actionbar_button_spacing"] = spacing:GetText()
			LolzenUIcfg.actionbar["actionbar_button_size"] = size:GetText()
			LolzenUIcfg.actionbar["actionbar_mmb_anchor1"] = mmb_anchor1:GetText()
			LolzenUIcfg.actionbar["actionbar_mmb_parent"] = mmb_parent:GetText()
			LolzenUIcfg.actionbar["actionbar_mmb_anchor2"] = mmb_anchor2:GetText()
			LolzenUIcfg.actionbar["actionbar_mmb_posx"] = tonumber(mmb_pos_x:GetText())
			LolzenUIcfg.actionbar["actionbar_mmb_posy"] = tonumber(mmb_pos_y:GetText())
			LolzenUIcfg.actionbar["actionbar_mbbl_anchor1"] = mbbl_anchor1:GetText()
			LolzenUIcfg.actionbar["actionbar_mbbl_parent"] = mbbl_parent:GetText()
			LolzenUIcfg.actionbar["actionbar_mbbl_anchor2"] = mbbl_anchor2:GetText()
			LolzenUIcfg.actionbar["actionbar_mbbl_posx"] = tonumber(mbbl_pos_x:GetText())
			LolzenUIcfg.actionbar["actionbar_mbbl_posy"] = tonumber(mbbl_pos_y:GetText())
			LolzenUIcfg.actionbar["actionbar_mbbr_anchor1"] = mbbr_anchor1:GetText()
			LolzenUIcfg.actionbar["actionbar_mbbr_parent"] = mbbr_parent:GetText()
			LolzenUIcfg.actionbar["actionbar_mbbr_anchor2"] = mbbr_anchor2:GetText()
			LolzenUIcfg.actionbar["actionbar_mbbr_posx"] = tonumber(mbbr_pos_x:GetText())
			LolzenUIcfg.actionbar["actionbar_mbbr_posy"] = tonumber(mbbr_pos_y:GetText())
			LolzenUIcfg.actionbar["actionbar_mbl_anchor1"] = mbl_anchor1:GetText()
			LolzenUIcfg.actionbar["actionbar_mbl_parent"] = mbl_parent:GetText()
			LolzenUIcfg.actionbar["actionbar_mbl_anchor2"] = mbl_anchor2:GetText()
			LolzenUIcfg.actionbar["actionbar_mbl_posx"] = tonumber(mbl_pos_x:GetText())
			LolzenUIcfg.actionbar["actionbar_mbl_posy"] = tonumber(mbl_pos_y:GetText())
			LolzenUIcfg.actionbar["actionbar_mbr_anchor1"] = mbr_anchor1:GetText()
			LolzenUIcfg.actionbar["actionbar_mbr_parent"] = mbr_parent:GetText()
			LolzenUIcfg.actionbar["actionbar_mbr_anchor2"] = mbr_anchor2:GetText()
			LolzenUIcfg.actionbar["actionbar_mbr_posx"] = tonumber(mbr_pos_x:GetText())
			LolzenUIcfg.actionbar["actionbar_mbr_posy"] = tonumber(mbr_pos_y:GetText())
			LolzenUIcfg.actionbar["actionbar_petb_anchor1"] = petb_anchor1:GetText()
			LolzenUIcfg.actionbar["actionbar_petb_parent"] = petb_parent:GetText()
			LolzenUIcfg.actionbar["actionbar_petb_anchor2"] = petb_anchor2:GetText()
			LolzenUIcfg.actionbar["actionbar_petb_posx"] = tonumber(petb_pos_x:GetText())
			LolzenUIcfg.actionbar["actionbar_petb_posy"] = tonumber(petb_pos_y:GetText())
			LolzenUIcfg.actionbar["actionbar_pb_anchor1"] = pb_anchor1:GetText()
			LolzenUIcfg.actionbar["actionbar_pb_parent"] = pb_parent:GetText()
			LolzenUIcfg.actionbar["actionbar_pb_anchor2"] = pb_anchor2:GetText()
			LolzenUIcfg.actionbar["actionbar_pb_posx"] = tonumber(pb_pos_x:GetText())
			LolzenUIcfg.actionbar["actionbar_pb_posy"] = tonumber(pb_pos_y:GetText())
		end

		ns["actionbars"].default = function(self)
			LolzenUIcfg.actionbar["actionbar_normal_texture"] = "gloss"
			LolzenUIcfg.actionbar["actionbar_flash_texture"] = "flash"
			LolzenUIcfg.actionbar["actionbar_checked_texture"] = "checked"
			LolzenUIcfg.actionbar["actionbar_hover_texture"] = "hover"
			LolzenUIcfg.actionbar["actionbar_pushed_texture"] = "pushed"
			LolzenUIcfg.actionbar["actionbar_button_spacing"] = 6
			LolzenUIcfg.actionbar["actionbar_button_size"] = 26
			LolzenUIcfg.actionbar["actionbar_mmb_anchor1"] = "BOTTOM"
			LolzenUIcfg.actionbar["actionbar_mmb_parent"] = "UIParent"
			LolzenUIcfg.actionbar["actionbar_mmb_anchor2"] = "BOTTOM"
			LolzenUIcfg.actionbar["actionbar_mmb_posx"] = 0
			LolzenUIcfg.actionbar["actionbar_mmb_posy"] = 22
			LolzenUIcfg.actionbar["actionbar_mbbl_anchor1"] = "BOTTOMLEFT"
			LolzenUIcfg.actionbar["actionbar_mbbl_parent"] = "ActionButton1"
			LolzenUIcfg.actionbar["actionbar_mbbl_anchor2"] = "TOPLEFT"
			LolzenUIcfg.actionbar["actionbar_mbbl_posx"] = 0
			LolzenUIcfg.actionbar["actionbar_mbbl_posy"] = 5
			LolzenUIcfg.actionbar["actionbar_mbbr_anchor1"] = "BOTTOMLEFT"
			LolzenUIcfg.actionbar["actionbar_mbbr_parent"] = "MultiBarBottomLeftButton1"
			LolzenUIcfg.actionbar["actionbar_mbbr_anchor2"] = "TOPLEFT"
			LolzenUIcfg.actionbar["actionbar_mbbr_posx"] = 0
			LolzenUIcfg.actionbar["actionbar_mbbr_posy"] = 5
			LolzenUIcfg.actionbar["actionbar_mbl_anchor1"] = "TOPLEFT"
			LolzenUIcfg.actionbar["actionbar_mbl_parent"] = "MultiBarRightButton1"
			LolzenUIcfg.actionbar["actionbar_mbl_anchor2"] = "TOPLEFT"
			LolzenUIcfg.actionbar["actionbar_mbl_posx"] = -33
			LolzenUIcfg.actionbar["actionbar_mbl_posy"] = 0
			LolzenUIcfg.actionbar["actionbar_mbr_anchor1"] = "RIGHT"
			LolzenUIcfg.actionbar["actionbar_mbr_parent"] = "UIParent"
			LolzenUIcfg.actionbar["actionbar_mbr_anchor2"] = "RIGHT"
			LolzenUIcfg.actionbar["actionbar_mbr_posx"] = -2
			LolzenUIcfg.actionbar["actionbar_mbr_posy"] = 150
			LolzenUIcfg.actionbar["actionbar_petb_anchor1"] = "BOTTOMLEFT"
			LolzenUIcfg.actionbar["actionbar_petb_parent"] = "MultiBarBottomRightButton1"
			LolzenUIcfg.actionbar["actionbar_petb_anchor2"] = "TOPLEFT"
			LolzenUIcfg.actionbar["actionbar_petb_posx"] = 15
			LolzenUIcfg.actionbar["actionbar_petb_posy"] = 60
			LolzenUIcfg.actionbar["actionbar_pb_anchor1"] = "BOTTOMLEFT"
			LolzenUIcfg.actionbar["actionbar_pb_parent"] = "MultiBarBottomRightButton1"
			LolzenUIcfg.actionbar["actionbar_pb_anchor2"] = "TOPLEFT"
			LolzenUIcfg.actionbar["actionbar_pb_posx"] = 25
			LolzenUIcfg.actionbar["actionbar_pb_posy"] = 30
			ReloadUI()
		end
	end
end)