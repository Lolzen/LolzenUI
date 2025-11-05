--// actionbars //--

local _, ns = ...
local L = ns.L
local LBT = LibStub("LibButtonTexture-1.0")

ns.RegisterModule("actionbars", L["desc_actionbars"], true)

-- Cache frequently used globals for better performance
local _G = _G
local CreateFrame = CreateFrame
local NUM_ACTIONBAR_BUTTONS = NUM_ACTIONBAR_BUTTONS

-- Pre-cache actionbar button names to avoid repeated string concatenation
local ACTIONBAR_BUTTONS = {
	"ActionButton",              -- MainMenuBar (ActionButton1-12)
	"MultiBarBottomLeftButton", 
	"MultiBarBottomRightButton",
	"MultiBarLeftButton",
	"MultiBarRightButton",
	"PetActionButton",
	"OverrideActionBarButton",
	"ExtraActionButton",
}

-- Additional buttons that may need theming
local ADDITIONAL_BUTTONS = {
	"BonusActionButton",         -- Bonus action bar buttons
}

-- Cached texture fetching to reduce LibButtonTexture calls
local cachedTextures = {}
local function getCachedTexture(textureType, textureName)
	local key = textureType .. "_" .. textureName
	if not cachedTextures[key] then
		cachedTextures[key] = LBT:Fetch(textureType, textureName)
	end
	return cachedTextures[key]
end

-- Single frame for all events to reduce overhead
local eventFrame = CreateFrame("Frame")
eventFrame:RegisterEvent("ADDON_LOADED")
eventFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
eventFrame:RegisterEvent("PLAYER_LOGIN")  -- Additional event for MainMenuBar reliability

-- Optimized theme application function
local function applyTheme(buttonName)
	local button = _G[buttonName]
	if not button then return end
	
	local icon = _G[buttonName.."Icon"]
	local flash = _G[buttonName.."Flash"]
	local cooldown = _G[buttonName.."Cooldown"]
	local hotkey = _G[buttonName.."HotKey"]
	local name = _G[buttonName.."Name"]
	local floatingBG = _G[buttonName.."FloatingBG"]
	local normalTexture = _G[buttonName.."NormalTexture"]
	local pushedTexture = button.PushedTexture
	local shine = _G[buttonName.."Shine"]
	local autoCastable = _G[buttonName.."AutoCastable"]
	
	-- Icon positioning and cropping
	if icon then
		icon:SetTexCoord(0.08, 0.92, 0.08, 0.92)
		icon:SetPoint("TOPLEFT", button, "TOPLEFT", 2, -2)
		icon:SetPoint("BOTTOMRIGHT", button, "BOTTOMRIGHT", -2, 2)
	end
	
	-- Apply textures using cached versions
	if flash then
		flash:SetTexture(getCachedTexture("flashing", LolzenUIcfg.actionbar["actionbar_flash_texture"]))
	end
	
	button:SetNormalTexture(getCachedTexture("border", LolzenUIcfg.actionbar["actionbar_normal_texture"]))
	button:SetCheckedTexture(getCachedTexture("checked", LolzenUIcfg.actionbar["actionbar_checked_texture"]))
	button:SetHighlightTexture(getCachedTexture("hover", LolzenUIcfg.actionbar["actionbar_hover_texture"]))
	button:SetPushedTexture(getCachedTexture("pushed", LolzenUIcfg.actionbar["actionbar_pushed_texture"]))
	
	-- Cooldown positioning
	if cooldown then
		cooldown:SetPoint("TOPLEFT", button, "TOPLEFT", 2, -2)
		cooldown:SetPoint("BOTTOMRIGHT", button, "BOTTOMRIGHT", -2, 2)
	end
	
	-- Keybind visibility
	if hotkey then
		hotkey:SetAlpha(LolzenUIcfg.actionbar["actionbar_show_keybinds"] and 1 or 0)
	end
	
	-- Hide unwanted elements
	if name then name:Hide() end
	if floatingBG then floatingBG:Hide() end
	
	-- Normal texture positioning
	if normalTexture then
		if LolzenUIcfg.actionbar["actionbar_normal_texture"] == "Blizzard QuickSlot2" and icon then
			normalTexture:SetPoint("TOPLEFT", icon, "TOPLEFT", -14, 14)
			normalTexture:SetPoint("BOTTOMRIGHT", icon, "BOTTOMRIGHT", 15, -15)
		else
			normalTexture:SetAllPoints(button)
		end
	end
	
	-- Pushed texture positioning
	if pushedTexture then
		pushedTexture:SetAllPoints(button)
	end
	
	-- Shine positioning
	if shine then
		shine:SetPoint("TOPLEFT", button, "TOPLEFT", 2, -2)
		shine:SetPoint("BOTTOMRIGHT", button, "BOTTOMRIGHT", -2, 2)
	end
	
	-- Hide AutoCastable (unresizable as of latest patches)
	if autoCastable then
		autoCastable:SetAlpha(0)
	end
end

-- Optimized function to apply theme to all buttons of a specific type
local function applyThemeToButtonSet(buttonPrefix)
	for i = 1, NUM_ACTIONBAR_BUTTONS do
		local buttonName = buttonPrefix .. i
		if _G[buttonName] then
			applyTheme(buttonName)
		end
	end
