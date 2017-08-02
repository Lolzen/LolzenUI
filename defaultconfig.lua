--// config defaults //--

local addon, ns = ...

local defaultconfig = {
	["actionbars"] = true,
	["artifactbar"] = true,
	["buffs"] = true,
	["buffwatcher"] = true,
	["chat"] = true,
	["clock"] = true,
	["fonts"] = true,
	["gambler"] = true,
	["interruptannouncer"] = true,
	["minimap"] = true,
--	["nameplates"] = true,
	["objectivetracker"] = true,
	["orderhallbar"] = true,
	["pullcount"] = true,
	["slashcommands"] = true,
	["tooltip"] = true,
	["unitframes"] = true,
	["versioncheck"] = true,
	["worldmap"] = true,
	["xpbar"] = true,
	-- // panel variables //
	-- [actionbar]
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
	-- [artifactbar]
	["artifactbar_height"] = 4,
	["artifactbar_width"] = 378,
	["artifactbar_anchor"] = "BOTTOM",
	["artifactbar_parent"] = "UIParent",
	["artifactbar_posx"] = 0,
	["artifactbar_posy"] = 120,
	["artifactbar_texture"] = "statusbar.tga",
	["artifactbar_alpha"] = 0.4,
	["artifactbar_bg_alpha"] = 0.5,
	["artifactbar_color"] = {1, 1, 0.7},
	["artifactbar_1px_border"] = true,
	["artifactbar_1px_border_round"] = true,
	["artifactbar_font"] = "DroidSansBold.ttf",
	["artifactbar_font_size"] = 10,
	["artifactbar_font_flag"] = "THINOUTLINE",
	["artifactbar_font_color"] = {1, 1, 1},
	["artifactbar_text_anchor1"] = "BOTTOM",
	["artifactbar_text_anchor2"] = "TOP",
	["artifactbar_text_posx"] = 0,
	["artifactbar_text_posy"] = -2,
	-- [buffwatcher]
	["buffwatchlist"] = {
		225142, --Nefarious Pact
		225776, --Devil's Due
		225719, --Accelererando
	},
	["buffwatch_pos_x"] = -250,
	["buffwatch_pos_y"] = -140,
	["buffwatch_icon_size"] = 52,
	["buffwatch_icon_spacing"] = 5,
	-- [fonts]
	["fonts_DAMAGE_TEXT_FONT"] = "DroidSansBold.ttf",
	["fonts_UNIT_NAME_FONT"] = "DroidSans.ttf",
	["fonts_NAMEPLATE_FONT"] = "DroidSans.ttf",
	["fonts_STANDARD_TEXT_FONT"] = "DroidSans.ttf",
	-- [interruptannouncer]
	["interruptannoucer_say"] = true,
	["interruptannoucer_party"] = true,
	["interruptannoucer_instance"] = true,
	["interruptannouncer_msg"] = "Unterbrochen: !spell von >>!name<<",
	-- [objectivetracker]
	["objectivetracker_anchor"] = "TOPLEFT",
	["objectivetracker_posx"] = 30,
	["objectivetracker_posy"] = -30,
	["objectivetracker_combatcollapse"] = true,
	["objectivetracker_logincollapse"] = true,
	-- [worlmap]
	["worldmap_scale"] = 1,
	-- [xpbar]
	["xpbar_height"] = 4,
	["xpbar_width"] = 378,
	["xpbar_anchor"] = "BOTTOM",
	["xpbar_parent"] = "UIParent",
	["xpbar_posx"] = 0,
	["xpbar_posy"] = 5,
	["xpbar_texture"] = "statusbar.tga",
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
--ToDO: booleans throw an error
local f = CreateFrame("Frame")
f:SetScript("OnEvent", function(self, event, addon)
	if addon == "LolzenUI" then
		-- create new defaults on first login
		if LolzenUIcfg == nil then
			LolzenUIcfg = defaultconfig
			print("|cff5599ffLolzenUI:|r first login detected! n\default values written to saved vars")
		else
			-- if new variables are discovered, write them into the saved vars db
			for k, v in pairs(defaultconfig) do
				-- don't try to write saved vars for disabled modules
				if LolzenUIcfg[k] == false then return end
				if not LolzenUIcfg[k] then
					if type(v) == "table" then
						LolzenUIcfg[k] = {unpack(v)}
						print("|cff5599ffLolzenUI:|r new default variable(|cffff8888"..k.." = "..unpack(v).."|r) written do db")
					elseif type(v) == "boolean" then
						local bool
						if v == true then
							bool = "true"
							LolzenUIcfg[k] = true
						else
							bool = "false"
							LolzenUIcfg[k] = false
						end
						print("|cff5599ffLolzenUI:|r new default variable(|cffff8888"..k.." = "..bool.."|r) written do db")
					else
						LolzenUIcfg[k] = v
						print("|cff5599ffLolzenUI:|r new default variable(|cffff8888"..k.." = "..v.."|r) written do db")
					end
				end
			end
		end
	end
end)
f:RegisterEvent("ADDON_LOADED")
