--// options for chat //--

local addon, ns = ...

ns.RegisterModule("chat")

local f = CreateFrame("Frame")
f:RegisterEvent("ADDON_LOADED")
f:SetScript("OnEvent", function(self, event, addon)
	if addon == "LolzenUI" and LolzenUIcfg.modules["chat"] == true then

		local title = ns.createTitle("chat")

		local about = ns.createDescription("chat", "Modifies Chat look & feel")
		about:SetPoint("TOPLEFT", title, "BOTTOMLEFT", 0, -8)

		local cb1 = ns.createCheckBox("chat", "chat_custom_stamps", "|cff5599ffuse short chat stamps (G| P| R| ...)|r", LolzenUIcfg.chat["chat_custom_channel_stamps"])
		cb1:SetPoint("TOPLEFT", about, "BOTTOMLEFT", 0, -20)

		local cb2 = ns.createCheckBox("chat", "chat_brackets", "|cff5599ffstrip brackets from links (items, achievements, etc)|r", LolzenUIcfg.chat["chat_strip_brackets"])
		cb2:SetPoint("TOPLEFT", cb1, "BOTTOMLEFT", 0, 0)

		local cb3 = ns.createCheckBox("chat", "chat_timestamp", "|cff5599ffshow timestamps|r", LolzenUIcfg.chat["chat_timestamp"])
		cb3:SetPoint("TOPLEFT", cb2, "BOTTOMLEFT", 0, 0)

		local cb4 = ns.createCheckBox("chat", "chat_fading", "|cff5599ffdisable fading|r", LolzenUIcfg.chat["chat_disable_fading"])
		cb4:SetPoint("TOPLEFT", cb3, "BOTTOMLEFT", 0, 0)

		local cb5 = ns.createCheckBox("chat", "chat_auto_who", "|cff5599ffauto /who for new whispers|r", LolzenUIcfg.chat["chat_auto_who"])
		cb5:SetPoint("TOPLEFT", cb4, "BOTTOMLEFT", 0, 0)

		local cb6 = ns.createCheckBox("chat", "chat_afkdnd_once", "|cff5599ffshow afk/dnd messages only once per person|r", LolzenUIcfg.chat["chat_show_afkdnd_once"])
		cb6:SetPoint("TOPLEFT", cb5, "BOTTOMLEFT", 0, 0)

		local cb7 = ns.createCheckBox("chat", "chat_strip_say_yell", "|cff5599ffstrip 'says' and 'yells' from chat|r", LolzenUIcfg.chat["chat_strip_say_and_yell"])
		cb7:SetPoint("TOPLEFT", cb6, "BOTTOMLEFT", 0, 0)

		local header1 = ns.createHeader("chat", "Frame:")
		header1:SetPoint("TOPLEFT", cb7, "BOTTOMLEFT", 0, -20)

		local pos_x_text = ns.createFonstring("chat", "PosX:")
		pos_x_text:SetPoint("TOPLEFT", header1, "BOTTOMLEFT", 0, -10)

		local pos_x = ns.createInputbox("chat", 30, 20, LolzenUIcfg.chat["chat_posx"])
		pos_x:SetPoint("LEFT", pos_x_text, "RIGHT", 10, 0)

		local pos_y_text = ns.createFonstring("chat", "PosY:")
		pos_y_text:SetPoint("LEFT", pos_x, "RIGHT", 5, 0)

		local pos_y = ns.createInputbox("chat", 30, 20, LolzenUIcfg.chat["chat_posy"])
		pos_y:SetPoint("LEFT", pos_y_text, "RIGHT", 10, 0)

		local anchor_text = ns.createFonstring("chat", "Anchor1:")
		anchor_text:SetPoint("LEFT", pos_y, "RIGHT", 5, 0)

		local anchor = ns.createPicker("chat", "anchor", "chat_anchor1", 110, LolzenUIcfg.chat["chat_anchor1"])
		anchor:SetPoint("LEFT", anchor_text, "RIGHT", -10, -3)

		local anchor2_text = ns.createFonstring("chat", "Anchor2:")
		anchor2_text:SetPoint("LEFT", anchor, "RIGHT", -5, 3)

		local anchor2 = ns.createPicker("chat", "anchor", "chat_anchor2", 110, LolzenUIcfg.chat["chat_anchor2"])
		anchor2:SetPoint("LEFT", anchor2_text, "RIGHT", -10, -3)

		local header2 = ns.createHeader("chat", "Font:")
		header2:SetPoint("TOPLEFT", pos_x_text, "BOTTOMLEFT", 0, -20)

		local cb8 = ns.createCheckBox("chat", "chat_font_shadow", "|cff5599fffont shadow|r", LolzenUIcfg.chat["chat_font_shadow"])
		cb8:SetPoint("TOPLEFT", header2, "BOTTOMLEFT", 0, -10)

		local font_text = ns.createFonstring("chat", "Font:")
		font_text:SetPoint("TOPLEFT", cb8, "BOTTOMLEFT", 0, -10)

		local font = ns.createPicker("chat", "font", "chat_font", 120, LolzenUIcfg.chat["chat_font"])
		font:SetPoint("LEFT", font_text, "RIGHT", -10, -3)

		local font_size_text = ns.createFonstring("chat", "Size:")
		font_size_text:SetPoint("LEFT", font, "RIGHT", -5, 3)

		local font_size = ns.createInputbox("chat", 30, 20, LolzenUIcfg.chat["chat_font_size"])
		font_size:SetPoint("LEFT", font_size_text, "RIGHT", 10, 0)

		local font_flag_text = ns.createFonstring("chat", "Flag:")
		font_flag_text:SetPoint("LEFT", font_size, "RIGHT", 10, 0)

		local font_flag = ns.createPicker("chat", "flag", "chat_font_flag", 120, LolzenUIcfg.chat["chat_font_flag"])
		font_flag:SetPoint("LEFT", font_flag_text, "RIGHT", -10, -3)

		local spacing_text = ns.createFonstring("chat", "Spacing:")
		spacing_text:SetPoint("LEFT", font_flag, "RIGHT", -5, 3)

		local spacing = ns.createInputbox("chat", 30, 20, LolzenUIcfg.chat["chat_font_spacing"])
		spacing:SetPoint("LEFT", spacing_text, "RIGHT", 10, 0)

		local header3 = ns.createHeader("chat", "Background:")
		header3:SetPoint("TOPLEFT", font_text, "BOTTOMLEFT", 0, -20)

		local cb9 = ns.createCheckBox("chat", "chat_backgound", "|cff5599ffchat background|r", LolzenUIcfg.chat["chat_background"])
		cb9:SetPoint("TOPLEFT", header3, "BOTTOMLEFT", 0, -10)

		local texture_text = ns.createFonstring("chat", "Texture:")
		texture_text:SetPoint("TOPLEFT", cb9, "BOTTOMLEFT", 0, -10)

		local texture = ns.createInputbox("chat", 100, 20, LolzenUIcfg.chat["chat_background_texture"])
		texture:SetPoint("LEFT", texture_text, "RIGHT", 10, 0)

		local alpha_text = ns.createFonstring("chat", "Alpha:")
		alpha_text:SetPoint("LEFT", texture, "RIGHT", 10, 0)

		local alpha = ns.createPicker("chat", "alpha", "chat_bg_alpha", 45, LolzenUIcfg.chat["chat_background_alpha"])
		alpha:SetPoint("LEFT", alpha_text, "RIGHT", -10, -3)

		local border_text = ns.createFonstring("chat", "Border:")
		border_text:SetPoint("LEFT", alpha, "RIGHT", -5, 3)

		local border = ns.createInputbox("chat", 100, 20, LolzenUIcfg.chat["chat_background_border"])
		border:SetPoint("LEFT", border_text, "RIGHT", 10, 0)

		local header4 = ns.createHeader("chat", "Flags & Sticky Channels: (0 = false, 1 = true)")
		header4:SetPoint("TOPLEFT", texture_text, "BOTTOMLEFT", 0, -20)

		local sticky_say_text = ns.createFonstring("chat", "Say:")
		sticky_say_text:SetPoint("TOPLEFT", header4, "BOTTOMLEFT", 0, -10)

		local sticky_say = ns.createPicker("chat", "bin", "chat_sticky_say", 35, LolzenUIcfg.chat["chat_sticky_say"])
		sticky_say:SetPoint("LEFT", sticky_say_text, "RIGHT", -10, -3)

		local sticky_yell_text = ns.createFonstring("chat", "Yell:")
		sticky_yell_text:SetPoint("LEFT", sticky_say, "RIGHT", -5, 3)

		local sticky_yell = ns.createPicker("chat", "bin", "chat_sticky_yell", 35, LolzenUIcfg.chat["chat_sticky_yell"])
		sticky_yell:SetPoint("LEFT", sticky_yell_text, "RIGHT", -10, -3)

		local sticky_party_text = ns.createFonstring("chat", "Party:")
		sticky_party_text:SetPoint("LEFT", sticky_yell, "RIGHT", -5, 3)

		local sticky_party = ns.createPicker("chat", "bin", "chat_sticky_party", 35, LolzenUIcfg.chat["chat_sticky_party"])
		sticky_party:SetPoint("LEFT", sticky_party_text, "RIGHT", -10, -3)

		local sticky_guild_text = ns.createFonstring("chat", "Guild:")
		sticky_guild_text:SetPoint("LEFT", sticky_party, "RIGHT", -5, 3)

		local sticky_guild = ns.createPicker("chat", "bin", "chat_sticky_guild", 35, LolzenUIcfg.chat["chat_sticky_guild"])
		sticky_guild:SetPoint("LEFT", sticky_guild_text, "RIGHT", -10, -3)

		local sticky_officer_text = ns.createFonstring("chat", "Officer:")
		sticky_officer_text:SetPoint("LEFT", sticky_guild, "RIGHT", -5, 3)

		local sticky_officer = ns.createPicker("chat", "bin", "chat_sticky_officer", 35, LolzenUIcfg.chat["chat_sticky_officer"])
		sticky_officer:SetPoint("LEFT", sticky_officer_text, "RIGHT", -10, -3)

		local sticky_raid_text = ns.createFonstring("chat", "Raid:")
		sticky_raid_text:SetPoint("LEFT", sticky_officer, "RIGHT", -5, 3)

		local sticky_raid = ns.createPicker("chat", "bin", "chat_sticky_raid", 35, LolzenUIcfg.chat["chat_sticky_raid"])
		sticky_raid:SetPoint("LEFT", sticky_raid_text, "RIGHT", -10, -3)

		local sticky_raidwarning_text = ns.createFonstring("chat", "Raid Warning:")
		sticky_raidwarning_text:SetPoint("TOPLEFT", sticky_say_text, "BOTTOMLEFT", 0, -15)

		local sticky_raidwarning = ns.createPicker("chat", "bin", "chat_sticky_raidwarning", 35, LolzenUIcfg.chat["chat_sticky_raidwarning"])
		sticky_raidwarning:SetPoint("LEFT", sticky_raidwarning_text, "RIGHT", -10, -3)

		local sticky_whisper_text = ns.createFonstring("chat", "Whisper:")
		sticky_whisper_text:SetPoint("LEFT", sticky_raidwarning, "RIGHT", -5, 3)

		local sticky_whisper = ns.createPicker("chat", "bin", "chat_sticky_whisper", 35, LolzenUIcfg.chat["chat_sticky_whisper"])
		sticky_whisper:SetPoint("LEFT", sticky_whisper_text, "RIGHT", -10, -3)

		local sticky_channel_text = ns.createFonstring("chat", "Channel:")
		sticky_channel_text:SetPoint("LEFT", sticky_whisper, "RIGHT", -5, 3)

		local sticky_channel = ns.createPicker("chat", "bin", "chat_sticky_channel", 35, LolzenUIcfg.chat["chat_sticky_channel"])
		sticky_channel:SetPoint("LEFT", sticky_channel_text, "RIGHT", -10, -3)

		local chat_afkflag_text = ns.createFonstring("chat", "AFK flag:")
		chat_afkflag_text:SetPoint("LEFT", sticky_channel, "RIGHT", -5, 3)

		local chat_afkflag = ns.createInputbox("chat", 50, 20, LolzenUIcfg.chat["chat_flag_afk"])
		chat_afkflag:SetPoint("LEFT", chat_afkflag_text, "RIGHT", 10, 0)

		local chat_dndflag_text = ns.createFonstring("chat", "DND flag:")
		chat_dndflag_text:SetPoint("LEFT", chat_afkflag, "RIGHT", 5, 0)

		local chat_dndflag = ns.createInputbox("chat", 50, 20, LolzenUIcfg.chat["chat_flag_dnd"])
		chat_dndflag:SetPoint("LEFT", chat_dndflag_text, "RIGHT", 10, 0)

		ns["chat"].okay = function(self)
			LolzenUIcfg.chat["chat_custom_channel_stamps"] = cb1:GetChecked()
			LolzenUIcfg.chat["chat_strip_brackets"] = cb2:GetChecked()
			LolzenUIcfg.chat["chat_timestamp"] = cb3:GetChecked()
			LolzenUIcfg.chat["chat_disable_fading"] = cb4:GetChecked()
			LolzenUIcfg.chat["chat_auto_who"] = cb5:GetChecked()
			LolzenUIcfg.chat["chat_show_afkdnd_once"] = cb6:GetChecked()
			LolzenUIcfg.chat["chat_strip_say_and_yell"] = cb7:GetChecked()
			LolzenUIcfg.chat["chat_posx"] = tonumber(pos_x:GetText())
			LolzenUIcfg.chat["chat_posy"] = tonumber(pos_y:GetText())
			LolzenUIcfg.chat["chat_anchor1"] = ns.picker_anchor[UIDropDownMenu_GetSelectedID(anchor)]
			LolzenUIcfg.chat["chat_anchor2"] = ns.picker_anchor[UIDropDownMenu_GetSelectedID(anchor2)]
			LolzenUIcfg.chat["chat_font"] = ns.picker_fonts[UIDropDownMenu_GetSelectedID(font)]
			LolzenUIcfg.chat["chat_font_size"] = tonumber(font_size:GetText())
			LolzenUIcfg.chat["chat_font_flag"] = ns.picker_flags[UIDropDownMenu_GetSelectedID(font_flag)]
			LolzenUIcfg.chat["chat_font_spacing"] = tonumber(spacing:GetText())
			LolzenUIcfg.chat["chat_font_shadow"] = cb8:GetChecked()
			LolzenUIcfg.chat["chat_background"] = cb9:GetChecked()
			LolzenUIcfg.chat["chat_background_texture"] = texture:GetText()
			LolzenUIcfg.chat["chat_background_alpha"] = tonumber(ns.picker_alpha[UIDropDownMenu_GetSelectedID(alpha)])
			LolzenUIcfg.chat["chat_background_border"] = border:GetText()
			LolzenUIcfg.chat["chat_sticky_say"] = tonumber(ns.picker_bin[UIDropDownMenu_GetSelectedID(sticky_say)])
			LolzenUIcfg.chat["chat_sticky_yell"] = tonumber(ns.picker_bin[UIDropDownMenu_GetSelectedID(sticky_yell)])
			LolzenUIcfg.chat["chat_sticky_party"] = tonumber(ns.picker_bin[UIDropDownMenu_GetSelectedID(sticky_party)])
			LolzenUIcfg.chat["chat_sticky_guild"] = tonumber(ns.picker_bin[UIDropDownMenu_GetSelectedID(sticky_guild)])
			LolzenUIcfg.chat["chat_sticky_officer"] = tonumber(ns.picker_bin[UIDropDownMenu_GetSelectedID(sticky_officer)])
			LolzenUIcfg.chat["chat_sticky_raid"] = tonumber(ns.picker_bin[UIDropDownMenu_GetSelectedID(sticky_raid)])
			LolzenUIcfg.chat["chat_sticky_raidwarning"] = tonumber(ns.picker_bin[UIDropDownMenu_GetSelectedID(sticky_raidwarning)])
			LolzenUIcfg.chat["chat_sticky_whisper"] = tonumber(ns.picker_bin[UIDropDownMenu_GetSelectedID(sticky_whisper)])
			LolzenUIcfg.chat["chat_sticky_channel"] = tonumber(ns.picker_bin[UIDropDownMenu_GetSelectedID(sticky_channel)])
			LolzenUIcfg.chat["chat_flag_afk"] = chat_afkflag:GetText()
			LolzenUIcfg.chat["chat_flag_dnd"] = chat_dndflag:GetText()
		end

		ns["chat"].default = function(self)
			LolzenUIcfg.chat["chat_custom_channel_stamps"] = true
			LolzenUIcfg.chat["chat_strip_brackets"] = true
			LolzenUIcfg.chat["chat_timestamp"] = true
			LolzenUIcfg.chat["chat_disable_fading"] = true
			LolzenUIcfg.chat["chat_auto_who"] = true
			LolzenUIcfg.chat["chat_show_afkdnd_once"] = true
			LolzenUIcfg.chat["chat_strip_say_and_yell"] = true
			LolzenUIcfg.chat["chat_posx"] = 8
			LolzenUIcfg.chat["chat_posy"] = 15
			LolzenUIcfg.chat["chat_anchor1"] = "BOTTOMLEFT"
			LolzenUIcfg.chat["chat_anchor2"] = "BOTTOMLEFT"
			LolzenUIcfg.chat["chat_font"] = "DroidSans.ttf"
			LolzenUIcfg.chat["chat_font_size"] = 12
			LolzenUIcfg.chat["chat_font_flag"] = ""
			LolzenUIcfg.chat["chat_font_spacing"] = 1
			LolzenUIcfg.chat["chat_font_shadow"] = true
			LolzenUIcfg.chat["chat_background"] = true
			LolzenUIcfg.chat["chat_background_texture"] = "statusbar"
			LolzenUIcfg.chat["chat_background_alpha"] = 0.5
			LolzenUIcfg.chat["chat_background_border"] = "border"
			LolzenUIcfg.chat["chat_sticky_say"] = 1
			LolzenUIcfg.chat["chat_sticky_yell"] = 0
			LolzenUIcfg.chat["chat_sticky_party"] = 1
			LolzenUIcfg.chat["chat_sticky_guild"] = 1
			LolzenUIcfg.chat["chat_sticky_officer"] = 1
			LolzenUIcfg.chat["chat_sticky_raid"] = 1
			LolzenUIcfg.chat["chat_sticky_raidwarning"] = 1
			LolzenUIcfg.chat["chat_sticky_whisper"] = 0
			LolzenUIcfg.chat["chat_sticky_channel"] = 1
			LolzenUIcfg.chat["chat_flag_afk"] = "AFK |"
			LolzenUIcfg.chat["chat_flag_dnd"] = "DND |"
			ReloadUI()
		end
	end
end)