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

-- sounds
LSM:Register("sound", "UT2004_female: Denied", [[Interface\Addons\LolzenUI\sounds\UT2004_female\Denied.mp3]])
LSM:Register("sound", "UT2004_female: Play", [[Interface\Addons\LolzenUI\sounds\UT2004_female\Play.mp3]])
LSM:Register("sound", "UT2004_female: one", [[Interface\Addons\LolzenUI\sounds\UT2004_female\one.mp3]])
LSM:Register("sound", "UT2004_female: two", [[Interface\Addons\LolzenUI\sounds\UT2004_female\two.mp3]])
LSM:Register("sound", "UT2004_female: three", [[Interface\Addons\LolzenUI\sounds\UT2004_female\three.mp3]])
LSM:Register("sound", "UT2004_female: four", [[Interface\Addons\LolzenUI\sounds\UT2004_female\four.mp3]])
LSM:Register("sound", "UT2004_female: five", [[Interface\Addons\LolzenUI\sounds\UT2004_female\five.mp3]])
LSM:Register("sound", "UT2004_female: six", [[Interface\Addons\LolzenUI\sounds\UT2004_female\six.mp3]])
LSM:Register("sound", "UT2004_female: seven", [[Interface\Addons\LolzenUI\sounds\UT2004_female\seven.mp3]])
LSM:Register("sound", "UT2004_female: eight", [[Interface\Addons\LolzenUI\sounds\UT2004_female\eight.mp3]])
LSM:Register("sound", "UT2004_female: nine", [[Interface\Addons\LolzenUI\sounds\UT2004_female\nine.mp3]])
LSM:Register("sound", "UT2004_female: ten", [[Interface\Addons\LolzenUI\sounds\UT2004_female\ten.mp3]])

LSM:Register("sound", "UT3_female: Denied", [[Interface\Addons\LolzenUI\sounds\UT3_female\Denied.ogg]])
LSM:Register("sound", "UT3_female: Play", [[Interface\Addons\LolzenUI\sounds\UT3_female\Play.ogg]])
LSM:Register("sound", "UT3_female: one", [[Interface\Addons\LolzenUI\sounds\UT3_female\one.ogg]])
LSM:Register("sound", "UT3_female: two", [[Interface\Addons\LolzenUI\sounds\UT3_female\two.ogg]])
LSM:Register("sound", "UT3_female: three", [[Interface\Addons\LolzenUI\sounds\UT3_female\three.ogg]])
LSM:Register("sound", "UT3_female: four", [[Interface\Addons\LolzenUI\sounds\UT3_female\four.ogg]])
LSM:Register("sound", "UT3_female: five", [[Interface\Addons\LolzenUI\sounds\UT3_female\five.ogg]])
LSM:Register("sound", "UT3_female: six", [[Interface\Addons\LolzenUI\sounds\UT3_female\six.ogg]])
LSM:Register("sound", "UT3_female: seven", [[Interface\Addons\LolzenUI\sounds\UT3_female\seven.ogg]])
LSM:Register("sound", "UT3_female: eight", [[Interface\Addons\LolzenUI\sounds\UT3_female\eight.ogg]])
LSM:Register("sound", "UT3_female: nine", [[Interface\Addons\LolzenUI\sounds\UT3_female\nine.ogg]])
LSM:Register("sound", "UT3_female: ten", [[Interface\Addons\LolzenUI\sounds\UT3_female\ten.ogg]])

LSM:Register("sound", "Nyanners: Cucked", [[Interface\Addons\LolzenUI\sounds\Nyanners\cucked.ogg]])
LSM:Register("sound", "Nyanners: Blastoff", [[Interface\Addons\LolzenUI\sounds\Nyanners\blastoff.ogg]])
LSM:Register("sound", "Nyanners: one", [[Interface\Addons\LolzenUI\sounds\Nyanners\one.ogg]])
LSM:Register("sound", "Nyanners: two", [[Interface\Addons\LolzenUI\sounds\Nyanners\two.ogg]])
LSM:Register("sound", "Nyanners: three", [[Interface\Addons\LolzenUI\sounds\Nyanners\three.ogg]])
LSM:Register("sound", "Nyanners: four", [[Interface\Addons\LolzenUI\sounds\Nyanners\four.ogg]])
LSM:Register("sound", "Nyanners: five", [[Interface\Addons\LolzenUI\sounds\Nyanners\five.ogg]])
LSM:Register("sound", "Nyanners: six", [[Interface\Addons\LolzenUI\sounds\Nyanners\six.ogg]])
LSM:Register("sound", "Nyanners: seven", [[Interface\Addons\LolzenUI\sounds\Nyanners\seven.ogg]])
LSM:Register("sound", "Nyanners: eight", [[Interface\Addons\LolzenUI\sounds\Nyanners\eight.ogg]])
LSM:Register("sound", "Nyanners: nine", [[Interface\Addons\LolzenUI\sounds\Nyanners\nine.ogg]])
LSM:Register("sound", "Nyanners: ten", [[Interface\Addons\LolzenUI\sounds\Nyanners\ten.ogg]])

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