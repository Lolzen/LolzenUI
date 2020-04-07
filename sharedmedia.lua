--// sharedmedia //--
-- standard textures, fonts, sounds, etc from LolzenUI

local LSM = LibStub("LibSharedMedia-3.0")
local LBT = LibStub("LibButtonTexture-1.0")

-- fonts
LSM:Register("font", "DroidSans", [[Interface\Addons\LolzenUI\fonts\DroidSans.ttf]])
LSM:Register("font", "DroidSansBold", [[Interface\Addons\LolzenUI\fonts\DroidSansBold.ttf]])
LSM:Register("font", "Semplice Regular", [[Interface\Addons\LolzenUI\fonts\SEMPRG.ttf]])

-- borders
LSM:Register("border", "LolzenUI Standard", [[Interface\Addons\LolzenUI\media\border]])

-- statusbars
LSM:Register("statusbar", "LolzenUI Standard", [[Interface\Addons\LolzenUI\media\statusbar]])

-- backgrounds
LSM:Register("background", "LolzenUI Standard", [[Interface\Addons\LolzenUI\media\statusbar]])

-- [buttons]
-- border
LBT:Register("border", "LolzenUI Standard", [[Interface\Addons\LolzenUI\media\gloss]])

-- flashing
LBT:Register("flashing", "LolzenUI Standard", [[Interface\Addons\LolzenUI\media\flash]])

-- checked
LBT:Register("checked", "LolzenUI Standard", [[Interface\Addons\LolzenUI\media\checked]])

-- hover
LBT:Register("hover", "LolzenUI Standard", [[Interface\Addons\LolzenUI\media\hover]])

-- pushed
LBT:Register("pushed", "LolzenUI Standard", [[Interface\Addons\LolzenUI\media\pushed]])

-- [auras]
-- buff
LBT:Register("buff", "LolzenUI Standard", [[Interface\Addons\LolzenUI\media\auraborder]])

--debuff
LBT:Register("debuff", "LolzenUI Standard", [[Interface\Addons\LolzenUI\media\debuffborder]])