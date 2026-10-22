# LoveCa × Tabletop Simulator

[简体中文](README.md) | **English** | [日本語](README_ja.md)

Now is on [steam workshop](https://steamcommunity.com/sharedfiles/filedetails/?id=3823101966)

Unofficial TTS Lua helpers for the **official LoveLive! series card game (LoveCa / ラブカ)**: import decks, view card details, calculate field totals, use signed value markers, and see whether the current Live Heart requirements are met.

Players still resolve skills, draw cards, pay costs, move cards, and manage turns themselves. This project does not include a complete, loadable TTS scene or a full offline card database.

## Features

- **Deck import**: Query the official site by full card number, generate main and energy decks, and check generated counts and duplicate instances.
- **Card details**: Hover descriptions show type, cost, Hearts, Blade, score, cheer information, abilities, and LoveCa points. Original data and icon tokens are retained.
- **Field totals**: Count each player's stage, Live, cheer, and energy areas separately, refreshing every second. Hidden cards, unclear placement, and invalid data produce warnings.
- **Value adjustments**: Signed Heart, Blade, and score markers affect totals according to their placement.
- **Live check**: Check all Lives together against one shared Heart pool from the stage and cheer areas. Recalculate automatically when modifiers change.
- **Decide turn order**: Randomly select which seated player chooses to play first or second, excluding the GM and spectators.
- **Three languages**: Choose 中文, 日本語, or English for the whole table. Fixed interface text and card-detail headings follow the selected language.

## Requirements and table setup

- **Tabletop Simulator**. In-game card queries, card images, and marker textures require network access.
- **Python 3** for building and the optional sync tool. Both use only the standard library; no third-party Python packages are required.
- Run all commands below from the **project root**. PowerShell examples use **PowerShell 7**.

Field statistics require two playmats matching this project's zone layout. The defaults are in `FIELD_DEFAULTS` in [`ground/field_statistics.lua`](ground/field_statistics.lua): White maps to `0e661d`, and Pink to `bab5f6`. These are **object GUIDs from the development scene**, not universal IDs for any new table.

To adapt another scene, check the playmat GUIDs, dimensions, orientation, and local zones, then update the configuration and rebuild. In existing saves, `field.config` overrides source defaults. Changing defaults alone does not migrate an old save.

## Quick start

### 1. Build the Global script

```powershell
python tools/build_importer.py
```

The output is [`ground/import_cards.lua`](ground/import_cards.lua). It bundles shared logic, localization, field calculations, marker scripts, and the importer. **Do not edit the generated file directly.**

### 2. Install in TTS

1. Open a compatible table and save the latest scene in-game first. If you save to a new slot, load that new save before continuing.
2. Open the TTS scripting editor and select **Global**.
3. Paste the complete contents of `ground/import_cards.lua` into Global.
4. Run **Save & Play**, check the buttons on the left and the playmat zones, then save the game again.

**Save & Play reloads the scene; unsaved placements may revert.** Do not paste the script onto an individual card or overwrite the current game with an old recovery save.

### 3. Import a deck

Click **Import deck** and enter one **full card number and quantity** per line, for example:

```text
PL!-bp3-021-SRL 2
PL!-pb2-000-R 4
PL!S-PR-034-PR+ 6
```

- Include the rarity in each card number. Both half-width `+` and full-width `＋` are supported.
- Blank lines and full-line comments beginning with `#` are ignored. Quantities for repeated card numbers are combined.
- Each batch is limited to 200 cards and 60 types. This is an import safeguard, not a deck-legality check.
- You can paste `.tts.txt` lists from [`deck/`](deck/). The `.yaml` files are reference deck data; the import box does not parse YAML.
- The importer validates data before generating cards. Loading a save never imports cards again automatically.

This example demonstrates the format, not a complete legal deck. LoveCa points use the **2026-08-08** snapshot in [`card/points.json`](card/points.json). Check the latest tournament requirements before use.

## In-game controls

### Field totals and Live check

Click **Field totals** to view both players' statistics. Data updates every second; **Refresh** and **Details** are also available.

- Stage members contribute Hearts in either Active or Wait state. Only Active members contribute Blade.
- Each player's cheer area is the green frame outside their playmat, on their left. Reveal individual cards before stacking them as needed.
- Place stage, Live, and deployed energy cards individually. These zones do not accept a deck instead of separate cards.
- The check uses the **combined requirements of all Lives and a single shared resource pool**. Hearts cannot be reused. ALL can cover specified colors; colorless Hearts only contribute to the total.
- The result is pending when relevant cards are hidden, placement is invalid, or there is no Live. Negative final Heart quantities after modifiers are retained and flagged for confirmation.
- Use **Block Live (effect/manual)** for blocking effects. Resolve other skills manually first, then check the current values.

Success or failure here describes **the current Heart requirements**. It does not automatically settle or compare final scores, move successful Lives, or determine the winner of the game.

### Value markers

Click **Value markers**, select a player, resource, initial value, and area, then create a marker.

- Drag the icon to move it. Click the outer number: left-click `+1`, right-click `−1`.
- The right-click menu supports entering an integer, inverting its sign, resetting to zero, and deleting the marker.
- `M1～M3` correspond to three member slots, and `L1～L3` to three Live slots. There are also Live total score, cheer modifier, and storage areas.
- Only markers in applicable areas affect totals; storage has no effect. For example, ALL belongs in cheer modifiers, not member modifiers.
- Member/Live markers bind to the card present when placed. To change targets, move the marker to storage first, then place it in the new card's slot. Old modifiers do not transfer automatically.

### Private card resolution area

Use the hidden zone for your player color when an effect tells you to view and choose cards privately. Afterwards, move the cards to the hand, waiting room, or other destinations specified by that effect. Centered titles and instructions follow the selected language, omit owner or exclusive-use labels, and do not intercept card clicks or dragging.

### Turn order and language

**Decide turn order** selects which seated player **chooses** to play first or second; it does not make that choice for them. The GM (Black) and spectators (Grey) are excluded. A host seated at a normal player color can participate. The result reads "[White player] decides turn order".

**Language** offers 中文, 日本語, and English. The selection is saved with script state. Entry buttons stay visible, only one popup opens at a time, and all popups use the same upper-left starting position.

Fixed labels and descriptions support all three languages. Card names, series, units, products, and untranslated ability text retain their Japanese source. Printed text in card and playmat images is not redrawn. Switching languages does not split existing decks; contained cards update their descriptions when taken out.

## Optional: use the sync tool

Instead of installing manually, you can use [`tools/sync_tts.py`](tools/sync_tts.py). First enable TTS's **External Editor API**. The tool sends requests to the local loopback address on port `39999` and receives replies on `39998`. Run only one sync client at a time.

The external save directory is not hard-coded. Enter the actual TTS Saves path **relative to the current project directory**:

```powershell
$ttsSaves = Read-Host 'Enter the relative path to the TTS Saves directory'

# Back up runtime source, UI, script state, and an existing disk save without changing the game.
python tools/sync_tts.py --save-dir "$ttsSaves" --capture-only
```

The specified directory must contain `TS_AutoSave*.json`. This backup is **not a live snapshot of the entire table** and does not replace saving in-game.

Before a full sync, save the latest table in-game. If you save to a new slot, load it first so Save & Play targets the same file. Enter the filename you actually just saved; do not reuse a historical slot number:

```powershell
$saveName = Read-Host 'Enter the filename just saved, for example TS_Save_3.json'
$savedGame = Join-Path $ttsSaves $saveName
python tools/sync_tts.py --save-dir "$ttsSaves" --reload --saved-game "$savedGame"
```

This command backs up data, checks scene objects and transforms, and rejects a mismatch between the loaded save and the specified file before reloading. It then runs Save & Play and checks source, editor cache, transforms, and persistent state before updating the specified save. If a check fails, follow its message; do not bypass the difference check to force a sync.

`--apply` is a **hot preview without reloading**. It does not mean the editor cache and native save are updated. Recovery materials stay in local `.tts-backups/`; save the latest game before restoring an older backup.

## Project structure

```text
.
├── README.md                    # Chinese overview and usage
├── README_en.md                 # English overview and usage
├── README_ja.md                 # Japanese overview and usage
├── loveca-tts-research.md        # Rules, design, issues, and translation proposal
├── loveca-tts-handoff.md         # Development progress, handoff, and tasks
├── card/
│   ├── localization.lua         # Chinese/Japanese/English text and locale state
│   ├── card_common.lua          # Metadata, Unicode, icons, and presentation
│   ├── samples.json             # Small card sample, not a full database
│   ├── points.json              # Point snapshot with source and date
│   └── assets/                  # Historical images, not used by the main importer
├── ground/
│   ├── card_importer.lua        # Official API, import jobs, shared UI, and state
│   ├── field_statistics.lua     # Zones, totals, Live checks, and choice draw
│   ├── marker_tools.lua         # Marker panel, areas, binding, and scanning
│   ├── import_cards.lua         # Generated Global installation file
│   └── spawn_test_card.lua      # Historical experiment, not the main entry point
├── mark/
│   ├── marker_resources.lua     # Marker definitions and existing textures
│   └── adjustable_marker.lua    # Standalone marker controls and persistence
├── deck/
│   ├── *.yaml                   # Reference deck data
│   └── *.tts.txt                # Lists ready to paste into the importer
└── tools/
    ├── build_importer.py        # Bundles source and embeds the marker script
    └── sync_tts.py              # Backup, hot preview, and full sync
```

Rebuild after editing source modules. To compile-check the Python tools:

```powershell
python -m py_compile tools/build_importer.py tools/sync_tts.py
```

Local IDE/assistant settings, Python caches, and `.tts-backups/` are excluded by `.gitignore`; omit them from manual archives too. Official service URLs, public image sources, object GUIDs, and TTS protocol ports are not personal file paths.

## Ability translations: proposal and current status

Ability text varies between cards, but a translation can be reused for the same version. Prefer **reviewed, offline translations indexed by base card number and source-text version**, rather than calling a translation service from the game each time:

1. Standardize rules terminology. Preserve `{{filename|original alt}}` icon tokens and translate only the prose.
2. Keep the Japanese source snapshot, translated text, source, and review status. Check values, conditions, targets, optional actions, and duration.
3. Reuse translations across rarities only when the source is identical. If the official text changes, fall back to Japanese pending review.
4. Reviewed Chinese text can use `translations.zh.ability`; English uses `translations.en.ability`. Translations never participate in numerical calculations.

See [research notes, section 39.2](loveca-tts-research.md) for the proposal and an actual card example. **Bulk Chinese/English ability translations are not included, and no automatic translation service is connected.**

## Status and references

The importer, marker integration, turn-order selection, and Live checks are deployed to the development table. **All three languages were deployed to the local native save on 2026-10-22 and verified by loading Chinese, Japanese, and English saved states.** The current language is Chinese. Research section 42 also covers save-target and persistent-state checks added to the sync tool. See [loveca-tts-handoff.md](loveca-tts-handoff.md) for the latest handoff.

- [LoveCa official website](https://llofficial-cardgame.com/) and [rules](https://llofficial-cardgame.com/rule/)
- [Official LoveCa point system](https://llofficial-cardgame.com/lovecapointsystem/)
- [TTS Scripting API](https://api.tabletopsimulator.com/)
- [Card image mirror and sample data](https://github.com/wlt233/llocg_db); card rendering also uses the public [wsrv.nl](https://wsrv.nl/) conversion service
- [Card-back image](https://loveca.lovelivefun.xyz/back.jpg); markers use public texture URLs from the existing table

Card and image content belongs to the respective rights holders. If a service or image fails to load, check the import status and logs. Successful data queries do not establish that images have finished loading.
