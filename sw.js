// Offline support: app files (including the fonts) are cached on install.
const VERSION = "geoaffe-v37";
const APP = ["./", "data.js", "d3.min.js", "topojson.min.js", "manifest.webmanifest", "icon-192.png", "icon-512.png", "apple-touch-icon.png", "favicon-32.png", "icon-maskable-192.png", "icon-maskable-512.png", "fonts/fredoka-latin.woff2", "fonts/fredoka-latin-ext.woff2", "fonts/nunito-latin.woff2", "fonts/nunito-latin-ext.woff2", "avatars/entdecker.webp", "avatars/pilot.webp", "avatars/astronaut.webp", "avatars/pirat.webp", "avatars/koch.webp", "avatars/koenig.webp", "avatars/taucher.webp", "avatars/cowboy.webp", "avatars/wikinger.webp", "avatars/ninja.webp", "avatars/dj.webp", "avatars/skifahrer.webp", "avatars/kapitaen.webp", "avatars/detektiv.webp", "avatars/party.webp", "avatars/fussballer.webp", "avatars/maler.webp", "avatars/surfer.webp", "avatars/feuerwehr.webp", "avatars/zauberer.webp", "avatars/superheld.webp", "avatars/gamer.webp", "avatars/weihnachtsmann.webp", "avatars/rockstar.webp", "avatars/arzt.webp", "avatars/bergsteiger.webp", "avatars/tennis.webp", "avatars/bauarbeiter.webp", "avatars/gaertner.webp", "avatars/tourist.webp"];
self.addEventListener("install", e => { e.waitUntil(caches.open(VERSION).then(c => c.addAll(APP)).then(() => self.skipWaiting())); });
self.addEventListener("activate", e => {
  e.waitUntil(caches.keys().then(keys => Promise.all(keys.filter(k => k !== VERSION).map(k => caches.delete(k)))).then(() => self.clients.claim()));
});
self.addEventListener("fetch", e => {
  const url = new URL(e.request.url);
  if (e.request.method !== "GET") return;
  if (url.origin === location.origin) {
    // app files: network first so updates arrive, cache as fallback when offline
    e.respondWith(fetch(e.request).then(r => { const copy = r.clone(); caches.open(VERSION).then(c => c.put(e.request, copy)); return r; }).catch(() => caches.match(e.request).then(r => r || caches.match("./"))));
  }
});
