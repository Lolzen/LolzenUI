--// tooltip // --

local _, ns = ...
local L = ns.L
local LSM = LibStub("LibSharedMedia-3.0")

ns.RegisterModule("tooltip", L["desc_tooltip"], true)

-- Cache frequently used globals and functions for better performance
local UnitExists, UnitName, UnitClass, UnitRace, UnitLevel = UnitExists, UnitName, UnitClass, UnitRace, UnitLevel
local UnitIsPlayer, UnitIsPVP, UnitIsAFK, UnitIsDND, UnitIsConnected = UnitIsPlayer, UnitIsPVP, UnitIsAFK, UnitIsDND, UnitIsConnected
local UnitReaction, UnitClassification, UnitCreatureType = UnitReaction, UnitClassification, UnitCreatureType
local UnitFactionGroup, UnitIsInMyGuild, UnitIsFriend = UnitFactionGroup, UnitIsInMyGuild, UnitIsFriend
local GetGuildInfo, GetRaidTargetIndex, GetZonePVPInfo = GetGuildInfo, GetRaidTargetIndex, GetZonePVPInfo
local GetItemQualityColor, GetQuestDifficultyColor = C_Item.GetItemQualityColor, GetQuestDifficultyColor
local GetSpecializationInfoByID, GetInspectSpecialization = GetSpecializationInfoByID, GetInspectSpecialization
local RAID_CLASS_COLORS, FACTION_BAR_COLORS = RAID_CLASS_COLORS, FACTION_BAR_COLORS
local string_format, string_gsub, string_sub, string_lower = string.format, string.gsub, string.sub, string.lower
local select, unpack, type, pairs = select, unpack, type, pairs

-- Safe function to get tooltip line text
local function getTooltipLineText(lineNum)
	local line = _G["GameTooltipTextLeft" .. lineNum]
	return line and line:GetText() or nil
end

-- Safe function to set tooltip line text
local function setTooltipLineText(lineNum, text)
	local line = _G["GameTooltipTextLeft" .. lineNum]
	if line then
		line:SetText(text)
	end
end

-- Safe function to set tooltip line color
local function setTooltipLineColor(lineNum, r, g, b)
	local line = _G["GameTooltipTextLeft" .. lineNum]
	if line and r and g and b then
		line:SetTextColor(r, g, b)
	end
end

-- Safe function to get/set right side tooltip text
local function getTooltipRightText(lineNum)
	local line = _G["GameTooltipTextRight" .. lineNum]
	return line and line:GetText() or nil
end

local function setTooltipRightText(lineNum, text)
	local line = _G["GameTooltipTextRight" .. lineNum]
	if line then
		line:SetText(text)
		line:Show()
	end
end

local function hideTooltipRightText(lineNum)
	local line = _G["GameTooltipTextRight" .. lineNum]
	if line then
		line:Hide()
	end
end

