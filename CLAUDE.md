# Geoaffe

Tägliche Geografie-Spiele (wie Wordle): 6 Spiele à 5 Level, je Level bis 100 Punkte (500 pro Spiel, 3.000 pro Tag). Für alle gleich, neu ab Mitternacht. Eigentümer: Gabriel – **kein Entwickler**.

## Zusammenarbeit mit Gabriel

- Antworten auf **Deutsch**, einfach und ohne Fachjargon. Klick-Anleitungen Schritt für Schritt.
- Vor größeren Design-Änderungen **Screenshots zeigen** (Playwright + Chromium unter `/opt/pw-browsers/chromium`), kleine, klar gewünschte Änderungen direkt umsetzen.
- Ehrlich sagen, was nicht geht oder nicht getestet ist.
- Nie zwei Claude-Sitzungen gleichzeitig auf GitHub hochladen lassen. Die Mac-Sitzung baut nur die iPhone-App und pusht nicht.

## Aufbau

- `index.html`: die ganze App (CSS, Spiele, Screens) in einer Datei, kein Build-Schritt. `data.js`: Städte, Länder, Nachbarn, Flaggen, Weltkarte (sehr groß, nur gezielt lesen).
- Spiele (`GAMES` in index.html): Nadelwurf `pin`, Grenzgänger `border`, Flaggen-Mix `flag`, Kompass `nord`, Umriss `shape`, Flächenduell `size`.
- Spielstand nur im Browser (`localStorage`, Schlüssel `kompass-v1`): Punkte, Bananen-Joker, Einstellungen, Avatar.
- Freunde & Ranglisten (freiwillig): Supabase, Projekt `fienrzyyzmontvwudaqj` (Frankfurt), anonyme Anmeldung. Datenbank + Regeln in `supabase/schema.sql`. In der App steht nur der öffentliche publishable Key.
- Avatare: 30 Bilder in `avatars/*.webp` (640 px, Kopf mittig im Kreis). Neue Bilder: Gabriel lässt ChatGPT ein Raster erzeugen, Claude schneidet aus, skaliert per Real-ESRGAN (Anime-Modell) hoch und richtet aus.
- `sw.js`: Offline-Speicher. **Bei jeder Änderung `VERSION` hochzählen**, neue Dateien in die Liste `APP` aufnehmen.

## Veröffentlichen

- **Web:** Push auf `main` → Cloudflare Workers veröffentlicht automatisch (ca. 1 Min.) auf https://geoaffe.gabrielmaz1602.workers.dev. Was nicht veröffentlicht wird, steht in `.assetsignore`.
- Netlify (geoaffe.netlify.app) ist stillgelegt (GitHub-App suspendiert), bleibt auf altem Stand. Nicht mehr nutzen.
- **iPhone-App:** Capacitor 8, Projekt in `ios/`, Bundle-ID `com.gabrielmaz.geoaffe`, Team `S4SQRCH29W`. Die App enthält eine feste Kopie der Web-App – Updates nur über `npm run ios` + Xcode ▶ auf Gabriels Mac (siehe `IOS-ANLEITUNG.md`). In der App: Vibration (Haptics), Statusleiste, kein Service Worker.

## Design-Entscheidungen (von Gabriel)

- Verspielt & bunt, Stil ähnlich GeoTrivia, aber eigenständig (Affe als Maskottchen). Schriften Fredoka + Nunito, lokal in `fonts/` (keine Google-Anfragen).
- Startet immer im **hellen Modus**. Dunkel = Schwarz/Grau (nicht Blau), nur wenn gewählt.
- Startseite: kräftige Kacheln mit großem Icon und Name, ohne Beschreibung. Fertige Spiele pastell-gestreift mit Haken und Sternen.
- Spielerklärung nur als Pop-up beim ersten Öffnen (später über „?“). Keine Erklärtexte im Spiel.
- Tab-Leiste: Spielen, Freunde, Einstellungen. Avatar-Auswahl in 3er-Reihen.

## Offene Punkte

- Name + Kontaktadresse für Datenschutz („Verantwortlich: Angaben folgen“) und Impressum fehlen noch.
- „Heute neu spielen“ vor dem Store-Launch verstecken.
- Für den App Store: Entwicklerkonto (99 €/Jahr), Push-Benachrichtigungen, Abo (RevenueCat) + Werbung (AdMob), Offline nur für Pro, Exklusiv-Spiele für Pro, Store-Screenshots.
- Spielideen für Pro (Hangman, Hauptstadt-Sprint, Geo-Wordle): siehe `IDEEN.md`.
- **Android später (Gabriel: im Hinterkopf behalten):** Capacitor-Android-Projekt dazulegen, Google Play 25 $ einmalig; neue private Konten brauchen 14 Tage Test mit 12 Testern – früh einplanen. RevenueCat/AdMob/Supabase funktionieren auch dort.
- Name „Geoaffe“ auf Markenrechte prüfen. Schummelschutz für die Welt-Rangliste, falls nötig.
