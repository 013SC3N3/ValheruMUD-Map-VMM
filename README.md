# ValheruMUD Map (VMM)

A browsable web map of **ValheruMUD**, open in any browser — no client, no install, no account.

**Live: https://013sc3n3.github.io/ValheruMUD-Map-VMM/**

**v1.0.1** · Author: **O13SC3N3 (Shinra)** — [github.com/013SC3N3](https://github.com/013SC3N3)

## What this is for

ValheruMUD has no in-game map. Everything here is player mapping work done in Mudlet, published
so it can be read on a second monitor or a phone while playing, and shared with people who don't
run the Mudlet package at all.

The site renders `maps/VMM.dat` — the same Mudlet binary map that ships with the o13 minimap
package. One file feeds both, so the website and the in-client minimap can never drift apart.

## Using it

It opens on **Village of Udgaard**. From there:

- **Area list** — jump to any of the mapped areas.
- **Level switcher** — appears for multi-level areas. Most areas have more than one level, and
  only one renders at a time; the view stays framed as you step through them.
- **Search** — by room id, or by name.
- **Deep links** — `?area=<id>` opens an area, `?loc=<roomId>` opens and selects a room. Handy
  for pointing someone at an exact spot instead of "head north from the square".

Grid, embossed rooms, circular rooms, uniform level sizing and zoom persistence are on by
default. Change anything in the settings panel and your choice sticks in that browser.

## What the map does and doesn't show

- **Doors** are drawn in their natural closed state.
- **Lock state is deliberately not shown.** That is a choice, not a gap.

## How it's built

There is no hand-written HTML here. [Delwing/mudlet-map-page](https://github.com/Delwing/mudlet-map-page)
decodes the `.dat` to JSON at build time and generates the page around the
`mudlet-map-browser-script` viewer.

    .github/workflows/pages.yml   build + deploy; map path, title, credits
    maps/VMM.dat                  the map — the only file that changes routinely
    scripts/default-settings.mjs  seeds the default view settings for new visitors
    update-map.ps1                export -> commit -> push helper

Those default settings are not build options — the viewer keeps them in `localStorage` — so the
script injects them before the viewer loads, filling in only what a visitor hasn't already set.

## Author & License

Map data, configuration and scripts in this repository: **O13SC3N3 (Shinra)**. Please credit if
you reuse or redistribute. Licensed MIT — see [LICENSE](LICENSE).

Built with [mudlet-map-page](https://github.com/Delwing/mudlet-map-page) and
[mudlet-map-browser-script](https://github.com/Delwing/mudlet-map-browser-script), both MIT
licensed by Piotr Wilczynski (Delwing).
