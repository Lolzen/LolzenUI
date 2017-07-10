--// hide Blizzard's Actionbar art //--

local addon, ns = ...

local blizzarthidden
local f = CreateFrame("Frame")
f:RegisterEvent("ADDON_LOADED")
f:SetScript("OnEvent", function(self, event, addon)
	if addon == "LolzenUI" then
		if LolzenUIcfg["actionbars"] == false then return end
		if blizzarthidden == true then return end
		
		local invisible = CreateFrame("Frame", nil)
		invisible:RegisterEvent("PLAYER_ENTERING_WORLD")
		invisible:EnableMouse(false)
		invisible:Hide()

		local BlizzArt = {
			MainMenuBarTexture0, MainMenuBarTexture1,
			MainMenuBarTexture2,MainMenuBarTexture3,
			MainMenuBarLeftEndCap, MainMenuBarRightEndCap,
			MainMenuBarPageNumber, ActionBarUpButton, ActionBarDownButton,
			CharacterBag0Slot, CharacterBag1Slot, CharacterBag2Slot, CharacterBag3Slot,
			MainMenuBarBackpackButton,
			StanceBarFrame,
			ReputationWatchBar, MainMenuExpBar, ArtifactWatchBar, HonorWatchBar,
		}

		for _, frame in pairs(BlizzArt) do
			frame:SetParent(invisible)
		end

		local MicroButtons = {
			CharacterMicroButton, SpellbookMicroButton, TalentMicroButton, 
			AchievementMicroButton, QuestLogMicroButton, GuildMicroButton, 
			PVPMicroButton, LFDMicroButton, CompanionsMicroButton,
			EJMicroButton, HelpMicroButton, MainMenuMicroButton,
			CollectionsMicroButton, StoreMicroButton,
		}

		--fix a blizz bug; thx tuller
		if not _G['AchievementMicroButton_Update'] then
			_G['AchievementMicroButton_Update'] = function() end
		end

		function invisible.PLAYER_ENTERING_WORLD()
			for _, frame in pairs(MicroButtons) do
				frame:SetParent(invisible)
				frame:Hide()
			end
		end

		invisible:SetScript("OnEvent", function(self, event, ...)  
			if(self[event]) then
				self[event](self, event, ...)
			else
				print("LolzenUI - actionbars debug: "..event)
			end 
		end)
		blizzarthidden = true
	end
end)