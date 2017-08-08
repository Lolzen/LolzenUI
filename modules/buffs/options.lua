--// options for buffs //--

local addon, ns = ...

if not ns.modules["actionabars"] then
	tinsert(ns.modules, "buffs")
end
-- counter pos's
local f = CreateFrame("Frame")
f:RegisterEvent("ADDON_LOADED")
f:SetScript("OnEvent", function(self, event, addon)
	if addon == "LolzenUI" and LolzenUIcfg["buffs"] == true then

		local title = ns["buffs"]:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
		title:SetPoint("TOPLEFT", ns["buffs"], 16, -16)
		title:SetText("|cff5599ff"..ns["buffs"].name.."|r")

		local about = ns["buffs"]:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
		about:SetPoint("TOPLEFT", title, "BOTTOMLEFT", 0, -8)
		about:SetText("Skins the buffs/debuffs along with a more detailed timer")
		
		local button = ns["buffs"]:CreateTexture(nil, "TEXTURE")
		button:SetTexture(select(3, GetSpellInfo(546)))
		button:SetSize(LolzenUIcfg["buff_size"], LolzenUIcfg["buff_size"])
		button:SetPoint("TOPLEFT", about, "BOTTOMLEFT", 0, -20)
		button:SetTexCoord(0.1, 0.9, 0.1, 0.9)

		local bufftex = ns["buffs"]:CreateTexture(nil, "OVERLAY")
		bufftex:SetTexture("Interface\\AddOns\\LolzenUI\\media\\"..LolzenUIcfg["buff_aura_texture"])
		bufftex:SetPoint("TOPLEFT", button, "TOPLEFT", -2, 2)
		bufftex:SetPoint("BOTTOMRIGHT", button, "BOTTOMRIGHT", 2, -2)
		bufftex:SetVertexColor(0, 0, 0)
		
		local button2 = ns["buffs"]:CreateTexture(nil, "TEXTURE")
		button2:SetTexture(select(3, GetSpellInfo(192423)))
		button2:SetSize(LolzenUIcfg["buff_debuff_size"], LolzenUIcfg["buff_debuff_size"])
		button2:SetPoint("LEFT", button, "RIGHT", 5, 0)
		button2:SetTexCoord(0.1, 0.9, 0.1, 0.9)
		
		local debufftex = ns["buffs"]:CreateTexture(nil, "OVERLAY")
		debufftex:SetTexture("Interface\\AddOns\\LolzenUI\\media\\"..LolzenUIcfg["buff_debuff_texture"])
		debufftex:SetPoint("TOPLEFT", button2, "TOPLEFT", -2, 2)
		debufftex:SetPoint("BOTTOMRIGHT", button2, "BOTTOMRIGHT", 2, -2)
		debufftex:SetVertexColor(1, 0, 0)
		
--		local button3 = ns["buffs"]:CreateTexture(nil, "TEXTURE")
--		button3:SetTexture(select(3, GetSpellInfo(53343)))
--		button3:SetSize(LolzenUIcfg["buff_tempenchant_size"], LolzenUIcfg["buff_tempenchant_size"])
--		button3:SetPoint("LEFT", button2, "RIGHT", 5, 0)
--		button3:SetTexCoord(0.1, 0.9, 0.1, 0.9)
		
--		local tempenchtex = ns["buffs"]:CreateTexture(nil, "OVERLAY")
--		tempenchtex:SetTexture("Interface\\AddOns\\LolzenUI\\media\\"..LolzenUIcfg["buff_aura_texture"])
--		tempenchtex:SetPoint("TOPLEFT", button3, "TOPLEFT", -2, 2)
--		tempenchtex:SetPoint("BOTTOMRIGHT", button3, "BOTTOMRIGHT", 2, -2)
--		tempenchtex:SetVertexColor(0, 0, 0)

		local buffs_text = ns["buffs"]:CreateFontString(nil, "ARTWORK", "GameFontNormal")
		buffs_text:SetPoint("TOPLEFT", button, "BOTTOMLEFT", 0, -8)
		buffs_text:SetText("|cff5599ffBuffs:|r")
		
		local buff_size_text = ns["buffs"]:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
		buff_size_text:SetPoint("TOPLEFT", buffs_text, "BOTTOMLEFT", 0, -10)
		buff_size_text:SetText("Buff size:")
		
		local buff_size = CreateFrame("EditBox", nil, ns["buffs"], "InputBoxTemplate")
		buff_size:SetPoint("LEFT", buff_size_text, "RIGHT", 10, 0)
		buff_size:SetSize(30, 20)
		buff_size:SetAutoFocus(false)
		buff_size:ClearFocus()
		buff_size:SetNumber(LolzenUIcfg["buff_size"])
		buff_size:SetCursorPosition(0)
		
		local debuff_size_text = ns["buffs"]:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
		debuff_size_text:SetPoint("LEFT", buff_size, "RIGHT", 5, 0)
		debuff_size_text:SetText("Debuff size:")
		
		local debuff_size = CreateFrame("EditBox", nil, ns["buffs"], "InputBoxTemplate")
		debuff_size:SetPoint("LEFT", debuff_size_text, "RIGHT", 10, 0)
		debuff_size:SetSize(30, 20)
		debuff_size:SetAutoFocus(false)
		debuff_size:ClearFocus()
		debuff_size:SetNumber(LolzenUIcfg["buff_debuff_size"])
		debuff_size:SetCursorPosition(0)
		
		local tempenchant_size_text = ns["buffs"]:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
		tempenchant_size_text:SetPoint("LEFT", debuff_size, "RIGHT", 5, 0)
		tempenchant_size_text:SetText("Tempenchant size:")
		
		local tempenchant_size = CreateFrame("EditBox", nil, ns["buffs"], "InputBoxTemplate")
		tempenchant_size:SetPoint("LEFT", tempenchant_size_text, "RIGHT", 10, 0)
		tempenchant_size:SetSize(30, 20)
		tempenchant_size:SetAutoFocus(false)
		tempenchant_size:ClearFocus()
		tempenchant_size:SetNumber(LolzenUIcfg["buff_tempenchant_size"])
		tempenchant_size:SetCursorPosition(0)

		local pos_x_text = ns["buffs"]:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
		pos_x_text:SetPoint("TOPLEFT", buff_size_text, "BOTTOMLEFT", 0, -10)
		pos_x_text:SetText("PosX:")

		local pos_x = CreateFrame("EditBox", nil, ns["buffs"], "InputBoxTemplate")
		pos_x:SetPoint("LEFT", pos_x_text, "RIGHT", 10, 0)
		pos_x:SetSize(30, 20)
		pos_x:SetAutoFocus(false)
		pos_x:ClearFocus()
		pos_x:SetNumber(LolzenUIcfg["buff_posx"])
		pos_x:SetCursorPosition(0)

		local pos_y_text = ns["buffs"]:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
		pos_y_text:SetPoint("LEFT", pos_x, "RIGHT", 5, 0)
		pos_y_text:SetText("PosY:")

		local pos_y = CreateFrame("EditBox", nil, ns["buffs"], "InputBoxTemplate")
		pos_y:SetPoint("LEFT", pos_y_text, "RIGHT", 10, 0)
		pos_y:SetSize(30, 20)
		pos_y:SetAutoFocus(false)
		pos_y:ClearFocus()
		pos_y:SetNumber(LolzenUIcfg["buff_posy"])
		pos_y:SetCursorPosition(0)

		local anchor_text = ns["buffs"]:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
		anchor_text:SetPoint("LEFT", pos_y, "RIGHT", 5, 0)
		anchor_text:SetText("Anchor1:")

		local anchor = CreateFrame("EditBox", nil, ns["buffs"], "InputBoxTemplate")
		anchor:SetPoint("LEFT", anchor_text, "RIGHT", 10, 0)
		anchor:SetSize(100, 20)
		anchor:SetAutoFocus(false)
		anchor:ClearFocus()
		anchor:SetText(LolzenUIcfg["buff_anchor1"])
		anchor:SetCursorPosition(0)

		local parent_text = ns["buffs"]:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
		parent_text:SetPoint("LEFT", anchor, "RIGHT", 5, 0)
		parent_text:SetText("Parent:")

		local parent = CreateFrame("EditBox", nil, ns["buffs"], "InputBoxTemplate")
		parent:SetPoint("LEFT", parent_text, "RIGHT", 10, 0)
		parent:SetSize(80, 20)
		parent:SetAutoFocus(false)
		parent:ClearFocus()
		parent:SetText(LolzenUIcfg["buff_parent"])
		parent:SetCursorPosition(0)

		local anchor2_text = ns["buffs"]:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
		anchor2_text:SetPoint("LEFT", parent, "RIGHT", 5, 0)
		anchor2_text:SetText("Anchor2:")

		local anchor2 = CreateFrame("EditBox", nil, ns["buffs"], "InputBoxTemplate")
		anchor2:SetPoint("LEFT", anchor2_text, "RIGHT", 10, 0)
		anchor2:SetSize(100, 20)
		anchor2:SetAutoFocus(false)
		anchor2:ClearFocus()
		anchor2:SetText(LolzenUIcfg["buff_anchor2"])
		anchor2:SetCursorPosition(0)
		
		local bufftex_path_text = ns["buffs"]:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
		bufftex_path_text:SetPoint("TOPLEFT", pos_x_text, "BOTTOMLEFT", 0, -10)
		bufftex_path_text:SetText("|cff5599ffbuff/tempenchant texture:|r Interface/AddOns/LolzenUI/media/")

		local bufftex_path = CreateFrame("EditBox", nil, ns["buffs"], "InputBoxTemplate")
		bufftex_path:SetPoint("LEFT", bufftex_path_text, "RIGHT", 10, 0)
		bufftex_path:SetSize(80, 20)
		bufftex_path:SetAutoFocus(false)
		bufftex_path:ClearFocus()
		bufftex_path:SetText(LolzenUIcfg["buff_aura_texture"])
		bufftex_path:SetCursorPosition(0)
		
		local debufftex_path_text = ns["buffs"]:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
		debufftex_path_text:SetPoint("TOPLEFT", bufftex_path_text, "BOTTOMLEFT", 0, -10)
		debufftex_path_text:SetText("|cff5599ffdebuff texture:|r Interface/AddOns/LolzenUI/media/")

		local debufftex_path = CreateFrame("EditBox", nil, ns["buffs"], "InputBoxTemplate")
		debufftex_path:SetPoint("LEFT", debufftex_path_text, "RIGHT", 10, 0)
		debufftex_path:SetSize(80, 20)
		debufftex_path:SetAutoFocus(false)
		debufftex_path:ClearFocus()
		debufftex_path:SetText(LolzenUIcfg["buff_debuff_texture"])
		debufftex_path:SetCursorPosition(0)

		local dur_text = ns["buffs"]:CreateFontString(nil, "ARTWORK", "GameFontNormal")
		dur_text:SetPoint("TOPLEFT", debufftex_path_text, "BOTTOMLEFT", 0, -20)
		dur_text:SetText("|cff5599ffDuration text:|r")

		local dur_pos_x_text = ns["buffs"]:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
		dur_pos_x_text:SetPoint("TOPLEFT", dur_text, "BOTTOMLEFT", 0, -10)
		dur_pos_x_text:SetText("PosX:")

		local dur_pos_x = CreateFrame("EditBox", nil, ns["buffs"], "InputBoxTemplate")
		dur_pos_x:SetPoint("LEFT", dur_pos_x_text, "RIGHT", 10, 0)
		dur_pos_x:SetSize(30, 20)
		dur_pos_x:SetAutoFocus(false)
		dur_pos_x:ClearFocus()
		dur_pos_x:SetNumber(LolzenUIcfg["buff_duration_posx"])
		dur_pos_x:SetCursorPosition(0)

		local dur_pos_y_text = ns["buffs"]:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
		dur_pos_y_text:SetPoint("LEFT", dur_pos_x, "RIGHT", 5, 0)
		dur_pos_y_text:SetText("PosY:")

		local dur_pos_y = CreateFrame("EditBox", nil, ns["buffs"], "InputBoxTemplate")
		dur_pos_y:SetPoint("LEFT", dur_pos_y_text, "RIGHT", 10, 0)
		dur_pos_y:SetSize(30, 20)
		dur_pos_y:SetAutoFocus(false)
		dur_pos_y:ClearFocus()
		dur_pos_y:SetNumber(LolzenUIcfg["buff_duration_posy"])
		dur_pos_y:SetCursorPosition(0)

		local dur_anchor_text = ns["buffs"]:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
		dur_anchor_text:SetPoint("LEFT", dur_pos_y, "RIGHT", 5, 0)
		dur_anchor_text:SetText("Anchor1:")

		local dur_anchor = CreateFrame("EditBox", nil, ns["buffs"], "InputBoxTemplate")
		dur_anchor:SetPoint("LEFT", dur_anchor_text, "RIGHT", 10, 0)
		dur_anchor:SetSize(100, 20)
		dur_anchor:SetAutoFocus(false)
		dur_anchor:ClearFocus()
		dur_anchor:SetText(LolzenUIcfg["buff_duration_anchor1"])
		dur_anchor:SetCursorPosition(0)

		local dur_anchor2_text = ns["buffs"]:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
		dur_anchor2_text:SetPoint("LEFT", dur_anchor, "RIGHT", 5, 0)
		dur_anchor2_text:SetText("Anchor2:")

		local dur_anchor2 = CreateFrame("EditBox", nil, ns["buffs"], "InputBoxTemplate")
		dur_anchor2:SetPoint("LEFT", dur_anchor2_text, "RIGHT", 10, 0)
		dur_anchor2:SetSize(100, 20)
		dur_anchor2:SetAutoFocus(false)
		dur_anchor2:ClearFocus()
		dur_anchor2:SetText(LolzenUIcfg["buff_duration_anchor2"])
		dur_anchor2:SetCursorPosition(0)
		
		local dur_font_text = ns["buffs"]:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
		dur_font_text:SetPoint("TOPLEFT", dur_pos_x_text, "BOTTOMLEFT", 0, -10)
		dur_font_text:SetText("|cff5599ffFont:|r Interface\\AddOns\\LolzenUI\\fonts\\")

		local dur_font = CreateFrame("EditBox", nil, ns["buffs"], "InputBoxTemplate")
		dur_font:SetPoint("LEFT", dur_font_text, "RIGHT", 10, 0)
		dur_font:SetSize(100, 20)
		dur_font:SetAutoFocus(false)
		dur_font:ClearFocus()
		dur_font:SetText(LolzenUIcfg["buff_duration_font"])
		dur_font:SetCursorPosition(0)
		
		local dur_font_size_text = ns["buffs"]:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
		dur_font_size_text:SetPoint("LEFT", dur_font, "RIGHT", 5, 0)
		dur_font_size_text:SetText("Size:")
		
		local dur_font_size = CreateFrame("EditBox", nil, ns["buffs"], "InputBoxTemplate")
		dur_font_size:SetPoint("LEFT", dur_font_size_text, "RIGHT", 10, 0)
		dur_font_size:SetSize(30, 20)
		dur_font_size:SetAutoFocus(false)
		dur_font_size:ClearFocus()
		dur_font_size:SetNumber(LolzenUIcfg["buff_duration_font_size"])
		dur_font_size:SetCursorPosition(0)
		
		local dur_font_flag_text = ns["buffs"]:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
		dur_font_flag_text:SetPoint("LEFT", dur_font_size, "RIGHT", 5, 0)
		dur_font_flag_text:SetText("Flag:")
		
		local dur_font_flag = CreateFrame("EditBox", nil, ns["buffs"], "InputBoxTemplate")
		dur_font_flag:SetPoint("LEFT", dur_font_flag_text, "RIGHT", 10, 0)
		dur_font_flag:SetSize(100, 20)
		dur_font_flag:SetAutoFocus(false)
		dur_font_flag:ClearFocus()
		dur_font_flag:SetText(LolzenUIcfg["buff_duration_font_flag"])
		dur_font_flag:SetCursorPosition(0)
		
		local cb1 = CreateFrame("CheckButton", "detailedduration", ns["buffs"], "ChatConfigCheckButtonTemplate")
		cb1:SetPoint("TOPLEFT", dur_pos_x_text, "BOTTOMLEFT", 0, -88)
		detaileddurationText:SetText("|cff5599ffmore detailed duration text (uses more cpu cycles)|r")

		if LolzenUIcfg["buff_duration_detailed"] == true then
			cb1:SetChecked(true)
		else
			cb1:SetChecked(false)
		end
		
		
	end
end)