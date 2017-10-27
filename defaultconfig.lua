--// config defaults //--

local addon, ns = ...

local defaultconfig = {}

defaultconfig.modules = {
	["actionbars"] = true,
	["artifactbar"] = true,
	["buffs"] = true,
	["buffwatcher"] = true,
	["chat"] = true,
	["clock"] = true,
	["fonts"] = true,
	["itemlevel"] = true,
	["inspect"] = true,
	["interruptannouncer"] = true,
	["minimap"] = true,
	["nameplates"] = true,
	["objectivetracker"] = true,
	["orderhallbar"] = true,
	["pullcount"] = true,
	["slashcommands"] = true,
	["tooltip"] = true,
	["unitframes"] = true,
	["versioncheck"] = true,
	["worldmap"] = true,
	["xpbar"] = true,
}

defaultconfig.actionbar = {
	["actionbar_button_spacing"] = 6,
	["actionbar_button_size"] = 26,
	["actionbar_normal_texture"] = "gloss",
	["actionbar_flash_texture"] = "flash",
	["actionbar_checked_texture"] = "checked",
	["actionbar_hover_texture"] = "hover",
	["actionbar_pushed_texture"] = "pushed",
	-- mainmenubar
	["actionbar_mmb_anchor1"] = "BOTTOM",
	["actionbar_mmb_parent"] = "UIParent",
	["actionbar_mmb_anchor2"] = "BOTTOM",
	["actionbar_mmb_posx"] = 0,
	["actionbar_mmb_posy"] = 22,
	-- multibar bottom left
	["actionbar_mbbl_anchor1"] = "BOTTOMLEFT",
	["actionbar_mbbl_parent"] = "ActionButton1",
	["actionbar_mbbl_anchor2"] = "TOPLEFT",
	["actionbar_mbbl_posx"] = 0,
	["actionbar_mbbl_posy"] = 5,
	-- multibar bottom right
	["actionbar_mbbr_anchor1"] = "BOTTOMLEFT",
	["actionbar_mbbr_parent"] = "MultiBarBottomLeftButton1",
	["actionbar_mbbr_anchor2"] = "TOPLEFT",
	["actionbar_mbbr_posx"] = 0,
	["actionbar_mbbr_posy"] = 5,
	-- multi bar left
	["actionbar_mbl_anchor1"] = "TOPLEFT",
	["actionbar_mbl_parent"] = "MultiBarRightButton1",
	["actionbar_mbl_anchor2"] = "TOPLEFT",
	["actionbar_mbl_posx"] = -33,
	["actionbar_mbl_posy"] = 0,
	-- multi bar right
	["actionbar_mbr_anchor1"] = "RIGHT",
	["actionbar_mbr_parent"] = "UIParent",
	["actionbar_mbr_anchor2"] = "RIGHT",
	["actionbar_mbr_posx"] = -2,
	["actionbar_mbr_posy"] = 150,
	-- pet bar
	["actionbar_petb_anchor1"] = "BOTTOMLEFT",
	["actionbar_petb_parent"] = "MultiBarBottomRightButton1",
	["actionbar_petb_anchor2"] = "TOPLEFT",
	["actionbar_petb_posx"] = 15,
	["actionbar_petb_posy"] = 60,
	-- possess bar
	["actionbar_pb_anchor1"] = "BOTTOMLEFT",
	["actionbar_pb_parent"] = "MultiBarBottomRightButton1",
	["actionbar_pb_anchor2"] = "TOPLEFT",
	["actionbar_pb_posx"] = 25,
	["actionbar_pb_posy"] = 30,
}

