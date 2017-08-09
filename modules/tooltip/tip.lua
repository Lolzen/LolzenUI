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
		ricon:SetPoint("TOP", "GameTooltip", "TOP", 0, 5)

		-- make the Healthbar sweet
		GameTooltipStatusBar:ClearAllPoints()
		GameTooltipStatusBar:SetPoint("BOTTOMLEFT", 5, 4)
		GameTooltipStatusBar:SetPoint("BOTTOMRIGHT", -5, 4)
		GameTooltipStatusBar:SetStatusBarTexture("Interface\\AddOns\\LolzenUI\\media\\statusbar")
		GameTooltipStatusBar:SetStatusBarColor(0.3, 0.9, 0.3, 1)
		GameTooltipStatusBar:SetHeight(2)

		local bg = GameTooltipStatusBar:CreateTexture(nil, "BACKGROUND")
		bg:SetTexture("Interface\\AddOns\\ProTip\\media\\statusbar")
		bg:SetVertexColor(0, 0, 0)

		-- return the unitClassColor values
		local function getClassColor(unit)
			if not unit then return end
			local classcolor = RAID_CLASS_COLORS[select(2, UnitClass(unit))]
			return classcolor.r, classcolor.g, classcolor.b
		end

		-- return the unitReactionColor values
		local function getReactionColor(unit)
			if not unit then return end
			local reactioncolor = FACTION_BAR_COLORS[UnitReaction(unit, "player")]
			return reactioncolor.r, reactioncolor.g, reactioncolor.b
		end

		-- return hex value of color values and the unitname
		local function getColorHexUnit(unit, r, g, b)
			return ("|cff%.2x%.2x%.2x%s"):format(r*255,g*255,b*255, UnitName(unit))
		end

		-- return a questdifficulty inspired colored level
		local function getColorizedLevel(unit)
			if UnitLevel(unit) ~= nil then
				if not UnitLevel(unit) or UnitLevel(unit) == -1 then
					return "|cffff0000??|r "
				else
					return ("|cff%02x%02x%02x%d|r"):format(GetQuestDifficultyColor(UnitLevel(unit)).r*255, GetQuestDifficultyColor(UnitLevel(unit)).g*255, GetQuestDifficultyColor(UnitLevel(unit)).b*255, UnitLevel(unit))
				end
			end
		end

		-- get the StatusFlag aka AFK, DND or offline
		local function getStatusFlag(unit)
			local status

			if UnitIsAFK(unit) then
				status = "AFK| "
			elseif UnitIsDND(unit) then
				status = "DND| "
			elseif not UnitIsConnected(unit) then
				status = "(Off) "
			else
				status = "" 
			end

			return "|cffffffff"..status.."|r"
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

		--talents
		local function InspectTalents(inspect)
			local unit = select(2, GameTooltip:GetUnit())
			if not unit then return end

			if UnitPlayerControlled(unit) == false then return end

			local role
			if select(5, GetSpecializationInfoByID(GetInspectSpecialization(unit))) == "HEALER" then
				role = "Heal"
			elseif select(5, GetSpecializationInfoByID(GetInspectSpecialization(unit))) == "DAMAGER" then
				role = "Damage"
			elseif select(5, GetSpecializationInfoByID(GetInspectSpecialization(unit))) == "TANK" then
				role = "Tank"
			end

			if not select(4, GetSpecializationInfoByID(GetInspectSpecialization(unit))) then return end

			--by default the PvP line is hidden in the modyfyTip function, if we just add a line it would look messy as the talents displayed are halfway outside of the border,
			--while the hidden PvP line is an empty space. So we use the PvP line and set out text there instead of adding a new one, if the target has PvP activated
			if UnitLevel(unit) > 9 then
				if UnitIsPVP(unit) then
					_G["GameTooltipTextLeft"..GameTooltip:NumLines()]:SetText((string.format("|T%s:%d:%d:0:-1|t", select(4, GetSpecializationInfoByID(GetInspectSpecialization(unit))), 16, 16)).." |cFFFFFFFF"..select(2, GetSpecializationInfoByID(GetInspectSpecialization(unit))).." ("..role..")|r")
					_G["GameTooltipTextLeft"..GameTooltip:NumLines()]:Show()
				else
					GameTooltip:AddLine((string.format("|T%s:%d:%d:0:-1|t", select(4, GetSpecializationInfoByID(GetInspectSpecialization(unit))), 16, 16)).." |cFFFFFFFF"..select(2, GetSpecializationInfoByID(GetInspectSpecialization(unit))).." ("..role..")|r")
				end
			end
			GameTooltip:AppendText("")
		end

		local function modifyPlayerTooltip(unit)
			local name, realm = UnitName(unit)
			local _, pRealm = UnitName("player")

			--display talents
			if UnitLevel(unit) > 9 or UnitLevel(unit) ~= -1 then
				if not InspectFrame or not InspectFrame:IsShown() then
					if CheckInteractDistance(unit,1) and CanInspect(unit) then
						GameTooltip:RegisterEvent("INSPECT_READY")
						NotifyInspect(unit)
					end
				end
			end

			for i=1, GameTooltip:NumLines() do
				if IsInGuild(unit) then
					if _G["GameTooltipTextLeft"..i]:GetText():find("^"..GetGuildInfo("player")) then
						_G["GameTooltipTextLeft"..i]:SetText("|cff22eeee"..GetGuildInfo(unit).."|r")
					end
				end
				if _G["GameTooltipTextLeft"..i]:GetText():find("^"..LEVEL) then
					_G["GameTooltipTextLeft"..i]:SetText(getColorizedLevel(unit).." "..UnitRace(unit).." "..UnitClass(unit))
				end
			end
		end

		local function modifyNPCTooltip(unit)
			if not unit or unit == nil then return end
			local mobType = mobType[UnitClassification(unit)] or ""
			for i=1, GameTooltip:NumLines() do
				if _G["GameTooltipTextLeft"..i]:GetText():find("^"..LEVEL) then
					_G["GameTooltipTextLeft"..i]:SetText(getColorizedLevel(unit).." "..mobType.." "..UnitCreatureType(unit) or "")
				end
			end
		end

		-- sets the target of the mouseovetarget on the tooltip
		local function getUnitTarget(unit)
			if not unit or not UnitExists(unit) then return end

			local text
			if UnitIsPlayer(unit.."target") and UnitName(unit.."target") == UnitName("player") then
				text = "|cffffffff[YOU]"
			elseif UnitPlayerControlled(unit.."target") then
				text = getColorHexUnit(unit.."target", getClassColor(unit.."target"))
			else
				local ureaction = FACTION_BAR_COLORS[UnitReaction(unit.."target", "player")]
				if ureaction then
					text = getColorHexUnit(unit.."target", getReactionColor(unit.."target"))
				end
			end

			if text ~= nil then
				if UnitExists(unit.."target") then
					_G["GameTooltipTextRight1"]:SetText("|cffffffff>>|r"..text) --!
					_G["GameTooltipTextRight1"]:Show()
				elseif not UnitExists(unit.."target") then
					_G["GameTooltipTextRight1"]:Hide()
				else
					print("TARGETLINE ERROR")
				end
			end

			GameTooltip:AppendText("")
		end

		local function modifyTooltip(self)
			local unit = select(2, GameTooltip:GetUnit())
			--if not GameTooltip:IsUnit(unit) then return end
			if not unit or not UnitExists(unit) then return end

			-- colorize TooltipBorder accordinglly to classColor or UnitReaction
			if UnitIsPlayer(unit) then
				self:SetBackdropBorderColor(getClassColor(unit))
				--call player modifications function
				modifyPlayerTooltip(unit)
			elseif UnitPlayerControlled(unit) == false then
				self:SetBackdropBorderColor(getReactionColor(unit))
				--call NPC modification function
				modifyNPCTooltip(unit)
			end

			-- black background color
			self:SetBackdropColor(0, 0, 0, 1)

			-- modify PvP color text according to friendly or enemy
			local PvPColor
			if UnitIsFriend("player", unit) then
				PvPcolor = "|cff00ff00"
			else
				PvPcolor = "|cffff0000"
			end

			-- activate the custom (PvP) flag, custom unitFlags and classcolored/reactioncolored UnitNames
			if UnitIsPVP(unit) and isInInstance ~= "pvp" and isInInstance ~= "arena" and GetZonePVPInfo() ~= "combat" then
				if UnitIsPlayer(unit) then
					_G["GameTooltipTextLeft1"]:SetText(PvPcolor.."(PvP) |r"..getStatusFlag(unit)..getColorHexUnit(unit, getClassColor(unit)))
				else
					_G["GameTooltipTextLeft1"]:SetText(PvPcolor.."(PvP) |r"..getColorHexUnit(unit, getReactionColor(unit)))
				end
			else
				if UnitIsPlayer(unit) then
					_G["GameTooltipTextLeft1"]:SetText(getStatusFlag(unit)..getColorHexUnit(unit, getClassColor(unit)))
				else
					_G["GameTooltipTextLeft1"]:SetText(getColorHexUnit(unit, getReactionColor(unit)))
				end
			end	

			if UnitIsPVP(unit) then
				for i=2, GameTooltip:NumLines() do
					if _G["GameTooltipTextLeft"..i]:GetText():find(PVP_ENABLED) then
						_G["GameTooltipTextLeft"..i]:Hide()
					end
				end
				GameTooltip:AppendText("")
			end

			-- set the background of the tooltipstatusbar to the statusbar itself
			bg:SetAllPoints(GameTooltipStatusBar)

			-- set the raidIcon on the tooltip or hide it
			if GetRaidTargetIndex(unit) then
				ricon:SetTexture("Interface\\TargetingFrame\\UI-RaidTargetingIcon_"..GetRaidTargetIndex(unit))
			end

			-- show a background texture of the faction
			if UnitFactionGroup(unit) and UnitFactionGroup(unit) == "Horde" or "Alliance" then
				factionbg:SetTexture(factionIcons[UnitFactionGroup(unit)])
			end

			-- call the target of target function to get the target from the mouseover unit
			getUnitTarget(unit)
		end

		--hooks and scripts
		-- anchor
		hooksecurefunc("GameTooltip_SetDefaultAnchor", function(tooltip, parent)
			if parent == nil then return end
			tooltip:ClearAllPoints()
			tooltip:SetOwner(parent,"ANCHOR_NONE")
			tooltip:SetPoint("BOTTOMRIGHT", UIParent, "BOTTOMRIGHT", -13, 43)
			tooltip:SetScale(1)
			tooltip.default = 1
		end)

		--styling for units
		GameTooltip:HookScript("OnTooltipSetUnit", modifyTooltip)

		GameTooltip:HookScript("OnHide", function(self)
			ricon:SetTexture(nil)
			factionbg:SetTexture(nil)
		end)

		-- also modify more tooltip types
		for i=1, #tooltips do
			tooltips[i]:HookScript("OnTooltipSetItem", colorItemQuality)
			tooltips[i]:SetBackdrop(backdrop)

			-- we really don't like the gradient, blue background color!!
			tooltips[i]:HookScript("OnUpdate", function(self, elapsed)
				self:SetBackdropColor(0, 0, 0, 1)
			end)
		end

		-- update target of mouseovertarget when UNIT_TARGET was fired (the target is changed)
		function GameTooltip:UNIT_TARGET()
			getUnitTarget(select(2, GameTooltip:GetUnit()))
		end

		function GameTooltip:INSPECT_READY()
			GameTooltip:UnregisterEvent("INSPECT_READY")
			InspectTalents(1)
		end

		GameTooltip:RegisterEvent("UNIT_TARGET")
		GameTooltip:SetScript("OnEvent", function(self, event, ...) self[event](self, event, ...) end)
	end
end)