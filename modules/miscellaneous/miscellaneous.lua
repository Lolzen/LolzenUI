--// miscellaneous // --

local _, ns = ...
local L = ns.L

ns.RegisterModule("miscellaneous", L["desc_miscellaneous"], true)

local f = CreateFrame("Frame")
f:RegisterEvent("PLAYER_LOGIN")
f:SetScript("OnEvent", function(self, event, addon)
	if LolzenUIcfg.modules["miscellaneous"] == false then return end

	-- ReputationFrame (DNW)
	--Mixin(WorldMapFrame.BorderFrame.TitleContainer, ReputationBarMixin)
		
	local FactionTextToNum = {
		["Hated"] = 1,
		["Hostile"] = 2,
		["Unfriendly"] = 3,
		["Neutral"] = 4,
		["Friendly"] = 5,
		["Honored"] = 6,
		["Revered"] = 7,
		["Exalted"] = 8
	}
		
	--replace/extend this Blizzard code
	function ReputationBarMixin:UpdateBarColor(color)
		if LolzenUIcfg.miscellaneous["misc_alternative_faction_colors"] == true then
			local beautyColors = FactionTextToNum[self.reputationStandingText]
			if beautyColors ~= nil then
				self:SetStatusBarColor(unpack(LolzenUIcfg.miscellaneous["misc_faction_colors"][beautyColors]));
			else
				self:SetStatusBarColor(color:GetRGB());
			end
		end
	end
		
		
	-- MicroButtons
	local MicroButtons = {
		CharacterMicroButton, SpellbookMicroButton, TalentMicroButton, 
		AchievementMicroButton, QuestLogMicroButton, GuildMicroButton, 
		PVPMicroButton, LFDMicroButton, CompanionsMicroButton,
		EJMicroButton, HelpMicroButton, MainMenuMicroButton,
		CollectionsMicroButton,
	}

	local oAchievementMicroButton_Update = AchievementMicroButton_Update
	local function setMBV()
		if LolzenUIcfg.miscellaneous["misc_hide_microbuttons"] == true then
			--fix a blizz bug; thx tuller
			if not _G['AchievementMicroButton_Update'] then
				_G['AchievementMicroButton_Update'] = function() end
			end

			-- special snowflake microbutton
		--	StoreMicroButton:Hide()
		--	StoreMicroButton.Show = function() end
			StoreMicroButton:SetAlpha(0)
			StoreMicroButton:EnableMouse(false)

			for _, frame in pairs(MicroButtons) do
				frame:Hide()
			end
		else
			_G['AchievementMicroButton_Update'] = oAchievementMicroButton_Update

			StoreMicroButton:SetAlpha(1)
			StoreMicroButton:EnableMouse(true)

			for _, frame in pairs(MicroButtons) do
				frame:Show()
			end
		end
	end
	setMBV()

	ns.updateCustomRepColors = function()
		ReputationFrame_Update()
	end

	ns.updateMicroButtonVisibility = function()
		setMBV()
	end
end)