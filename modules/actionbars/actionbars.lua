--// actionbars //--

local _, ns = ...
local L = ns.L
local LBT = LibStub("LibButtonTexture-1.0")

ns.RegisterModule("actionbars", L["desc_actionbars"], true)

local f = CreateFrame("Frame")
f:RegisterEvent("ADDON_LOADED")
f:RegisterEvent("PLAYER_ENTERING_WORLD")
f:SetScript("OnEvent", function(self, event, addon)
	if addon == "LolzenUI" then
		if LolzenUIcfg.modules["actionbars"] == false then return end

		--// hide blizz art //--
		local invisible = CreateFrame("Frame", nil)
		invisible:EnableMouse(false)
		invisible:Hide()

		local BlizzArt = {
			MainMenuBarArtFrameBackground,
			MainMenuBarArtFrame.LeftEndCap, MainMenuBarArtFrame.RightEndCap,
			MainMenuBarArtFrame.PageNumber, ActionBarUpButton, ActionBarDownButton,
			StanceBarFrame, SlidingActionBarTexture0, SlidingActionBarTexture1,
			MicroButtonAndBagsBar,
			-- Vehicle Textures
			OverrideActionBarBG, OverrideActionBarEndCapL, OverrideActionBarEndCapR, OverrideActionBarBorder,
			OverrideActionBarDivider1, OverrideActionBarDivider2, OverrideActionBarDivider3,
			OverrideActionBarExitBG, OverrideActionBarMicroBGL, OverrideActionBarMicroBGR, OverrideActionBarMicroBGMid,
			OverrideActionBarButtonBGL, OverrideActionBarButtonBGR, OverrideActionBarButtonBGMid,
			OverrideActionBarExpBar, OverrideActionBarHealthBar, 
			OverrideActionBarPowerBar, OverrideActionBarPitchFrame,
		}

		for _, frame in pairs(BlizzArt) do
			frame:SetParent(invisible)
		end
		
		MainMenuBarArtFrame:UnregisterAllEvents()

		-- Hide the StatusTrackingBarManager
		StatusTrackingBarManager:UnregisterAllEvents()
		StatusTrackingBarManager:Hide()
		StatusTrackingBarManager.show = StatusTrackingBarManager.Hide

		--// Bar sizes, positions & styling//--

		-- Make the MainMenuBar clickthrough, so it doesn't interfere with other frames placed at the bottom
		MainMenuBar:EnableMouse(false)
		-- Also the PetActionBarFrame
		PetActionBarFrame:EnableMouse(false)

		-- move the VehicleExitButton
		OverrideActionBar.LeaveButton:ClearAllPoints()
		OverrideActionBar.LeaveButton:SetPoint("BOTTOMRIGHT", ActionButton12)

		-- Create a holder frame, which some bars can refer to when positioning;
		-- per default they wouldn't be centered
		local mmb_holder = CreateFrame("Frame", "MainMenuBarHolderFrame", UIParent, "SecureHandlerStateTemplate")
		mmb_holder:SetSize(LolzenUIcfg.actionbar["actionbar_button_size"]*12+LolzenUIcfg.actionbar["actionbar_button_spacing"]*11, LolzenUIcfg.actionbar["actionbar_button_size"])
		mmb_holder:SetPoint("BOTTOM", UIParent, "BOTTOM", LolzenUIcfg.actionbar["actionbar_mmb_posx"], LolzenUIcfg.actionbar["actionbar_mmb_posy"])
		ns.mmb_holder = mmb_holder

		local mbbl_holder = CreateFrame("Frame", "MultiBarBottomLeftHolderFrame", UIParent, "SecureHandlerStateTemplate")
		mbbl_holder:SetSize(LolzenUIcfg.actionbar["actionbar_button_size"]*12+LolzenUIcfg.actionbar["actionbar_button_spacing"]*11, LolzenUIcfg.actionbar["actionbar_button_size"])
		mbbl_holder:SetPoint("BOTTOM", UIParent, "BOTTOM", LolzenUIcfg.actionbar["actionbar_mbbl_posx"], LolzenUIcfg.actionbar["actionbar_mbbl_posy"])
		ns.mbbl_holder = mbbl_holder

		local mbbr_holder = CreateFrame("Frame", "MultiBarBottomRightHolderFrame", UIParent, "SecureHandlerStateTemplate")
		mbbr_holder:SetSize(LolzenUIcfg.actionbar["actionbar_button_size"]*12+LolzenUIcfg.actionbar["actionbar_button_spacing"]*11, LolzenUIcfg.actionbar["actionbar_button_size"])
		mbbr_holder:SetPoint("BOTTOM", UIParent, "BOTTOM", LolzenUIcfg.actionbar["actionbar_mbbr_posx"], LolzenUIcfg.actionbar["actionbar_mbbr_posy"])
		ns.mbbr_holder = mbbr_holder
		
		local pet_holder = CreateFrame("Frame", "PetBarHolderFrame", UIParent, "SecureHandlerStateTemplate")
		pet_holder:SetSize(LolzenUIcfg.actionbar["actionbar_button_size"]*12+LolzenUIcfg.actionbar["actionbar_button_spacing"]*11, LolzenUIcfg.actionbar["actionbar_button_size"])
		pet_holder:SetPoint("BOTTOM", UIParent, "BOTTOM", LolzenUIcfg.actionbar["actionbar_petb_posx"], LolzenUIcfg.actionbar["actionbar_petb_posy"])
		ns.pet_holder = pet_holder

		local actionbars = {
			"ActionButton",
			"MultiBarBottomLeftButton",
			"MultiBarBottomRightButton",
			"MultiBarLeftButton",
			"MultiBarRightButton",
			"PetActionButton",
			"OverrideActionBarButton",
			"ExtraActionButton",
		}

		local function applyTheme(name)
			_G[name.."Icon"]:SetTexCoord(.08, .92, .08, .92)
			_G[name.."Icon"]:SetPoint("TOPLEFT", _G[name], "TOPLEFT", 2, -2)
			_G[name.."Icon"]:SetPoint("BOTTOMRIGHT", _G[name], "BOTTOMRIGHT", -2, 2)

			_G[name.."Flash"]:SetTexture(LBT:Fetch("flashing", LolzenUIcfg.actionbar["actionbar_flash_texture"]))
			_G[name]:SetNormalTexture(LBT:Fetch("border", LolzenUIcfg.actionbar["actionbar_normal_texture"]))
			_G[name]:SetCheckedTexture(LBT:Fetch("checked", LolzenUIcfg.actionbar["actionbar_checked_texture"]))
			_G[name]:SetHighlightTexture(LBT:Fetch("hover", LolzenUIcfg.actionbar["actionbar_hover_texture"]))
			_G[name]:SetPushedTexture(LBT:Fetch("pushed", LolzenUIcfg.actionbar["actionbar_pushed_texture"]))

			if _G[name.."Border"] then
				_G[name.."Border"]:SetTexture(nil)
			end

			if _G[name.."Cooldown"] then
				_G[name.."Cooldown"]:SetPoint("TOPLEFT", _G[name], "TOPLEFT", 2, -2)
				_G[name.."Cooldown"]:SetPoint("BOTTOMRIGHT", _G[name], "BOTTOMRIGHT", -2, 2)
			end

			if _G[name.."HotKey"] then
				if LolzenUIcfg.actionbar["actionbar_show_keybinds"] == false then
					_G[name.."HotKey"]:Hide()
				end
			end

			if _G[name.."Name"] then
				_G[name.."Name"]:Hide()
			end

			if _G[name.."FloatingBG"] then
				_G[name.."FloatingBG"]:Hide()
			end

			if _G[name.."NormalTexture"] then
				if LolzenUIcfg.actionbar["actionbar_normal_texture"] == "Blizzard QuickSlot2" then
					_G[name.."NormalTexture"]:SetPoint("TOPLEFT", _G[name.."Icon"], "TOPLEFT", -10, 10)
					_G[name.."NormalTexture"]:SetPoint("BOTTOMRIGHT", _G[name.."Icon"], "BOTTOMRIGHT", 11, -11)
				else
					_G[name.."NormalTexture"]:SetAllPoints(_G[name])
				end
			end

			-- petbar specific
			if _G[name.."NormalTexture2"] then
				if LolzenUIcfg.actionbar["actionbar_normal_texture"] == "Blizzard QuickSlot2" then
					_G[name.."NormalTexture2"]:SetPoint("TOPLEFT", _G[name.."Icon"], "TOPLEFT", -13, 13)
					_G[name.."NormalTexture2"]:SetPoint("BOTTOMRIGHT", _G[name.."Icon"], "BOTTOMRIGHT", 15, -15)
				else
					_G[name.."NormalTexture2"]:SetAllPoints(_G[name])
				end
			end

			if _G[name.."Shine"] then
				_G[name.."Shine"]:SetPoint("TOPLEFT", _G[name], "TOPLEFT", 2, -2)
				_G[name.."Shine"]:SetPoint("BOTTOMRIGHT", _G[name], "BOTTOMRIGHT", -2, 2)
			end

			if _G[name.."AutoCastable"] then
				_G[name.."AutoCastable"]:SetPoint("TOPLEFT", _G[name], "TOPLEFT", -2, 2)
				_G[name.."AutoCastable"]:SetPoint("BOTTOMRIGHT", _G[name], "BOTTOMRIGHT", 2, -2)
			end
		end

		-- hide those pesky hotkeys, ffs
		hooksecurefunc("ActionButton_UpdateHotkeys", function(self, actionButtonType)
			if LolzenUIcfg.actionbar["actionbar_show_keybinds"] == false then
				local name = self:GetName()
				_G[name.."HotKey"]:Hide()
			end
		end)

		--hook PetActionBar_Update, so it doesn't interfer with SetNormalTexture()
		hooksecurefunc("PetActionBar_Update", function(self)
			for i=1, NUM_PET_ACTION_SLOTS do
				_G["PetActionButton"..i]:SetNormalTexture("Interface\\AddOns\\LolzenUI\\media\\"..LolzenUIcfg.actionbar["actionbar_normal_texture"])
			end
		end)

		local function setActionBarPosition(name)
			for i = 1, NUM_ACTIONBAR_BUTTONS do
				local button = _G[name..i]

				if button then
					applyTheme(name..i)
					if button ~= _G["ExtraActionButton"..i] then
						button:SetSize(LolzenUIcfg.actionbar["actionbar_button_size"], LolzenUIcfg.actionbar["actionbar_button_size"])
					end
					button:ClearAllPoints()

					if i == 1 then
						if button == _G["ActionButton"..i] then
							button:SetPoint("BOTTOMLEFT", mmb_holder, 0, 0)
						elseif button == _G["MultiBarBottomLeftButton"..i] then
							button:SetPoint("BOTTOMLEFT", mbbl_holder, 0, 0)
						elseif button == _G["MultiBarBottomRightButton"..i] then
							button:SetPoint("BOTTOMLEFT", mbbr_holder, 0, 0)
						elseif button == _G["MultiBarLeftButton"..i] then
							button:SetPoint("RIGHT", UIParent, "RIGHT", LolzenUIcfg.actionbar["actionbar_mbl_posx"], LolzenUIcfg.actionbar["actionbar_mbl_posy"])
						elseif button == _G["MultiBarRightButton"..i] then
							button:SetPoint("RIGHT", UIParent, "RIGHT", LolzenUIcfg.actionbar["actionbar_mbr_posx"], LolzenUIcfg.actionbar["actionbar_mbr_posy"])
						elseif button == _G["PetActionButton"..i] then
							button:SetPoint("BOTTOMLEFT", pet_holder, 0, 0)
						elseif button == _G["OverrideActionBarButton"..i] then
							button:SetPoint("BOTTOMLEFT", ActionButton1)
						elseif button == _G["ExtraActionButton"..i] then
							button:SetPoint("BOTTOM", UIParent, 0, 200)
						end
					else
						if button == _G["ActionButton"..i] then
							button:SetPoint("LEFT", _G["ActionButton"..i-1], "RIGHT", LolzenUIcfg.actionbar["actionbar_button_spacing"], 0)
						elseif button == _G["MultiBarBottomLeftButton"..i] then
							button:SetPoint("LEFT", _G["MultiBarBottomLeftButton"..i-1], "RIGHT", LolzenUIcfg.actionbar["actionbar_button_spacing"], 0)
						elseif button == _G["MultiBarBottomRightButton"..i] then
							button:SetPoint("LEFT", _G["MultiBarBottomRightButton"..i-1], "RIGHT", LolzenUIcfg.actionbar["actionbar_button_spacing"], 0)
						elseif button == _G["MultiBarLeftButton"..i] then
							button:SetPoint("BOTTOM", _G["MultiBarLeftButton"..i-1], "BOTTOM", 0, - LolzenUIcfg.actionbar["actionbar_button_size"] - LolzenUIcfg.actionbar["actionbar_button_spacing"])
						elseif button == _G["MultiBarRightButton"..i] then
							button:SetPoint("BOTTOM", _G["MultiBarRightButton"..i-1], "BOTTOM", 0, - LolzenUIcfg.actionbar["actionbar_button_size"] - LolzenUIcfg.actionbar["actionbar_button_spacing"])
						elseif button == _G["PetActionButton"..i] then
							button:SetPoint("LEFT", _G["PetActionButton"..i-1], "RIGHT", LolzenUIcfg.actionbar["actionbar_button_spacing"], 0)
						elseif button == _G["OverrideActionBarButton"..i] then
							button:SetPoint("LEFT", _G["OverrideActionBarButton"..i-1], "RIGHT", LolzenUIcfg.actionbar["actionbar_button_spacing"], 0)
						end
					end
				end
			end
		end

		for _, name in pairs(actionbars) do
			setActionBarPosition(name)
		end
	end

	function ns.SetActionBarTheme()
		local actionbars = {
			"ActionButton",
			"MultiBarBottomLeftButton",
			"MultiBarBottomRightButton",
			"MultiBarLeftButton",
			"MultiBarRightButton",
			"PetActionButton",
			"OverrideActionBarButton",
			"ExtraActionButton",
		}
		for _, name in pairs(actionbars) do

			for i = 1, NUM_ACTIONBAR_BUTTONS do
				_G[name..i.."Flash"]:SetTexture(LBT:Fetch("flashing", LolzenUIcfg.actionbar["actionbar_flash_texture"]))
				_G[name..i]:SetNormalTexture(LBT:Fetch("border", LolzenUIcfg.actionbar["actionbar_normal_texture"]))
				_G[name..i]:SetCheckedTexture(LBT:Fetch("checked", LolzenUIcfg.actionbar["actionbar_checked_texture"]))
				_G[name..i]:SetHighlightTexture(LBT:Fetch("hover", LolzenUIcfg.actionbar["actionbar_hover_texture"]))
				_G[name..i]:SetPushedTexture(LBT:Fetch("pushed", LolzenUIcfg.actionbar["actionbar_pushed_texture"]))
				if LolzenUIcfg.actionbar["actionbar_normal_texture"] == "Blizzard QuickSlot2" then
					_G[name..i.."NormalTexture"]:SetPoint("TOPLEFT", _G[name..i.."Icon"], "TOPLEFT", -10, 10)
					_G[name..i.."NormalTexture"]:SetPoint("BOTTOMRIGHT", _G[name..i.."Icon"], "BOTTOMRIGHT", 11, -11)
				else
					_G[name..i.."NormalTexture"]:SetAllPoints(_G[name..i])
				end
			end
		end
	end

	-- hide pet hotkeys on login
	if event == "PLAYER_ENTERING_WORLD" then
		if LolzenUIcfg.modules["actionbars"] == false then return end
		if LolzenUIcfg.actionbar["actionbar_show_keybinds"] == false then
			for i=1, NUM_PET_ACTION_SLOTS do
				_G["PetActionButton"..i.."HotKey"]:Hide()
			end
		end
	end
end)