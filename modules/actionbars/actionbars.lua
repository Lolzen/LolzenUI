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

		-- Hide the StatusTrackingBarManager
		StatusTrackingBarManager:UnregisterAllEvents()
		StatusTrackingBarManager:Hide()
		StatusTrackingBarManager.show = StatusTrackingBarManager.Hide

		--// Bar sizes, positions & styling//--

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

			if _G[name.."Cooldown"] then
				_G[name.."Cooldown"]:SetPoint("TOPLEFT", _G[name], "TOPLEFT", 2, -2)
				_G[name.."Cooldown"]:SetPoint("BOTTOMRIGHT", _G[name], "BOTTOMRIGHT", -2, 2)
			end

			if _G[name.."HotKey"] then
				if LolzenUIcfg.actionbar["actionbar_show_keybinds"] == false then
					_G[name.."HotKey"]:SetAlpha(0)
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
					_G[name.."NormalTexture"]:SetPoint("TOPLEFT", _G[name.."Icon"], "TOPLEFT", -14, 14)
					_G[name.."NormalTexture"]:SetPoint("BOTTOMRIGHT", _G[name.."Icon"], "BOTTOMRIGHT", 15, -15)
				else
					_G[name.."NormalTexture"]:SetAllPoints(_G[name])
				end
			end

			if _G[name]["PushedTexture"] then
				_G[name]["PushedTexture"]:SetAllPoints(_G[name])
			end
				
			if _G[name.."Shine"] then
				_G[name.."Shine"]:SetPoint("TOPLEFT", _G[name], "TOPLEFT", 2, -2)
				_G[name.."Shine"]:SetPoint("BOTTOMRIGHT", _G[name], "BOTTOMRIGHT", -2, 2)
			end

			if _G[name.."AutoCastable"] then
				--autocastable is unresizable as of last. simply hide it for now
				_G[name.."AutoCastable"]:SetAlpha(0)
			--	_G[name.."AutoCastable"]:SetPoint("TOPLEFT", _G[name], "TOPLEFT", -2, 2)
			--	_G[name.."AutoCastable"]:SetPoint("BOTTOMRIGHT", _G[name], "BOTTOMRIGHT", -2, 2)
			end
		end


		local function setActionBarPosition(name)
			for i = 1, NUM_ACTIONBAR_BUTTONS do
				local button = _G[name..i]

				if button then
					applyTheme(name..i)
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
				if _G[name..i] then
					_G[name..i.."Flash"]:SetTexture(LBT:Fetch("flashing", LolzenUIcfg.actionbar["actionbar_flash_texture"]))
					_G[name..i]:SetNormalTexture(LBT:Fetch("border", LolzenUIcfg.actionbar["actionbar_normal_texture"]))
					_G[name..i]:SetCheckedTexture(LBT:Fetch("checked", LolzenUIcfg.actionbar["actionbar_checked_texture"]))
					_G[name..i]:SetHighlightTexture(LBT:Fetch("hover", LolzenUIcfg.actionbar["actionbar_hover_texture"]))
					_G[name..i]:SetPushedTexture(LBT:Fetch("pushed", LolzenUIcfg.actionbar["actionbar_pushed_texture"]))

					if name ~= "PetActionButton" then
						if _G[name..i.."NormalTexture"] then
							if LolzenUIcfg.actionbar["actionbar_normal_texture"] == "Blizzard QuickSlot2" then
								_G[name..i.."NormalTexture"]:SetPoint("TOPLEFT", _G[name..i.."Icon"], "TOPLEFT", -14, 14)
								_G[name..i.."NormalTexture"]:SetPoint("BOTTOMRIGHT", _G[name..i.."Icon"], "BOTTOMRIGHT", 15, -15)
							else
								_G[name..i.."NormalTexture"]:SetAllPoints(_G[name..i])
							end
						end
					end
				end
			end
		end
	end
	ns.SetActionBarTheme()

	function ns.SetActionBarKeyBindToggle()
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
		
		for i = 1, NUM_ACTIONBAR_BUTTONS do
			for _, name in pairs(actionbars) do
				if _G[name..i.."HotKey"] then
					if LolzenUIcfg.actionbar["actionbar_show_keybinds"] == false then
						_G[name..i.."HotKey"]:SetAlpha(0)
					else
						_G[name..i.."HotKey"]:SetAlpha(1)
					end
				end
			end
		end
	end
end)