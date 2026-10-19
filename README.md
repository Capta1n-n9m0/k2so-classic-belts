# K2SO Classic Belts

A Factorio 2.1 mod for [Krastorio 2](https://mods.factorio.com/mod/Krastorio2) with
[Krastorio 2 Spaced Out](https://mods.factorio.com/mod/Krastorio2-spaced-out) (K2SO). It undoes three K2SO
logistics changes.

Mod portal: <https://mods.factorio.com/mod/k2so-classic-belts>

| K2SO change | This mod |
|---|---|
| Express underground belt reach 20 -> 15 | Back to 20 |
| K2 advanced belt, underground belt and splitter hidden (items, recipes, entities, tech `kr-logistic-4`) | Back, with K2's own recipes, unlocked by `kr-logistic-4` |
| Express splitter (+80 lubricant), express underground belt (+40) and express loader (+40) need an assembler with fluid | No lubricant, hand-craftable again |
| K2 advanced loader rebuilt for Vulcanus (turbo belt, tungsten, lubricant) | K2 recipe again: 1 advanced belt + 2 express loaders + 10 rare metals, unlocked by `kr-logistic-4` |

Not changed: K2SO's upgrade chain (express -> turbo), so upgrade planners skip the advanced tier.

All prototype changes are in `data-updates.lua`. The mod depends on Krastorio2-spaced-out, so they run after
K2SO's own data-updates and before every data-final-fixes; recycling, down-binning and stacking recipes for the
restored items are then generated as usual. On an existing save where `kr-logistic-4` is already researched, the
restored recipes are enabled when the mod is added.

## Requirements

Factorio 2.1, Krastorio2 and Krastorio2-spaced-out.

## Development

The mod lives in `mod/k2so-classic-belts/`. Its tests are a
[FactorioTest](https://github.com/GlassBricks/FactorioTest) suite in `mod/k2so-classic-belts/tests/`; they load
only when the `factorio-test` mod is active, so they never run in a normal game. Run them with the FactorioTest
CLI, for example

```
npx -p factorio-test-cli factorio-test run --mod-path mod/k2so-classic-belts
```

`tests/fixtures/logistic-4-before-mod.lua` describes a save from before the mod was installed (`kr-logistic-4`
researched, restored recipes off); tests tagged `fixture:logistic-4-before-mod` run on a save built from it with
the mod added afterwards.

## License

MIT, see `LICENSE`.
