--// actionbars //--

local _, ns = ...
ns.RegisterModule("actionbars")

local modded
local f = CreateFrame("Frame")
f:RegisterEvent("ADDON_LOADED")
f:SetScript("OnEvent", function(self, event, addon)
	if addon == "LolzenUI" then
		if LolzenUIcfg.modules["actionbars"] == false then return end
		if modded == true then return end

		--// hide blizz art //--

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

		--// Bar sizes & positions //--

		-- Make the MainMenuBar clickthrough, so it doesn't interfere with other frames placed at the bottom
		MainMenuBar:EnableMouse(false)

		-- Create a holder frame, which the Main Menu Bar can refer to when positioning;
		-- per default it wouldn't be centered
		local holder = CreateFrame("Frame", "MainMenuBarHolderFrame", UIParent, "SecureHandlerStateTemplate")
		holder:SetSize(LolzenUIcfg.actionbar["actionbar_button_size"]*12+LolzenUIcfg.actionbar["actionbar_button_spacing"]*11, LolzenUIcfg.actionbar["actionbar_button_size"])
		holder:SetPoint(LolzenUIcfg.actionbar["actionbar_mmb_anchor1"], LolzenUIcfg.actionbar["actionbar_mmb_parent"], LolzenUIcfg.actionbar["actionbar_mmb_anchor1"], LolzenUIcfg.actionbar["actionbar_mmb_posx"], LolzenUIcfg.actionbar["actionbar_mmb_posy"])
		
		for i = 1, NUM_ACTIONBAR_BUTTONS do
			local ab = _G["ActionButton"..i]
			local mbbl = _G["MultiBarBottomLeftButton"..i]
			local mbbr = _G["MultiBarBottomRightButton"..i]
			local mbl = _G["MultiBarLeftButton"..i]
			local mbr = _G["MultiBarRightButton"..i]
			local pab = _G["PetActionButton"..i]
			local pb = _G["PossessButton"..i]

			ab:SetSize(LolzenUIcfg.actionbar["actionbar_button_size"], LolzenUIcfg.actionbar["actionbar_button_size"])
			mbbl:SetSize(LolzenUIcfg.actionbar["actionbar_button_size"], LolzenUIcfg.actionbar["actionbar_button_size"])
			mbbr:SetSize(LolzenUIcfg.actionbar["actionbar_button_size"], LolzenUIcfg.actionbar["actionbar_button_size"])
			mbl:SetSize(LolzenUIcfg.actionbar["actionbar_button_size"], LolzenUIcfg.actionbar["actionbar_button_size"])
			mbr:SetSize(LolzenUIcfg.actionbar["actionbar_button_size"], LolzenUIcfg.actionbar["actionbar_button_size"])
			if pab then
				pab:SetSize(LolzenUIcfg.actionbar["actionbar_button_size"], LolzenUIcfg.actionbar["actionbar_button_size"])
			end
			if pb then
				pb:SetSize(LolzenUIcfg.actionbar["actionbar_button_size"], LolzenUIcfg.actionbar["actionbar_button_size"])
			end

			ab:ClearAllPoints()
			mbbl:ClearAllPoints()
			mbbr:ClearAllPoints()
			mbl:ClearAllPoints()
			mbr:ClearAllPoints()

			if i == 1 then
				ab:SetPoint("BOTTOMLEFT", holder, 0, 0)
				mbbl:SetPoint(LolzenUIcfg.actionbar["actionbar_mbbl_anchor1"], LolzenUIcfg.actionbar["actionbar_mbbl_parent"], LolzenUIcfg.actionbar["actionbar_mbbl_anchor2"], LolzenUIcfg.actionbar["actionbar_mbbl_posx"], LolzenUIcfg.actionbar["actionbar_mbbl_posy"])
				mbbr:SetPoint(LolzenUIcfg.actionbar["actionbar_mbbr_anchor1"], LolzenUIcfg.actionbar["actionbar_mbbr_parent"], LolzenUIcfg.actionbar["actionbar_mbbr_anchor2"], LolzenUIcfg.actionbar["actionbar_mbbr_posx"], LolzenUIcfg.actionbar["actionbar_mbbr_posy"])
				mbl:SetPoint(LolzenUIcfg.actionbar["actionbar_mbl_anchor1"], LolzenUIcfg.actionbar["actionbar_mbl_parent"], LolzenUIcfg.actionbar["actionbar_mbl_anchor2"], LolzenUIcfg.actionbar["actionbar_mbl_posx"], LolzenUIcfg.actionbar["actionbar_mbl_posy"])
				mbr:SetPoint(LolzenUIcfg.actionbar["actionbar_mbr_anchor1"], LolzenUIcfg.actionbar["actionbar_mbr_parent"], LolzenUIcfg.actionbar["actionbar_mbr_anchor2"], LolzenUIcfg.actionbar["actionbar_mbr_posx"], LolzenUIcfg.actionbar["actionbar_mbr_posy"])
			else
				ab:SetPoint("LEFT", _G["ActionButton"..i-1], "RIGHT", LolzenUIcfg.actionbar["actionbar_button_spacing"], 0)
				mbbl:SetPoint("LEFT", _G["MultiBarBottomLeftButton"..i-1], "RIGHT", LolzenUIcfg.actionbar["actionbar_button_spacing"], 0)
				mbbr:SetPoint("LEFT", _G["MultiBarBottomRightButton"..i-1], "RIGHT", LolzenUIcfg.actionbar["actionbar_button_spacing"], 0)
				mbl:SetPoint("BOTTOM", _G["MultiBarLeftButton"..i-1], "BOTTOM", 0, - LolzenUIcfg.actionbar["actionbar_button_size"] - LolzenUIcfg.actionbar["actionbar_button_spacing"])
				mbr:SetPoint("BOTTOM", _G["MultiBarRightButton"..i-1], "BOTTOM", 0, - LolzenUIcfg.actionbar["actionbar_button_size"] - LolzenUIcfg.actionbar["actionbar_button_spacing"])
			end
			PetActionButton1:ClearAllPoints()
			PetActionButton1:SetPoint(LolzenUIcfg.actionbar["actionbar_petb_anchor1"], LolzenUIcfg.actionbar["actionbar_petb_parent"], LolzenUIcfg.actionbar["actionbar_petb_anchor2"], LolzenUIcfg.actionbar["actionbar_petb_posx"], LolzenUIcfg.actionbar["actionbar_petb_posy"])
			PetActionBarFrame:SetFrameStrata('HIGH')
			PossessButton1:ClearAllPoints()
			PossessButton1:SetPoint(LolzenUIcfg.actionbar["actionbar_pb_anchor1"], LolzenUIcfg.actionbar["actionbar_pb_parent"], LolzenUIcfg.actionbar["actionbar_pb_anchor2"], LolzenUIcfg.actionbar["actionbar_pb_posx"], LolzenUIcfg.actionbar["actionbar_pb_posy"])
		end

		--// skinning bars //--

		local function applyTheme(self)
			local name = self:GetName()

			_G[name.."Icon"]:SetTexCoord(.08, .92, .08, .92)
			_G[name.."Icon"]:SetPoint("TOPLEFT", _G[name], "TOPLEFT", 2, -2)
			_G[name.."Icon"]:SetPoint("BOTTOMRIGHT", _G[name], "BOTTOMRIGHT", -2, 2)

			_G[name.."Flash"]:SetTexture("Interface\\AddOns\\LolzenUI\\media\\"..LolzenUIcfg.actionbar["actionbar_flash_texture"])
			_G[name]:SetNormalTexture("Interface\\AddOns\\LolzenUI\\media\\"..LolzenUIcfg.actionbar["actionbar_normal_texture"])
			_G[name]:SetCheckedTexture("Interface\\AddOns\\LolzenUI\\media\\"..LolzenUIcfg.actionbar["actionbar_checked_texture"])
			_G[name]:SetHighlightTexture("Interface\\AddOns\\LolzenUI\\media\\"..LolzenUIcfg.actionbar["actionbar_hover_texture"])
			_G[name]:SetPushedTexture("Interface\\AddOns\\LolzenUI\\media\\"..LolzenUIcfg.actionbar["actionbar_pushed_texture"])

			if _G[name.."Border"] then
				_G[name.."Border"]:SetTexture(nil)
			end

			if _G[name.."Cooldown"] then
				_G[name.."Cooldown"]:SetPoint("TOPLEFT", _G[name], "TOPLEFT", 2, -2)
				_G[name.."Cooldown"]:SetPoint("BOTTOMRIGHT", _G[name], "BOTTOMRIGHT", -2, 2)
			end

			if _G[name.."HotKey"] then
				_G[name.."HotKey"]:Hide()
			end

			if _G[name.."Name"] then
				_G[name.."Name"]:Hide()
			end

			if _G[name.."FloatingBG"] then
				_G[name.."FloatingBG"]:Hide()
			end

			if _G[name.."NormalTexture"] then
				_G[name.."NormalTexture"]:SetAllPoints(_G[name])
				return
			end
		end

		local function applyPetBarTheme(self, i)
			local button = self..i

			_G[button.."Icon"]:SetTexCoord(.08, .92, .08, .92)
			_G[button.."Icon"]:SetPoint("TOPLEFT", button, "TOPLEFT", 2, -2)
			_G[button.."Icon"]:SetPoint("BOTTOMRIGHT", button, "BOTTOMRIGHT", -2, 2)

			_G[button.."Flash"]:SetTexture("Interface\\AddOns\\LolzenUI\\media\\"..LolzenUIcfg.actionbar["actionbar_flash_texture"])
			_G[button]:SetNormalTexture("Interface\\AddOns\\LolzenUI\\media\\"..LolzenUIcfg.actionbar["actionbar_normal_texture"])
			_G[button]:SetCheckedTexture("Interface\\AddOns\\LolzenUI\\media\\"..LolzenUIcfg.actionbar["actionbar_checked_texture"])
			_G[button]:SetHighlightTexture("Interface\\AddOns\\LolzenUI\\media\\"..LolzenUIcfg.actionbar["actionbar_hover_texture"])
			_G[button]:SetPushedTexture("Interface\\AddOns\\LolzenUI\\media\\"..LolzenUIcfg.actionbar["actionbar_pushed_texture"])

			_G[button.."Cooldown"]:SetPoint("TOPLEFT", button, "TOPLEFT", 2, -2)
			_G[button.."Cooldown"]:SetPoint("BOTTOMRIGHT", button, "BOTTOMRIGHT", -2, 2)

			_G[button.."NormalTexture2"]:SetVertexColor(0, 0, 0)
			_G[button.."NormalTexture2"]:SetPoint("TOPLEFT", button, "TOPLEFT", -0, 0)
			_G[button.."NormalTexture2"]:SetPoint("BOTTOMRIGHT", button, "BOTTOMRIGHT", 0, -0)

			--Autocast stuff on petbar
			if _G[button.."Shine"] then
				_G[button.."Shine"]:SetPoint("TOPLEFT", button, "TOPLEFT", 2, -2)
				_G[button.."Shine"]:SetPoint("BOTTOMRIGHT", button, "BOTTOMRIGHT", -2, 2)
			end

			if _G[button.."AutoCastable"] then
				_G[button.."AutoCastable"]:SetPoint("TOPLEFT", button, "TOPLEFT", -12, 12)
				_G[button.."AutoCastable"]:SetPoint("BOTTOMRIGHT", button, "BOTTOMRIGHT", 12, -12)
			end

			if _G[button.."HotKey"] then
				_G[button.."HotKey"]:Hide()
			end
		end

		local function applyThemeToPetBar()
			for i = 1, NUM_PET_ACTION_SLOTS do
				applyPetBarTheme("PetActionButton", i)
			end
		end

		hooksecurefunc("ActionButton_Update", applyTheme)
		hooksecurefunc("PetActionBar_Update", applyThemeToPetBar)
		modded = true
	end
end)