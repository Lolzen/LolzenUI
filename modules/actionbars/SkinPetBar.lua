--// Skin //--

local addon, ns = ...

local skinned
local f = CreateFrame("Frame")
f:RegisterEvent("ADDON_LOADED")
f:SetScript("OnEvent", function(self, event, addon)
	if addon == "LolzenUI" then
		if LolzenUIcfg["actionbars"] == false then return end
		if skinned == true then return end

		local function applyPetBarTheme(self, i)
			local button = self..i

			_G[button.."Icon"]:SetTexCoord(.08, .92, .08, .92)
			_G[button.."Icon"]:SetPoint("TOPLEFT", button, "TOPLEFT", 2, -2)
			_G[button.."Icon"]:SetPoint("BOTTOMRIGHT", button, "BOTTOMRIGHT", -2, 2)

			_G[button.."Flash"]:SetTexture("Interface\\AddOns\\LolzenUI\\media\\flash")
			_G[button]:SetNormalTexture("Interface\\AddOns\\LolzenUI\\media\\gloss")
			_G[button]:SetCheckedTexture("Interface\\AddOns\\LolzenUI\\media\\checked")
			_G[button]:SetHighlightTexture("Interface\\AddOns\\LolzenUI\\media\\hover")
			_G[button]:SetPushedTexture("Interface\\AddOns\\LolzenUI\\media\\pushed")

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

		hooksecurefunc("PetActionBar_Update", applyThemeToPetBar)
		skinned = true
	end
end)