end

-- Main initialization function
local function initializeActionBars()
	if not LolzenUIcfg or not LolzenUIcfg.modules["actionbars"] then 
		return 
	end
	
	-- Hide StatusTrackingBarManager with improved method
	local statusManager = StatusTrackingBarManager
	if statusManager then
		statusManager:UnregisterAllEvents()
		statusManager:Hide()
		statusManager:SetScript("OnShow", statusManager.Hide)
		-- Cache the hide function to prevent repeated calls
		statusManager.show = statusManager.Hide
	end
	
	-- Apply themes to all actionbar types
	for _, buttonPrefix in ipairs(ACTIONBAR_BUTTONS) do
		applyThemeToButtonSet(buttonPrefix)
	end
	
	-- Apply themes to additional button types
	for _, buttonPrefix in ipairs(ADDITIONAL_BUTTONS) do
		applyThemeToButtonSet(buttonPrefix)
	end
	
	-- Special handling for MainMenuBar to ensure it's properly themed
	-- Force update ActionButtons after a short delay for reliability
	C_Timer.After(0.1, function()
		for i = 1, NUM_ACTIONBAR_BUTTONS do
			local buttonName = "ActionButton" .. i
			if _G[buttonName] then
				applyTheme(buttonName)
			end
		end
	end)
end

-- Event handler with reduced overhead
eventFrame:SetScript("OnEvent", function(self, event, addon)
	if event == "ADDON_LOADED" and addon == "LolzenUI" then
		initializeActionBars()
	elseif event == "PLAYER_LOGIN" then
		-- Ensure MainMenuBar is properly themed after login
		C_Timer.After(0.5, function()
			for i = 1, NUM_ACTIONBAR_BUTTONS do
				local buttonName = "ActionButton" .. i
				if _G[buttonName] then
					applyTheme(buttonName)
				end
			end
		end)
	end
end)

-- Optimized theme update function for settings changes
function ns.SetActionBarTheme()
	-- Clear texture cache when themes change
	wipe(cachedTextures)
	
	-- Combine all button types for processing
	local allButtonTypes = {}
	for _, buttonPrefix in ipairs(ACTIONBAR_BUTTONS) do
		table.insert(allButtonTypes, buttonPrefix)
	end
	for _, buttonPrefix in ipairs(ADDITIONAL_BUTTONS) do
		table.insert(allButtonTypes, buttonPrefix)
	end
	
	for _, buttonPrefix in ipairs(allButtonTypes) do
		for i = 1, NUM_ACTIONBAR_BUTTONS do
			local buttonName = buttonPrefix .. i
			local button = _G[buttonName]
			if button then
				local flash = _G[buttonName.."Flash"]
				local normalTexture = _G[buttonName.."NormalTexture"]
				local icon = _G[buttonName.."Icon"]
				
				-- Update textures
				if flash then
					flash:SetTexture(getCachedTexture("flashing", LolzenUIcfg.actionbar["actionbar_flash_texture"]))
				end
				
				button:SetNormalTexture(getCachedTexture("border", LolzenUIcfg.actionbar["actionbar_normal_texture"]))
				button:SetCheckedTexture(getCachedTexture("checked", LolzenUIcfg.actionbar["actionbar_checked_texture"]))
				button:SetHighlightTexture(getCachedTexture("hover", LolzenUIcfg.actionbar["actionbar_hover_texture"]))
				button:SetPushedTexture(getCachedTexture("pushed", LolzenUIcfg.actionbar["actionbar_pushed_texture"]))
				
				-- Handle normal texture positioning for non-pet buttons
				if buttonPrefix ~= "PetActionButton" and normalTexture then
					if LolzenUIcfg.actionbar["actionbar_normal_texture"] == "Blizzard QuickSlot2" and icon then
						normalTexture:SetPoint("TOPLEFT", icon, "TOPLEFT", -14, 14)
						normalTexture:SetPoint("BOTTOMRIGHT", icon, "BOTTOMRIGHT", 15, -15)
					else
						normalTexture:SetAllPoints(button)
					end
				end
			end
		end
	end
end

-- Optimized keybind toggle function
function ns.SetActionBarKeyBindToggle()
	local showKeybinds = LolzenUIcfg.actionbar["actionbar_show_keybinds"]
	local alpha = showKeybinds and 1 or 0
	
	-- Combine all button types for processing
	local allButtonTypes = {}
	for _, buttonPrefix in ipairs(ACTIONBAR_BUTTONS) do
		table.insert(allButtonTypes, buttonPrefix)
	end
	for _, buttonPrefix in ipairs(ADDITIONAL_BUTTONS) do
		table.insert(allButtonTypes, buttonPrefix)
	end
	
	for _, buttonPrefix in ipairs(allButtonTypes) do
		for i = 1, NUM_ACTIONBAR_BUTTONS do
			local hotkey = _G[buttonPrefix .. i .. "HotKey"]
			if hotkey then
				hotkey:SetAlpha(alpha)
			end
		end
	end
end

-- Initialize on load
initializeActionBars()