local f = CreateFrame("Frame")
f:RegisterEvent("ADDON_LOADED")
f:SetScript("OnEvent", function(self, event, addon)
	if addon == "LolzenUI" then
		if LolzenUIcfg.modules["tooltip"] == false then return end

		local tooltips = {
			-- general tooltips
			GameTooltip,
			ItemRefTooltip,
			-- shopping tooltips
			ShoppingTooltip1,
			ShoppingTooltip2,
			ShoppingTooltip3,
			--General
			WorldMapTooltip,
		--	EmbeddedItemTooltip,
		--	ItemRefShoppingTooltip1,
		--	ItemRefShoppingTooltip2,
		}

		--9.1.5 fix
		for i=1, #tooltips do
			if not tooltips[i].SetBackdrop then
				Mixin(tooltips[i], BackdropTemplateMixin)
			end
		end

		-- overwrite tooltip styles
		local tt_style = {
			bgFile = "Interface\\Buttons\\WHITE8x8",
			edgeFile = LSM:Fetch("border", LolzenUIcfg.tooltip["tip_border"]),
			tile = false,
			tileEdge = true,
			tileSize = 16,
			edgeSize = 16,
			insets = { left = 3, right = 3, top = 3, bottom = 3 },

			backdropBorderColor = CreateColor(1, 1, 1),
			backdropColor = CreateColor(0, 0, 0),
		}

		-- customize the mobClassification
		local mobType = {
			["normal"] = "",
			["worldboss"] = " Boss",
			["rareelite"] = " + Rare",
			["rare"] = " Rare",
			["elite"] = " +",
			["trivial"] = "Trivial",
			["minus"] = " -",
		}

		-- faction icons
		local factionIcons = {
			["Alliance"] = "Interface\\Timer\\Alliance-Logo",
			["Horde"] = "Interface\\Timer\\Horde-Logo",
		}

		-- faction icon
		local factionbg = GameTooltip:CreateTexture("GameTooltFactionBackground", "BACKGROUND")
		factionbg:SetSize(64, 64)
		factionbg:SetPoint("RIGHT", GameTooltip, "TOPLEFT", 32, -4)
		factionbg:SetDrawLayer("BACKGROUND", -8)

		-- raidicon on the tooltip, because why not
		local ricon = GameTooltip:CreateTexture("GameTooltipRaidIcon", "OVERLAY")
		ricon:SetSize(18, 18)
		ricon:SetPoint("TOP", GameTooltip, "TOP", 0, 5)

		-- make the Healthbar sweet
		GameTooltipStatusBar:ClearAllPoints()
		GameTooltipStatusBar:SetPoint("BOTTOMLEFT", 5, 4)
		GameTooltipStatusBar:SetPoint("BOTTOMRIGHT", -5, 4)
		GameTooltipStatusBar:SetStatusBarTexture(LSM:Fetch("statusbar", LolzenUIcfg.tooltip["tip_healthbar_texture"]))
		GameTooltipStatusBar:SetStatusBarColor(0.3, 0.9, 0.3, 1)
		GameTooltipStatusBar:SetHeight(2)
		
		-- Build spec name to icon lookup table
		local specIconLookup = {}
		local function buildSpecLookup()
			for classID = 1, GetNumClasses() do
				local _, classFile = GetClassInfo(classID)
				if classFile then
					local numSpecs = GetNumSpecializationsForClassID(classID)
					for specIndex = 1, numSpecs do
						local specID, name, _, icon = GetSpecializationInfoForClassID(classID, specIndex)
						if name and icon then
							-- Store both localized name and icon
							specIconLookup[name] = icon
						end
					end
				end
			end
		end
		buildSpecLookup()
		
		-- return the unit which is mouseovered
		local function getTooltipUnit()
			-- Use modern tooltip data API
			local tooltipData = GameTooltip:GetTooltipData()
			if tooltipData and tooltipData.type == Enum.TooltipDataType.Unit then
				return tooltipData.guid and UnitTokenFromGUID(tooltipData.guid) or nil
			end
			
			-- Fallback to old method
			local _, unit = GameTooltip:GetUnit()
			return unit
		end

		-- return the unitClassColor values
		local function getClassColor(unit)
			if not unit or not UnitExists(unit) then return 0.5, 0.5, 0.5 end
			
			local _, classToken = UnitClass(unit)
			if classToken then
				local classColor = RAID_CLASS_COLORS[classToken]
				if classColor then
					return classColor.r, classColor.g, classColor.b
				end
			end
			return 0.5, 0.5, 0.5 -- fallback gray
		end

		-- return the unitReactionColor values
		local function getReactionColor(unit)
			if not unit or not UnitExists(unit) then return 0.5, 0.5, 0.5 end
			
			local reaction = UnitReaction(unit, "player")
			if not reaction then return 0.5, 0.5, 0.5 end
			
			if LolzenUIcfg.modules["miscellaneous"] and LolzenUIcfg.miscellaneous["misc_alternative_faction_colors"] then
				local reactioncolor = LolzenUIcfg.miscellaneous["misc_faction_colors"][reaction]
				if reactioncolor then
					return reactioncolor[1], reactioncolor[2], reactioncolor[3]
				end
			end
			
			local reactioncolor = FACTION_BAR_COLORS[reaction]
			if reactioncolor then
				return reactioncolor.r, reactioncolor.g, reactioncolor.b
			end
			
			return 0.5, 0.5, 0.5 -- fallback
		end

		-- return hex value of color values and the unitname
		local function getColorHexUnit(unit, r, g, b)
			if not unit or not UnitExists(unit) then return "" end
			
			local unitName = UnitName(unit)
			if not unitName then return "" end
			
			if r and g and b then
				return string_format("|cff%02x%02x%02x%s|r", r*255, g*255, b*255, unitName)
			else
				return string_format("|cff888888%s|r", unitName)
			end
		end

		-- return a questdifficulty inspired colored level
		local function getColorizedLevel(unit)
			if not unit or not UnitExists(unit) then return "" end
			
			local level = UnitLevel(unit)
			if not level then return "" end
			
			if level == -1 then
				return "|cffff0000??|r"
			else
				local diff = GetQuestDifficultyColor(level)
				if diff then
					return string_format("|cff%02x%02x%02x%d|r", diff.r*255, diff.g*255, diff.b*255, level)
				else
					return tostring(level)
				end
			end
		end

		-- return the unitclassification
		local function getMobType(unit)
			if not unit or not UnitExists(unit) then return "" end
			
			local classification = UnitClassification(unit)
			return mobType[classification] or classification or ""
		end

		-- return the StatusFlag aka AFK, DND or offline
		local function getStatusFlag(unit)
			if not unit or not UnitExists(unit) then return "" end
			
			if UnitIsAFK(unit) then
				local r, g, b = unpack(LolzenUIcfg.tooltip["tip_statusflag_afk_color"])
				return ("|cff%02x%02x%02x%s ".."|r "):format(r*255, g*255, b*255, LolzenUIcfg.tooltip["tip_statusflag_afk"])
			elseif UnitIsDND(unit) then
				local r, g, b = unpack(LolzenUIcfg.tooltip["tip_statusflag_dnd_color"])
				return ("|cff%02x%02x%02x%s ".."|r "):format(r*255, g*255, b*255, LolzenUIcfg.tooltip["tip_statusflag_dnd"])
			elseif not UnitIsConnected(unit) then
				local r, g, b = unpack(LolzenUIcfg.tooltip["tip_statusflag_off_color"])
				return ("|cff%02x%02x%02x%s ".."|r "):format(r*255, g*255, b*255, LolzenUIcfg.tooltip["tip_statusflag_off"])
			end
			return "" 
		end

		-- colorize tooltipBorder accordingly to itemQuality
		local function colorItemQuality(self)
			if not self or not self.SetBackdrop then 
				Mixin(self, BackdropTemplateMixin) 
			end
			
			local tooltipData = self:GetTooltipData()
			if tooltipData and tooltipData.type == Enum.TooltipDataType.Item then
				local itemID = tooltipData.id
				if itemID then
					local itemQuality = C_Item.GetItemQualityByID(itemID)
					if itemQuality then
						local r, g, b = GetItemQualityColor(itemQuality)
						if r and g and b then
							self:SetBackdropBorderColor(r, g, b)
						end
					end
				end
			end
		end

		-- colorize tooltipborder accordingly to Azerite Essence rank
		local function colorEssenceQuality(self)
			if not self then return end
			
			local firstLineText = getTooltipLineText(1)
			if not firstLineText then return end
			
			local selectedEssenceRank = string.gsub(firstLineText, "[%a%p%s]", "")
			local rankNum = tonumber(selectedEssenceRank)
			if rankNum then
				local r, g, b = GetItemQualityColor(rankNum + 1)
				if r and g and b then
					self:SetBackdropBorderColor(r, g, b)
				end
			end
		end

		-- colorize tooltipborder accordingly to Azerite EssenceSlot rank
		local function colorEssenceSlotQuality(self)
			if not self or not C_AzeriteEssence then return end
			
			local firstLineText = getTooltipLineText(1)
			if not firstLineText then return end
			
			local selectedEssenceName = string.gsub(firstLineText, " %b()", "")
			local essences = C_AzeriteEssence.GetEssences()
			if not essences or type(essences) ~= "table" then return end
			
			for _, slot in pairs(essences) do
				local essence = C_AzeriteEssence.GetEssenceInfo(slot.ID)
				if essence and selectedEssenceName == essence.name then
					local r, g, b = GetItemQualityColor(essence.rank + 1)
					if r and g and b then
						self:SetBackdropBorderColor(r, g, b)
					end
				end
			end
		end

		--- Add spec icon based on text matching
local function addSpecIconByText()
	if not LolzenUIcfg.tooltip["tip_display_talents"] then return end
	
	local unit = getTooltipUnit()
	if not unit or not UnitExists(unit) then return end
	
	local raceName = UnitRace(unit)
	
	for i = 1, GameTooltip:NumLines() do
		local lineText = getTooltipLineText(i)
		if lineText and not lineText:find("^" .. LEVEL) and not lineText:find("|T") then
			-- Skip if line contains race name
			if not raceName or not lineText:find(raceName) then
				-- Check each spec name in our lookup table
				for specName, icon in pairs(specIconLookup) do
					if lineText:find(specName) then
						-- Found a match! Add the icon
						setTooltipLineText(i, string_format("|T%s:16:16:0:0|t %s", icon, lineText))
						return -- Only add one icon per tooltip
					end
				end
			end
		end
	end
end

		-- return the alternative PvP flag
		local function getPvPflag(unit)
			if not unit or not UnitExists(unit) or not UnitIsPVP(unit) then return "" end
			
			local _, instanceType = IsInInstance()
			if instanceType == "pvp" or instanceType == "arena" or GetZonePVPInfo() == "combat" then
				return ""
			end
			
			return "|cff00ff00(PvP)|r "
		end
		
		-- return the target of the mouseovetarget on the tooltip
		local function getUnitTarget(unit)
			if not unit or not UnitExists(unit .. "target") then return "" end
			
			if UnitIsPlayer(unit .. "target") then
				if UnitName(unit .. "target") == UnitName("player") then
					return "|cffffffff[YOU]|r"
				else
					return getColorHexUnit(unit .. "target", getClassColor(unit .. "target"))
				end
			else
				return getColorHexUnit(unit .. "target", getReactionColor(unit .. "target"))
			end
		end

		-- function which can be called to show/hide the unit's target
		local function showUT(unit)
			if unit and UnitExists(unit .. "target") then
				setTooltipRightText(1, "|cffffffff>>|r" .. getUnitTarget(unit))
				GameTooltip:AppendText("")
			else
				hideTooltipRightText(1)
				GameTooltip:AppendText("")
			end
		end

		-- general tooltip modifications
		local function modifyTooltip(tooltip, tooltipData)
			local unit = getTooltipUnit()
			if not unit or not UnitExists(unit) then return end

			-- Safe check for self parameter
			local self = tooltip or GameTooltip
			if not self then return end

			-- colorize TooltipBorder accordingly to classColor or UnitReaction
			if UnitIsPlayer(unit) then
				-- colorize the tooltip border with classcolor
				local r, g, b = getClassColor(unit)
				if r and g and b then
					self:SetBackdropBorderColor(r, g, b)
				end
				
				-- colorize the unit's name and add the alternative PvP flag
				local coloredName = getColorHexUnit(unit, r, g, b)
				local statusFlag = getStatusFlag(unit)
				local pvpFlag = getPvPflag(unit)
				
				setTooltipLineText(1, pvpFlag .. statusFlag .. coloredName)
				
				-- colorize the guild name if it's the same as the Player's
				-- or color any guild if the option is set
				if GetGuildInfo(unit) then
					local secondLineText = getTooltipLineText(2)
					if secondLineText then
						if UnitIsInMyGuild(unit) and LolzenUIcfg.tooltip["tip_use_guild_color_globally"] == false then
							if secondLineText:find("^" .. GetGuildInfo("player")) then
								setTooltipLineColor(2, unpack(LolzenUIcfg.tooltip["tip_own_guild_color"]))
							end
						elseif LolzenUIcfg.tooltip["tip_use_guild_color_globally"] == true then
							setTooltipLineColor(2, unpack(LolzenUIcfg.tooltip["tip_own_guild_color"]))
						end
					end
				end

				-- alter the appearance of level, race & class
				for i = 1, GameTooltip:NumLines(), 1 do
					local lineText = getTooltipLineText(i)
					if lineText and lineText:find("^" .. LEVEL) then
						local raceText = UnitRace(unit) or ""
						local classText = UnitClass(unit) or ""
						setTooltipLineText(i, getColorizedLevel(unit) .. " " .. raceText .. " " .. classText)
					end
				end
				
				-- Add spec icon by matching text
				addSpecIconByText()
			else
				-- colorize the tooltip border with unitreaction
				local r, g, b = getReactionColor(unit)
				if r and g and b then
					self:SetBackdropBorderColor(r, g, b)
				end
				
				-- colorize the unit's name and add the alternative PvP flag
				setTooltipLineText(1, getPvPflag(unit) .. getColorHexUnit(unit, getReactionColor(unit)))
				
				-- alter the appearance of level, race & class
				for i = 1, GameTooltip:NumLines(), 1 do
					local lineText = getTooltipLineText(i)
					if lineText and lineText:find("^" .. LEVEL) then
						local creatureType = UnitCreatureType(unit) or ""
						setTooltipLineText(i, getColorizedLevel(unit) .. getMobType(unit) .. " " .. creatureType)
					end
				end
			end

			-- hide the PvP line
			if UnitIsPVP(unit) then
				for i = 2, GameTooltip:NumLines(), 1 do
					local lineText = getTooltipLineText(i)
					if lineText and lineText:find(PVP_ENABLED) then
						setTooltipLineText(i, nil)
					end
				end
			end

			-- set the raidIcon on the tooltip or hide it
			if LolzenUIcfg.tooltip["tip_show_raidmark"] == true then
				local raidTargetIndex = GetRaidTargetIndex(unit)
				if raidTargetIndex then
					ricon:SetTexture("Interface\\TargetingFrame\\UI-RaidTargetingIcon_" .. raidTargetIndex)
				end
			end

			-- show a background texture of the faction
			if LolzenUIcfg.tooltip["tip_show_factionicons"] == true then
				local factionGroup = UnitFactionGroup(unit)
				if factionGroup and factionIcons[factionGroup] then
					factionbg:SetTexture(factionIcons[factionGroup])
				end
			end
			
			-- call the target of target function to get the target from the mouseover unit
			showUT(unit)
		end

		-- [hooks and scripts]
		-- anchor
		hooksecurefunc("GameTooltip_SetDefaultAnchor", function(tooltip, parent)
			if parent == "ANCHOR_CURSOR" then return end
			-- fix 8.2 out of screen bug (thanks oUF)
			if not pcall(tooltip.GetCenter, tooltip) then
				tooltip:SetOwner(parent, "ANCHOR_CURSOR")
			else
				tooltip:ClearAllPoints()
				tooltip:SetPoint(LolzenUIcfg.tooltip["tip_anchor1"], UIParent, LolzenUIcfg.tooltip["tip_anchor2"], LolzenUIcfg.tooltip["tip_posx"], LolzenUIcfg.tooltip["tip_posy"])
			end
		end)

		-- styling for units
		TooltipDataProcessor.AddTooltipPostCall(Enum.TooltipDataType.Unit, modifyTooltip)

		-- Azerite Essences
		if C_AzeriteEssence then
			hooksecurefunc(GameTooltip, "SetAzeriteEssence", colorEssenceQuality)
			hooksecurefunc(GameTooltip, "SetAzeriteEssenceSlot", colorEssenceSlotQuality)
			hooksecurefunc("SharedTooltip_SetBackdropStyle", colorEssenceSlotQuality)
		end

		-- clear textures when the tooltip is hidden
		GameTooltip:HookScript("OnHide", function(self)
			if LolzenUIcfg.tooltip["tip_show_raidmark"] == true then
				if ricon:GetTexture() ~= nil then
					ricon:SetTexture(nil)
				end
			end
			if LolzenUIcfg.tooltip["tip_show_factionicons"] == true then
				if factionbg:GetTexture() ~= nil then
					factionbg:SetTexture(nil)
				end
			end
		end)

		-- set the background color
		local function colorBG(self)
			if not self then return end
			self:SetBackdropColor(0, 0, 0, 1)
			self:SetBackdropBorderColor(1, 1, 1, 1)
			if self.NineSlice then
				self.NineSlice:SetAlpha(0)
			end
		end

		-- add icon to the tooltip (original code taken from Tipachu by Tuller)
		local function setTooltipIcon(self, icon)
			if not self or not icon then return end
			
			local title = _G[self:GetName() .. 'TextLeft1']
			if title then
				local currentText = title:GetText()
				if currentText and not currentText:find("|T") then -- Don't add icon if already present
					title:SetFormattedText('|T%s:16:16:0:0|t %s', icon, currentText)
				end
			end
		end

		local function setTTIconItem(tooltip, tooltipData)
			if not tooltip or not tooltipData then return end
			
			if tooltipData.type == Enum.TooltipDataType.Item and tooltipData.id then
				local icon = C_Item.GetItemIconByID(tooltipData.id)
				if icon then
					setTooltipIcon(tooltip, icon)
				end
			end
		end

		local function setTTIconSpell(tooltip, tooltipData)
			if not tooltip or not tooltipData then return end
			
			if tooltipData.type == Enum.TooltipDataType.Spell and tooltipData.id then
				local icon = C_Spell.GetSpellTexture(tooltipData.id)
				if icon then
					setTooltipIcon(tooltip, icon)
				end
			end
		end

		for i=1, #tooltips, 1 do
			if tooltips[i] then
				tooltips[i]:SetBackdrop(tt_style)
				hooksecurefunc(tooltips[i], "SetOwner", colorBG)
			end
		end

		-- also modify more tooltip types
		TooltipDataProcessor.AddTooltipPostCall(Enum.TooltipDataType.Unit, modifyTooltip)
		TooltipDataProcessor.AddTooltipPostCall(Enum.TooltipDataType.Item, colorItemQuality)
		TooltipDataProcessor.AddTooltipPostCall(Enum.TooltipDataType.Item, setTTIconItem)
		TooltipDataProcessor.AddTooltipPostCall(Enum.TooltipDataType.Spell, setTTIconSpell)

		-- update target of mouseovertarget when UNIT_TARGET was fired (the target is changed)
		function GameTooltip:UNIT_TARGET()
			showUT(getTooltipUnit())
		end

		-- register the tooltip with UNIT_TARGET event, which fires when a unit switches the target
		GameTooltip:RegisterEvent("UNIT_TARGET")
		GameTooltip:SetScript("OnEvent", function(self, event, ...) 
			if not self[event] then return end 
			self[event](self, event, ...) 
		end)

		ns.setTTBorder = function()
			-- reapply the tooltip "skin"
			tt_style = {
				bgFile = "Interface\\Buttons\\WHITE8x8",
				edgeFile = LSM:Fetch("border", LolzenUIcfg.tooltip["tip_border"]),
				tile = false,
				tileEdge = true,
				tileSize = 16,
				edgeSize = 16,
				insets = { left = 3, right = 3, top = 3, bottom = 3 },

				backdropBorderColor = CreateColor(1, 1, 1),
				backdropColor = CreateColor(0, 0, 0),
			}
			for i=1, #tooltips, 1 do
				if tooltips[i] then
					tooltips[i]:SetBackdrop(tt_style)
				end
			end
		end

		ns.setTTHBTexture = function()
			GameTooltipStatusBar:SetStatusBarTexture(LSM:Fetch("statusbar", LolzenUIcfg.tooltip["tip_healthbar_texture"]))
		end
	end
end)