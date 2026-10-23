# Spielideen (noch nicht gebaut)

Gedacht als Exklusiv-Spiele für ein Pro-Abo in Geoaffe, oder für eine neue App. Alle drei hat Gabriel ausgewählt.

## Hangman: Länder und Hauptstädte

- Gesucht: ein Land oder eine Hauptstadt. Buchstaben über eine Bildschirmtastatur raten.
- Statt Galgen: eine Banane, die bei jedem Fehler Stück für Stück aufgegessen wird (passt zum Affen).
- Hinweis: der Kontinent, bei Hauptstädten das Land.
- Punkte: je weniger Fehler, desto mehr. Täglich für alle gleich, mehrere Level.

## Hauptstadt-Sprint

- 60 Sekunden auf der Uhr. Ein Land nach dem anderen wird gezeigt (Name, evtl. Flagge), die Hauptstadt eintippen.
- Vorschläge beim Tippen wie beim Grenzgänger, Enter nimmt den ersten Vorschlag.
- Jede richtige Antwort gibt Punkte, Überspringen kostet ein paar Sekunden.
- Danach eine Übersicht: richtig, falsch, übersprungen.

## Geo-Wordle

- Gesucht: ein Land, für alle gleich. 6 Versuche.
- Nach jedem falschen Tipp: Entfernung in km, Richtungspfeil (⬆️ ↗️ ➡️ …) und Nähe-Balken (rot = weit, grün = nah).
- Kleine Karte, auf der die getippten Länder farbig markiert werden.
- Beispiel (gesucht Ungarn): Spanien 1.950 km ➡️ · Deutschland 830 km ↘️ · Polen 560 km ⬇️ · Ungarn 🎉
- Punkte: je weniger Versuche, desto mehr. Ergebnis als Emoji-Reihe teilbar.

## Bausteine, die es in Geoaffe schon gibt

Länderdaten mit Nachbarn und Koordinaten, Städte, Flaggen, Weltkarte (`data.js`), Entfernungsberechnung (`hav` in `index.html`), Eingabe mit Vorschlägen (Grenzgänger), Tagesrätsel für alle gleich (`hashSeed`), Punkte-Logik, Joker, Rangliste.
