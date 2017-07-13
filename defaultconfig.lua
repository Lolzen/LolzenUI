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
	-- panel variables
	["actionbar_button_spacing"] = 6,
	["actiobar_button_size"] = 26,
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
