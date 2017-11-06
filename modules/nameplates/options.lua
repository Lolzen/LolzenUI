--// options for nameplates //--

local addon, ns = ...

ns.RegisterModule("nameplates")

local f = CreateFrame("Frame")
f:RegisterEvent("ADDON_LOADED")
f:SetScript("OnEvent", function(self, event, addon)
	if addon == "LolzenUI" and LolzenUIcfg.modules["nameplates"] == true then

		local title = ns.createTitle("nameplates")

		local about = ns.createDescription("nameplates", "Modifies the Nameplates")
		about:SetPoint("TOPLEFT", title, "BOTTOMLEFT", 0, -8)

		local header1 = ns.createHeader("nameplates", "Preview:")
		header1:SetPoint("TOPLEFT", about, "BOTTOMLEFT", 0, -20)

		local prev_np_frame = CreateFrame("Frame", nil, ns["nameplates"])
		prev_np_frame:SetSize(LolzenUIcfg.nameplates["np_width"]*LolzenUIcfg.nameplates["np_selected_scale"], LolzenUIcfg.nameplates["np_height"]*LolzenUIcfg.nameplates["np_selected_scale"])
		prev_np_frame:SetPoint("TOPLEFT", header1, "BOTTOMLEFT", 0, -10)

		local prev_np = prev_np_frame:CreateTexture(nil, "BACKGROUND")
		prev_np:SetAllPoints(prev_np_frame)
		prev_np:SetTexture("Interface\\AddOns\\LolzenUI\\media\\"..LolzenUIcfg.nameplates["np_texture"])
		prev_np:SetVertexColor(0.6, 0.1, 0)

		local prev_np_lvlname = prev_np_frame:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
		prev_np_lvlname:SetFont("Interface\\AddOns\\LolzenUI\\fonts\\"..LolzenUIcfg.nameplates["np_lvlname_font"], LolzenUIcfg.nameplates["np_lvlname_font_size"]*LolzenUIcfg.nameplates["np_selected_scale"], LolzenUIcfg.nameplates["np_lvlname_font_flag"])
		prev_np_lvlname:SetText("|cffffff00110|r + Random Name")
		prev_np_lvlname:SetPoint(LolzenUIcfg.nameplates["np_lvlname_anchor"], prev_np_frame, LolzenUIcfg.nameplates["np_lvlname_posx"], LolzenUIcfg.nameplates["np_lvlname_posy"])

		local prev_np_threatglow = CreateFrame("Frame", nil, ns["nameplates"])
		prev_np_threatglow:SetFrameStrata("BACKGROUND")
		prev_np_threatglow:SetBackdrop({
			edgeFile ="Interface\\AddOns\\LolzenUI\\media\\glow", edgeSize = 5,
			insets = {left = 4, right = 4, top = 4, bottom = 4}
		})
		prev_np_threatglow:SetPoint("TOPLEFT", prev_np, -5, 5)
		prev_np_threatglow:SetPoint("BOTTOMRIGHT", prev_np, 5, -5)
		prev_np_threatglow:SetBackdropBorderColor(6, 0, 0)

		local prev_np_targetindicator = prev_np_frame:CreateTexture(nil, "OVERLAY")
		prev_np_targetindicator:SetTexture("Interface\\AddOns\\LolzenUI\\media\\target-glow")
		prev_np_targetindicator:SetPoint("CENTER", prev_np, 0, -3*LolzenUIcfg.nameplates["np_selected_scale"])
		prev_np_targetindicator:SetSize(LolzenUIcfg.nameplates["np_width"]*LolzenUIcfg.nameplates["np_selected_scale"], LolzenUIcfg.nameplates["np_height"]*LolzenUIcfg.nameplates["np_selected_scale"])
		prev_np_targetindicator:SetVertexColor(48/255, 113/255, 191/255)

		local prev_np_raidmark = prev_np_frame:CreateTexture(nil, "OVERLAY")
		prev_np_raidmark:SetTexture("Interface\\TargetingFrame\\UI-RaidTargetingIcon_8")
		prev_np_raidmark:SetPoint(LolzenUIcfg.nameplates["np_raidmark_anchor"], prev_np, LolzenUIcfg.nameplates["np_raidmark_posx"], LolzenUIcfg.nameplates["np_raidmark_posy"])
		prev_np_raidmark:SetSize(LolzenUIcfg.nameplates["np_raidmark_size"], LolzenUIcfg.nameplates["np_raidmark_size"])

		local cb1 = ns.createCheckBox("nameplates", "targetindicator", "|cff5599ffTarget indicator on target nameplate|r", LolzenUIcfg.nameplates["np_targetindicator"])
		cb1:SetPoint("TOPLEFT", prev_np, "BOTTOMLEFT", 0, -20)

		cb1:SetScript("OnClick", function(self)
			if cb1:GetChecked() == false then
				prev_np_targetindicator:Hide()
			else
				prev_np_targetindicator:Show()
			end
		end)

		if cb1:GetChecked() == false then
			prev_np_targetindicator:Hide()
		else
			prev_np_targetindicator:Show()
		end

		local cb2 = ns.createCheckBox("nameplates", "threatindicator", "|cff5599ffThreat Glow border|r", LolzenUIcfg.nameplates["np_threatindicator"])
		cb2:SetPoint("TOPLEFT", cb1, "BOTTOMLEFT", 0, 0)

		cb2:SetScript("OnClick", function(self)
			if cb2:GetChecked() == false then
				prev_np_threatglow:Hide()
			else
				prev_np_threatglow:Show()
			end
		end)

		if cb2:GetChecked() == false then
			prev_np_threatglow:Hide()
		else
			prev_np_threatglow:Show()
		end

		local header2 = ns.createHeader("nameplates", "Nameplates General")
		header2:SetPoint("TOPLEFT", cb2, "BOTTOMLEFT", 0, -20)

		local height_text = ns.createFonstring("nameplates", "Height:")
		height_text:SetPoint("TOPLEFT", header2, "BOTTOMLEFT", 0, -10)

		local height = ns.createInputbox("nameplates", 40, 20, LolzenUIcfg.nameplates["np_height"])
		height:SetPoint("LEFT", height_text, "RIGHT", 10, 0)

		local width_text = ns.createFonstring("nameplates", "Width:")
		width_text:SetPoint("LEFT", height, "RIGHT", 10, 0)

		local width = ns.createInputbox("nameplates", 40, 20, LolzenUIcfg.nameplates["np_width"])
		width:SetPoint("LEFT", width_text, "RIGHT", 10, 0)

		local texture_text = ns.createFonstring("nameplates", "Texture:")
		texture_text:SetPoint("LEFT", width, "RIGHT", 10, 0)

		local texture = ns.createInputbox("nameplates", 100, 20, LolzenUIcfg.nameplates["np_texture"])
		texture:SetPoint("LEFT", texture_text, "RIGHT", 10, 0)

		local selected_text = ns.createFonstring("nameplates", "Target nameplate scale:")
		selected_text:SetPoint("LEFT", texture, "RIGHT", 10, 0)

		local selected = ns.createInputbox("nameplates", 30, 20, LolzenUIcfg.nameplates["np_selected_scale"])
		selected:SetPoint("LEFT", selected_text, "RIGHT", 10, 0)

		local header3 = ns.createHeader("nameplates", "Level & Name")
		header3:SetPoint("TOPLEFT", height_text, "BOTTOMLEFT", 0, -30)

		local lvlname_font_text = ns.createFonstring("nameplates", "Font:")
		lvlname_font_text:SetPoint("TOPLEFT", header3, "BOTTOMLEFT", 0, -10)

		local lvlname_font = ns.createPicker("nameplates", "font", "lvlname_font", 120, LolzenUIcfg.nameplates["np_lvlname_font"])
		lvlname_font:SetPoint("LEFT", lvlname_font_text, "RIGHT", -10, -3)

		local lvlname_font_size_text = ns.createFonstring("nameplates", "Size:")
		lvlname_font_size_text:SetPoint("LEFT", lvlname_font, "RIGHT", -10, 3)

		local lvlname_font_size = ns.createInputbox("nameplates", 30, 20, LolzenUIcfg.nameplates["np_lvlname_font_size"])
		lvlname_font_size:SetPoint("LEFT", lvlname_font_size_text, "RIGHT", 10, 0)

		local lvlname_font_flag_text = ns.createFonstring("nameplates", "Flag:")
		lvlname_font_flag_text:SetPoint("LEFT", lvlname_font_size, "RIGHT", 10, 0)

		local lvlname_font_flag = ns.createPicker("nameplates", "flag", "lvlname_font_flag", 120, LolzenUIcfg.nameplates["np_lvlname_font_flag"])
		lvlname_font_flag:SetPoint("LEFT", lvlname_font_flag_text, "RIGHT", -10, -3)

		local lvlname_pos_x_text = ns.createFonstring("nameplates", "PosX:")
		lvlname_pos_x_text:SetPoint("TOPLEFT", lvlname_font_text, "BOTTOMLEFT", 0, -15)

		local lvlname_pos_x = ns.createInputbox("nameplates", 30, 20, LolzenUIcfg.nameplates["np_lvlname_posx"])
		lvlname_pos_x:SetPoint("LEFT", lvlname_pos_x_text, "RIGHT", 10, 0)

		local lvlname_pos_y_text = ns.createFonstring("nameplates", "PosY:")
		lvlname_pos_y_text:SetPoint("LEFT", lvlname_pos_x, "RIGHT", 5, 0)

		local lvlname_pos_y = ns.createInputbox("nameplates", 30, 20, LolzenUIcfg.nameplates["np_lvlname_posy"])
		lvlname_pos_y:SetPoint("LEFT", lvlname_pos_y_text, "RIGHT", 10, 0)

		local lvlname_anchor_text = ns.createFonstring("nameplates", "Anchor1:")
		lvlname_anchor_text:SetPoint("LEFT", lvlname_pos_y, "RIGHT", 10, 0)

		local lvlname_anchor = ns.createPicker("nameplates", "anchor", "nameplates_lvlname_anchor1", 110, LolzenUIcfg.nameplates["np_lvlname_anchor"])
		lvlname_anchor:SetPoint("LEFT", lvlname_anchor_text, "RIGHT", -10, -3)

		local header4 = ns.createHeader("nameplates", "Raidmark")
		header4:SetPoint("TOPLEFT", lvlname_pos_x_text, "BOTTOMLEFT", 0, -30)

		local cb3 = ns.createCheckBox("nameplates", "raidtargetindicator", "|cff5599ffShow raid mark indicators|r", LolzenUIcfg.nameplates["np_raidtargetindicator"])
		cb3:SetPoint("TOPLEFT", header4, "BOTTOMLEFT", 0, -5)

		cb3:SetScript("OnClick", function(self)
			if cb3:GetChecked() == false then
				prev_np_raidmark:Hide()
			else
				prev_np_raidmark:Show()
			end
		end)

		if cb3:GetChecked() == false then
			prev_np_raidmark:Hide()
		else
			prev_np_raidmark:Show()
		end

		local rt_size_text = ns.createFonstring("nameplates", "Size:")
		rt_size_text:SetPoint("TOPLEFT", cb3, "BOTTOMLEFT", 0, 0)

		local rt_size = ns.createInputbox("nameplates", 30, 20, LolzenUIcfg.nameplates["np_raidmark_size"])
		rt_size:SetPoint("LEFT", rt_size_text, "RIGHT", 10, 0)

		local rt_pos_x_text = ns.createFonstring("nameplates", "PosX:")
		rt_pos_x_text:SetPoint("LEFT", rt_size, "RIGHT", 10, 0)

		local rt_pos_x = ns.createInputbox("nameplates", 30, 20, LolzenUIcfg.nameplates["np_raidmark_posx"])
		rt_pos_x:SetPoint("LEFT", rt_pos_x_text, "RIGHT", 10, 0)

		local rt_pos_y_text = ns.createFonstring("nameplates", "PosY:")
		rt_pos_y_text:SetPoint("LEFT", rt_pos_x, "RIGHT", 5, 0)

		local rt_pos_y = ns.createInputbox("nameplates", 30, 20, LolzenUIcfg.nameplates["np_raidmark_posy"])
		rt_pos_y:SetPoint("LEFT", rt_pos_y_text, "RIGHT", 10, 0)

		local rt_anchor_text = ns.createFonstring("nameplates", "Anchor:")
		rt_anchor_text:SetPoint("LEFT", rt_pos_y, "RIGHT", 10, 0)

		local rt_anchor = ns.createPicker("nameplates", "anchor", "nameplates_raidmark_anchor", 110, LolzenUIcfg.nameplates["np_raidmark_anchor"])
		rt_anchor:SetPoint("LEFT", rt_anchor_text, "RIGHT", -10, -3)

		-- // Create a subcategory panel for Castbar // --
		ns.np_castbar_options = CreateFrame("Frame", "nameplates_castbarpanel", ns["nameplates"])
		ns.np_castbar_options.name = "   Castbar"
		ns.np_castbar_options.parent = "nameplates"
		InterfaceOptions_AddCategory(ns.np_castbar_options)

		local cb_title = ns.np_castbar_options:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
		cb_title:SetPoint("TOPLEFT", ns.np_castbar_options, 16, -16)
		cb_title:SetText("|cff5599ffNameplates module: Castbar Options|r")

		local cb_header1 = ns.createHeader("np_castbar_options", "Preview:")
		cb_header1:SetPoint("TOPLEFT", cb_title, "BOTTOMLEFT", 0, -40)

		local cb_prev_np_frame = CreateFrame("Frame", nil, ns["np_castbar_options"])
		cb_prev_np_frame:SetSize(LolzenUIcfg.nameplates["np_width"]*LolzenUIcfg.nameplates["np_selected_scale"], LolzenUIcfg.nameplates["np_height"]*LolzenUIcfg.nameplates["np_selected_scale"])
		cb_prev_np_frame:SetPoint("TOPLEFT", cb_header1, "BOTTOMLEFT", 20, -10)

		local cb_prev_np = cb_prev_np_frame:CreateTexture(nil, "BACKGROUND")
		cb_prev_np:SetAllPoints(cb_prev_np_frame)
		cb_prev_np:SetTexture("Interface\\AddOns\\LolzenUI\\media\\"..LolzenUIcfg.nameplates["np_texture"])
		cb_prev_np:SetVertexColor(0.6, 0.1, 0)

		local cb_prev_np_lvlname = cb_prev_np_frame:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
		cb_prev_np_lvlname:SetFont("Interface\\AddOns\\LolzenUI\\fonts\\"..LolzenUIcfg.nameplates["np_lvlname_font"], LolzenUIcfg.nameplates["np_lvlname_font_size"]*LolzenUIcfg.nameplates["np_selected_scale"], LolzenUIcfg.nameplates["np_lvlname_font_flag"])
		cb_prev_np_lvlname:SetText("|cffffff00110|r + Random Name")
		cb_prev_np_lvlname:SetPoint("CENTER", cb_prev_np_frame, 0, 3)

		local cb_prev_np_cb = cb_prev_np_frame:CreateTexture(nil, "BACKGROUND")
		cb_prev_np_cb:SetSize(LolzenUIcfg.nameplates["np_cb_width"]*LolzenUIcfg.nameplates["np_selected_scale"], LolzenUIcfg.nameplates["np_cb_height"]*LolzenUIcfg.nameplates["np_selected_scale"])
		cb_prev_np_cb:SetPoint(LolzenUIcfg.nameplates["np_cb_anchor"], cb_prev_np_frame, LolzenUIcfg.nameplates["np_cb_anchor2"], LolzenUIcfg.nameplates["np_cb_posx"], LolzenUIcfg.nameplates["np_cb_posy"])
		cb_prev_np_cb:SetTexture("Interface\\AddOns\\LolzenUI\\media\\"..LolzenUIcfg.nameplates["np_cb_texture"])

		local cb_prev_np_spark = cb_prev_np_frame:CreateTexture(nil, "BACKGROUND")
		cb_prev_np_spark:SetSize(LolzenUIcfg.nameplates["np_spark_width"]*LolzenUIcfg.nameplates["np_selected_scale"], LolzenUIcfg.nameplates["np_spark_height"]*LolzenUIcfg.nameplates["np_selected_scale"])
		cb_prev_np_spark:SetPoint("RIGHT", cb_prev_np_cb, "RIGHT", LolzenUIcfg.nameplates["np_spark_width"]*LolzenUIcfg.nameplates["np_selected_scale"]/2, 0)
		cb_prev_np_spark:SetBlendMode("ADD")
		cb_prev_np_spark:SetTexture('Interface\\CastingBar\\UI-CastingBar-Spark')

		local cb_prev_np_icon = ns.createButtonTexture("np_castbar_options", LolzenUIcfg.nameplates["np_cbicon_size"]*LolzenUIcfg.nameplates["np_selected_scale"], select(3, GetSpellInfo(214815)))
		cb_prev_np_icon:SetPoint(LolzenUIcfg.nameplates["np_cbicon_anchor"], cb_prev_np_frame, LolzenUIcfg.nameplates["np_cbicon_anchor2"], LolzenUIcfg.nameplates["np_cbicon_posx"], LolzenUIcfg.nameplates["np_cbicon_posy"])

		local cb_prev_np_shield = cb_prev_np_frame:CreateTexture(nil, "BACKGROUND")
		cb_prev_np_shield:SetSize(LolzenUIcfg.nameplates["np_cbicon_size"]*3*LolzenUIcfg.nameplates["np_selected_scale"], LolzenUIcfg.nameplates["np_cbicon_size"]*3*LolzenUIcfg.nameplates["np_selected_scale"])
		cb_prev_np_shield:SetTexture("Interface\\AddOns\\LolzenUI\\media\\shield")
		cb_prev_np_shield:SetPoint("CENTER", cb_prev_np_icon, 0, 0)

		local cb_prev_np_time = ns.createFonstring("np_castbar_options", "3.0")
		cb_prev_np_time:SetFont("Interface\\AddOns\\LolzenUI\\fonts\\"..LolzenUIcfg.nameplates["np_cbtime_font"], LolzenUIcfg.nameplates["np_cbtime_font_size"]*LolzenUIcfg.nameplates["np_selected_scale"] , LolzenUIcfg.nameplates["np_cbtime_font_flag"])
		cb_prev_np_time:SetPoint(LolzenUIcfg.nameplates["np_cbtime_anchor"], cb_prev_np_cb, LolzenUIcfg.nameplates["np_cbtime_anchor2"], LolzenUIcfg.nameplates["np_cbtime_posx"]*LolzenUIcfg.nameplates["np_selected_scale"], LolzenUIcfg.nameplates["np_cbtime_posy"]*LolzenUIcfg.nameplates["np_selected_scale"])

		local cb_prev_np_text = ns.createFonstring("np_castbar_options", "Random Castname")
		cb_prev_np_text:SetFont("Interface\\AddOns\\LolzenUI\\fonts\\"..LolzenUIcfg.nameplates["np_cbtext_font"], LolzenUIcfg.nameplates["np_cbtext_font_size"]*LolzenUIcfg.nameplates["np_selected_scale"] , LolzenUIcfg.nameplates["np_cbtext_font_flag"])
		cb_prev_np_text:SetPoint("RIGHT", cb_prev_np_cb, "RIGHT", -2*LolzenUIcfg.nameplates["np_selected_scale"], -5*LolzenUIcfg.nameplates["np_selected_scale"])

		local cb_pos_x_text = ns.createFonstring("np_castbar_options", "PosX:")
		cb_pos_x_text:SetPoint("TOPLEFT", cb_prev_np_frame, "BOTTOMLEFT", -20, -30)

		local cb_pos_x = ns.createInputbox("np_castbar_options", 30, 20, LolzenUIcfg.nameplates["np_cb_posx"])
		cb_pos_x:SetPoint("LEFT", cb_pos_x_text, "RIGHT", 10, 0)

		local cb_pos_y_text = ns.createFonstring("np_castbar_options", "PosY:")
		cb_pos_y_text:SetPoint("LEFT", cb_pos_x, "RIGHT", 10, 0)

		local cb_pos_y = ns.createInputbox("np_castbar_options", 30, 20, LolzenUIcfg.nameplates["np_cb_posy"])
		cb_pos_y:SetPoint("LEFT", cb_pos_y_text, "RIGHT", 10, 0)

		local cb_anchor_text = ns.createFonstring("np_castbar_options", "Anchor1:")
		cb_anchor_text:SetPoint("LEFT", cb_pos_y, "RIGHT", 10, 0)

		local cb_anchor = ns.createPicker("np_castbar_options", "anchor", "nameplates_castbar_anchor_bar1", 110, LolzenUIcfg.nameplates["np_cb_anchor"])
		cb_anchor:SetPoint("LEFT", cb_anchor_text, "RIGHT", -10, -3)

		local cb_anchor_text2 = ns.createFonstring("np_castbar_options", "Anchor2:")
		cb_anchor_text2:SetPoint("LEFT", cb_anchor, "RIGHT", -5, 3)

		local cb_anchor2 = ns.createPicker("np_castbar_options", "anchor", "nameplates_castbar_anchor_bar2", 110, LolzenUIcfg.nameplates["np_cb_anchor2"])
		cb_anchor2:SetPoint("LEFT", cb_anchor_text2, "RIGHT", -10, -3)

		local cb_texture_text = ns.createFonstring("np_castbar_options", "Texture:")
		cb_texture_text:SetPoint("TOPLEFT", cb_pos_x_text, "BOTTOMLEFT", 0, -15)

		local cb_texture = ns.createInputbox("np_castbar_options", 100, 20, LolzenUIcfg.nameplates["np_cb_texture"])
		cb_texture:SetPoint("LEFT", cb_texture_text, "RIGHT", 10, 0)

		local cb_height_text = ns.createFonstring("np_castbar_options", "Height:")
		cb_height_text:SetPoint("LEFT", cb_texture, "RIGHT", 10, 0)

		local cb_height = ns.createInputbox("np_castbar_options", 40, 20, LolzenUIcfg.nameplates["np_cb_height"])
		cb_height:SetPoint("LEFT", cb_height_text, "RIGHT", 10, 0)

		local cb_width_text = ns.createFonstring("np_castbar_options", "Width:")
		cb_width_text:SetPoint("LEFT", cb_height, "RIGHT", 10, 0)

		local cb_width = ns.createInputbox("np_castbar_options", 40, 20, LolzenUIcfg.nameplates["np_cb_width"])
		cb_width:SetPoint("LEFT", cb_width_text, "RIGHT", 10, 0)

		local cb_header2 = ns.createHeader("np_castbar_options", "Spark")
		cb_header2:SetPoint("TOPLEFT", cb_texture_text, "BOTTOMLEFT", 0, -30)

		local cb_spark_height_text = ns.createFonstring("np_castbar_options", "Height:")
		cb_spark_height_text:SetPoint("TOPLEFT", cb_header2, "BOTTOMLEFT", 0, -10)

		local cb_spark_height = ns.createInputbox("np_castbar_options", 30, 20, LolzenUIcfg.nameplates["np_spark_height"])
		cb_spark_height:SetPoint("LEFT", cb_spark_height_text, "RIGHT", 10, 0)

		local cb_spark_width_text = ns.createFonstring("np_castbar_options", "Width:")
		cb_spark_width_text:SetPoint("LEFT", cb_spark_height, "RIGHT", 10, 0)

		local cb_spark_width = ns.createInputbox("np_castbar_options", 30, 20, LolzenUIcfg.nameplates["np_spark_width"])
		cb_spark_width:SetPoint("LEFT", cb_spark_width_text, "RIGHT", 10, 0)

		local cb_header3 = ns.createHeader("np_castbar_options", "Icon")
		cb_header3:SetPoint("TOPLEFT", cb_spark_height_text, "BOTTOMLEFT", 0, -30)

		local cb_icon_size_text = ns.createFonstring("np_castbar_options", "Size:")
		cb_icon_size_text:SetPoint("TOPLEFT", cb_header3, "BOTTOMLEFT", 0, -10)

		local cb_icon_size = ns.createInputbox("np_castbar_options", 30, 20, LolzenUIcfg.nameplates["np_cbicon_size"])
		cb_icon_size:SetPoint("LEFT", cb_icon_size_text, "RIGHT", 10, 0)

		local cb_icon_pos_x_text = ns.createFonstring("np_castbar_options", "PosX:")
		cb_icon_pos_x_text:SetPoint("LEFT", cb_icon_size, "RIGHT", 5, 0)

		local cb_icon_pos_x = ns.createInputbox("np_castbar_options", 30, 20, LolzenUIcfg.nameplates["np_cbicon_posx"])
		cb_icon_pos_x:SetPoint("LEFT", cb_icon_pos_x_text, "RIGHT", 10, 0)

		local cb_icon_pos_y_text = ns.createFonstring("np_castbar_options", "PosY:")
		cb_icon_pos_y_text:SetPoint("LEFT", cb_icon_pos_x, "RIGHT", 5, 0)

		local cb_icon_pos_y = ns.createInputbox("np_castbar_options", 30, 20, LolzenUIcfg.nameplates["np_cbicon_posy"])
		cb_icon_pos_y:SetPoint("LEFT", cb_icon_pos_y_text, "RIGHT", 10, 0)

		local cb_icon_anchor_text = ns.createFonstring("np_castbar_options", "Anchor1:")
		cb_icon_anchor_text:SetPoint("LEFT", cb_icon_pos_y, "RIGHT", 10, 0)

		local cb_icon_anchor = ns.createPicker("np_castbar_options", "anchor", "nameplates_castbar_icon_anchor1", 110, LolzenUIcfg.nameplates["np_cbicon_anchor"])
		cb_icon_anchor:SetPoint("LEFT", cb_icon_anchor_text, "RIGHT", -10, -3)

		local cb_icon_anchor_text2 = ns.createFonstring("np_castbar_options", "Anchor2:")
		cb_icon_anchor_text2:SetPoint("LEFT", cb_icon_anchor, "RIGHT", -5, 3)

		local cb_icon_anchor2 = ns.createPicker("np_castbar_options", "anchor", "nameplates_castbar_icon_anchor2", 110, LolzenUIcfg.nameplates["np_cbicon_anchor2"])
		cb_icon_anchor2:SetPoint("LEFT", cb_icon_anchor_text2, "RIGHT", -10, -3)

		local cb_header4 = ns.createHeader("np_castbar_options", "Time")
		cb_header4:SetPoint("TOPLEFT", cb_icon_size_text, "BOTTOMLEFT", 0, -30)

		local cb_time_font_text = ns.createFonstring("np_castbar_options", "Font:")
		cb_time_font_text:SetPoint("TOPLEFT", cb_header4, "BOTTOMLEFT", 0, -10)

		local cb_time_font = ns.createPicker("np_castbar_options", "font", "cb_time_font", 120, LolzenUIcfg.nameplates["np_cbtime_font"])
		cb_time_font:SetPoint("LEFT", cb_time_font_text, "RIGHT", -10, -3)

		local cb_time_font_size_text = ns.createFonstring("np_castbar_options", "Size:")
		cb_time_font_size_text:SetPoint("LEFT", cb_time_font, "RIGHT", -10, 3)

		local cb_time_font_size = ns.createInputbox("np_castbar_options", 30, 20, LolzenUIcfg.nameplates["np_cbtime_font_size"])
		cb_time_font_size:SetPoint("LEFT", cb_time_font_size_text, "RIGHT", 10, 0)

		local cb_time_font_flag_text = ns.createFonstring("np_castbar_options", "Flag:")
		cb_time_font_flag_text:SetPoint("LEFT", cb_time_font_size, "RIGHT", 10, 0)

		local cb_time_font_flag = ns.createPicker("np_castbar_options", "flag", "cb_time_font_flag", 120, LolzenUIcfg.nameplates["np_cbtime_font_flag"])
		cb_time_font_flag:SetPoint("LEFT", cb_time_font_flag_text, "RIGHT", -10, -3)

		local cb_time_pos_x_text = ns.createFonstring("np_castbar_options", "PosX:")
		cb_time_pos_x_text:SetPoint("TOPLEFT", cb_time_font_text, "BOTTOMLEFT", 0, -15)

		local cb_time_pos_x = ns.createInputbox("np_castbar_options", 30, 20, LolzenUIcfg.nameplates["np_cbtime_posx"])
		cb_time_pos_x:SetPoint("LEFT", cb_time_pos_x_text, "RIGHT", 10, 0)

		local cb_time_pos_y_text = ns.createFonstring("np_castbar_options", "PosY:")
		cb_time_pos_y_text:SetPoint("LEFT", cb_time_pos_x, "RIGHT", 5, 0)

		local cb_time_pos_y = ns.createInputbox("np_castbar_options", 30, 20, LolzenUIcfg.nameplates["np_cbtime_posy"])
		cb_time_pos_y:SetPoint("LEFT", cb_time_pos_y_text, "RIGHT", 10, 0)

		local cb_time_anchor_text = ns.createFonstring("np_castbar_options", "Anchor1:")
		cb_time_anchor_text:SetPoint("LEFT", cb_time_pos_y, "RIGHT", 10, 0)

		local cb_time_anchor = ns.createPicker("np_castbar_options", "anchor", "nameplates_castbar_time_anchor1", 110, LolzenUIcfg.nameplates["np_cbtime_anchor"])
		cb_time_anchor:SetPoint("LEFT", cb_time_anchor_text, "RIGHT", -10, -3)

		local cb_time_anchor_text2 = ns.createFonstring("np_castbar_options", "Anchor2:")
		cb_time_anchor_text2:SetPoint("LEFT", cb_time_anchor, "RIGHT", -5, 3)

		local cb_time_anchor2 = ns.createPicker("np_castbar_options", "anchor", "nameplates_castbar_time_anchor2", 110, LolzenUIcfg.nameplates["np_cbtime_anchor2"])
		cb_time_anchor2:SetPoint("LEFT", cb_time_anchor_text2, "RIGHT", -10, -3)

		local cb_header5 = ns.createHeader("np_castbar_options", "Text")
		cb_header5:SetPoint("TOPLEFT", cb_time_pos_x_text, "BOTTOMLEFT", 0, -30)

		local cb_text_font_text = ns.createFonstring("np_castbar_options", "Font:")
		cb_text_font_text:SetPoint("TOPLEFT", cb_header5, "BOTTOMLEFT", 0, -10)

		local cb_text_font = ns.createPicker("np_castbar_options", "font", "cb_text_font", 120, LolzenUIcfg.nameplates["np_cbtext_font"])
		cb_text_font:SetPoint("LEFT", cb_text_font_text, "RIGHT", -10, -3)

		local cb_text_font_size_text = ns.createFonstring("np_castbar_options", "Size:")
		cb_text_font_size_text:SetPoint("LEFT", cb_text_font, "RIGHT", -10, 3)

		local cb_text_font_size = ns.createInputbox("np_castbar_options", 30, 20, LolzenUIcfg.nameplates["np_cbtext_font_size"])
		cb_text_font_size:SetPoint("LEFT", cb_text_font_size_text, "RIGHT", 10, 0)

		local cb_text_font_flag_text = ns.createFonstring("np_castbar_options", "Flag:")
		cb_text_font_flag_text:SetPoint("LEFT", cb_text_font_size, "RIGHT", 10, 0)

		local cb_text_font_flag = ns.createPicker("np_castbar_options", "flag", "cb_text_font_flag", 120, LolzenUIcfg.nameplates["np_cbtext_font_flag"])
		cb_text_font_flag:SetPoint("LEFT", cb_text_font_flag_text, "RIGHT", -10, -3)

		local cb_text_pos_x_text = ns.createFonstring("np_castbar_options", "PosX:")
		cb_text_pos_x_text:SetPoint("TOPLEFT", cb_text_font_text, "BOTTOMLEFT", 0, -15)

		local cb_text_pos_x = ns.createInputbox("np_castbar_options", 30, 20, LolzenUIcfg.nameplates["np_cbtext_posx"])
		cb_text_pos_x:SetPoint("LEFT", cb_text_pos_x_text, "RIGHT", 10, 0)

		local cb_text_pos_y_text = ns.createFonstring("np_castbar_options", "PosY:")
		cb_text_pos_y_text:SetPoint("LEFT", cb_text_pos_x, "RIGHT", 5, 0)

		local cb_text_pos_y = ns.createInputbox("np_castbar_options", 30, 20, LolzenUIcfg.nameplates["np_cbtext_posy"])
		cb_text_pos_y:SetPoint("LEFT", cb_text_pos_y_text, "RIGHT", 10, 0)

		local cb_text_anchor_text = ns.createFonstring("np_castbar_options", "Anchor1:")
		cb_text_anchor_text:SetPoint("LEFT", cb_text_pos_y, "RIGHT", 10, 0)

		local cb_text_anchor = ns.createPicker("np_castbar_options", "anchor", "nameplates_castbar_text_anchor1", 110, LolzenUIcfg.nameplates["np_cbtext_anchor"])
		cb_text_anchor:SetPoint("LEFT", cb_text_anchor_text, "RIGHT", -10, -3)

		local cb_text_anchor_text2 = ns.createFonstring("np_castbar_options", "Anchor2:")
		cb_text_anchor_text2:SetPoint("LEFT", cb_text_anchor, "RIGHT", -5, 3)

		local cb_text_anchor2 = ns.createPicker("np_castbar_options", "anchor", "nameplates_castbar_text_anchor2", 110, LolzenUIcfg.nameplates["np_cbtext_anchor2"])
		cb_text_anchor2:SetPoint("LEFT", cb_text_anchor_text2, "RIGHT", -10, -3)

		ns["nameplates"].okay = function(self)
			LolzenUIcfg.nameplates["np_targetindicator"] = cb1:GetChecked()
			LolzenUIcfg.nameplates["np_threatindicator"] = cb2:GetChecked()
			LolzenUIcfg.nameplates["np_raidtargetindicator"] = cb3:GetChecked()
			LolzenUIcfg.nameplates["np_width"] = tonumber(width:GetText())
			LolzenUIcfg.nameplates["np_height"] = tonumber(height:GetText())
			LolzenUIcfg.nameplates["np_selected_scale"] = tonumber(selected:GetText())
			LolzenUIcfg.nameplates["np_texture"] = texture:GetText()
			LolzenUIcfg.nameplates["np_lvlname_font"] = ns.picker_fonts[UIDropDownMenu_GetSelectedID(lvlname_font)]
			LolzenUIcfg.nameplates["np_lvlname_font_size"] = tonumber(lvlname_font_size:GetText())
			LolzenUIcfg.nameplates["np_lvlname_font_flag"] = ns.picker_flags[UIDropDownMenu_GetSelectedID(lvlname_font_flag)]
			LolzenUIcfg.nameplates["np_lvlname_posx"] = tonumber(lvlname_pos_x:GetText())
			LolzenUIcfg.nameplates["np_lvlname_posy"] = tonumber(lvlname_pos_y:GetText())
			LolzenUIcfg.nameplates["np_lvlname_anchor"] = ns.picker_anchor[UIDropDownMenu_GetSelectedID(lvlname_anchor)]
			LolzenUIcfg.nameplates["np_raidmark_size"] = tonumber(rt_size:GetText())
			LolzenUIcfg.nameplates["np_raidmark_anchor"] = ns.picker_anchor[UIDropDownMenu_GetSelectedID(rt_anchor)]
			LolzenUIcfg.nameplates["np_raidmark_posx"] = tonumber(rt_pos_x:GetText())
			LolzenUIcfg.nameplates["np_raidmark_posy"] = tonumber(rt_pos_y:GetText())
		end

		ns["nameplates"].default = function(self)
			LolzenUIcfg.nameplates["np_targetindicator"] = true
			LolzenUIcfg.nameplates["np_threatindicator"] = true
			LolzenUIcfg.nameplates["np_raidtargetindicator"] = true
			LolzenUIcfg.nameplates["np_width"] = 100
			LolzenUIcfg.nameplates["np_height"] = 4
			LolzenUIcfg.nameplates["np_selected_scale"] = 1.4
			LolzenUIcfg.nameplates["np_texture"] = "statusbar"
			LolzenUIcfg.nameplates["np_lvlname_font"] = "DroidSansBold.ttf"
			LolzenUIcfg.nameplates["np_lvlname_font_size"] = 6
			LolzenUIcfg.nameplates["np_lvlname_font_flag"] = "THINOUTLINE"
			LolzenUIcfg.nameplates["np_lvlname_posx"] = 0
			LolzenUIcfg.nameplates["np_lvlname_posy"] = 3
			LolzenUIcfg.nameplates["np_lvlname_anchor"] = "CENTER"
			LolzenUIcfg.nameplates["np_raidmark_size"] = 16
			LolzenUIcfg.nameplates["np_raidmark_anchor"] = "TOPRIGHT"
			LolzenUIcfg.nameplates["np_raidmark_posx"] = -2
			LolzenUIcfg.nameplates["np_raidmark_posy"] = 14
			ReloadUI()
		end

		ns["np_castbar_options"].okay = function(self)
			LolzenUIcfg.nameplates["np_cb_anchor"] = ns.picker_anchor[UIDropDownMenu_GetSelectedID(cb_anchor)]
			LolzenUIcfg.nameplates["np_cb_anchor2"] = ns.picker_anchor[UIDropDownMenu_GetSelectedID(cb_anchor2)]
			LolzenUIcfg.nameplates["np_cb_posx"] = tonumber(cb_pos_x:GetText())
			LolzenUIcfg.nameplates["np_cb_posy"] = tonumber(cb_pos_y:GetText())
			LolzenUIcfg.nameplates["np_cb_height"] = tonumber(cb_height:GetText())
			LolzenUIcfg.nameplates["np_cb_width"] = tonumber(cb_width:GetText())
			LolzenUIcfg.nameplates["np_cb_texture"] = cb_texture:GetText()
			LolzenUIcfg.nameplates["np_spark_height"] = tonumber(cb_spark_height:GetText())
			LolzenUIcfg.nameplates["np_spark_width"] = tonumber(cb_spark_width:GetText())
			LolzenUIcfg.nameplates["np_cbicon_anchor"] = ns.picker_anchor[UIDropDownMenu_GetSelectedID(cb_icon_anchor)]
			LolzenUIcfg.nameplates["np_cbicon_anchor2"] = ns.picker_anchor[UIDropDownMenu_GetSelectedID(cb_icon_anchor2)]
			LolzenUIcfg.nameplates["np_cbicon_posx"] = tonumber(cb_icon_pos_x:GetText())
			LolzenUIcfg.nameplates["np_cbicon_posy"] = tonumber(cb_icon_pos_y:GetText())
			LolzenUIcfg.nameplates["np_cbicon_size"] = tonumber(cb_icon_size:GetText())
			LolzenUIcfg.nameplates["np_cbtime_anchor"] = ns.picker_anchor[UIDropDownMenu_GetSelectedID(cb_time_anchor)]
			LolzenUIcfg.nameplates["np_cbtime_anchor2"] = ns.picker_anchor[UIDropDownMenu_GetSelectedID(cb_time_anchor2)]
			LolzenUIcfg.nameplates["np_cbtime_posx"] = tonumber(cb_time_pos_x:GetText())
			LolzenUIcfg.nameplates["np_cbtime_posy"] = tonumber(cb_time_pos_y:GetText())
			LolzenUIcfg.nameplates["np_cbtime_font"] = ns.picker_fonts[UIDropDownMenu_GetSelectedID(cb_time_font)]
			LolzenUIcfg.nameplates["np_cbtime_font_size"] = tonumber(cb_time_font_size:GetText())
			LolzenUIcfg.nameplates["np_cbtime_font_flag"] = ns.picker_flags[UIDropDownMenu_GetSelectedID(cb_time_font_flag)]
			LolzenUIcfg.nameplates["np_cbtext_anchor"] = ns.picker_anchor[UIDropDownMenu_GetSelectedID(cb_text_anchor)]
			LolzenUIcfg.nameplates["np_cbtext_anchor2"] = ns.picker_anchor[UIDropDownMenu_GetSelectedID(cb_text_anchor2)]
			LolzenUIcfg.nameplates["np_cbtext_posx"] = tonumber(cb_text_pos_x:GetText())
			LolzenUIcfg.nameplates["np_cbtext_posy"] = tonumber(cb_text_pos_y:GetText())
			LolzenUIcfg.nameplates["np_cbtext_font"] = ns.picker_fonts[UIDropDownMenu_GetSelectedID(cb_text_font)]
			LolzenUIcfg.nameplates["np_cbtext_font_size"] = tonumber(cb_text_font_size:GetText())
			LolzenUIcfg.nameplates["np_cbtext_font_flag"] = ns.picker_flags[UIDropDownMenu_GetSelectedID(cb_text_font_flag)]
		end

		ns["np_castbar_options"].default = function(self)
			LolzenUIcfg.nameplates["np_cb_anchor"] = "TOP"
			LolzenUIcfg.nameplates["np_cb_anchor2"] = "BOTTOM"
			LolzenUIcfg.nameplates["np_cb_posx"] = 0
			LolzenUIcfg.nameplates["np_cb_posy"] = 1
			LolzenUIcfg.nameplates["np_cb_height"] = 1
			LolzenUIcfg.nameplates["np_cb_width"] = 100
			LolzenUIcfg.nameplates["np_cb_texture"] = "statusbar"
			LolzenUIcfg.nameplates["np_spark_height"] = 4
			LolzenUIcfg.nameplates["np_spark_width"] = 6
			LolzenUIcfg.nameplates["np_cbicon_anchor"] = "RIGHT"
			LolzenUIcfg.nameplates["np_cbicon_anchor2"] = "LEFT"
			LolzenUIcfg.nameplates["np_cbicon_posx"] = -4
			LolzenUIcfg.nameplates["np_cbicon_posy"] = 0
			LolzenUIcfg.nameplates["np_cbicon_size"] = 8
			LolzenUIcfg.nameplates["np_cbtime_anchor"] = "LEFT"
			LolzenUIcfg.nameplates["np_cbtime_anchor2"] = "LEFT"
			LolzenUIcfg.nameplates["np_cbtime_posx"] = 2
			LolzenUIcfg.nameplates["np_cbtime_posy"] = -5
			LolzenUIcfg.nameplates["np_cbtime_font"] = "DroidSansBold.ttf"
			LolzenUIcfg.nameplates["np_cbtime_font_size"] = 6
			LolzenUIcfg.nameplates["np_cbtime_font_flag"] = "THINOUTLINE"
			LolzenUIcfg.nameplates["np_cbtext_anchor"] = "RIGHT"
			LolzenUIcfg.nameplates["np_cbtext_anchor2"] = "RIGHT"
			LolzenUIcfg.nameplates["np_cbtext_posx"] = -2
			LolzenUIcfg.nameplates["np_cbtext_posy"] = -5
			LolzenUIcfg.nameplates["np_cbtext_font"] = "DroidSansBold.ttf"
			LolzenUIcfg.nameplates["np_cbtext_font_size"] = 6
			LolzenUIcfg.nameplates["np_cbtext_font_flag"] = "THINOUTLINE"
			ReloadUI()
		end
	end
end)