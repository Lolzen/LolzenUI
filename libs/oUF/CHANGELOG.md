**Changes in 9.1.3:**

- _Rainrider (1):_
    1. stagger: fix visibility toggling
- 1 file changed, 2 insertions(+)

**Changes in 9.1.2:**

- _Rainrider (1):_
    1. core: handle pass-through events for eventless frames as unitless
- _Val Voronov (5):_
    1. Renamed Private.UnitSelectionType to Private.unitSelectionType
    2. Renamed Private.UnitExists to Private.unitExists
    3. runes: Updated docs ([#494](https://github.com/oUF-wow/oUF/issues/494))
    4. powerprediction: Use next instead of pairs
    5. powerprediction: Fixed a typo
- 10 files changed, 26 insertions(+), 26 deletions(-)

**Changes in 9.1.1:**

- _Rainrider (1):_
    1. elements: do not toggle visibility on enable in elements where it is part of the update process
- _Val Voronov (2):_
    1. core: Prevent multiple instances of the nameplate driver ([#492](https://github.com/oUF-wow/oUF/issues/492))
    2. core: Greatly reduced the number of UAE calls for the nameplates ([#491](https://github.com/oUF-wow/oUF/issues/491))
- 4 files changed, 19 insertions(+), 15 deletions(-)

**Changes in 9.1.0:**

- _Val Voronov (5):_
    1. core: Use _initialAttribute-* to set attributes
    2. Add .colorSelection option to health and power elements ([#484](https://github.com/oUF-wow/oUF/issues/484))
    3. threatindicator: Use a better default texture ([#486](https://github.com/oUF-wow/oUF/issues/486))
    4. pvpclassificationindicator: Add the element ([#482](https://github.com/oUF-wow/oUF/issues/482))
    5. core: Update the event system ([#483](https://github.com/oUF-wow/oUF/issues/483))
- 9 files changed, 287 insertions(+), 39 deletions(-)

**Changes in 9.0.2:**

- _Rainrider (3):_
    1. core: unregister the event when unit validation fails
    2. core: do not use table.remove as it alters the index which also breaks the loop in the __call meta method
    3. core: keep the event table even with one handler left
- 2 files changed, 12 insertions(+), 17 deletions(-)

**Changes in 9.0.1:**

- _Rainrider (1):_
    1. Update toc interface and a happy new year everyone
- 2 files changed, 5 insertions(+), 5 deletions(-)

