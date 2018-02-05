**Changes in 7.0.14:**

- _Adrian L Lange (1):_
    1. changelog: Fix link markup ([#416](https://github.com/oUF-wow/oUF/issues/416))
- _Rainrider (4):_
    1. changelog: show newest commits on top
    2. auras: use oUF's colors table for debuff types
    3. colors: add debuff to the colors table
    4. auras: Add more arguments to PostUpdateIcon ([#418](https://github.com/oUF-wow/oUF/issues/418))
- _Val Voronov (1):_
    1. core: Update raid vehicle handling hack ([#424](https://github.com/oUF-wow/oUF/issues/424))
- 4 files changed, 38 insertions(+), 23 deletions(-)

**Changes in 7.0.13:**

- _Adrian L Lange (1):_
    1. changelog: Add links to issues mentioned in commit messages ([#414](https://github.com/oUF-wow/oUF/issues/414))
- _Rainrider (1):_
    1. core: update arena frames on ARENA_OPPONENT_UPDATE
- _Val Voronov (1):_
    1. healthprediction: Maths update
- 3 files changed, 26 insertions(+), 24 deletions(-)

**Changes in 7.0.12:**

- _Adrian L Lange (1):_
    1. castbar: Account for orientation and reverse fill for Spark repositioning ([#408](https://github.com/oUF-wow/oUF/issues/408))
- 1 file changed, 19 insertions(+), 2 deletions(-)

**Changes in 7.0.11:**

- _Val Voronov (1):_
    1. core: Disable raid frames vehicle handling in Antorus raid ([#404](https://github.com/oUF-wow/oUF/issues/404))
- 1 file changed, 70 insertions(+), 3 deletions(-)

**Changes in 7.0.10:**

- _Adrian L Lange (1):_
    1. core: Let the packager set a static version ([#401](https://github.com/oUF-wow/oUF/issues/401))
- 1 file changed, 1 insertion(+), 1 deletion(-)

**Changes in 7.0.9:**

- _Val Voronov (1):_
    1. portrait: Use both UNIT_PORTRAIT_UPDATE and UNIT_MODEL_CHANGED ([#400](https://github.com/oUF-wow/oUF/issues/400))
- 2 files changed, 5 insertions(+), 2 deletions(-)

**Changes in 7.0.8:**

- _Val Voronov (1):_
    1. portrait: Fix updates for *target units ([#399](https://github.com/oUF-wow/oUF/issues/399))
- 2 files changed, 26 insertions(+), 23 deletions(-)

**Changes in 7.0.7:**

- _Adrian L Lange (1):_
    1. Update README ([#397](https://github.com/oUF-wow/oUF/issues/397))
- _Rainrider (1):_
    1. core: update the frame units upon UNIT_EXITING_VEHICLE
- 2 files changed, 16 insertions(+), 8 deletions(-)

**Changes in 7.0.6:**

- _Belzaru (3):_
    1. Remove unnecessary Show.
    2. Remove unnecessary code and rename variable.
    3. Change units and percent calculation to be relative to maximum cast duration.
- _Rainrider (2):_
    1. stagger: add a nil check for UnitStagger ([#392](https://github.com/oUF-wow/oUF/issues/392))
    2. threatindicator: asure the element has SetVertexColor before using it
- 3 files changed, 12 insertions(+), 14 deletions(-)

**Changes in 7.0.5:**

- _Val Voronov (1):_
    1. core: Update units of already handled nameplates ([#391](https://github.com/oUF-wow/oUF/issues/391))
- 1 file changed, 2 insertions(+)

**Changes in 7.0.4:**

- _Adrian L Lange (1):_
    1. utils: Pandoc is extremely picky with the prefixed spacing on sublists ([#388](https://github.com/oUF-wow/oUF/issues/388))
- _Val Voronov (1):_
    1. classpower: Unregister all events ([#387](https://github.com/oUF-wow/oUF/issues/387))
- 2 files changed, 5 insertions(+), 1 deletion(-)

**Changes in 7.0.3:**

- _Adrian L Lange (1):_
    1. utils: Use ordrered lists for commit messages
- _Val Voronov (1):_
    1. core: Set nameplate CVars immediately if already logged in
- 2 files changed, 15 insertions(+), 2 deletions(-)

**Changes in 7.0.2:**

- _Adrian L Lange (1):_
    1. toc: CurseForge wants IDs, not slugs ([#382](https://github.com/oUF-wow/oUF/issues/382))
- _Val Voronov (1):_
    1. Update README
- 2 files changed, 8 insertions(+), 4 deletions(-)

**Changes in 7.0.1:**

- _Adrian L Lange (1):_
    1. Update Interface version ([#380](https://github.com/oUF-wow/oUF/issues/380))
- 1 file changed, 1 insertion(+), 1 deletion(-)

**Changes in 7.0.0:**

- _Adrian L Lange (19):_
    1. We need to escape the regex pattern for travis config
    2. Don't restrict builds away from tags
    3. Only let travis run on master
    4. Revert "Put the changelog in the cloned directory"
    5. Only let travis run on master
    6. Put the changelog in the cloned directory
    7. Add automatic packaging with the help of TravisCI and BigWigs' packager script
    8. Use a custom changelog generated before packaging
    9. Don't count merge commits as actual changes in the changelog
    10. Convert the changelog script to output markdown formatted logs
    11. classpower: Only show active bars ([#363](https://github.com/oUF-wow/oUF/issues/363))
    12. core: Expose header visibility ([#329](https://github.com/oUF-wow/oUF/issues/329))
    13. aura: Update returns from UnitAura ([#314](https://github.com/oUF-wow/oUF/issues/314))
    14. classicons: Fake unit if player is in a vehicle
    15. core: Make sure UpdateAllElements has an event
    16. core: There are 5 arena and boss frames
    17. additionalpower: Remove beta client compatibility code
    18. totems: TotemFrame is parented to PlayerFrame
    19. druidmana: Rename element to "AdditionalPower"
- _Erik Raetz (1):_
    1. Use GetCreatureDifficultyColor and fallback level 999
- _Jakub Šoustar (1):_
    1. totems: Use actual number of totem sub-widgets instead of MAX_TOTEMS
- _Phanx (1):_
    1. health: Ignore updates with nil unit (Blizz bug in 7.1) ([#319](https://github.com/oUF-wow/oUF/issues/319))
- _Rainrider (15):_
    1. runes: update docs
    2. masterlooterindicator: make sure all update paths trigger Pre|PostUpdate
    3. castbar: add .timeToHold option
    4. castbar: pass the spellid to Post* hooks where applicable
    5. castbar: set .Text for failed and interrupted casts accordingly
    6. castbar: delegate hiding the castbar to the OnUpdate script
    7. castbar: update interruptible flag in UNIT_SPELLCAST(_NOT)_INTERRUPTIBLE
    8. castbar: upvalue GetNetStats
    9. castbar: rename object to self
    10. castbar: remove some unused variables
    11. castbar: deprecate .interrupt in favor of .notInterruptible
    12. castbar: use SetColorTexture
    13. castbar: add a .holdTime option
    14. power: Allow using atlases
    15. core:  update the pet frame properly after entering/exiting a vehicle
- _Sticklord (1):_
    1. core: Change the framestrata to LOW
- _Val Voronov (13):_
    1. Add README ([#373](https://github.com/oUF-wow/oUF/issues/373))
    2. threatindicator: Fix UnitThreatSituation error ([#371](https://github.com/oUF-wow/oUF/issues/371))
    3. stagger: Move Hide() call to a better spot
    4. power: Add Show() call to Enable function
    5. portrait: Move Show() call to a better spot
    6. healthprediction: Remove redundant Show() calls
    7. health: Add Show() call to Enable function
    8. alternativepower: Move Hide() call to a better spot
    9. core: oUF.xml cleanup ([#369](https://github.com/oUF-wow/oUF/issues/369))
    10. classpower: Element update ([#368](https://github.com/oUF-wow/oUF/issues/368))
    11. runes: Add nil and 0 spec checks ([#367](https://github.com/oUF-wow/oUF/issues/367))
    12. runebar: Set cooldown start time to 0 if rune was energized ([#310](https://github.com/oUF-wow/oUF/issues/310))
    13. tags: Added 'powercolor' tag.
- 65 files changed, 5536 insertions(+), 4507 deletions(-)

