--// tooltip // --

local _, ns = ...
local LSM = LibStub("LibSharedMedia-3.0")

ns.RegisterModule("tooltip", "Modifies the look of the Tooltip and adds a few features", true)

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

		-- overwrite the default tooltip style
		GAME_TOOLTIP_BACKDROP_STYLE_DEFAULT = {
			bgFile = "Interface\\Buttons\\WHITE8x8",
			edgeFile = LSM:Fetch("border", LolzenUIcfg.tooltip["tip_border"]),
			--edgeFile = "Interface\\AddOns\\LolzenUI\\media\\border_round",
			tile = false,
			tileEdge = true,
			tileSize = 16,
			edgeSize = 16,
			insets = { left = 3, right = 3, top = 3, bottom = 3 },

			backdropBorderColor = CreateColor(1, 1, 1),
			backdropColor = CreateColor(0, 0, 0),
		}
		GAME_TOOLTIP_BACKDROP_STYLE_EMBEDDED = GAME_TOOLTIP_BACKDROP_STYLE_DEFAULT
		GAME_TOOLTIP_BACKDROP_STYLE_AZERITE_ITEM  = {
			--bgFile = "Interface\\Buttons\\WHITE8x8",
			bgFile = "Interface\\AddOns\\LolzenUI\\media\\tooltip-azerite-bg",
			--edgeFile = "Interface/Tooltips/UI-Tooltip-Border-Azerite",
			edgeFile = "Interface\\AddOns\\LolzenUI\\media\\border-azerite",
			--edgeFile = LSM:Fetch("border", LolzenUIcfg.tooltip["tip_border"]),
			tile = false,
			tileEdge = true,
			tileSize = 16,
			--edgeSize = 19,
			edgeSize = 16,
			--insets = { left = 4, right = 4, top = 4, bottom = 4 },
			insets = { left = 3, right = 3, top = 3, bottom = 3 },

			backdropBorderColor = CreateColor(1, 1, 1),
			backdropColor = CreateColor(1, 1, 1),
			
			overlayAtlasTop = "AzeriteTooltip-Topper";
			overlayAtlasTopScale = .75,
			overlayAtlasBottom = "AzeriteTooltip-Bottom";
			--overlayAtlasBottomScale = 1.5,
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
		
		-- return the unit which is mouseovered
		local function getTooltipUnit()
			local _, unit = GameTooltip:GetUnit()
			return unit
		end

		-- return the unitClassColor values
		local function getClassColor(unit)
			local classcolor = RAID_CLASS_COLORS[select(2, UnitClass(unit))]
			return classcolor.r, classcolor.g, classcolor.b
		end

		-- return the unitReactionColor values
		local function getReactionColor(unit)
			local reactioncolor = FACTION_BAR_COLORS[UnitReaction(unit, "player")]
			if reactioncolor then
				return reactioncolor.r, reactioncolor.g, reactioncolor.b
			end
		end

		-- return hex value of color values and the unitname
		local function getColorHexUnit(unit, r, g, b)
			return ("|cff%.2x%.2x%.2x%s"):format(r*255,g*255,b*255, UnitName(unit))
		end

		-- return a questdifficulty inspired colored level
		local function getColorizedLevel(unit)
			local level = UnitLevel(unit)
			if level == nil then
				return level
			elseif level == -1 then
				return "|cffff0000??|r "
			else
				local diff = GetQuestDifficultyColor(level)
				return ("|cff%02x%02x%02x%d|r"):format(diff.r*255, diff.g*255, diff.b*255, level)
			end
		end

		-- return the unitclassification
		local function getMobType(unit)
			local classif = mobType[UnitClassification(unit)]
			if classif ~= nil then
				return classif
			else
				return UnitClassification(unit)
			end
		end

		-- return the StatusFlag aka AFK, DND or offline
		local function getStatusFlag(unit)
			if UnitIsAFK(unit) then
				local r, g, b = unpack(LolzenUIcfg.tooltip["tip_statusflag_afk_color"])
				return ("|cff%02x%02x%02x%s ".."|r "):format(r*255, g*255, b*255, LolzenUIcfg.tooltip["tip_statusflag_afk"])
			elseif UnitIsDND(unit) then
				local r, g, b = unpack(LolzenUIcfg.tooltip["tip_statusflag_dnd_color"])
				return ("|cff%02x%02x%02x%s ".."|r "):format(r*255, g*255, b*255, LolzenUIcfg.tooltip["tip_statusflag_dnd"])
			elseif not UnitIsConnected(unit) then
				local r, g, b = unpack(LolzenUIcfg.tooltip["tip_statusflag_off_color"])
				return ("|cff%02x%02x%02x%s ".."|r "):format(r*255, g*255, b*255, LolzenUIcfg.tooltip["tip_statusflag_off"])
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
					if self.TopOverlay:IsShown() then
						self:SetBackdropColor(r, g, b)
					end
				end
			end
		end

		-- talents
		local function InspectTalents(inspect, unit)
			-- by default the PvP line is hidden in the modyfyTip function, if we just add a line it would look messy as the talents displayed are halfway outside of the border,
			-- while the hidden PvP line is an empty space. So we use the PvP line and set our text there instead of adding a new one, if the target has PvP activated
			if UnitIsPlayer(unit) then
				local _, name, _, icon, role, _ = GetSpecializationInfoByID(GetInspectSpecialization(unit))
				if icon then
					if UnitIsPVP(unit) then
						_G["GameTooltipTextLeft"..GameTooltip:NumLines()]:SetText((string.format("|T%s:%d:%d:0:-1|t", icon, 16, 16)).." |cFFFFFFFF"..name.." ("..string.sub(role, 1, 1)..string.lower(string.sub(role, 2))..")|r")
						_G["GameTooltipTextLeft"..GameTooltip:NumLines()]:Show()
					else
						GameTooltip:AddLine((string.format("|T%s:%d:%d:0:-1|t", icon, 16, 16)).." |cFFFFFFFF"..name.." ("..string.sub(role, 1, 1)..string.lower(string.sub(role, 2))..")|r")
					end
					GameTooltip:AppendText("")
				end
			end
		end

		-- return the alternative PvP flag
		local function getPvPflag(unit)
			if UnitIsPVP(unit) then
				if isInInstance ~= "pvp" and isInInstance ~= "arena" and GetZonePVPInfo() ~= "combat" then
					if UnitIsFriend("player", unit) then
						return "|cff00ff00(PvP) |r"
					else
						return "|cff00ff00(PvP) |r"
					end
				else
					return ""
				end
			else
				return ""
			end
		end
		
		-- return the target of the mouseovetarget on the tooltip
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
			local unit = getTooltipUnit()
			if not unit or not UnitExists(unit) then return end

			-- colorize TooltipBorder accordingly to classColor or UnitReaction
			if UnitIsPlayer(unit) then
				-- colorize the tooltip border with classcolor
				self:SetBackdropBorderColor(getClassColor(unit))
				-- colorize the unit's name and add the alternative PvP flag
				_G["GameTooltipTextLeft1"]:SetText(getPvPflag(unit)..getStatusFlag(unit)..getColorHexUnit(unit, getClassColor(unit)))
				-- display talents
				if LolzenUIcfg.tooltip["tip_display_talents"] == true then
					if UnitLevel(unit) > 9 then
						if not InspectFrame or not InspectFrame:IsShown() then
							if CheckInteractDistance(unit,1) and CanInspect(unit) then
								GameTooltip:RegisterEvent("INSPECT_READY")
								NotifyInspect(unit)
							end
						end
					end
				end
				-- colorize the guild name if it's the same as the Player's
				-- or color any guild if the option is set
				if GetGuildInfo(unit) then
					if UnitIsInMyGuild(unit) and LolzenUIcfg.tooltip["tip_use_guild_color_globally"] == false then
						if _G["GameTooltipTextLeft2"]:GetText():find("^"..GetGuildInfo("player")) then
							_G["GameTooltipTextLeft2"]:SetTextColor(unpack(LolzenUIcfg.tooltip["tip_own_guild_color"]))
						end
					elseif LolzenUIcfg.tooltip["tip_use_guild_color_globally"] == true then
						_G["GameTooltipTextLeft2"]:SetTextColor(unpack(LolzenUIcfg.tooltip["tip_own_guild_color"]))
					end
				end

				-- alter the appearance of level, race & class
				for i=1, GameTooltip:NumLines(), 1 do
					if _G["GameTooltipTextLeft"..i]:GetText():find("^"..LEVEL) then
						_G["GameTooltipTextLeft"..i]:SetText(getColorizedLevel(unit).." "..UnitRace(unit).." "..UnitClass(unit))
					end
				end
			else
				-- colorize the tooltip border with unitreaction
				self:SetBackdropBorderColor(getReactionColor(unit))
				-- colorize the unit's name and add the alternative PvP flag
				_G["GameTooltipTextLeft1"]:SetText(getPvPflag(unit)..getColorHexUnit(unit, getReactionColor(unit)))
				-- alter the appearance of level, race & class
				for i=1, GameTooltip:NumLines(), 1 do
					if _G["GameTooltipTextLeft"..i]:GetText():find("^"..LEVEL) then
						_G["GameTooltipTextLeft"..i]:SetText(getColorizedLevel(unit)..getMobType(unit).." "..(UnitCreatureType(unit) or ""))
					end
				end
			end

			-- hide the PvP line
			if UnitIsPVP(unit) then
				for i=2, GameTooltip:NumLines(), 1 do
					if _G["GameTooltipTextLeft"..i]:GetText():find(PVP_ENABLED) then
						_G["GameTooltipTextLeft"..i]:Hide()
					end
				end
			end

			-- set the raidIcon on the tooltip or hide it
			if LolzenUIcfg.tooltip["tip_show_raidmark"] == true then
				if GetRaidTargetIndex(unit) then
					ricon:SetTexture("Interface\\TargetingFrame\\UI-RaidTargetingIcon_"..GetRaidTargetIndex(unit))
				end
			end

			-- show a background texture of the faction
			if LolzenUIcfg.tooltip["tip_show_factionicons"] == true then
				if UnitFactionGroup(unit) and UnitFactionGroup(unit) == "Horde" or "Alliance" then
					factionbg:SetTexture(factionIcons[UnitFactionGroup(unit)])
				end
			end
			
			-- call the target of target function to get the target from the mouseover unit
			showUT(unit)
		end

		-- [hooks and scripts]
		-- anchor
		hooksecurefunc("GameTooltip_SetDefaultAnchor", function(tooltip, parent)
			tooltip:SetPoint(LolzenUIcfg.tooltip["tip_anchor1"], UIParent, LolzenUIcfg.tooltip["tip_anchor2"], LolzenUIcfg.tooltip["tip_posx"], LolzenUIcfg.tooltip["tip_posy"])
		end)

		-- styling for units
		GameTooltip:HookScript("OnTooltipSetUnit", modifyTooltip)

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
			self:SetBackdropColor(0, 0, 0, 1)
		end

		-- also modify more tooltip types
		for i=1, #tooltips, 1 do
			tooltips[i]:HookScript("OnTooltipSetItem", colorItemQuality)
			tooltips[i]:SetBackdrop(GAME_TOOLTIP_BACKDROP_STYLE_DEFAULT)
			hooksecurefunc(tooltips[i], "SetOwner", colorBG)
		end

		-- update target of mouseovertarget when UNIT_TARGET was fired (the target is changed)
		function GameTooltip:UNIT_TARGET()
			showUT(getTooltipUnit())
		end

		-- inspect when INSPECT_READY is fired
		if LolzenUIcfg.tooltip["tip_display_talents"] == true then
			function GameTooltip:INSPECT_READY()
				GameTooltip:UnregisterEvent("INSPECT_READY")
				InspectTalents(1, getTooltipUnit())
			end
		end

		-- register the tooltip with UNIT_TARGET event, which fires when a unit switches the target
		GameTooltip:RegisterEvent("UNIT_TARGET")
		GameTooltip:SetScript("OnEvent", function(self, event, ...) self[event](self, event, ...) end)
	end
end)