defaultconfig.artifactbar = {
	["artifactbar_height"] = 4,
	["artifactbar_width"] = 378,
	["artifactbar_anchor"] = "BOTTOM",
	["artifactbar_parent"] = "UIParent",
	["artifactbar_posx"] = 0,
	["artifactbar_posy"] = 120,
	["artifactbar_texture"] = "statusbar",
	["artifactbar_alpha"] = 0.4,
	["artifactbar_bg_alpha"] = 0.5,
	["artifactbar_color"] = {1, 1, 0.7},
	["artifactbar_1px_border"] = true,
	["artifactbar_1px_border_round"] = true,
	["artifactbar_font"] = "DroidSansBold.ttf",
	["artifactbar_font_size"] = 10,
	["artifactbar_font_flag"] = "THINOUTLINE",
	["artifactbar_font_color"] = {1, 1, 1},
	["artifactbar_text_anchor1"] = "TOP",
	["artifactbar_text_posx"] = 0,
	["artifactbar_text_posy"] = 8,
}

defaultconfig.buffs = {
	["buff_size"] = 30,
--	["buff_spacing_horizontal"] = -3,
--	["buff_spacing_vertical"] = 0,
	["buff_debuff_size"] = 30,
--	["buff_debuff_spacing_horizontal"] = -3,
--	["buff_debuffspacing_vertical"] = 0,
	["buff_tempenchant_size"] = 30,
--	["buff_tempenchant_spacing_horizontal"] = -3,
--	["buff_tempenchant_vertical"] = 0,
	["buff_anchor1"] = "TOPRIGHT",
	["buff_parent"] = "Minimap",
	["buff_anchor2"] = "TOPLEFT",
	["buff_posx"] = -15,
	["buff_posy"] = 2,
	["buff_duration_anchor1"] = "CENTER",
	["buff_duration_anchor2"] = "BOTTOM",
	["buff_duration_posx"] = 0,
	["buff_duration_posy"] = 3,
	["buff_duration_detailed"] = true,
	["buff_duration_font"] = "DroidSans.ttf",
	["buff_duration_font_size"] = 11,
	["buff_duration_font_flag"] = "OUTLINE",
	["buff_counter_anchor"] = "TOPRIGHT",
	["buff_counter_posx"] = 0,
	["buff_counter_posy"] = 0,
	["buff_counter_font"] = "DroidSans.ttf",
	["buff_counter_size"] = 16,
	["buff_counter_font_flag"] = "OUTLINE",
	["buff_aura_texture"] = "auraborder",
	["buff_debuff_texture"] = "debuffborder",
}

defaultconfig.buffwatcher ={
	["buffwatchlist"] = {},
	["buffwatch_pos_x"] = -250,
	["buffwatch_pos_y"] = -140,
	["buffwatch_icon_size"] = 52,
	["buffwatch_icon_spacing"] = 5,
}

defaultconfig.chat = {

}

defaultconfig.clock = {
	["clock_color"] = {0.85, 0.55, 0},
	["clock_seconds_color"] = {1, 1, 1},
	["clock_font"] = "DroidSansBold.ttf",
	["clock_font_seconds"] = "DroidSans.ttf",
	["clock_font_size"] = 20,
	["clock_seconds_font_size"] = 14,
	["clock_font_flag"] = "OUTLINE",
	["clock_seconds_font_flag"] = "THINOUTLINE",
	["clock_anchor1"] = "TOPRIGHT",
	["clock_anchor2"] = "TOPRIGHT",
	["clock_posx"] = -5,
	["clock_posy"] = -9,
}

defaultconfig.fonts = {
	["fonts_DAMAGE_TEXT_FONT"] = "DroidSansBold.ttf",
	["fonts_UNIT_NAME_FONT"] = "DroidSans.ttf",
	["fonts_NAMEPLATE_FONT"] = "DroidSans.ttf",
	["fonts_STANDARD_TEXT_FONT"] = "DroidSans.ttf",
}

defaultconfig.itemlevel = {
	["ilvl_characterframe"] = true,
	["ilvl_inspectframe"] = true,
	["ilvl_bags"] = true,
	["ilvl_font"] = "DroidSans.ttf",
	["ilvl_font_size"] = 14,
	["ilvl_font_flag"] = "THINOUTLINE",
	["ilvl_font_color"] = {0, 1, 0},
	["ilvl_anchor"] = "TOP",
	["ilvl_font_posx"] = 0,
	["ilvl_font_posy"] = -5,
}

