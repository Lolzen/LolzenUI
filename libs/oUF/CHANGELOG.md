**Changes in 7.0.11:**

- _Val Voronov (1):_
    1. core: Disable raid frames vehicle handling in Antorus raid (#404)
- 1 file changed, 70 insertions(+), 3 deletions(-)

**Changes in 7.0.10:**

- _Adrian L Lange (1):_
    1. core: Let the packager set a static version (#401)
- 1 file changed, 1 insertion(+), 1 deletion(-)

**Changes in 7.0.9:**

- _Val Voronov (1):_
    1. portrait: Use both UNIT_PORTRAIT_UPDATE and UNIT_MODEL_CHANGED (#400)
- 2 files changed, 5 insertions(+), 2 deletions(-)

**Changes in 7.0.8:**

- _Val Voronov (1):_
    1. portrait: Fix updates for *target units (#399)
- 2 files changed, 26 insertions(+), 23 deletions(-)

**Changes in 7.0.7:**

- _Adrian L Lange (1):_
    1. Update README (#397)
- _Rainrider (1):_
    1. core: update the frame units upon UNIT_EXITING_VEHICLE
- 2 files changed, 16 insertions(+), 8 deletions(-)

**Changes in 7.0.6:**

- _Belzaru (3):_
    1. Change units and percent calculation to be relative to maximum cast duration.
    2. Remove unnecessary code and rename variable.
    3. Remove unnecessary Show.
- _Rainrider (2):_
    1. threatindicator: asure the element has SetVertexColor before using it
    2. stagger: add a nil check for UnitStagger (#392)
- 3 files changed, 12 insertions(+), 14 deletions(-)

**Changes in 7.0.5:**

- _Val Voronov (1):_
    1. core: Update units of already handled nameplates (#391)
- 1 file changed, 2 insertions(+)

**Changes in 7.0.4:**

- _Adrian L Lange (1):_
    1. utils: Pandoc is extremely picky with the prefixed spacing on sublists (#388)
- _Val Voronov (1):_
    1. classpower: Unregister all events (#387)
- 2 files changed, 5 insertions(+), 1 deletion(-)

**Changes in 7.0.3:**

- _Adrian L Lange (1):_
    1. utils: Use ordrered lists for commit messages
- _Val Voronov (1):_
    1. core: Set nameplate CVars immediately if already logged in
- 2 files changed, 15 insertions(+), 2 deletions(-)

**Changes in 7.0.2:**

- _Adrian L Lange (1):_
    1. toc: CurseForge wants IDs, not slugs (#382)
- _Val Voronov (1):_
    1. Update README
- 2 files changed, 8 insertions(+), 4 deletions(-)

**Changes in 7.0.1:**

- _Adrian L Lange (1):_
    1. Update Interface version (#380)
- 1 file changed, 1 insertion(+), 1 deletion(-)

**Changes in 7.0.0:**

- _Adrian L Lange (20):_
    1. druidmana: Rename element to "AdditionalPower"
    2. totems: TotemFrame is parented to PlayerFrame
    3. additionalpower: Remove beta client compatibility code
    4. core: There are 5 arena and boss frames
    5. core: Make sure UpdateAllElements has an event
    6. classicons: Fake unit if player is in a vehicle
    7. aura: Update returns from UnitAura (#314)
    8. core: Expose header visibility (#329)
    9. tags: Update documentation
    10. classpower: Only show active bars (#363)
    11. Convert the changelog script to output markdown formatted logs
    12. Don't count merge commits as actual changes in the changelog
    13. Use a custom changelog generated before packaging
    14. Add automatic packaging with the help of TravisCI and BigWigs' packager script
    15. Put the changelog in the cloned directory
    16. Only let travis run on master
    17. Revert "Put the changelog in the cloned directory"
    18. Only let travis run on master
    19. Don't restrict builds away from tags
    20. We need to escape the regex pattern for travis config
- _Erik Raetz (1):_
    1. Use GetCreatureDifficultyColor and fallback level 999
- _Jakub Šoustar (2):_
    1. totems: Remove priorities
    2. totems: Use actual number of totem sub-widgets instead of MAX_TOTEMS
- _Phanx (1):_
    1. health: Ignore updates with nil unit (Blizz bug in 7.1) (#319)
- _Rainrider (18):_
    1. core:  update the pet frame properly after entering/exiting a vehicle
    2. power: Allow using atlases
    3. castbar: add a .holdTime option
    4. castbar: use SetColorTexture
    5. castbar: deprecate .interrupt in favor of .notInterruptible
    6. castbar: remove some unused variables
    7. castbar: rename object to self
    8. castbar: upvalue GetNetStats
    9. castbar: update interruptible flag in UNIT_SPELLCAST(_NOT)_INTERRUPTIBLE
    10. castbar: delegate hiding the castbar to the OnUpdate script
    11. castbar: set .Text for failed and interrupted casts accordingly
    12. castbar: pass the spellid to Post* hooks where applicable
    13. castbar: add .timeToHold option
    14. portrait: check for PlayerModel instead of Model
    15. range: minor cleanup
    16. raidroleindicator: make sure all update paths trigger Pre|PostUpdate
    17. masterlooterindicator: make sure all update paths trigger Pre|PostUpdate
    18. runes: update docs
- _Sticklord (1):_
    1. core: Change the framestrata to LOW
- _Val Voronov (19):_
    1. tags: Added 'powercolor' tag.
    2. runebar: Set cooldown start time to 0 if rune was energized (#310)
    3. healthprediction: Element update (#353)
    4. runes: Min value should be 0
    5. runes: Add colouring support
    6. additionalpower: Move colour update to its own function (#360)
    7. auras: Element update (#361)
    8. stagger: Move colour update to its own function (#359)
    9. runes: Add nil and 0 spec checks (#367)
    10. classpower: Element update (#368)
    11. core: oUF.xml cleanup (#369)
    12. alternativepower: Move Hide() call to a better spot
    13. health: Add Show() call to Enable function
    14. healthprediction: Remove redundant Show() calls
    15. portrait: Move Show() call to a better spot
    16. power: Add Show() call to Enable function
    17. stagger: Move Hide() call to a better spot
    18. threatindicator: Fix UnitThreatSituation error (#371)
    19. Add README (#373)
- 65 files changed, 5536 insertions(+), 4507 deletions(-)

