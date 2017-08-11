--// tooltip // --

local addon, ns = ...

local f = CreateFrame("Frame")
f:RegisterEvent("ADDON_LOADED")
f:SetScript("OnEvent", function(self, event, addon)
	if addon == "LolzenUI" then
		if LolzenUIcfg.modules["tooltip"] == false then return end

		local tooltips = {
			-- general tooltips
			GameTooltip,
			ItemRefTooltip,
			WorldMapTooltip,
			WorldMapCompareTooltip1,
			WorldMapCompareTooltip2,
			-- shopping tooltips
			ShoppingTooltip1,
			ShoppingTooltip2,
			ShoppingTooltip3,
		}

		-- the backdrop of our Tooltips along with a beautiful border
		local backdrop = { 
			bgFile = "Interface\\Buttons\\WHITE8x8",
			edgeFile = "Interface\\AddOns\\LolzenUI\\media\\border", 
			tile = false,
			tileSize = 8,
			edgeSize = 16,
			insets = {
				left = 3,
				right = 3,
				top = 3,
				bottom = 3
			}
		}

		-- customize the mobClassification
		local mobType = {
			["worldboss"] = "Boss",
			["rareelite"] = "+ Rare",
			["rare"] = "Rare",
			["elite"] = "+",
		}

		-- faction icons and a background texture
		local factionIcons = {
			["Alliance"] = "Interface\\Timer\\Alliance-Logo",
			["Horde"] = "Interface\\Timer\\Horde-Logo",
		}

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
		GameTooltipStatusBar:SetStatusBarTexture("Interface\\AddOns\\LolzenUI\\media\\statusbar")
		GameTooltipStatusBar:SetStatusBarColor(0.3, 0.9, 0.3, 1)
		GameTooltipStatusBar:SetHeight(2)
		
		-- return the unit which is mouseovered
		local function getUnit()
			return select(2, GameTooltip:GetUnit())
		end

		-- return the unitClassColor values
		local function getClassColor(unit)
			local classcolor = RAID_CLASS_COLORS[select(2, UnitClass(unit))]
			return classcolor.r, classcolor.g, classcolor.b
		end

		-- return the unitReactionColor values
		local function getReactionColor(unit)
			local reactioncolor = FACTION_BAR_COLORS[UnitReaction(unit, "player")]
			return reactioncolor.r, reactioncolor.g, reactioncolor.b
		end

		-- return hex value of color values and the unitname
		local function getColorHexUnit(unit, r, g, b)
			return ("|cff%.2x%.2x%.2x%s"):format(r*255,g*255,b*255, UnitName(unit))
		end

		-- return a questdifficulty inspired colored level
		local function getColorizedLevel(unit, level)
			--local level = UnitLevel(unit)
			if level == nil or level == -1 then
				return "|cffff0000??|r "
			else
				local diff = GetQuestDifficultyColor(level)
				return ("|cff%02x%02x%02x%d|r"):format(diff.r*255, diff.g*255, diff.b*255, level)
			end
		end

		-- return the StatusFlag aka AFK, DND or offline
		local function getStatusFlag(unit)
			if UnitIsAFK(unit) then
				return "AFK| "
			elseif UnitIsDND(unit) then
				return "DND| "
			elseif not UnitIsConnected(unit) then
				return "(Off) "
			else
				return "" 
			end
		end

		-- colorize tooltipBorder accordingly to itemQuality
		local function colorItemQuality(self)
			local _, link = self:GetItem()

			if link then
				local quality = link and select(3, GetItemInfo(link))
				if quality then
					local r, g, b = GetItemQualityColor(quality)
					self:SetBackdropBorderColor(r, g, b)
				end
			end
		end

		-- talents
		local function InspectTalents(inspect, unit)
			-- by default the PvP line is hidden in the modyfyTip function, if we just add a line it would look messy as the talents displayed are halfway outside of the border,
			-- while the hidden PvP line is an empty space. So we use the PvP line and set our text there instead of adding a new one, if the target has PvP activated
			if UnitIsPlayer(unit) and UnitLevel(unit) > 9 then
				local _, name, _, icon, role, _ = GetSpecializationInfoByID(GetInspectSpecialization(unit))
				if icon then
					if UnitIsPVP(unit) then
						_G["GameTooltipTextLeft"..GameTooltip:NumLines()]:SetText((string.format("|T%s:%d:%d:0:-1|t", icon, 16, 16)).." |cFFFFFFFF"..name.." ("..role..")|r")
						_G["GameTooltipTextLeft"..GameTooltip:NumLines()]:Show()
					else
						GameTooltip:AddLine((string.format("|T%s:%d:%d:0:-1|t", icon, 16, 16)).." |cFFFFFFFF"..name.." ("..string.sub(role, 1, 1)..string.lower(string.sub(role, 2))..")|r")
						GameTooltip:AppendText("")
					end
				end
			end
		end

		-- player tooltip modifications
		local function modifyPlayerTooltip(unit, level)
			-- display talents
			if level > 9 then
				if not InspectFrame or not InspectFrame:IsShown() then
					if CheckInteractDistance(unit,1) and CanInspect(unit) then
						GameTooltip:RegisterEvent("INSPECT_READY")
						NotifyInspect(unit)
					end
				end
			end

			if IsInGuild(unit) then
				local guild = GetGuildInfo("player")
				if _G["GameTooltipTextLeft2"]:GetText():find("^"..guild) then
					_G["GameTooltipTextLeft2"]:SetText("|cff22eeee"..guild.."|r")
				end
			end
			for i=1, GameTooltip:NumLines(), 1 do
				if _G["GameTooltipTextLeft"..i]:GetText():find("^"..LEVEL) then
					_G["GameTooltipTextLeft"..i]:SetText(getColorizedLevel(unit, level).." "..UnitRace(unit).." "..UnitClass(unit))
				end
			end
		end

		-- NPC/Pet tooltip modifications
		local function modifyNPCTooltip(unit, level)
			local mobType = mobType[UnitClassification(unit)] or ""
			for i=1, GameTooltip:NumLines(), 1 do
				if _G["GameTooltipTextLeft"..i]:GetText():find("^"..LEVEL) then
					_G["GameTooltipTextLeft"..i]:SetText(getColorizedLevel(unit, level).." "..mobType.." "..UnitCreatureType(unit) or "")
				end
			end
		end
		
		-- sets the target of the mouseovetarget on the tooltip
		local function getUnitTarget(unit)
			if UnitIsPlayer(unit.."target") then
				if UnitName(unit.."target") == UnitName("player") then
					return "|cffffffff[YOU]|r"
				else
					return getColorHexUnit(unit.."target", getClassColor(unit.."target"))
				end
			else
				return getColorHexUnit(unit.."target", getReactionColor(unit.."target"))
			end
		end

		-- function which can be called to show/hide the unit's target
		local function showUT(unit)
			if unit and UnitExists(unit.."target") then
				_G["GameTooltipTextRight1"]:SetText(">>"..getUnitTarget(unit))
				_G["GameTooltipTextRight1"]:Show()
				GameTooltip:AppendText("")
			else
				_G["GameTooltipTextRight1"]:Hide()
				GameTooltip:AppendText("")
			end
		end

		-- general tooltip modifications
		local function modifyTooltip(self)
			local unit = getUnit()
			local level = UnitLevel(unit)
			local unitType = select(1, strsplit("-", UnitGUID(unit)))

			-- colorize TooltipBorder accordinglly to classColor or UnitReaction
			if unitType == "Player" then
				self:SetBackdropBorderColor(getClassColor(unit))
				--call player modifications function
				modifyPlayerTooltip(unit, level)
			elseif unitType == "Creature" or unitType == "Pet" then
				self:SetBackdropBorderColor(getReactionColor(unit))
				--call NPC modification function
				modifyNPCTooltip(unit, level)
			end

			-- black background color
			self:SetBackdropColor(0, 0, 0, 1)

			-- activate the custom (PvP) flag, custom unitFlags and classcolored/reactioncolored UnitNames
			if UnitIsPVP(unit) and isInInstance ~= "pvp" and isInInstance ~= "arena" and GetZonePVPInfo() ~= "combat" then
				if UnitIsFriend("player", unit) then	
					if UnitIsPlayer(unit) then
						_G["GameTooltipTextLeft1"]:SetText("|cff00ff00(PvP) |r"..getStatusFlag(unit)..getColorHexUnit(unit, getClassColor(unit)))
					else
						_G["GameTooltipTextLeft1"]:SetText("|cff00ff00(PvP) |r"..getColorHexUnit(unit, getReactionColor(unit)))
					end
				else
					if UnitIsPlayer(unit) then
						_G["GameTooltipTextLeft1"]:SetText("|cffff0000(PvP) |r"..getStatusFlag(unit)..getColorHexUnit(unit, getClassColor(unit)))
					else
						_G["GameTooltipTextLeft1"]:SetText("|cffff0000(PvP) |r"..getColorHexUnit(unit, getReactionColor(unit)))
					end
				end
			else
				if UnitIsPlayer(unit) then
					_G["GameTooltipTextLeft1"]:SetText(getStatusFlag(unit)..getColorHexUnit(unit, getClassColor(unit)))
				else
					_G["GameTooltipTextLeft1"]:SetText(getColorHexUnit(unit, getReactionColor(unit)))
				end
			end	

			-- hide the PvP line
			if UnitIsPVP(unit) then
				for i=2, GameTooltip:NumLines(), 1 do
					if _G["GameTooltipTextLeft"..i]:GetText():find(PVP_ENABLED) then
						_G["GameTooltipTextLeft"..i]:Hide()
						GameTooltip:AppendText("")
					end
				end
			end

			-- set the raidIcon on the tooltip or hide it
			if GetRaidTargetIndex(unit) then
				ricon:SetTexture("Interface\\TargetingFrame\\UI-RaidTargetingIcon_"..GetRaidTargetIndex(unit))
			end

			-- show a background texture of the faction
			if UnitFactionGroup(unit) and UnitFactionGroup(unit) == "Horde" or "Alliance" then
				factionbg:SetTexture(factionIcons[UnitFactionGroup(unit)])
			end
			
			-- call the target of target function to get the target from the mouseover unit
			showUT(unit)
		end

		-- [hooks and scripts]
		-- anchor
		hooksecurefunc("GameTooltip_SetDefaultAnchor", function(tooltip, parent)
			if parent == nil then return end
		--	tooltip:ClearAllPoints()
			tooltip:SetOwner(parent,"ANCHOR_NONE")
			tooltip:SetPoint("BOTTOMRIGHT", UIParent, "BOTTOMRIGHT", -13, 43)
--			tooltip:SetScale(1)
--			tooltip.default = 1
		end)

		-- styling for units
		GameTooltip:HookScript("OnTooltipSetUnit", modifyTooltip)

		-- clear textures when the tooltip is hidden
		GameTooltip:HookScript("OnHide", function(self)
			ricon:SetTexture(nil)
			factionbg:SetTexture(nil)
		end)

		-- set the background color
		local function colorBG(self)
			self:SetBackdropColor(0, 0, 0, 1)
		end

		-- also modify more tooltip types
		for i=1, #tooltips, 1 do
			tooltips[i]:HookScript("OnTooltipSetItem", colorItemQuality)
			tooltips[i]:SetBackdrop(backdrop)

			tooltips[i]:HookScript("OnShow", colorBG)
		end

		-- update target of mouseovertarget when UNIT_TARGET was fired (the target is changed)
		function GameTooltip:UNIT_TARGET()
			showUT(getUnit())
		end

		-- inspect when INSPECT_READY is fired
		function GameTooltip:INSPECT_READY()
			GameTooltip:UnregisterEvent("INSPECT_READY")
			InspectTalents(1, getUnit())
		end

		GameTooltip:RegisterEvent("UNIT_TARGET")
		GameTooltip:SetScript("OnEvent", function(self, event, ...) self[event](self, event, ...) end)
	end
end)