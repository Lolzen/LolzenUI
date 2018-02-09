![Alt text](http://abload.de/img/wowscrnshot_112417_185tsk5.jpg "Screenshot1")

## LolzenUI
This is my personal User Interface for World of Warcraft.

It is a compilation of different utilities for either information, feature, ease-of-life addition or anything of that sort.

------
### embedded Libs:
**LibItemUpgradeInfo-1.0**

As blizzards API doesn't perfectly well work (heirlooms, upgrades, ..) LolzenUI makes use of this lib.

**LibSharedMedia-3.0**

Can be used to easily add custom fonts and textures to LolzenUI.

**oUF**

the Unitframes and Nameplates integrated make use of oUF.

------
### Some AddOn Suggestions to complement LolzenUI:
- BaudBag (or any other Bag addon)
- BonusRollPreview
- ChatLootIcons
- ConvertRatings
- Doom_CooldownPulse
- EasyDeleteConfirm
- GnomishAuctionShrinker
- GnomishVendorShrinker
- HideTalkingHead
- Molinari
- NameplateRange
- QuickQuest
- tekability
- tekErr
- tekKompare
- teksLoot
- Tipachu
- tullaRange
- VendorBait
- xanErrorDevourer

------
### ToDo:
- [ ] possible bug: buttons get occasionaly blocked (?)
- [ ] bug: occasional taint: find & fix it
- [ ] finish Unitframe options
  - [ ] option to enable user placement (shift + click)
    - [ ] enable a tooltip with placement info (example: "CENTER", -276, 46)
	- [ ] disable "normal" Saved Variables when used and use it's own)
  - [ ] OOC fading
  - [x] focus castbar
  - [x] focus auras
  - [ ] pet castbar
  - [ ] make something with alphachannel to "cut" a hole into pet frame (when player is casting), so the pet unitrame doesn't collide with player castbar time
  - [ ] target/focus/boss panel (name & level font, etc) options
  - [ ] uf power colors: make it more efficient
  - [x] scrollable content: make scroll area size fit needed space (so there's no empty space to scroll down to") & hide scrollbar if everything shown fits into the panel
- [ ] nameplates: debuffs
- [ ] revisit descriptions
- [ ] unify optionpanel formatting as good as possible
- [ ] itemlevel: add support for more bags
- [ ] orderhallbar: font option for zonetext
- [ ] tweak module (several tiny tweaks like "increase max watched currency" (BaudBag does this))
- [ ] previews: make more previews/preview positions where it makes sense
- [ ] finetuning
- [ ] export/import profiles
- [ ] localizations