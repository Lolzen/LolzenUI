local _, ns = ...
local L = ns.L
local LSM = LibStub("LibSharedMedia-3.0")
local oUF = ns.oUF

ns.RegisterModule("unitframes", L["desc_unitframes"], true)

local f = CreateFrame("Frame")
f:RegisterEvent("ADDON_LOADED")
f:SetScript("OnEvent", function(self, event, addon)
	if addon == "LolzenUI" then
		if LolzenUIcfg.modules["unitframes"] == false then return end

		local UnitSpecific = {
			player = ns.SetupPlayer,
			target = ns.SetupTarget,
			targettarget = ns.SetupTargetTarget,
			party = ns.SetupParty,
			raid = ns.SetupRaid,
			pet = ns.SetupPet,
			boss = ns.SetupBoss,
			focus = ns.SetupFocus,
			arena = ns.SetupArena,
		}

		-- A small helper to change the style into a unit specific, if it exists.
		local spawnHelper = function(self, unit, ...)
			if unit:match("nameplate") then return end
			if(UnitSpecific[unit]) then
				self:SetActiveStyle('Lolzen - ' .. unit:gsub("^%l", string.upper))
			elseif(UnitSpecific[unit:match('%D+')]) then -- boss1 -> boss
				self:SetActiveStyle('Lolzen - ' .. unit:match('%D+'):gsub("^%l", string.upper))
			else
				self:SetActiveStyle'Lolzen'
			end
			local object = self:Spawn(unit)
			object:SetPoint(...)
			return object
		end

		oUF:RegisterStyle("Lolzen", ns.shared)
		for unit,layout in next, UnitSpecific do
			-- Capitalize the unit name, so it looks better.
			oUF:RegisterStyle('Lolzen - ' .. unit:gsub("^%l", string.upper), layout)
		end

		-- Hide the standard raid frames
		if LolzenUIcfg.unitframes.raid["uf_raid_enabled"] == true then
			RegisterStateDriver(CompactRaidFrameManager, 'visibility', 'hide')
			RegisterStateDriver(CompactRaidFrameContainer, 'visibility', 'hide')
		end

		oUF:Factory(function(self)
			spawnHelper(self, "player", "CENTER", -250, -200)
			spawnHelper(self, "target", "CENTER", 250, -200)
			spawnHelper(self, "targettarget", "CENTER", 300, -177)
			spawnHelper(self, "focus", "CENTER", -250, -230)
			spawnHelper(self, "pet", "CENTER", -300, -177)

			for i=1, MAX_BOSS_FRAMES do
				if LolzenUIcfg.unitframes.boss["uf_boss_additional_pos"] == "ABOVE" then
					spawnHelper(self, "boss" .. i, "CENTER", 0, -200 - LolzenUIcfg.unitframes.boss["uf_boss_height"] + (LolzenUIcfg.unitframes.boss["uf_boss_height"] * i) - LolzenUIcfg.unitframes.boss["uf_boss_additional_spacing"] + (LolzenUIcfg.unitframes.boss["uf_boss_additional_spacing"] * i))
				elseif LolzenUIcfg.unitframes.boss["uf_boss_additional_pos"] == "BELOW" then
					spawnHelper(self, "boss" .. i, "CENTER", 0, -200 + LolzenUIcfg.unitframes.boss["uf_boss_height"] - (LolzenUIcfg.unitframes.boss["uf_boss_height"] * i) + LolzenUIcfg.unitframes.boss["uf_boss_additional_spacing"] - (LolzenUIcfg.unitframes.boss["uf_boss_additional_spacing"] * i))
				elseif 	LolzenUIcfg.unitframes.boss["uf_boss_additional_pos"] == "LEFT" then
					spawnHelper(self, "boss" .. i, "CENTER", (0 + LolzenUIcfg.unitframes.boss["uf_boss_width"]) - (LolzenUIcfg.unitframes.boss["uf_boss_width"] * i) + LolzenUIcfg.unitframes.boss["uf_boss_additional_spacing"] - (LolzenUIcfg.unitframes.boss["uf_boss_additional_spacing"] * i), -200)
				elseif 	LolzenUIcfg.unitframes.boss["uf_boss_additional_pos"] == "RIGHT" then
					spawnHelper(self, "boss" .. i, "CENTER", (0 - LolzenUIcfg.unitframes.boss["uf_boss_width"]) + (LolzenUIcfg.unitframes.boss["uf_boss_width"] * i) - LolzenUIcfg.unitframes.boss["uf_boss_additional_spacing"] + (LolzenUIcfg.unitframes.boss["uf_boss_additional_spacing"] * i), -200)
				end
			end

			for i=1, 3 do
				if LolzenUIcfg.unitframes.arena["uf_arena_additional_pos"] == "ABOVE" then
					spawnHelper(self, "arena" .. i, "CENTER", 0, -200 - LolzenUIcfg.unitframes.arena["uf_arena_height"] + (LolzenUIcfg.unitframes.arena["uf_arena_height"] * i) - LolzenUIcfg.unitframes.arena["uf_arena_additional_spacing"] + (LolzenUIcfg.unitframes.arena["uf_arena_additional_spacing"] * i))
				elseif LolzenUIcfg.unitframes.arena["uf_arena_additional_pos"] == "BELOW" then
					spawnHelper(self, "arena" .. i, "CENTER", 0, -200 + LolzenUIcfg.unitframes.arena["uf_arena_height"] - (LolzenUIcfg.unitframes.arena["uf_arena_height"] * i) + LolzenUIcfg.unitframes.arena["uf_arena_additional_spacing"] - (LolzenUIcfg.unitframes.arena["uf_arena_additional_spacing"] * i))
				elseif 	LolzenUIcfg.unitframes.arena["uf_arena_additional_pos"] == "LEFT" then
					spawnHelper(self, "arena" .. i, "CENTER", (0 + LolzenUIcfg.unitframes.arena["uf_arena_width"]) - (LolzenUIcfg.unitframes.arena["uf_arena_width"] * i) + LolzenUIcfg.unitframes.arena["uf_arena_additional_spacing"] - (LolzenUIcfg.unitframes.arena["uf_arena_additional_spacing"] * i), -200)
				elseif 	LolzenUIcfg.unitframes.arena["uf_arena_additional_pos"] == "RIGHT" then
					spawnHelper(self, "arena" .. i, "CENTER", (0 - LolzenUIcfg.unitframes.arena["uf_arena_width"]) + (LolzenUIcfg.unitframes.arena["uf_arena_width"] * i) - LolzenUIcfg.unitframes.arena["uf_arena_additional_spacing"] + (LolzenUIcfg.unitframes.arena["uf_arena_additional_spacing"] * i), -200)
				end
			end

			self:SetActiveStyle("Lolzen - Party")
			-- ToDo: can this be solved with a single party header?
			-- setting up two party headers requires much code duplication, also requires to change party positioning code changes
			-- (& OMF, saved variables..)
			local vert_party = self:SpawnHeader(
				nil, nil, 'party',
				'showParty', LolzenUIcfg.unitframes.party["uf_party_use_vertical_layout"] and LolzenUIcfg.unitframes.party["uf_party_enabled"],
				'showPlayer', LolzenUIcfg.unitframes.party["uf_party_use_vertical_layout"] and LolzenUIcfg.unitframes.party["uf_party_enabled"],
				'xOffset', 0,
				'yOffset', 0,
				'oUF-initialConfigFunction', [[
					self:SetHeight(19)
					self:SetWidth(70)
				]],
				'maxColumns', 5,
				'unitsperColumn', 1,
				'columnSpacing', 5,
				'columnAnchorPoint', "TOP"
			)
			vert_party:SetPoint("BOTTOM", UIParent, 0, 140)
			
			local hor_party = self:SpawnHeader(
				nil, nil, 'party',
				'showParty', LolzenUIcfg.unitframes.party["uf_party_use_vertical_layout"]==false and LolzenUIcfg.unitframes.party["uf_party_enabled"],
				'showPlayer', LolzenUIcfg.unitframes.party["uf_party_use_vertical_layout"]==false and LolzenUIcfg.unitframes.party["uf_party_enabled"],
				'xOffset', 7,
				'yOffset', 0,
				'oUF-initialConfigFunction', [[
					self:SetHeight(19)
					self:SetWidth(70)
				]],
				'maxColumns', 5,
				'unitsperColumn', 1,
				'columnSpacing', 7,
				'columnAnchorPoint', "RIGHT"
			)
			hor_party:SetPoint("BOTTOM", UIParent, 0, 140)

			ns.ToggleOUFParty = function()
				vert_party:SetAttribute('showParty', LolzenUIcfg.unitframes.party["uf_party_use_vertical_layout"] and LolzenUIcfg.unitframes.party["uf_party_enabled"])
				hor_party:SetAttribute('showParty', LolzenUIcfg.unitframes.party["uf_party_use_vertical_layout"]==false and LolzenUIcfg.unitframes.party["uf_party_enabled"])
				vert_party:SetAttribute('showPlayer', LolzenUIcfg.unitframes.party["uf_party_use_vertical_layout"] and LolzenUIcfg.unitframes.party["uf_party_enabled"])
				hor_party:SetAttribute('showPlayer', LolzenUIcfg.unitframes.party["uf_party_use_vertical_layout"]==false and LolzenUIcfg.unitframes.party["uf_party_enabled"])
				if LolzenUIcfg.unitframes.party["uf_party_enabled"] == true then
					for i=1, 4 do
						ns.oUF:DisableBlizzard("party"..i)
					end
				else
					--reenable default blizzard partyframes
					PartyMemberFrame_OnLoad(PartyMemberFrame1)
					PartyMemberFrame_OnLoad(PartyMemberFrame2)
					PartyMemberFrame_OnLoad(PartyMemberFrame3)
					PartyMemberFrame_OnLoad(PartyMemberFrame4)
					PartyMemberFrame1:SetParent(UIParent)
					PartyMemberFrame2:SetParent(UIParent)
					PartyMemberFrame3:SetParent(UIParent)
					PartyMemberFrame4:SetParent(UIParent)
				end	
			end

			ns.SetUFPartySize = function()
				for k,v in ipairs(vert_party) do
					v:SetSize(LolzenUIcfg.unitframes.party["uf_party_width"], LolzenUIcfg.unitframes.party["uf_party_height"])
				end
				for k,v in ipairs(hor_party) do
					v:SetSize(LolzenUIcfg.unitframes.party["uf_party_width"], LolzenUIcfg.unitframes.party["uf_party_height"])
				end
			end

			ns.SetUFPartyOwnFont = function()
				if LolzenUIcfg.unitframes.party["uf_party_use_own_hp_font_settings"] == true then
					for k,v in ipairs(vert_party) do
						v.Health.value:SetFont(LSM:Fetch("font", LolzenUIcfg.unitframes.party["uf_party_hp_font"]), LolzenUIcfg.unitframes.party["uf_party_hp_font_size"], LolzenUIcfg.unitframes.party["uf_party_hp_font_flag"])
						v.Health.value:ClearAllPoints()
						v.Health.value:SetPoint(LolzenUIcfg.unitframes.party["uf_party_hp_anchor"], LolzenUIcfg.unitframes.party["uf_party_hp_posx"], LolzenUIcfg.unitframes.party["uf_party_hp_posy"])
					end
					for k,v in ipairs(hor_party) do
						v.Health.value:SetFont(LSM:Fetch("font", LolzenUIcfg.unitframes.party["uf_party_hp_font"]), LolzenUIcfg.unitframes.party["uf_party_hp_font_size"], LolzenUIcfg.unitframes.party["uf_party_hp_font_flag"])
						v.Health.value:ClearAllPoints()
						v.Health.value:SetPoint(LolzenUIcfg.unitframes.party["uf_party_hp_anchor"], LolzenUIcfg.unitframes.party["uf_party_hp_posx"], LolzenUIcfg.unitframes.party["uf_party_hp_posy"])
					end
				else
					for k,v in ipairs(vert_party) do
						v.Health.value:SetFont(LSM:Fetch("font", LolzenUIcfg.unitframes.general["uf_general_hp_font"]), LolzenUIcfg.unitframes.general["uf_general_hp_font_size"], LolzenUIcfg.unitframes.general["uf_general_hp_font_flag"])
						v.Health.value:ClearAllPoints()
						v.Health.value:SetPoint(LolzenUIcfg.unitframes.general["uf_general_hp_anchor"], LolzenUIcfg.unitframes.general["uf_general_hp_posx"], LolzenUIcfg.unitframes.general["uf_general_hp_posy"])
					end
					for k,v in ipairs(hor_party) do
						v.Health.value:SetFont(LSM:Fetch("font", LolzenUIcfg.unitframes.general["uf_general_hp_font"]), LolzenUIcfg.unitframes.general["uf_general_hp_font_size"], LolzenUIcfg.unitframes.general["uf_general_hp_font_flag"])
						v.Health.value:ClearAllPoints()
						v.Health.value:SetPoint(LolzenUIcfg.unitframes.general["uf_general_hp_anchor"], LolzenUIcfg.unitframes.general["uf_general_hp_posx"], LolzenUIcfg.unitframes.general["uf_general_hp_posy"])
					end
				end
			end

			ns.SetUFPartyHPPos = function()
				if LolzenUIcfg.unitframes.party["uf_party_use_own_hp_font_settings"] == true then
					for k,v in ipairs(vert_party) do
						v.Health.value:ClearAllPoints()
						v.Health.value:SetPoint(LolzenUIcfg.unitframes.party["uf_party_hp_anchor"], LolzenUIcfg.unitframes.party["uf_party_hp_posx"], LolzenUIcfg.unitframes.party["uf_party_hp_posy"])
					end
					for k,v in ipairs(hor_party) do
						v.Health.value:ClearAllPoints()
						v.Health.value:SetPoint(LolzenUIcfg.unitframes.party["uf_party_hp_anchor"], LolzenUIcfg.unitframes.party["uf_party_hp_posx"], LolzenUIcfg.unitframes.party["uf_party_hp_posy"])
					end
				end
			end

			ns.SetUFPartyHPFont = function()
				if LolzenUIcfg.unitframes.party["uf_party_use_own_hp_font_settings"] == true then
					for k,v in ipairs(vert_party) do
						v.Health.value:SetFont(LSM:Fetch("font", LolzenUIcfg.unitframes.party["uf_party_hp_font"]), LolzenUIcfg.unitframes.party["uf_party_hp_font_size"], LolzenUIcfg.unitframes.party["uf_party_hp_font_flag"])
					end
					for k,v in ipairs(hor_party) do
						v.Health.value:SetFont(LSM:Fetch("font", LolzenUIcfg.unitframes.party["uf_party_hp_font"]), LolzenUIcfg.unitframes.party["uf_party_hp_font_size"], LolzenUIcfg.unitframes.party["uf_party_hp_font_flag"])
					end
				end
			end

			ns.SetUFPartyShowRoleIndicator = function()
				if LolzenUIcfg.unitframes.party["uf_party_showroleindicator"] == true then
					for k,v in ipairs(vert_party) do
						v.GroupRoleIndicator:Show()
					end
					for k,v in ipairs(hor_party) do
						v.GroupRoleIndicator:Show()
					end
				else
					for k,v in ipairs(vert_party) do
						v.GroupRoleIndicator:Hide()
					end
					for k,v in ipairs(hor_party) do
						v.GroupRoleIndicator:Hide()
					end
				end
			end

			ns.SetUFPartyRoleIndicatorSize = function()
				for k,v in ipairs(vert_party) do
					v.GroupRoleIndicator:SetSize(LolzenUIcfg.unitframes.party["uf_party_ri_size"], LolzenUIcfg.unitframes.party["uf_party_ri_size"])
				end
				for k,v in ipairs(hor_party) do
					v.GroupRoleIndicator:SetSize(LolzenUIcfg.unitframes.party["uf_party_ri_size"], LolzenUIcfg.unitframes.party["uf_party_ri_size"])
				end
			end

			ns.SetUFPartyRoleIndicatorPos = function()
				for k,v in ipairs(vert_party) do
					v.GroupRoleIndicator:ClearAllPoints()
					v.GroupRoleIndicator:SetPoint(LolzenUIcfg.unitframes.party["uf_party_ri_anchor"], self.Health, LolzenUIcfg.unitframes.party["uf_party_ri_posx"], LolzenUIcfg.unitframes.party["uf_party_ri_posy"])
				end
				for k,v in ipairs(hor_party) do
					v.GroupRoleIndicator:ClearAllPoints()
					v.GroupRoleIndicator:SetPoint(LolzenUIcfg.unitframes.party["uf_party_ri_anchor"], self.Health, LolzenUIcfg.unitframes.party["uf_party_ri_posx"], LolzenUIcfg.unitframes.party["uf_party_ri_posy"])
				end
			end

			ns.SetUFPartyReadyCheckIndicatorSize = function()
				for k,v in ipairs(vert_party) do
					v.ReadyCheckIndicator:SetSize(LolzenUIcfg.unitframes.party["uf_party_rc_size"], LolzenUIcfg.unitframes.party["uf_party_rc_size"])
				end
				for k,v in ipairs(hor_party) do
					v.ReadyCheckIndicator:SetSize(LolzenUIcfg.unitframes.party["uf_party_rc_size"], LolzenUIcfg.unitframes.party["uf_party_rc_size"])
				end
			end

			ns.SetUFPartyReadyCheckIndicatorPos = function()
				for k,v in ipairs(vert_party) do
					v.ReadyCheckIndicator:ClearAllPoints()
					v.ReadyCheckIndicator:SetPoint(LolzenUIcfg.unitframes.party["uf_party_rc_anchor"], self.Health, LolzenUIcfg.unitframes.party["uf_party_rc_posx"], LolzenUIcfg.unitframes.party["uf_party_rc_posy"])
				end
				for k,v in ipairs(hor_party) do
					v.ReadyCheckIndicator:ClearAllPoints()
					v.ReadyCheckIndicator:SetPoint(LolzenUIcfg.unitframes.party["uf_party_rc_anchor"], self.Health, LolzenUIcfg.unitframes.party["uf_party_rc_posx"], LolzenUIcfg.unitframes.party["uf_party_rc_posy"])
				end
			end

			if LolzenUIcfg.unitframes.raid["uf_raid_enabled"] == true then
				self:SetActiveStyle("Lolzen - Raid")
				local raid = self:SpawnHeader(
					nil, nil, 'raid',
					'showPlayer', true,
					'showSolo', false,
					'showParty', false,
					'showRaid', true,
					'xoffset', 7,
					'yOffset', -5,
					'oUF-initialConfigFunction', [[
						self:SetHeight(19)
						self:SetWidth(50)
					]],
					'groupFilter', '1,2,3,4,5,6,7,8',
					'groupingOrder', '1,2,3,4,5,6,7,8',
					'sortMethod', 'GROUP',
					'groupBy', 'GROUP',
					'maxColumns', 8,
					'unitsPerColumn', 5,
					'columnSpacing', 7,
					'columnAnchorPoint', "RIGHT"
				)
				raid:SetPoint("LEFT", UIParent, 20, 0)
			end
		end)
	end
end)