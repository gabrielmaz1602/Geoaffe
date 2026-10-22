// Copies the web app (the files GitHub/Cloudflare serve) into www/, which Capacitor packs into the iOS app.
import { cpSync, rmSync, mkdirSync } from "node:fs";
const files = ["index.html", "data.js", "d3.min.js", "topojson.min.js", "sw.js", "manifest.webmanifest",
  "icon-192.png", "icon-512.png", "apple-touch-icon.png", "favicon-32.png", "fonts", "avatars"];
rmSync("www", { recursive: true, force: true });
mkdirSync("www");
for (const f of files) cpSync(f, `www/${f}`, { recursive: true });
console.log(`www/ bereit (${files.length} Einträge)`);
