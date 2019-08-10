local _, ns = ...
local LSM = LibStub("LibSharedMedia-3.0")

local PostUpdateClassPower = function(element, power, maxPower, maxPowerChanged)
	if not maxPower or not maxPowerChanged then return end

	for i = 1, maxPower do
		local parent = element[i]:GetParent()
		element[i]:SetSize((parent:GetWidth()/maxPower) - ((LolzenUIcfg.unitframes.player["uf_player_classpower_spacing"]*maxPower-1)/(maxPower+1)), 8)
	end
end

function ns.AddClassPower(self, unit)
	-- ClassPower (Combo Points, etc)
	local ClassPower = {}
	for i=1, 10 do
		ClassPower[i] = CreateFrame("StatusBar", "ClassPower"..i.."Bar", self)
		ClassPower[i]:SetStatusBarTexture(LSM:Fetch("statusbar", LolzenUIcfg.unitframes.general["uf_statusbar_texture"]))
		if i == 1 then
			ClassPower[i]:SetPoint(LolzenUIcfg.unitframes.player["uf_player_classpower_anchor1"], self, LolzenUIcfg.unitframes.player["uf_player_classpower_anchor2"], LolzenUIcfg.unitframes.player["uf_player_classpower_posx"], LolzenUIcfg.unitframes.player["uf_player_classpower_posy"])
		else
			ClassPower[i]:SetPoint("LEFT", ClassPower[i-1], "RIGHT", LolzenUIcfg.unitframes.player["uf_player_classpower_spacing"], 0)
		end

		ClassPower[i].border = CreateFrame("Frame", nil, ClassPower[i])
		ClassPower[i].border:SetBackdrop({
			edgeFile = LSM:Fetch("border", LolzenUIcfg.unitframes.player["uf_player_classpower_border"]),
			tile=true, tileSize=4, edgeSize=4,
			insets={left=0.5, right=0.5, top=0.5, bottom=0.5}
		})
		ClassPower[i].border:SetPoint("TOPLEFT", ClassPower[i], -1.5, 1.5)
		ClassPower[i].border:SetPoint("BOTTOMRIGHT", ClassPower[i], 1, -1)
		ClassPower[i].border:SetBackdropBorderColor(0, 0, 0)
		ClassPower[i].border:SetFrameLevel(3)
	end
	self.ClassPower = ClassPower

	ClassPower.PostUpdate = PostUpdateClassPower
end