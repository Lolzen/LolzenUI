﻿--// config defaults //--

local addon, ns = ...

local defaultconfig = {
	["actionbars"] = true,
	["artifactbar"] = true,
	["buffs"] = true,
	["buffwatcher"] = true,
	["chat"] = true,
	["clock"] = true,
	["fonts"] = true,
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
	-- others (not in order yet)
	["worldmap_scale"] = 1,
	["buffwatchlist"] = {
		225142, --Nefarious Pact
		225776, --Devil's Due
		225719, --Accelererando
	},
	["buffwatch_pos_x"] = -250,
	["buffwatch_pos_y"] = -140,
	["buffwatch_icon_size"] = 52,
	["buffwatch_icon_spacing"] = 5,
	["objectivetracker_anchor"] = "TOPLEFT",
	["objectivetracker_posx"] = 30,
	["objectivetracker_posy"] = -30,
	["objectivetracker_combatcollapse"] = true,
	["objectivetracker_logincollapse"] = true,

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
--		else
			-- if new variables are discovered, write them into the saved vars db
--			for k, v in pairs(defaultconfig) do
--				if not LolzenUIcfg[k] then
--					LolzenUIcfg[k] = v
--					print("|cff5599ffLolzenUI:|r new default variable(|cffff8888"..k.." = "..v.."|r) written do db")
--				end
--			end
		end
	end
end)
f:RegisterEvent("ADDON_LOADED")
