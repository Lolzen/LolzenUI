--// options for actionbars //--

local addon, ns = ...

ns.RegisterModule("actionbars")

local f = CreateFrame("Frame")
f:RegisterEvent("ADDON_LOADED")
f:SetScript("OnEvent", function(self, event, addon)
	if addon == "LolzenUI" and LolzenUIcfg.modules["actionbars"] == true then

		local title = ns.createTitle("actionbars")

		local about = ns.createDescription("actionbars", "Options for the Actionbars")
		about:SetPoint("TOPLEFT", title, "BOTTOMLEFT", 0, -8)

		local header1 = ns.createHeader("actionbars", "Preview:")
		header1:SetPoint("TOPLEFT", about, "BOTTOMLEFT", 0, -20)

		-- // normaltexture buttonpreview // --

		local button = ns["actionbars"]:CreateTexture(nil, "TEXTURE")
		button:SetTexture(select(3, GetSpellInfo(214815)))
		button:SetSize(LolzenUIcfg.actionbar["actionbar_button_size"], LolzenUIcfg.actionbar["actionbar_button_size"])
		button:SetPoint("TOPLEFT", header1, "BOTTOMLEFT", 0, -8)
		button:SetTexCoord(.04, .94, .04, .94)

		local normaltex = ns["actionbars"]:CreateTexture(nil, "OVERLAY")
		normaltex:SetTexture("Interface\\AddOns\\LolzenUI\\media\\"..LolzenUIcfg.actionbar["actionbar_normal_texture"])
		normaltex:SetPoint("TOPLEFT", button, "TOPLEFT", -2, 2)
		normaltex:SetPoint("BOTTOMRIGHT", button, "BOTTOMRIGHT", 2, -2)

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

		local header2 = ns.createHeader("actionbars", "Textures & Size: |cffffffff(Textures are located in Interface/AddOns/LolzenUI/media)|r")
		header2:SetPoint("TOPLEFT", button, "BOTTOMLEFT", 0, -20)

		-- // texture paths // --
		
		local normaltex_path_text = ns.createFonstring("actionbars", "Normal texture:")
		normaltex_path_text:SetPoint("TOPLEFT", header2, "BOTTOMLEFT", 0, -8)

		local normaltex_path = ns.createInputbox("actionbars", 80, 20, LolzenUIcfg.actionbar["actionbar_normal_texture"])
		normaltex_path:SetPoint("LEFT", normaltex_path_text, "RIGHT", 10, 0)

		local flashtex_path_text = ns.createFonstring("actionbars", "Flash texture:")
		flashtex_path_text:SetPoint("TOPLEFT", normaltex_path_text, "BOTTOMLEFT", 0, -10)

		local flashtex_path = ns.createInputbox("actionbars", 80, 20, LolzenUIcfg.actionbar["actionbar_flash_texture"])
		flashtex_path:SetPoint("LEFT", flashtex_path_text, "RIGHT", 10, 0)

		local checkedtex_path_text = ns.createFonstring("actionbars", "Checked texture:")
		checkedtex_path_text:SetPoint("TOPLEFT", flashtex_path_text, "BOTTOMLEFT", 0, -10)

		local checkedtex_path = ns.createInputbox("actionbars", 80, 20, LolzenUIcfg.actionbar["actionbar_checked_texture"])
		checkedtex_path:SetPoint("LEFT", checkedtex_path_text, "RIGHT", 10, 0)

		local hovertex_path_text = ns.createFonstring("actionbars", "Hover texture:")
		hovertex_path_text:SetPoint("TOPLEFT", checkedtex_path_text, "BOTTOMLEFT", 0, -10)

		local hovertex_path = ns.createInputbox("actionbars", 80, 20, LolzenUIcfg.actionbar["actionbar_hover_texture"])
		hovertex_path:SetPoint("LEFT", hovertex_path_text, "RIGHT", 10, 0)

		local pushedtex_path_text = ns.createFonstring("actionbars", "Pushed texture:")
		pushedtex_path_text:SetPoint("TOPLEFT", hovertex_path_text, "BOTTOMLEFT", 0, -10)

		local pushedtex_path = ns.createInputbox("actionbars", 80, 20, LolzenUIcfg.actionbar["actionbar_pushed_texture"])
		pushedtex_path:SetPoint("LEFT", pushedtex_path_text, "RIGHT", 10, 0)

		-- // size // --

		local size_text = ns.createFonstring("actionbars", "Button size:")
		size_text:SetPoint("TOPLEFT", pushedtex_path_text, "BOTTOMLEFT", 0, -20)

		local size = ns.createInputbox("actionbars", 30, 20, LolzenUIcfg.actionbar["actionbar_button_size"])
		size:SetPoint("LEFT", size_text, "RIGHT", 10, 0)

		local spacing_text = ns.createFonstring("actionbars", "Button spacing:")
		spacing_text:SetPoint("LEFT", size, "RIGHT", 10, 0)

		local spacing = ns.createInputbox("actionbars", 30, 20, LolzenUIcfg.actionbar["actionbar_button_spacing"])
		spacing:SetPoint("LEFT", spacing_text, "RIGHT", 10, 0)

		local header3 = ns.createHeader("actionbars", "Bar positions: |cffffffff(scheme = anchor1, parent, anchor2, posX, posY)|r")
		header3:SetPoint("TOPLEFT", size_text, "BOTTOMLEFT", 0, -20)

		-- // Main Menu Bar // --

		local mmb_text = ns.createFonstring("actionbars", "Main Menu Bar:")
		mmb_text:SetPoint("TOPLEFT", header3, "BOTTOMLEFT", 0, -15)

		local mmb_anchor1 = ns.createPicker("actionbars", "anchor", "mmb_anchor1_picker", 100, LolzenUIcfg.actionbar["actionbar_mmb_anchor1"])
		mmb_anchor1:SetPoint("LEFT", mmb_text, "RIGHT", -10, -3)

		local mmb_parent = ns.createInputbox("actionbars", 140, 20, LolzenUIcfg.actionbar["actionbar_mmb_parent"])
		mmb_parent:SetPoint("LEFT", mmb_anchor1, "RIGHT", -5, 3)

		local mmb_anchor2 = ns.createPicker("actionbars", "anchor", "mmb_anchor2_picker", 100, LolzenUIcfg.actionbar["actionbar_mmb_anchor2"])
		mmb_anchor2:SetPoint("LEFT", mmb_parent, "RIGHT", -10, -3)

		local mmb_pos_x = ns.createInputbox("actionbars", 30, 20, LolzenUIcfg.actionbar["actionbar_mmb_posx"])
		mmb_pos_x:SetPoint("LEFT", mmb_anchor2, "RIGHT", -5, 3)

		local mmb_pos_y = ns.createInputbox("actionbars", 30, 20, LolzenUIcfg.actionbar["actionbar_mmb_posy"])
		mmb_pos_y:SetPoint("LEFT", mmb_pos_x, "RIGHT", 10, 0)

		-- // Multi Bar Bottom Left // --

		local mbbl_text = ns.createFonstring("actionbars", "Multi Bar Bottom Left:")
		mbbl_text:SetPoint("TOPLEFT", mmb_text, "BOTTOMLEFT", 0, -15)

		local mbbl_anchor1 = ns.createPicker("actionbars", "anchor", "mbbl_anchor1_picker", 100, LolzenUIcfg.actionbar["actionbar_mbbl_anchor1"])
		mbbl_anchor1:SetPoint("LEFT", mbbl_text, "RIGHT", -10, -3)

		local mbbl_parent = ns.createInputbox("actionbars", 140, 20, LolzenUIcfg.actionbar["actionbar_mbbl_parent"])
		mbbl_parent:SetPoint("LEFT", mbbl_anchor1, "RIGHT", -5, 3)

		local mbbl_anchor2 = ns.createPicker("actionbars", "anchor", "mbbl_anchor2_picker", 100, LolzenUIcfg.actionbar["actionbar_mbbl_anchor2"])
		mbbl_anchor2:SetPoint("LEFT", mbbl_parent, "RIGHT", -10, -3)

		local mbbl_pos_x = ns.createInputbox("actionbars", 30, 20, LolzenUIcfg.actionbar["actionbar_mbbl_posx"])
		mbbl_pos_x:SetPoint("LEFT", mbbl_anchor2, "RIGHT", -5, 3)

		local mbbl_pos_y = ns.createInputbox("actionbars", 30, 20, LolzenUIcfg.actionbar["actionbar_mbbl_posy"])
		mbbl_pos_y:SetPoint("LEFT", mbbl_pos_x, "RIGHT", 10, 0)

		-- // Multi Bar Bottom Right // --

		local mbbr_text = ns.createFonstring("actionbars", "Multi Bar Bottom Right:")
		mbbr_text:SetPoint("TOPLEFT", mbbl_text, "BOTTOMLEFT", 0, -15)

		local mbbr_anchor1 = ns.createPicker("actionbars", "anchor", "mbbr_anchor1_picker", 100, LolzenUIcfg.actionbar["actionbar_mbbr_anchor1"])
		mbbr_anchor1:SetPoint("LEFT", mbbr_text, "RIGHT", -10, -3)

		local mbbr_parent = ns.createInputbox("actionbars", 140, 20, LolzenUIcfg.actionbar["actionbar_mbbr_parent"])
		mbbr_parent:SetPoint("LEFT", mbbr_anchor1, "RIGHT", -5, 3)

		local mbbr_anchor2 = ns.createPicker("actionbars", "anchor", "mbbr_anchor2_picker", 100, LolzenUIcfg.actionbar["actionbar_mbbr_anchor2"])
		mbbr_anchor2:SetPoint("LEFT", mbbr_parent, "RIGHT", -10, -3)

		local mbbr_pos_x = ns.createInputbox("actionbars", 30, 20, LolzenUIcfg.actionbar["actionbar_mbbr_posx"])
		mbbr_pos_x:SetPoint("LEFT", mbbr_anchor2, "RIGHT", -5, 3)

		local mbbr_pos_y = ns.createInputbox("actionbars", 30, 20, LolzenUIcfg.actionbar["actionbar_mbbr_posy"])
		mbbr_pos_y:SetPoint("LEFT", mbbr_pos_x, "RIGHT", 10, 0)

		-- // Multi Bar Left // --

		local mbl_text = ns.createFonstring("actionbars", "Multi Bar Left:")
		mbl_text:SetPoint("TOPLEFT", mbbr_text, "BOTTOMLEFT", 0, -15)

		local mbl_anchor1 = ns.createPicker("actionbars", "anchor", "mbl_anchor1_picker", 100, LolzenUIcfg.actionbar["actionbar_mbl_anchor1"])
		mbl_anchor1:SetPoint("LEFT", mbl_text, "RIGHT", -10, -3)

		local mbl_parent = ns.createInputbox("actionbars", 140, 20, LolzenUIcfg.actionbar["actionbar_mbl_parent"])
		mbl_parent:SetPoint("LEFT", mbl_anchor1, "RIGHT", -5, 3)

		local mbl_anchor2 = ns.createPicker("actionbars", "anchor", "mbl_anchor2_picker", 100, LolzenUIcfg.actionbar["actionbar_mbl_anchor2"])
		mbl_anchor2:SetPoint("LEFT", mbl_parent, "RIGHT", -10, -3)

		local mbl_pos_x = ns.createInputbox("actionbars", 30, 20, LolzenUIcfg.actionbar["actionbar_mbl_posx"])
		mbl_pos_x:SetPoint("LEFT", mbl_anchor2, "RIGHT", -5, 3)

		local mbl_pos_y = ns.createInputbox("actionbars", 30, 20, LolzenUIcfg.actionbar["actionbar_mbl_posy"])
		mbl_pos_y:SetPoint("LEFT", mbl_pos_x, "RIGHT", 10, 0)

		-- // Multi Bar Right // --

		local mbr_text = ns.createFonstring("actionbars", "Multi Bar Right:")
		mbr_text:SetPoint("TOPLEFT", mbl_text, "BOTTOMLEFT", 0, -15)

		local mbr_anchor1 = ns.createPicker("actionbars", "anchor", "mbr_anchor1_picker", 100, LolzenUIcfg.actionbar["actionbar_mbr_anchor1"])
		mbr_anchor1:SetPoint("LEFT", mbr_text, "RIGHT", -10, -3)

		local mbr_parent = ns.createInputbox("actionbars", 140, 20, LolzenUIcfg.actionbar["actionbar_mbr_parent"])
		mbr_parent:SetPoint("LEFT", mbr_anchor1, "RIGHT", -5, 3)

		local mbr_anchor2 = ns.createPicker("actionbars", "anchor", "mbr_anchor2_picker", 100, LolzenUIcfg.actionbar["actionbar_mbr_anchor2"])
		mbr_anchor2:SetPoint("LEFT", mbr_parent, "RIGHT", -10, -3)

		local mbr_pos_x = ns.createInputbox("actionbars", 30, 20, LolzenUIcfg.actionbar["actionbar_mbr_posx"])
		mbr_pos_x:SetPoint("LEFT", mbr_anchor2, "RIGHT", -5, 3)

		local mbr_pos_y = ns.createInputbox("actionbars", 30, 20, LolzenUIcfg.actionbar["actionbar_mbr_posy"])
		mbr_pos_y:SetPoint("LEFT", mbr_pos_x, "RIGHT", 10, 0)

		-- // Pet Bar // --

		local petb_text = ns.createFonstring("actionbars", "Pet Bar:")
		petb_text:SetPoint("TOPLEFT", mbr_text, "BOTTOMLEFT", 0, -15)

		local petb_anchor1 = ns.createPicker("actionbars", "anchor", "petb_anchor1_picker", 100, LolzenUIcfg.actionbar["actionbar_petb_anchor1"])
		petb_anchor1:SetPoint("LEFT", petb_text, "RIGHT", -10, -3)

		local petb_parent = ns.createInputbox("actionbars", 140, 20, LolzenUIcfg.actionbar["actionbar_petb_parent"])
		petb_parent:SetPoint("LEFT", petb_anchor1, "RIGHT", -5, 3)

		local petb_anchor2 = ns.createPicker("actionbars", "anchor", "petb_anchor2_picker", 100, LolzenUIcfg.actionbar["actionbar_petb_anchor2"])
		petb_anchor2:SetPoint("LEFT", petb_parent, "RIGHT", -10, -3)

		local petb_pos_x = ns.createInputbox("actionbars", 30, 20, LolzenUIcfg.actionbar["actionbar_petb_posx"])
		petb_pos_x:SetPoint("LEFT", petb_anchor2, "RIGHT", -5, 3)

		local petb_pos_y = ns.createInputbox("actionbars", 30, 20, LolzenUIcfg.actionbar["actionbar_petb_posy"])
		petb_pos_y:SetPoint("LEFT", petb_pos_x, "RIGHT", 10, 0)

		-- // Possess Bar // --

		local pb_text = ns.createFonstring("actionbars", "Possess Bar:")
		pb_text:SetPoint("TOPLEFT", petb_text, "BOTTOMLEFT", 0, -15)

		local pb_anchor1 = ns.createPicker("actionbars", "anchor", "pb_anchor1_picker", 100, LolzenUIcfg.actionbar["actionbar_pb_anchor1"])
		pb_anchor1:SetPoint("LEFT", pb_text, "RIGHT", -10, -3)

		local pb_parent = ns.createInputbox("actionbars", 140, 20, LolzenUIcfg.actionbar["actionbar_pb_parent"])
		pb_parent:SetPoint("LEFT", pb_anchor1, "RIGHT", -5, 3)

		local pb_anchor2 = ns.createPicker("actionbars", "anchor", "pb_anchor2_picker", 100, LolzenUIcfg.actionbar["actionbar_pb_anchor2"])
		pb_anchor2:SetPoint("LEFT", pb_parent, "RIGHT", -10, -3)

		local pb_pos_x = ns.createInputbox("actionbars", 30, 20, LolzenUIcfg.actionbar["actionbar_pb_posx"])
		pb_pos_x:SetPoint("LEFT", pb_anchor2, "RIGHT", -5, 3)

		local pb_pos_y = ns.createInputbox("actionbars", 30, 20, LolzenUIcfg.actionbar["actionbar_pb_posy"])
		pb_pos_y:SetPoint("LEFT", pb_pos_x, "RIGHT", 10, 0)

		ns["actionbars"].okay = function(self)
			LolzenUIcfg.actionbar["actionbar_normal_texture"] = normaltex_path:GetText()
			LolzenUIcfg.actionbar["actionbar_flash_texture"] = flashtex_path:GetText()
			LolzenUIcfg.actionbar["actionbar_checked_texture"] = checkedtex_path:GetText()
			LolzenUIcfg.actionbar["actionbar_hover_texture"] = hovertex_path:GetText()
			LolzenUIcfg.actionbar["actionbar_pushed_texture"] = pushedtex_path:GetText()
			LolzenUIcfg.actionbar["actionbar_button_spacing"] = spacing:GetText()
			LolzenUIcfg.actionbar["actionbar_button_size"] = size:GetText()
			LolzenUIcfg.actionbar["actionbar_mmb_anchor1"] = ns.picker_anchor[UIDropDownMenu_GetSelectedID(mmb_anchor1)]
			LolzenUIcfg.actionbar["actionbar_mmb_parent"] = mmb_parent:GetText()
			LolzenUIcfg.actionbar["actionbar_mmb_anchor2"] = ns.picker_anchor[UIDropDownMenu_GetSelectedID(mmb_anchor2)]
			LolzenUIcfg.actionbar["actionbar_mmb_posx"] = tonumber(mmb_pos_x:GetText())
			LolzenUIcfg.actionbar["actionbar_mmb_posy"] = tonumber(mmb_pos_y:GetText())
			LolzenUIcfg.actionbar["actionbar_mbbl_anchor1"] = ns.picker_anchor[UIDropDownMenu_GetSelectedID(mbbl_anchor1)]
			LolzenUIcfg.actionbar["actionbar_mbbl_parent"] = mbbl_parent:GetText()
			LolzenUIcfg.actionbar["actionbar_mbbl_anchor2"] = ns.picker_anchor[UIDropDownMenu_GetSelectedID(mbbl_anchor2)]
			LolzenUIcfg.actionbar["actionbar_mbbl_posx"] = tonumber(mbbl_pos_x:GetText())
			LolzenUIcfg.actionbar["actionbar_mbbl_posy"] = tonumber(mbbl_pos_y:GetText())
			LolzenUIcfg.actionbar["actionbar_mbbr_anchor1"] = ns.picker_anchor[UIDropDownMenu_GetSelectedID(mbbr_anchor1)]
			LolzenUIcfg.actionbar["actionbar_mbbr_parent"] = mbbr_parent:GetText()
			LolzenUIcfg.actionbar["actionbar_mbbr_anchor2"] = ns.picker_anchor[UIDropDownMenu_GetSelectedID(mbbr_anchor2)]
			LolzenUIcfg.actionbar["actionbar_mbbr_posx"] = tonumber(mbbr_pos_x:GetText())
			LolzenUIcfg.actionbar["actionbar_mbbr_posy"] = tonumber(mbbr_pos_y:GetText())
			LolzenUIcfg.actionbar["actionbar_mbl_anchor1"] = ns.picker_anchor[UIDropDownMenu_GetSelectedID(mbl_anchor1)]
			LolzenUIcfg.actionbar["actionbar_mbl_parent"] = mbl_parent:GetText()
			LolzenUIcfg.actionbar["actionbar_mbl_anchor2"] = ns.picker_anchor[UIDropDownMenu_GetSelectedID(mbl_anchor2)]
			LolzenUIcfg.actionbar["actionbar_mbl_posx"] = tonumber(mbl_pos_x:GetText())
			LolzenUIcfg.actionbar["actionbar_mbl_posy"] = tonumber(mbl_pos_y:GetText())
			LolzenUIcfg.actionbar["actionbar_mbr_anchor1"] = ns.picker_anchor[UIDropDownMenu_GetSelectedID(mbr_anchor1)]
			LolzenUIcfg.actionbar["actionbar_mbr_parent"] = mbr_parent:GetText()
			LolzenUIcfg.actionbar["actionbar_mbr_anchor2"] = ns.picker_anchor[UIDropDownMenu_GetSelectedID(mbr_anchor2)]
			LolzenUIcfg.actionbar["actionbar_mbr_posx"] = tonumber(mbr_pos_x:GetText())
			LolzenUIcfg.actionbar["actionbar_mbr_posy"] = tonumber(mbr_pos_y:GetText())
			LolzenUIcfg.actionbar["actionbar_petb_anchor1"] = ns.picker_anchor[UIDropDownMenu_GetSelectedID(petb_anchor1)]
			LolzenUIcfg.actionbar["actionbar_petb_parent"] = petb_parent:GetText()
			LolzenUIcfg.actionbar["actionbar_petb_anchor2"] = ns.picker_anchor[UIDropDownMenu_GetSelectedID(petb_anchor2)]
			LolzenUIcfg.actionbar["actionbar_petb_posx"] = tonumber(petb_pos_x:GetText())
			LolzenUIcfg.actionbar["actionbar_petb_posy"] = tonumber(petb_pos_y:GetText())
			LolzenUIcfg.actionbar["actionbar_pb_anchor1"] = ns.picker_anchor[UIDropDownMenu_GetSelectedID(pb_anchor1)]
			LolzenUIcfg.actionbar["actionbar_pb_parent"] = pb_parent:GetText()
			LolzenUIcfg.actionbar["actionbar_pb_anchor2"] = ns.picker_anchor[UIDropDownMenu_GetSelectedID(pb_anchor2)]
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