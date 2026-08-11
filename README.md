# ValheruMUD Map (VMM)

A browsable web map of **ValheruMUD**, plus two Mudlet packages that put the same map inside your
client.

**Live map: https://013sc3n3.github.io/ValheruMUD-Map-VMM/**

**v1.0.1** · Author: **O13SC3N3 (Shinra)** — [github.com/013SC3N3](https://github.com/013SC3N3)

## What this is for

ValheruMUD has no in-game map. Everything here is player mapping work done in Mudlet, published
so it can be read on a second monitor or a phone while playing, shared with people who don't run
Mudlet at all, and installed directly into the client by those who do.

## Downloads

Two Mudlet packages, both built from the same map data as the website. Download and drag the
`.mpackage` file into Mudlet to install.

### VMM — Fully Revealed Map

[**Download VMM.mpackage**](https://github.com/013SC3N3/ValheruMUD-Map-VMM/releases/latest/download/VMM.mpackage)

The complete map, visible immediately. Every room that has been mapped is there from the moment
you install it. This is the same map the website renders — byte for byte the same file.

Best if you already know the world and want navigation and speedwalking, or you want to look
ahead before travelling.

### VMMF — Fog of War Map

[**Download VMMF.mpackage**](https://github.com/013SC3N3/ValheruMUD-Map-VMM/releases/latest/download/VMMF.mpackage)

The same world, but every room starts hidden behind fog and is revealed as you walk into it. Your
progress is saved between sessions.

Best for new players: you still get accurate mapping and speedwalking to places you've already
been, without the world being spoiled before you've seen it.

Install one or the other, not both.

## Using the web map

It opens on **Village of Udgaard**. From there:

- **Area list** — jump to any of the mapped areas.
- **Level switcher** — appears for multi-level areas. Most areas have more than one level, and
  only one renders at a time; the view stays framed as you step through them.
- **Search** — by room id, or by name.
- **Deep links** — `?area=<id>` opens an area, `?loc=<roomId>` opens and selects a room. Handy
  for pointing someone at an exact spot instead of "head north from the square".

Grid, embossed rooms, circular rooms, uniform level sizing and zoom persistence are on by
default. Change anything in the settings panel and your choice sticks in that browser.

## Scope — what this does and doesn't do

Answers to the questions that come up most.

**What is mapped?** The world and its coordinates. Rooms, exits, areas, levels, and the links
between them.

**Are Quest NPCs mapped?** No.

**Are mobs, shops, or other mobiles mapped?** No. Nothing outside the world geometry and its
coordinates is captured — no NPCs, no mobiles, no items, no spawn data.

**Are doors shown?** Yes, in their natural closed state. **Lock state is deliberately not
shown.** That is a design choice, not missing data.

**Is speedwalking supported?** Yes. Routing prefers land and is intended to avoid water and
river routes.

**Does it check my endurance or other vitals?** No. There are no character vital hooks of any
kind. Speedwalk at your own discretion — the map will happily route you further than you can
walk.

**Does it open doors, pick locks, or cast unlock for me?** No. It will not interact with doors
or locks on your behalf.

Those last two are deliberate. How you deal with doors, locks and your own endurance is left to
you, because that's a play decision and not a mapping one.

**Can I add these things myself?** Yes. Nothing prevents you from forking this or modifying the
map core to track NPCs, mobs, vitals, or door handling for your own use. The map data and the
package scripts are both open — see the license below.

## Important: this depends on server room IDs

**Read this before reporting a bug.** The packages find you by asking the server which room you
are in, over GMCP. Every room here is keyed to the unique room ID the server reports, stored as
that room's hash in Mudlet. If an ID stops matching, the lookup fails.

From Nove, on how the IDs behave:

> the room IDs are stable for what they represent, if someone goes and renames everything in
> zone files they'll change but that's because then it's a new unit. It's keyed to the mud so
> VS will have a different ID on heru than the test mud etc

In practice that means:

- **The IDs are stable in normal operation.** A room keeps its ID for as long as it stays the
  same unit. Ordinary server restarts, updates and reboots do not disturb them.
- **A rebuilt or renamed zone produces new IDs.** Those rooms then have to be remapped. This is
  a server-side change and is entirely outside this project's control.
- **IDs are specific to the server instance.** The same room has a different ID on live
  ValheruMUD than on a test MUD, so the packages will not track you correctly anywhere except
  the live server they were mapped against.

**How the failure looks:** it is silent. There is no error message. The map simply stops
following you into affected rooms, and speedwalks that target them will not work. If the map
suddenly stops tracking you in one area while the rest of the world still works, a zone rebuild
is the most likely explanation — please report it so that zone can be remapped.

## If you embed the map in your own dock or panel

Some UI setups put the map inside a dock, panel or custom layout — a `Geyser.Mapper` — rather
than using Mudlet's own **Map** button. That works, but there is a trap worth knowing about
before you build around it.

**Mudlet has exactly one mapper.** The docked map widget and an embedded panel map are the same
underlying object, not two views of it. They cannot both hold it.

**Opening Mudlet's native map window takes the mapper away from your embedded panel, and does
not give it back.** Closing the native map window does not release it either — closing only
hides it. Your panel map stays blank for the rest of the session.

**Recovering it takes a full profile restart.** Reloading your UI does not help. Geyser's own
repositioning simply asks for the mapper again, that request is refused, and Geyser does not
check the answer — so nothing errors, nothing logs, and the panel just stays empty. It looks
like your UI broke when in fact the mapper was taken.

`createMapView()` is not a way around this: it opens a new floating window each time it is
called and cannot be docked.

**Practical advice: pick one and stay with it.** Either use Mudlet's native map widget, or an
embedded map in your own layout — but don't switch between them mid-session. If your panel map
has already gone blank, restart the profile.

None of this is specific to VMM; it is how Mudlet's mapper behaves with any map. It is called
out here because a blank panel is easy to mistake for a broken map package.

## How it's built

There is no hand-written HTML here. [Delwing/mudlet-map-page](https://github.com/Delwing/mudlet-map-page)
decodes the `.dat` to JSON at build time and generates the page around the
`mudlet-map-browser-script` viewer.

    .github/workflows/pages.yml   build + deploy; map path, title, credits
    maps/VMM.dat                  the map — the only file that changes routinely
    scripts/default-settings.mjs  seeds the default view settings for new visitors
    update-map.ps1                export -> commit -> push helper

The `.mpackage` releases are published as release assets rather than committed here, so the
repository stays small. The map inside VMM.mpackage is the same `maps/VMM.dat` this site renders.

Those default settings are not build options — the viewer keeps them in `localStorage` — so the
script injects them before the viewer loads, filling in only what a visitor hasn't already set.

## Credits

**Nove** and **Vega** — for implementing GMCP on ValheruMUD and exposing unique room IDs
through it. This project simply would not exist without that work: every room here is keyed to
a server-provided ID, and there was no way to build any of this before those IDs were
available. Thank you both.

Map data, configuration, package scripts and site config: **O13SC3N3 (Shinra)** —
[github.com/013SC3N3](https://github.com/013SC3N3). Please credit if you reuse or redistribute.

Built with [mudlet-map-page](https://github.com/Delwing/mudlet-map-page) and
[mudlet-map-browser-script](https://github.com/Delwing/mudlet-map-browser-script), both MIT
licensed by Piotr Wilczynski (Delwing).

## License

Licensed MIT — see [LICENSE](LICENSE).
