local _, ns = ...
local LSM = LibStub("LibSharedMedia-3.0")

function ns.AddStagger(self, unit)
	local Stagger = CreateFrame('StatusBar', nil, self)
	Stagger:SetSize(LolzenUIcfg.unitframes.player["uf_player_width"], 8)
	Stagger:SetStatusBarTexture(LSM:Fetch("statusbar", LolzenUIcfg.unitframes.general["uf_statusbar_texture"]))
	Stagger:SetPoint(LolzenUIcfg.unitframes.player["uf_player_classpower_anchor1"], self, LolzenUIcfg.unitframes.player["uf_player_classpower_anchor2"], LolzenUIcfg.unitframes.player["uf_player_classpower_posx"], LolzenUIcfg.unitframes.player["uf_player_classpower_posy"])

	Stagger.border = CreateFrame("Frame", nil, Stagger, "BackdropTemplate")
	Stagger.border:SetBackdrop({
		edgeFile = LSM:Fetch("border", LolzenUIcfg.unitframes.player["uf_player_classpower_border"]),
		tile=true, tileSize=4, edgeSize=4,
	})
	Stagger.border:SetPoint("TOPLEFT", Stagger, -1.5, 1.5)
	Stagger.border:SetPoint("BOTTOMRIGHT", Stagger, 1, -1)
	Stagger.border:SetBackdropBorderColor(0, 0, 0)
	Stagger.border:SetFrameLevel(3)

	self.Stagger = Stagger
end