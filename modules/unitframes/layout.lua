local _, ns = ...
local L = ns.L
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

			if LolzenUIcfg.unitframes.party["uf_party_enabled"] == true then
				self:SetActiveStyle("Lolzen - Party")

				if LolzenUIcfg.unitframes.party["uf_party_use_vertical_layout"] == true then
					local party = self:SpawnHeader(
						nil, nil, 'party',
						'showParty', true,
						'showPlayer', true,
						'showRaid', true, --debug
						'xOffset', 0,
						'yoffset', 0,
						'oUF-initialConfigFunction', [[
							self:SetHeight(19)
							self:SetWidth(70)
						]],
						'maxColumns', 5,
						'unitsperColumn', 1,
						'columnSpacing', 5,
						'columnAnchorPoint', "TOP"
					)
					party:SetPoint("BOTTOM", UIParent, 0, 140)
				else
					local party = self:SpawnHeader(
						nil, nil, 'party',
						'showParty', true,
						'showPlayer', true,
						'xOffset', 7,
						'yoffset', 0,
						'oUF-initialConfigFunction', [[
							self:SetHeight(19)
							self:SetWidth(70)
						]],
						'maxColumns', 5,
						'unitsperColumn', 1,
						'columnSpacing', 7,
						'columnAnchorPoint', "RIGHT"
					)
					party:SetPoint("BOTTOM", UIParent, 0, 140)
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