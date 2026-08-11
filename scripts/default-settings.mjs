// Seeds default viewer settings for first-time visitors.
// Author: O13SC3N3 (Shinra) — https://github.com/013SC3N3
//
// These are UI state the bundle keeps in localStorage, not MAP_CONFIG options, so this
// injects them before the bundle loads. Only fills keys a visitor hasn't already set.
const DEFAULTS = {
    uniformLevelSize: true, // Uniform area level size
    keepZoomLevel: true, // Keep zoom level
    roomShape: "circle", // Circle location shape
    emboss: true, // Emboss locations
    gridEnabled: true, // Grid
    areaExitLabelFontSize: 0.5 // Area exit label size
};

const SNIPPET = `        <script>
            (function () {
                var d = ${JSON.stringify(DEFAULTS)};
                var s = {};
                try { s = JSON.parse(localStorage.getItem("settings")) || {}; } catch (e) { s = {}; }
                var changed = false;
                for (var k in d) { if (s[k] === undefined) { s[k] = d[k]; changed = true; } }
                if (changed) { try { localStorage.setItem("settings", JSON.stringify(s)); } catch (e) {} }
            })();
        </script>
`;

// Must run before the bundle's own script tag, or it has already read localStorage.
const BUNDLE_TAG = /^.*<script src="[^"]*index\.min\.js"><\/script>.*$/m;

export default function (html) {
    if (!BUNDLE_TAG.test(html)) {
        throw new Error("default-settings: bundle <script src> not found — the generated page shape changed.");
    }
    return html.replace(BUNDLE_TAG, (tag) => SNIPPET + tag);
}
