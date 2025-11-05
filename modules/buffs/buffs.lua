--// buffs // --

local _, ns = ...
local L = ns.L
local LSM = LibStub("LibSharedMedia-3.0")
local LBT = LibStub("LibButtonTexture-1.0")

ns.RegisterModule("buffs", L["desc_buffs"], true)

-- Cache frequently used functions for performance
local format = string.format
local ipairs = ipairs
local GetTime = GetTime
local C_Timer = C_Timer

-- Throttling variables for CPU optimization
local updateTimer = 0
local FULL_UPDATE_INTERVAL = 0.2 -- Full update every 200ms
local DURATION_UPDATE_INTERVAL = 0.1 -- Duration updates every 100ms
local lastFullUpdate = 0
local lastDurationUpdate = 0

-- Store styled buttons to avoid repeated styling
local styledButtons = {}
local hookedContainers = {}

local f = CreateFrame("Frame")
f:RegisterEvent("ADDON_LOADED")
f:RegisterEvent("UNIT_AURA")
f:SetScript("OnEvent", function(self, event, addon, unit)
	if event == "ADDON_LOADED" and addon == "LolzenUI" then
		if LolzenUIcfg.modules["buffs"] == false then return end

		-- Optimized time formatting with caching
		local timeCache = {}
		local function GetFormattedTime(seconds)
			if seconds <= 0 then return "" end
			
			-- Use cached result if available (reduces string operations)
			local key = math.floor(seconds * 10) / 10 -- Round to 1 decimal
			if timeCache[key] then
				return timeCache[key]
			end
			
			local result
			if seconds >= 86400 then 
				result = format("|cffffffff%.1fd|r", seconds/86400)
			elseif seconds >= 3600 then 
				result = format("|cffffffff%.2fh|r", seconds/3600)
			elseif seconds >= 60 then 
				result = format("|cffffffff%d:%02d|r", seconds/60, seconds%60)
			else
				result = format("|cffffffff%ds|r", seconds)
			end
			
			timeCache[key] = result
			-- Clear cache periodically to prevent memory buildup
			if math.random(1, 100) == 1 then
				wipe(timeCache)
			end
			
			return result
		end

		-- Optimized duration update with throttling
		local function UpdateDuration(self, timeLeft)
			if not self.Duration then return end
			
			if LolzenUIcfg.buffs["buff_duration_detailed"] == true then
				if timeLeft and timeLeft > 0 then
					self.Duration:SetText(GetFormattedTime(timeLeft))
					if not self.durationPositioned then
						self.Duration:ClearAllPoints()
						self.Duration:SetPoint(
							LolzenUIcfg.buffs["buff_duration_anchor1"], 
							self, 
							LolzenUIcfg.buffs["buff_duration_anchor2"], 
							LolzenUIcfg.buffs["buff_duration_posx"], 
							LolzenUIcfg.buffs["buff_duration_posy"] + 7
						)
						self.durationPositioned = true
					end
				else
					self.Duration:SetText("")
				end
			else
				self.Duration:SetText(SecondsToTimeAbbrev(timeLeft or 0))
			end
		end

		-- Optimized container update hook with throttling
		local function HookAuraContainerUpdate(container)
			if hookedContainers[container] then return end
			
			hooksecurefunc(container, "UpdateGridLayout", function(self, auras, ...)
				local currentTime = GetTime()
				
				-- Throttle full updates
				if currentTime - lastFullUpdate < FULL_UPDATE_INTERVAL then
					return
				end
				lastFullUpdate = currentTime
				
				if not auras then return end
				
				for i = 1, #auras do
					local aura = auras[i]
					if aura and not aura.hook then
						if aura.UpdateDuration then
							hooksecurefunc(aura, "UpdateDuration", UpdateDuration)
							aura.hook = true
						end
					end
				end
			end)
			
			hookedContainers[container] = true
		end

		-- Apply hooks to containers
		if BuffFrame and BuffFrame.AuraContainer then
			HookAuraContainerUpdate(BuffFrame.AuraContainer)
		end
		if DebuffFrame and DebuffFrame.AuraContainer then
			HookAuraContainerUpdate(DebuffFrame.AuraContainer)
		end

		-- Optimized aura styling with memoization
		local function StyleAuras(button)
			if not button or styledButtons[button] then return end
			
			-- Icon texture coordinates
			if button.Icon and button.Icon.SetTexCoord then
				button.Icon:SetTexCoord(0.1, 0.9, 0.1, 0.9)
			end
	
			-- Duration font styling
			if button.Duration and button.Duration.SetFont then
				button.Duration:SetFont(
					LSM:Fetch("font", LolzenUIcfg.buffs["buff_duration_font"]), 
					LolzenUIcfg.buffs["buff_duration_font_size"], 
					LolzenUIcfg.buffs["buff_duration_font_flag"]
				)
				button.Duration:SetDrawLayer("OVERLAY")
				button.durationPositioned = false -- Reset positioning flag
			end

			-- Count styling
			if button.Count then
				button.Count:ClearAllPoints()
				button.Count:SetPoint(
					LolzenUIcfg.buffs["buff_counter_anchor"], 
					button, 
					LolzenUIcfg.buffs["buff_counter_posx"], 
					LolzenUIcfg.buffs["buff_counter_posy"]
				)
				button.Count:SetFont(
					LSM:Fetch("font", LolzenUIcfg.buffs["buff_counter_font"]), 
					LolzenUIcfg.buffs["buff_counter_size"], 
					LolzenUIcfg.buffs["buff_counter_font_flag"]
				)
				button.Count:SetDrawLayer("OVERLAY")
			end

			styledButtons[button] = true
		end

		-- Optimized debuff styling
		local function StyleDebuffs(button)
			if not button or button.styled then return end
			
			if button.DebuffBorder then
				local texture = LBT:Fetch("debuff", LolzenUIcfg.buffs["buff_debuff_texture"])
				if button.DebuffBorder:GetTexture() ~= texture then
					button.DebuffBorder:SetParent(button)
					button.DebuffBorder:SetTexture(texture)
					button.DebuffBorder:SetPoint("TOPLEFT", button, "TOPLEFT", -2, 2)
					button.DebuffBorder:SetPoint("BOTTOMRIGHT", button, "BOTTOMRIGHT", 2, 7)
					button.DebuffBorder:SetTexCoord(0, 1, 0, 1)
				end
			end
			button.styled = true
		end
		
		-- Optimized buff styling
		local function StyleBuffs(button)
			if not button or button.styled then return end
			
			if not button.border then
				button.border = button:CreateTexture(nil, "BORDER")
			end
			
			local texture = LBT:Fetch("buff", LolzenUIcfg.buffs["buff_aura_texture"])
			if button.border:GetTexture() ~= texture then
				button.border:SetTexture(texture)
				
				if LolzenUIcfg.buffs["buff_aura_texture"] == "Blizzard QuickSlot2" then
					button.border:SetPoint("TOPLEFT", button, "TOPLEFT", -10, 10)
					button.border:SetPoint("BOTTOMRIGHT", button, "BOTTOMRIGHT", 10, -1)
					button.border:SetVertexColor(1, 1, 1, 1)
				else
					button.border:SetPoint("TOPLEFT", button, "TOPLEFT", -2, 2)
					button.border:SetPoint("BOTTOMRIGHT", button, "BOTTOMRIGHT", 2, 7)
					button.border:SetVertexColor(0, 0, 0, 1)
				end
				button.border:SetDrawLayer("OVERLAY")
			end
			button.styled = true
		end

		-- Batch styling function with error protection
		local function StyleAllAuras()
			-- Style buff buttons
			if BuffFrame and BuffFrame.AuraContainer then
				local buffChildren = {BuffFrame.AuraContainer:GetChildren()}
				for i = 1, #buffChildren do
					local button = buffChildren[i]
					if button then
						StyleAuras(button)
						StyleBuffs(button)
					end
				end
			end
			
			-- Style debuff buttons
			if DebuffFrame and DebuffFrame.AuraContainer then
				local debuffChildren = {DebuffFrame.AuraContainer:GetChildren()}
				for i = 1, #debuffChildren do
					local button = debuffChildren[i]
					if button then
						StyleAuras(button)
						StyleDebuffs(button)
					end
				end
			end
		end

		-- Initial styling
		StyleAllAuras()
		
		-- Periodic styling update with throttling
		local function PeriodicUpdate()
			local currentTime = GetTime()
			if currentTime - lastDurationUpdate >= DURATION_UPDATE_INTERVAL then
				StyleAllAuras()
				lastDurationUpdate = currentTime
			end
		end
		
		-- Use C_Timer for more efficient periodic updates
		C_Timer.NewTicker(DURATION_UPDATE_INTERVAL, PeriodicUpdate)
			
		-- Hide UI elements
		if BuffFrame and BuffFrame.CollapseAndExpandButton then
			BuffFrame.CollapseAndExpandButton:SetAlpha(0)
			BuffFrame.CollapseAndExpandButton:EnableMouse(false)
		end

		-- Hide private anchors
		if DebuffFrame then
			if DebuffFrame.privateAuraAnchor1 then
				DebuffFrame.privateAuraAnchor1:Hide()
			end
			if DebuffFrame.privateAuraAnchor2 then
				DebuffFrame.privateAuraAnchor2:Hide()
			end
		end
		
		-- Unregister ADDON_LOADED after initialization
		self:UnregisterEvent("ADDON_LOADED")
		
	elseif event == "UNIT_AURA" and unit == "player" then
		-- Only update on player aura changes and throttle updates
		local currentTime = GetTime()
		if currentTime - lastFullUpdate >= FULL_UPDATE_INTERVAL then
			StyleAllAuras()
			lastFullUpdate = currentTime
		end
	end

	ns.SetBuffAuraTexture = function()
			for _, button in ipairs({ BuffFrame.AuraContainer:GetChildren() }) do
				if not button then return end

				if not button.border then
					button.border = button:CreateTexture(nil, "BORDER")
					button.border:SetTexture(LBT:Fetch("buff", LolzenUIcfg.buffs["buff_aura_texture"]))
				else
					button.border:SetTexture(LBT:Fetch("buff", LolzenUIcfg.buffs["buff_aura_texture"]))
				end
				
				if LolzenUIcfg.buffs["buff_aura_texture"] == "Blizzard QuickSlot2" then
					button.border:SetPoint("TOPLEFT", button, "TOPLEFT", -10, 10)
					button.border:SetPoint("BOTTOMRIGHT", button, "BOTTOMRIGHT", 10, -1)
					button.border:SetVertexColor(1, 1, 1, 1)
				else
					button.border:SetPoint("TOPLEFT", button, "TOPLEFT", -2, 2)
					button.border:SetPoint("BOTTOMRIGHT", button, "BOTTOMRIGHT", 2, 7)
					button.border:SetVertexColor(0, 0, 0, 1)
				end
			end
		end

		ns.SetBuffDebuffTexture = function()
			for _, button in ipairs({ DebuffFrame.AuraContainer:GetChildren() }) do
				if not button then return end

				if button.DebuffBorder then
					button.DebuffBorder:SetParent(button)
					button.DebuffBorder:SetTexture(LBT:Fetch("debuff", LolzenUIcfg.buffs["buff_debuff_texture"]))
					button.DebuffBorder:SetPoint("TOPLEFT", button, "TOPLEFT", -2, 2)
					button.DebuffBorder:SetPoint("BOTTOMRIGHT", button, "BOTTOMRIGHT", 2, 7)
					button.DebuffBorder:SetTexCoord(0, 1, 0, 1)
				end
			end
		end

		ns.SetBuffDurationPosition = function()
			for _, button in ipairs({ BuffFrame.AuraContainer:GetChildren() }) do
				if not button then return end

				button.Duration:ClearAllPoints()
				button.Duration:SetPoint(LolzenUIcfg.buffs["buff_duration_anchor1"], button, LolzenUIcfg.buffs["buff_duration_anchor2"], LolzenUIcfg.buffs["buff_duration_posx"], LolzenUIcfg.buffs["buff_duration_posy"])
			end
			for _, button in ipairs({ DebuffFrame.AuraContainer:GetChildren() }) do
				if not button then return end

				button.Duration:ClearAllPoints()
				button.Duration:SetPoint(LolzenUIcfg.buffs["buff_duration_anchor1"], button, LolzenUIcfg.buffs["buff_duration_anchor2"], LolzenUIcfg.buffs["buff_duration_posx"], LolzenUIcfg.buffs["buff_duration_posy"])
			end
		end

		ns.SetBuffDurationFont = function()
			for _, button in ipairs({ BuffFrame.AuraContainer:GetChildren() }) do
				if not button then return end

				button.Duration:SetFont(LSM:Fetch("font", LolzenUIcfg.buffs["buff_duration_font"]), LolzenUIcfg.buffs["buff_duration_font_size"], LolzenUIcfg.buffs["buff_duration_font_flag"])
			end
			for _, button in ipairs({ DebuffFrame.AuraContainer:GetChildren() }) do
				if not button then return end

				button.Duration:SetFont(LSM:Fetch("font", LolzenUIcfg.buffs["buff_duration_font"]), LolzenUIcfg.buffs["buff_duration_font_size"], LolzenUIcfg.buffs["buff_duration_font_flag"])
			end
		end

		ns.SetBuffCounterPosition = function()
			for _, button in ipairs({ BuffFrame.AuraContainer:GetChildren() }) do
				if not button then return end

				button.Count:ClearAllPoints()
				button.Count:SetPoint(LolzenUIcfg.buffs["buff_counter_anchor"], button, LolzenUIcfg.buffs["buff_counter_posx"], LolzenUIcfg.buffs["buff_counter_posy"])
			end
			for _, button in ipairs({ DebuffFrame.AuraContainer:GetChildren() }) do
				if not button then return end

				button.Count:ClearAllPoints()
				button.Count:SetPoint(LolzenUIcfg.buffs["buff_counter_anchor"], button, LolzenUIcfg.buffs["buff_counter_posx"], LolzenUIcfg.buffs["buff_counter_posy"])
			end
		end

		ns.SetBuffCounterFont = function()
			for _, button in ipairs({ BuffFrame.AuraContainer:GetChildren() }) do
				if not button then return end

				button.Count:SetFont(LSM:Fetch("font", LolzenUIcfg.buffs["buff_counter_font"]), LolzenUIcfg.buffs["buff_counter_size"], LolzenUIcfg.buffs["buff_counter_font_flag"])
			end
			for _, button in ipairs({ DebuffFrame.AuraContainer:GetChildren() }) do
				if not button then return end

				button.Count:SetFont(LSM:Fetch("font", LolzenUIcfg.buffs["buff_counter_font"]), LolzenUIcfg.buffs["buff_counter_size"], LolzenUIcfg.buffs["buff_counter_font_flag"])
			end
		end
end)