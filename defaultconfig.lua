--// config defaults //--

local _, ns = ...

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
	["actionbar_show_keybinds"] = false,
	["actionbar_button_spacing"] = 6,
	["actionbar_button_size"] = 26,
	["actionbar_normal_texture"] = "gloss",
	["actionbar_flash_texture"] = "flash",
	["actionbar_checked_texture"] = "checked",
	["actionbar_hover_texture"] = "hover",
	["actionbar_pushed_texture"] = "pushed",
	["actionbar_mmb_anchor1"] = "BOTTOM",
	["actionbar_mmb_parent"] = "UIParent",
	["actionbar_mmb_anchor2"] = "BOTTOM",
	["actionbar_mmb_posx"] = 0,
	["actionbar_mmb_posy"] = 22,
	["actionbar_mbbl_anchor1"] = "BOTTOMLEFT",
	["actionbar_mbbl_parent"] = "ActionButton1",
	["actionbar_mbbl_anchor2"] = "TOPLEFT",
	["actionbar_mbbl_posx"] = 0,
	["actionbar_mbbl_posy"] = 5,
	["actionbar_mbbr_anchor1"] = "BOTTOMLEFT",
	["actionbar_mbbr_parent"] = "MultiBarBottomLeftButton1",
	["actionbar_mbbr_anchor2"] = "TOPLEFT",
	["actionbar_mbbr_posx"] = 0,
	["actionbar_mbbr_posy"] = 5,
	["actionbar_mbl_anchor1"] = "TOPLEFT",
	["actionbar_mbl_parent"] = "MultiBarRightButton1",
	["actionbar_mbl_anchor2"] = "TOPLEFT",
	["actionbar_mbl_posx"] = -33,
	["actionbar_mbl_posy"] = 0,
	["actionbar_mbr_anchor1"] = "RIGHT",
	["actionbar_mbr_parent"] = "UIParent",
	["actionbar_mbr_anchor2"] = "RIGHT",
	["actionbar_mbr_posx"] = -2,
	["actionbar_mbr_posy"] = 150,
	["actionbar_petb_anchor1"] = "BOTTOMLEFT",
	["actionbar_petb_parent"] = "MultiBarBottomRightButton1",
	["actionbar_petb_anchor2"] = "TOPLEFT",
	["actionbar_petb_posx"] = 32,
	["actionbar_petb_posy"] = 60,
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
	["artifactbar_texture"] = "LolzenUI Standard",
	["artifactbar_alpha"] = 0.4,
	["artifactbar_bg_alpha"] = 0.5,
	["artifactbar_color"] = {1, 1, 0.7},
	["artifactbar_1px_border"] = true,
	["artifactbar_1px_border_round"] = true,
	["artifactbar_mouseover_text"] = true,
	["artifactbar_font"] = "DroidSansBold",
	["artifactbar_font_size"] = 10,
	["artifactbar_font_flag"] = "THINOUTLINE",
	["artifactbar_font_color"] = {1, 1, 1},
	["artifactbar_text_anchor1"] = "TOP",
	["artifactbar_text_posx"] = 0,
	["artifactbar_text_posy"] = 8,
}

