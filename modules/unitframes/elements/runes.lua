local _, ns = ...
local LSM = LibStub("LibSharedMedia-3.0")

function ns.AddRunes(self, unit)
	local Runes = {}
	for i = 1, 6 do
		Runes[i] = CreateFrame("StatusBar", "Rune"..i.."Bar", self)
		Runes[i]:SetStatusBarTexture(LSM:Fetch("statusbar", LolzenUIcfg.unitframes.general["uf_statusbar_texture"]))
		Runes[i]:SetSize((self:GetWidth()/6) - ((LolzenUIcfg.unitframes.player["uf_player_classpower_spacing"]*5)/(6)), 8)
		if i == 1 then
			Runes[i]:SetPoint(LolzenUIcfg.unitframes.player["uf_player_classpower_anchor1"], self, LolzenUIcfg.unitframes.player["uf_player_classpower_anchor2"], LolzenUIcfg.unitframes.player["uf_player_classpower_posx"], LolzenUIcfg.unitframes.player["uf_player_classpower_posy"])
		else
			Runes[i]:SetPoint("LEFT", Runes[i-1], "RIGHT", LolzenUIcfg.unitframes.player["uf_player_classpower_spacing"], 0)
		end

		Runes[i].border = CreateFrame("Frame", nil, Runes[i])
		Runes[i].border:SetBackdrop({
			edgeFile = LSM:Fetch("border", LolzenUIcfg.unitframes.player["uf_player_classpower_border"]),
			tile=true, tileSize=4, edgeSize=4,
		})
		Runes[i].border:SetPoint("TOPLEFT", Runes[i], -1.5, 1.5)
		Runes[i].border:SetPoint("BOTTOMRIGHT", Runes[i], 1, -1)
		Runes[i].border:SetBackdropBorderColor(0, 0, 0)
		Runes[i].border:SetFrameLevel(3)
	end
	self.Runes = Runes
end