defaultconfig.interruptannouncer = {
	["interruptannoucer_say"] = true,
	["interruptannoucer_party"] = true,
	["interruptannoucer_instance"] = true,
	["interruptannouncer_msg"] = "Unterbrochen: !spell von >>!name<<",
}

defaultconfig.minimap = {
	["minimap_square"] = true,
}

defaultconfig.nameplates = {

}

defaultconfig.objectivetracker = {
	["objectivetracker_anchor"] = "TOPLEFT",
	["objectivetracker_posx"] = 30,
	["objectivetracker_posy"] = -30,
	["objectivetracker_combatcollapse"] = true,
	["objectivetracker_logincollapse"] = true,
}

defaultconfig.orderhallbar = {
	["ohb_currency_icon_size"] = 18,
	["ohb_currency_font"] = "DroidSansBold.ttf",
	["ohb_currency_font_size"] = 12,
	["ohb_currency_font_flag"] = "OUTLINE",
	["ohb_zone_color"] = {51/255, 181/255, 229/225},
	["ohb_background"] = "statusbar",
	["ohb_background_color"] = {0, 0, 0},
	["ohb_background_alpha"] = 0.5,
	["ohb_always_show"] = true,
}

defaultconfig.pullcount = {
	["pull_count_range"] = 3,
	["pull_msg_count"] = "Pull in !n",
	["pull_msg_now"] = ">> Pull Now <<",
	["pull_sound_1"] = "one.mp3",
	["pull_sound_2"] = "two.mp3",
	["pull_sound_3"] = "three.mp3",
	["pull_sound_4"] = "four.mp3",
	["pull_sound_5"] = "five.mp3",
	["pull_sound_6"] = "six.mp3",
	["pull_sound_7"] = "seven.mp3",
	["pull_sound_8"] = "eight.mp3",
	["pull_sound_9"] = "nine.mp3",
	["pull_sound_10"] = "ten.mp3",
	["pull_sound_pull"] = "Play.mp3",
	["pull_filter_guild"] = true,
	["pull_filter_party"] = true,
	["pull_filter_instance"] = true,
	["pull_filter_say"] = false,
	["pull_filter_channel"] = true,
}

defaultconfig.slashcommands = {

}

defaultconfig.tooltip = {

}

defaultconfig.unitframes = {

}

defaultconfig.versioncheck = {

}

defaultconfig.worldmap = {
	["worldmap_scale"] = 1,
}

defaultconfig.xpbar = {
	["xpbar_height"] = 4,
	["xpbar_width"] = 378,
	["xpbar_anchor"] = "BOTTOM",
	["xpbar_parent"] = "UIParent",
	["xpbar_posx"] = 0,
	["xpbar_posy"] = 5,
	["xpbar_texture"] = "statusbar",
	["xpbar_alpha"] = 0.4,
	["xpbar_bg_alpha"] = 0.5,
	["xpbar_pvp_color"] = {1, 0.4, 0},
	["xpbar_paragon_color"] = {0, 187/255, 255/255},
	["xpbar_xp_color"] = {0.6, 0, 0.6},
	["xpbar_xp_rested_color"] = {46/255, 103/255, 208/255},
	["xpbar_1px_border"] = true,
	["xpbar_1px_border_round"] = true,
	["xpbar_font"] = "DroidSansBold.ttf",
	["xpbar_font_size"] = 10,
	["xpbar_font_flag"] = "THINOUTLINE",
	["xpbar_font_color"] = {1, 1, 1},
	["xpbar_text_anchor1"] = "BOTTOM",
	["xpbar_text_anchor2"] = "TOP",
	["xpbar_text_posx"] = 0,
	["xpbar_text_posy"] = -2,
}

-- check default config and update if necessary
local f = CreateFrame("Frame")
f:SetScript("OnEvent", function(self, event, addon)
	if addon == "LolzenUI" then
		-- create new defaults on first login
		if LolzenUIcfg == nil then
			LolzenUIcfg = defaultconfig
			print("|cff5599ffLolzenUI:|r first login detected! n\default values written to saved vars")
		end
	end
end)
f:RegisterEvent("ADDON_LOADED")