--[[
	["buff_spacing_horizontal"] = -3,
	["buff_spacing_vertical"] = 0,
	["buff_debuff_spacing_horizontal"] = -3,
	["buff_debuffspacing_vertical"] = 0,
	["buff_tempenchant_spacing_horizontal"] = -3,
	["buff_tempenchant_vertical"] = 0,
]]
defaultconfig.buffs = {
	["buff_size"] = 30,
	["buff_debuff_size"] = 30,
	["buff_tempenchant_size"] = 30,
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
	["buff_duration_font"] = "DroidSans",
	["buff_duration_font_size"] = 11,
	["buff_duration_font_flag"] = "OUTLINE",
	["buff_counter_anchor"] = "TOPRIGHT",
	["buff_counter_posx"] = 0,
	["buff_counter_posy"] = 0,
	["buff_counter_font"] = "DroidSans",
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
	["chat_custom_channel_stamps"] = true,
	["chat_strip_brackets"] = true,
	["chat_timestamp"] = true,
	["chat_disable_fading"] = true,
	["chat_flag_afk"] = "AFK |",
	["chat_flag_dnd"] = "DND |",
	["chat_font"] = "DroidSans",
	["chat_font_size"] = 12,
	["chat_font_flag"] = "",
	["chat_font_shadow"] = true,
	["chat_font_spacing"] = 1,
	["chat_background"] = true,
	["chat_background_texture"] = "LolzenUI Standard",
	["chat_background_alpha"] = 0.5,
	["chat_background_border"] = "LolzenUI Standard",
	["chat_sticky_say"] = 1,
	["chat_sticky_yell"] = 0,
	["chat_sticky_party"] = 1,
	["chat_sticky_guild"] = 1,
	["chat_sticky_officer"] = 1,
	["chat_sticky_raid"] = 1,
	["chat_sticky_raidwarning"] = 1,
	["chat_sticky_whisper"] = 0,
	["chat_sticky_channel"] = 1,
	["chat_auto_who"] = true,
	["chat_show_afkdnd_once"] = true,
	["chat_posx"] = 8,
	["chat_posy"] = 15,
	["chat_anchor1"] = "BOTTOMLEFT",
	["chat_anchor2"] = "BOTTOMLEFT",
	["chat_strip_say_and_yell"] = true,
}

defaultconfig.clock = {
	["clock_seconds_enabled"] = true,
	["clock_color"] = {0.85, 0.55, 0},
	["clock_seconds_color"] = {1, 1, 1},
	["clock_font"] = "DroidSansBold",
	["clock_font_seconds"] = "DroidSans",
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
	["fonts_DAMAGE_TEXT_FONT"] = "DroidSansBold",
	["fonts_UNIT_NAME_FONT"] = "DroidSans",
	["fonts_NAMEPLATE_FONT"] = "DroidSans",
	["fonts_STANDARD_TEXT_FONT"] = "DroidSans",
}

