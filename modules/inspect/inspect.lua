--// inspect // --
-- this module is based on Snoopy Inspect by TotalPackage

local addon, ns = ...

local f = CreateFrame("Frame")
f:RegisterEvent("ADDON_LOADED")
f:SetScript("OnEvent", function(self, event, addon)
	if addon == "Blizzard_InspectUI" then
		if LolzenUIcfg.modules["inspect"] == false then return end

		local frame = CreateFrame("Frame")

		local cache = {}
		UnitPopupButtons.INSPECT.dist = 0  -- enables "Inspect" option in dropdown

		local function updateFrames()
			InspectPaperDollFrame_OnShow()
			InspectPVPFrame_OnShow()
			InspectFrame_UpdateTabs()
		end

		local function UpdateUnit(unit)
			InspectFrame.unit = unit
			ShowUIPanel(InspectFrame)
			updateFrames()
		end

		InspectFrame_OnEvent = function(self, event, a1)
			if not InspectFrame:IsShown() then return end
			local unit = InspectFrame.unit
			if (event == "PLAYER_TARGET_CHANGED" and unit == "target") or (event == "PARTY_MEMBERS_CHANGED" and unit ~= "target") then
				if UnitExists(unit) then
					UpdateUnit(unit)
				end
			elseif event == "UNIT_PORTRAIT_UPDATE" and unit == a1 then
				SetPortraitTexture(InspectFramePortrait, unit)
				UpdateUnit(unit)
			elseif event == "UNIT_NAME_UPDATE" and unit == a1 then
				InspectFrameTitleText:SetText(UnitPVPName(unit))
			elseif event == "INSPECT_READY" then
				UpdateUnit(unit)
			end
		end
		InspectFrame:SetScript("OnEvent", InspectFrame_OnEvent)

		local oInspectPaperDollItemSlotButton_Update = InspectPaperDollItemSlotButton_Update
		InspectPaperDollItemSlotButton_Update = function(self, ...)
			oInspectPaperDollItemSlotButton_Update(self, ...)
			local id = self:GetID()
			local link
			if CheckInteractDistance(InspectFrame.unit, 1) then
				link = GetInventoryItemLink(InspectFrame.unit, id)
				cache[id] = link
			end
		end

		InspectPaperDollItemSlotButton_OnEnter = function(self)
			local unit, id = InspectFrame.unit, self:GetID()
			GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
			if UnitExists(unit) and CheckInteractDistance(unit, 1) and GameTooltip:SetInventoryItem(unit, id) then

			elseif cache[id] then  -- retrieved from cache
				GameTooltip:SetHyperlink(cache[id])
			else  -- empty slot
				GameTooltip:SetText((self.checkRelic and UnitHasRelicSlot(unit) and _G.RELICSLOT) or _G[strupper(strsub(self:GetName(), 8))])
			end
			CursorUpdate(self)
		end

		local function onclick(self, button)
			local unit, id = InspectFrame.unit, self:GetID()
			if UnitExists(unit) and CheckInteractDistance(unit, 1) then
				HandleModifiedItemClick(GetInventoryItemLink(unit, id))
			elseif cache[id] then  -- retrieved from cache
				HandleModifiedItemClick(cache[id])
			end
		end

		local GetFrameType = frame.GetFrameType or frame.GetObjectType
		for _, frame in ipairs({ InspectPaperDollFrame:GetChildren() }) do
			if GetFrameType(frame) == "Button" and strmatch(frame:GetName() or "", "Inspect(.+)Slot") then
				frame:SetScript("OnClick", onclick)
				frame:SetScript("OnEnter", InspectPaperDollItemSlotButton_OnEnter)
			end
		end

		local oInspectPaperDollFrame_OnShow = InspectPaperDollFrame_OnShow
		InspectPaperDollFrame_OnShow = function(...)
			if not UnitIsPlayer(InspectFrame.unit) then return end
			oInspectPaperDollFrame_OnShow(...)
		end
		InspectPaperDollFrame:SetScript("OnShow", InspectPaperDollFrame_OnShow)

		local oInspectPaperDollFrame_SetLevel = InspectPaperDollFrame_SetLevel
		InspectPaperDollFrame_SetLevel = function(...)
			if UnitExists(InspectFrame.unit) then
				oInspectPaperDollFrame_SetLevel(...)
			end
		end

		local oInspectPVPFrame_Update = InspectPVPFrame_Update
		InspectPVPFrame_Update = function(...)
			if UnitExists(InspectFrame.unit) then
				modInspectPVPFrame_Update(...)
			end
		end

		local oTalentFrame_Update = TalentFrame_Update
		TalentFrame_Update = function(self, unit)
			if UnitExists(unit) then
				oTalentFrame_Update(self, unit)
			end
		end

		local oInspectGuildFrame_Update = InspectGuildFrame_Update
		InspectGuildFrame_Update = function(...)
			if UnitExists(InspectFrame.unit) then
				oInspectGuildFrame_Update(...)
			end
		end

		-- don't set a portraittexture like InspectPVPFrame_Update()
		function modInspectPVPFrame_Update()
			local unit = InspectFrame.unit
			local factionGroup = UnitFactionGroup(unit)
			local prestigeLevel = UnitPrestige(unit)
			local _, _, _, _, lifetimeHKs, _ = GetInspectHonorData()
			local level = UnitLevel(unit)
			local arenaFrames = {InspectPVPFrame.Arena2v2, InspectPVPFrame.Arena3v3}

			InspectPVPFrame.HKs:SetFormattedText(INSPECT_HONORABLE_KILLS, lifetimeHKs)

			if (level < MAX_PLAYER_LEVEL_TABLE[LE_EXPANSION_LEVEL_CURRENT]) then
				InspectPVPFrame.SmallWreath:Hide()
				InspectPVPFrame.HonorLevel:Hide()
				InspectPVPFrame.RatedBG:Hide()
				for i = 1, MAX_ARENA_TEAMS do
					arenaFrames[i]:Hide()
				end
				InspectPVPFrame.Talents:Hide()
			else
				InspectPVPFrame.SmallWreath:SetShown(prestigeLevel > 0)

				InspectPVPFrame.HonorLevel:SetFormattedText(HONOR_LEVEL_LABEL, UnitHonorLevel(unit))
				InspectPVPFrame.HonorLevel:Show()
				local rating, played, won = GetInspectRatedBGData()
				InspectPVPFrame.RatedBG.Rating:SetText(rating)
				InspectPVPFrame.RatedBG.Record:SetFormattedText(PVP_RECORD_DESCRIPTION, won, (played - won))
				InspectPVPFrame.RatedBG:Show()
				for i=1, MAX_ARENA_TEAMS do
					local arenarating, seasonPlayed, seasonWon, weeklyPlayed, weeklyWon = GetInspectArenaData(i)
					local frame = arenaFrames[i]
					frame.Rating:SetText(arenarating)
					frame.Record:SetFormattedText(PVP_RECORD_DESCRIPTION, seasonWon, (seasonPlayed - seasonWon))
					frame:Show()
				end
				InspectPVPFrame.talentGroup = GetActiveSpecGroup(true)
				PVPTalentFrame_Update(InspectPVPFrame, unit)
				InspectPVPFrame.Talents:Show()
			end
		end

		-- override this function to NOT clear any variables; fixes empty specIcon
		function InspectTalentFrameSpec_OnClear()
		end
	end
end)