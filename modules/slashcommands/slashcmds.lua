--// slashcommands //--

local addon, ns = ...

-- Open up the option panel
SLASH_LOLZENUI1 = "/lolzen"
SLASH_LOLZENUI2 = "/lolzenui"
SlashCmdList["LOLZENUI"] = function(self)
	-- we have to call it twice; known Blizzard bug
	-- see http://www.wowinterface.com/forums/showthread.php?t=54599
	InterfaceOptionsFrame_OpenToCategory("LolzenUI")
	InterfaceOptionsFrame_OpenToCategory("LolzenUI")
end
		
local f = CreateFrame("Frame")
f:RegisterEvent("ADDON_LOADED")
f:SetScript("OnEvent", function(self, event, addon)
	if addon == "LolzenUI" then
		if LolzenUIcfg["slashcommands"] == false then return end

		-- Reloading faster
		SLASH_RELOAD1 = "/rl"
		SlashCmdList["RELOAD"] = function() 
			ReloadUI() 
		end

		-- Getting the Framename, the mouse is over
		SLASH_FRAMENAME1 = "/frame"
		SlashCmdList["FRAMENAME"] = function() 
			print(GetMouseFocus():GetName())
		end

		-- Getting the Childframes, the mouse is over
		SLASH_CHILDFRAMES1 = "/child"
		SlashCmdList["CHILDFRAMES"] = function() 
			for k,v in pairs({GetMouseFocus():GetChildren()}) do
				print(v:GetName(),'-',v:GetObjectType())
			end 
		end

		-- /gm if we want to open a GM ticket
		SLASH_GM1 = "/gm"
		SlashCmdList["GM"] = function() 
			ToggleHelpFrame()
		end

		-- /uiscale for the optimal scale
		--SLASH_SCALE1 = "/uiscale"
		--SlashCmdList["SCALE"] = function() 
		--	SetCVar("uiScale", 768/string.match(({GetScreenResolutions()})[GetCurrentResolution()], "%d+x(%d+)"))
		--end
	end
end)