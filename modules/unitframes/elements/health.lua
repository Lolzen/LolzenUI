local _, ns = ...
local oUF = ns.oUF
local LSM = LibStub("LibSharedMedia-3.0")

local function EnsureColorObjects()
	-- Convert all color tables to proper ColorMixin objects
	local function ConvertColor(color)
		if not color then return CreateColor(1, 1, 1, 1) end
		
		-- Already a ColorMixin object
		if type(color) == "table" and color.GetRGB then
			return color
		end
		
		-- Table format - try different possible formats
		if type(color) == "table" then
			local r = color[1] or color.r
			local g = color[2] or color.g
			local b = color[3] or color.b
			local a = color[4] or color.a or 1
			
			-- Ensure we have valid RGB values
			if r and g and b then
				return CreateColor(r, g, b, a)
			end
		end
		
		-- Fallback - white
		return CreateColor(1, 1, 1, 1)
	end
	
	-- Process all color categories
	if oUF.colors then
		-- Class colors
		if oUF.colors.class then
			for class, color in pairs(oUF.colors.class) do
				oUF.colors.class[class] = ConvertColor(color)
			end
		end
		
		-- Reaction colors
		if oUF.colors.reaction then
			for i = 1, 8 do
				if oUF.colors.reaction[i] then
					oUF.colors.reaction[i] = ConvertColor(oUF.colors.reaction[i])
				end
			end
		end
		
		-- Power colors
		if oUF.colors.power then
			for powerType, color in pairs(oUF.colors.power) do
				oUF.colors.power[powerType] = ConvertColor(color)
			end
		end
		
		-- Single color values
		local singleColors = {
			'tapped', 'disconnected', 'health', 'tapping'
		}
		
		for _, colorName in ipairs(singleColors) do
			if oUF.colors[colorName] then
				oUF.colors[colorName] = ConvertColor(oUF.colors[colorName])
			end
		end
		
		-- Rune colors (indexed)
		if oUF.colors.runes then
			for i = 1, 6 do
				if oUF.colors.runes[i] then
					oUF.colors.runes[i] = ConvertColor(oUF.colors.runes[i])
				end
			end
		end
	end
end

-- Call it immediately
EnsureColorObjects()

local PostUpdateHealth = function(Health, unit, cur, max, curModifier, maxModifier)
	-- Use the modifiers to calculate percentage
	-- curModifier and maxModifier are non-secret values provided by oUF
	-- They represent the actual vs modified values
	local percentage
	
	if maxModifier and maxModifier > 0 then
		-- Use modified values if available
		percentage = (curModifier or 0) / maxModifier
	else
		-- Fallback: assume full health if we can't calculate
		percentage = 1
	end
	
	-- Handle reaction coloring manually to avoid broken color tables
	if unit ~= "player" and UnitReaction(unit, "player") then
		local reaction = UnitReaction(unit, "player")
		local reactionColors = {
			[1] = {0.8, 0.0, 0.0},  -- Hated
			[2] = {0.8, 0.0, 0.0},  -- Hostile
			[3] = {0.8, 0.0, 0.0},  -- Unfriendly
			[4] = {0.8, 0.8, 0.0},  -- Neutral
			[5] = {0.0, 0.8, 0.0},  -- Friendly
			[6] = {0.0, 0.8, 0.0},  -- Honored
			[7] = {0.0, 0.8, 0.0},  -- Revered
			[8] = {0.0, 0.8, 0.0},  -- Exalted
		}
		local color = reactionColors[reaction] or reactionColors[4]
		Health:SetStatusBarColor(color[1], color[2], color[3])
	end

	-- Access colors through oUF.colors
	local r, g, b = oUF.colors.health:GetRGB(percentage)
	if Health.value then
		Health.value:SetTextColor(r, g, b)
	end
end

function ns.AddHealthBar(self, unit)
	local Health = CreateFrame("StatusBar", nil, self)
	Health:SetStatusBarTexture(LSM:Fetch("statusbar", LolzenUIcfg.unitframes.general["uf_statusbar_texture"]))
	Health:SetFrameStrata("LOW")
	
	Health.smoothing = Enum.StatusBarInterpolation.Smooth
	
	--Health.colorTapping = unit ~= "raid"
	Health.colorDisconnected = true
	Health.colorClass = true
	Health.colorReaction = true
	
	Health:SetPoint("TOP")
	Health:SetPoint("LEFT")
	Health:SetPoint("RIGHT")
	
	self.Health = Health
	
	-- Ensure reaction colors have curves set up
	-- This might prevent the GetRGB error
	if oUF.colors.reaction then
		for i = 1, 8 do
			if oUF.colors.reaction[i] and not oUF.colors.reaction[i].GetRGB then
				-- Convert old-style color to new color object
				local r, g, b = unpack(oUF.colors.reaction[i])
				oUF.colors.reaction[i] = CreateColor(r, g, b, 1)
			end
		end
	end
	
	-- Background
	local bg = Health:CreateTexture(nil, "BORDER")
	bg:SetAllPoints(Health)
	bg:SetTexture(LSM:Fetch("statusbar", LolzenUIcfg.unitframes.general["uf_statusbar_texture"]))
	bg:SetVertexColor(0.3, 0.3, 0.3)
	bg.multiplier = 0.3
	
	Health.PostUpdate = PostUpdateHealth
end