defaultconfig.itemlevel = {
	["ilvl_characterframe"] = true,
	["ilvl_inspectframe"] = true,
	["ilvl_bags"] = true,
	["ilvl_font"] = "DroidSans",
	["ilvl_font_size"] = 14,
	["ilvl_font_flag"] = "THINOUTLINE",
	["ilvl_font_color"] = {0, 1, 0},
	["ilvl_anchor"] = "TOP",
	["ilvl_font_posx"] = 0,
	["ilvl_font_posy"] = -5,
	["ilvl_use_itemquality_color"] = false,
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
	["np_targetindicator"] = true,
	["np_threatindicator"] = true,
	["np_raidtargetindicator"] = true,
	["np_width"] = 100,
	["np_height"] = 4,
	["np_selected_scale"] = 1.4,
	["np_texture"] = "LolzenUI Standard",
	["np_lvlname_font"] = "DroidSansBold",
	["np_lvlname_font_size"] = 6,
	["np_lvlname_font_flag"] = "THINOUTLINE",
	["np_lvlname_posx"] = 0,
	["np_lvlname_posy"] = 3,
	["np_lvlname_anchor"] = "CENTER",
	["np_raidmark_size"] = 16,
	["np_raidmark_anchor"] = "TOPRIGHT",
	["np_raidmark_posx"] = -2,
	["np_raidmark_posy"] = 14,
	["np_cb_anchor"] = "TOP",
	["np_cb_anchor2"] = "BOTTOM",
	["np_cb_posx"] = 0,
	["np_cb_posy"] = 1,
	["np_cb_height"] = 1,
	["np_cb_width"] = 100,
	["np_cb_texture"] = "LolzenUI Standard",
	["np_spark_height"] = 4,
	["np_spark_width"] = 6,
	["np_cbicon_anchor"] = "RIGHT",
	["np_cbicon_anchor2"] = "LEFT",
	["np_cbicon_posx"] =  -4,
	["np_cbicon_posy"] = 0,
	["np_cbicon_size"] = 8,
	["np_cbtime_anchor"] = "LEFT",
	["np_cbtime_anchor2"] = "LEFT",
	["np_cbtime_posx"] = 2,
	["np_cbtime_posy"] = -5,
	["np_cbtime_font"] = "DroidSansBold",
	["np_cbtime_font_size"] = 6,
	["np_cbtime_font_flag"] = "THINOUTLINE",
	["np_cbtext_anchor"] = "RIGHT",
	["np_cbtext_anchor2"] = "RIGHT",
	["np_cbtext_posx"] = -2,
	["np_cbtext_posy"] = -5,
	["np_cbtext_font"] = "DroidSansBold",
	["np_cbtext_font_size"] = 6,
	["np_cbtext_font_flag"] = "THINOUTLINE",
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
	["ohb_currency_font"] = "DroidSansBold",
	["ohb_currency_font_size"] = 12,
	["ohb_currency_font_flag"] = "OUTLINE",
	["ohb_zone_color"] = {51/255, 181/255, 229/225},
	["ohb_background"] = "LolzenUI Standard",
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

defaultconfig.tooltip = {
	["tip_show_factionicons"] = true,
	["tip_show_raidmark"] = true,
	["tip_display_talents"] = true,
	["tip_border"] = "LolzenUI Standard",
	["tip_healthbar_texture"] = "LolzenUI Standard",
	["tip_statusflag_afk"] = "AFK|",
	["tip_statusflag_afk_color"] = {1, 1, 1},
	["tip_statusflag_dnd"] = "DND|",
	["tip_statusflag_dnd_color"] = {1, 1, 1},
	["tip_statusflag_off"] = "(Off)",
	["tip_statusflag_off_color"] = {1, 1, 1},
	["tip_posx"] = -13,
	["tip_posy"] = 43,
	["tip_anchor1"] = "BOTTOMRIGHT",
	["tip_anchor2"] = "BOTTOMRIGHT",
	["tip_own_guild_color"] = {0, 5, 1},
	["tip_use_guild_color_globally"] = false,
}

defaultconfig.unitframes = {
	["uf_use_sivalue"] = true,
	["uf_use_dot_format"] = false,
	["uf_use_hp_percent"] = false,
	["uf_general_hp_font"] = "DroidSansBold",
	["uf_general_hp_font_size"] = 24,
	["uf_general_hp_font_flag"] = "THINOUTLINE",
	["uf_general_hp_posx"] = -2,
	["uf_general_hp_posy"] = 8,
	["uf_general_hp_anchor"] = "RIGHT",
	["uf_general_power_font_size"] = 18,
	["uf_power_colors"] = {
		["0"] = {48/255, 113/255, 191/255}, --colors.power.MANA --0.00	0.00	1.00
		["1"] = {1, 0, 0},
		["2"] = {255/255, 178/255, 0}, --colors.power.FOCUS --1.00	0.50	0.25
		["3"] = {1.00, 1.00, 34/255}, --colors.power.ENERGY --1.00	1.00	0.00
		["4"] = {1.00, 0.96, 0.41},
		["5"] = {0.50, 0.50, 0.50},
		["6"] = {0.00, 0.82, 1.00},
		["7"] = {0.50, 0.32, 0.55},
		["8"] = {0.30, 0.52, 0.90},
		["9"] = {0.95, 0.90, 0.60},
		["11"] = {51/255, 181/255, 229/225}, --colors.power.MAELSTROM --0.00	0.50	1.00
		["12"] = {0.71, 1.00, 0.92},
		["13"] = {0.84, 0.1, 0.87}, --colors.power.INSANITY --0.40	0.00	0.80
		["16"] = {0.10, 0.10, 0.98},
		["17"] = {0.788, 0.259, 0.992},
		["18"] = {1.00, 0.61, 0.00},
	},
	["uf_statusbar_texture"] = "LolzenUI Standard",
	["uf_ri_size"] = 16, 
	["uf_ri_posx"] = 0,
	["uf_ri_posy"] = 10,
	["uf_ri_anchor"] = "CENTER",
	["uf_lead_size"] = 16,
	["uf_lead_posx"] = 0,
	["uf_lead_posy"] = 10,
	["uf_lead_anchor"] = "TOPLEFT",
	["uf_fade_outofreach"] = true,
	["uf_fade_outofreach_alpha"] = 0.5,
	["uf_border"] = "LolzenUI Standard",
	["uf_player_posx"] = -250,
	["uf_player_posy"] = -200,
	["uf_player_anchor"] = "CENTER",
	["uf_player_use_own_hp_font_settings"] = true,
	["uf_player_hp_font"] = "DroidSansBold",
	["uf_player_hp_font_size"] = 24,
	["uf_player_hp_font_flag"] = "THINOUTLINE",
	["uf_player_hp_posx"] = -2,
	["uf_player_hp_posy"] = 8,
	["uf_player_hp_anchor"] = "RIGHT",
	["uf_player_width"] = 220,
	["uf_player_height"] = 21,
	["uf_player_classpower_border"] = "Blizzard Tooltip",
	["uf_player_classpower_spacing"] = 5,
	["uf_player_classpower_posx"] = 0,
	["uf_player_classpower_posy"] = -5,
	["uf_player_classpower_anchor1"] = "TOPLEFT",
	["uf_player_classpower_anchor2"] = "BOTTOMLEFT",
	["uf_target_posx"] = 250,
	["uf_target_posy"] = -200,
	["uf_target_anchor"] = "CENTER",
	["uf_target_use_own_hp_font_settings"] = true,
	["uf_target_hp_font"] = "DroidSansBold",
	["uf_target_hp_font_size"] = 24,
	["uf_target_hp_font_flag"] = "THINOUTLINE",
	["uf_target_hp_posx"] = -2,
	["uf_target_hp_posy"] = 8,
	["uf_target_hp_anchor"] = "RIGHT",
	["uf_target_width"] = 220,
	["uf_target_height"] = 21,
	["uf_targettarget_posx"] = 300,
	["uf_targettarget_posy"] = -177,
	["uf_targettarget_anchor"] = "CENTER",
	["uf_targettarget_use_own_hp_font_settings"] = true,
	["uf_targettarget_hp_font"] = "DroidSansBold",
	["uf_targettarget_hp_font_size"] = 18,
	["uf_targettarget_hp_font_flag"] = "THINOUTLINE",
	["uf_targettarget_hp_posx"] = -2,
	["uf_targettarget_hp_posy"] = 8,
	["uf_targettarget_hp_anchor"] = "RIGHT",
	["uf_targettarget_width"] = 120,
	["uf_targettarget_height"] = 18,
	["uf_party_posx"] = 0,
	["uf_party_posy"] = 140,
	["uf_party_enabled"] = true,
	["uf_party_use_vertical_layout"] = false,
	["uf_party_anchor"] = "BOTTOM",
	["uf_party_use_own_hp_font_settings"] = true,
	["uf_party_hp_font"] = "DroidSansBold",
	["uf_party_hp_font_size"] = 13,
	["uf_party_hp_font_flag"] = "THINOUTLINE",
	["uf_party_hp_posx"] = 5,
	["uf_party_hp_posy"] = 0,
	["uf_party_hp_anchor"] = "LEFT",
	["uf_party_width"] = 70,
	["uf_party_height"] = 19,
	["uf_party_showroleindicator"] = true,
	["uf_party_ri_size"] = 16,
	["uf_party_ri_posx"] = 0,
	["uf_party_ri_posy"] = 0,
	["uf_party_ri_anchor"] = "RIGHT",
	["uf_party_rc_size"] = 16,
	["uf_party_rc_posx"] = 10,
	["uf_party_rc_posy"] = 10,
	["uf_party_rc_anchor"] = "LEFT",
	["uf_raid_enabled"] = true,
	["uf_raid_posx"] = 20,
	["uf_raid_posy"] = 0,
	["uf_raid_anchor"] = "LEFT",
	["uf_raid_use_own_hp_font_settings"] = true,
	["uf_raid_hp_font"] = "DroidSansBold",
	["uf_raid_hp_font_size"] = 13,
	["uf_raid_hp_font_flag"] = "THINOUTLINE",
	["uf_raid_hp_posx"] = 5,
	["uf_raid_hp_posy"] = 0,
	["uf_raid_hp_anchor"] = "LEFT",
	["uf_raid_width"] = 50,
	["uf_raid_height"] = 19,
	["uf_raid_showroleindicator"] = true,
	["uf_raid_ri_size"] = 16,
	["uf_raid_ri_posx"] = 0,
	["uf_raid_ri_posy"] = 0,
	["uf_raid_ri_anchor"] = "RIGHT",
	["uf_raid_rc_size"] = 16,
	["uf_raid_rc_posx"] = 10,
	["uf_raid_rc_posy"] = 10,
	["uf_raid_rc_anchor"] = "LEFT",
	["uf_pet_posx"] = -300,
	["uf_pet_posy"] = -177,
	["uf_pet_anchor"] = "CENTER",
	["uf_pet_use_own_hp_font_settings"] = true,
	["uf_pet_hp_font"] = "DroidSansBold",
	["uf_pet_hp_font_size"] = 18,
	["uf_pet_hp_font_flag"] = "THINOUTLINE",
	["uf_pet_hp_posx"] = -2,
	["uf_pet_hp_posy"] = 8,
	["uf_pet_hp_anchor"] = "RIGHT",
	["uf_pet_width"] = 120,
	["uf_pet_height"] = 18,
	["uf_boss_posx"] = 0,
	["uf_boss_posy"] = -200,
	["uf_boss_anchor"] = "CENTER",
	["uf_boss_additional_pos"] = "ABOVE",
	["uf_boss_additional_spacing"] = 5,
	["uf_boss_use_own_hp_font_settings"] = true,
	["uf_boss_hp_font"] = "DroidSansBold",
	["uf_boss_hp_font_size"] = 24,
	["uf_boss_hp_font_flag"] = "THINOUTLINE",
	["uf_boss_hp_posx"] = -2,
	["uf_boss_hp_posy"] = 8,
	["uf_boss_hp_anchor"] = "RIGHT",
	["uf_boss_width"] = 220,
	["uf_boss_height"] = 21,
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
	["xpbar_texture"] = "LolzenUI Standard",
	["xpbar_alpha"] = 0.4,
	["xpbar_bg_alpha"] = 0.5,
	["xpbar_pvp_color"] = {1, 0.4, 0},
	["xpbar_paragon_color"] = {0, 187/255, 255/255},
	["xpbar_xp_color"] = {0.6, 0, 0.6},
	["xpbar_xp_rested_color"] = {46/255, 103/255, 208/255},
	["xpbar_1px_border"] = true,
	["xpbar_1px_border_round"] = true,
	["xpbar_mouseover_text"] = true,
	["xpbar_font"] = "DroidSansBold",
	["xpbar_font_size"] = 10,
	["xpbar_font_flag"] = "THINOUTLINE",
	["xpbar_font_color"] = {1, 1, 1},
	["xpbar_text_anchor1"] = "TOP",
	["xpbar_text_posx"] = 0,
	["xpbar_text_posy"] = 8,
}

-- // check default config and update if necessary // --
local function updateDB(module)
	for k, v in pairs(defaultconfig[module]) do
		if not LolzenUIcfg[module][k] and v ~= nil then
			if type(v) == "table" then
				LolzenUIcfg[module][k] = {unpack(v)}
				print("|cff5599ffLolzenUI:|r new option in |cff00ff99"..module.."|r (|cffff8888"..k.." = "..unpack(v).."|r)")
			elseif type(v) == "boolean" then
				local bool
				if v == true and LolzenUIcfg[module][k] == nil then
					bool = "true"
					LolzenUIcfg[module][k] = true
					print("|cff5599ffLolzenUI:|r new option in |cff00ff99"..module.."|r (|cffff8888"..k.." = "..bool.."|r)")
				elseif v == false and LolzenUIcfg[module][k] == nil then
					bool = "false"
					LolzenUIcfg[module][k] = false
					print("|cff5599ffLolzenUI:|r new option in |cff00ff99"..module.."|r (|cffff8888"..k.." = "..bool.."|r)")
				end
				
			else
				LolzenUIcfg[module][k] = v
				print("|cff5599ffLolzenUI:|r new option in |cff00ff99"..module.."|r (|cffff8888"..k.." = "..v.."|r)")
			end
		end
	end
end

local f = CreateFrame("Frame")
f:SetScript("OnEvent", function(self, event, addon)
	if addon == "LolzenUI" then
		-- create new defaults on first login
		if LolzenUIcfg == nil then
			LolzenUIcfg = defaultconfig
			print("|cff5599ffLolzenUI:|r first login detected! n\default values written to saved vars")
		else
			-- update saved variables upon finding new entries
			for k, v in pairs(defaultconfig) do
				if not LolzenUIcfg[k] then
					LolzenUIcfg[k] = v
					print("|cff5599ffLolzenUI:|r Updated Saved vars ("..k..")")
				else
					updateDB(k)
				end
			end
		end
	end
end)
f:RegisterEvent("ADDON_LOADED")