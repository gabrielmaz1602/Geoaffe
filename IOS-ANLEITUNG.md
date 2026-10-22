# Geoaffe auf dein iPhone bringen

Einmalig ca. 20–30 Minuten. Danach dauert jedes Update nur noch 2 Minuten (siehe ganz unten).

## 1. Node.js installieren (falls `node -v` „command not found“ zeigt)

1. **nodejs.org** öffnen und die **LTS-Version** für macOS herunterladen.
2. Die `.pkg`-Datei öffnen und durchklicken.
3. Terminal schließen und neu öffnen (Cmd + Leertaste → „Terminal“), dann `node -v` eingeben. Jetzt sollte eine Versionsnummer erscheinen.

## 2. Das Projekt auf deinen Mac holen

Im Terminal nacheinander eingeben (jeweils Enter):

```
cd ~/Desktop
git clone https://github.com/gabrielmaz1602/Geoaffe.git
cd Geoaffe
```

Falls macOS fragt, ob die „Command Line Developer Tools“ installiert werden sollen: **Installieren** klicken, warten, dann den `git clone`-Befehl nochmal eingeben.

Jetzt liegt auf deinem Schreibtisch ein Ordner **Geoaffe**.

## 3. App bauen und in Xcode öffnen

Im selben Terminal-Fenster:

```
npm install
npm run ios
```

Das baut die App und öffnet Xcode automatisch. Beim ersten Mal lädt Xcode noch kurz Pakete (unten in der Leiste steht „Resolving Packages“), einfach warten.

## 4. In Xcode mit deiner Apple-ID anmelden

1. Oben in der Menüleiste: **Xcode → Settings… → Accounts** → unten links **+** → **Apple ID** → mit deiner normalen Apple-ID anmelden. Fenster schließen.
2. Links in der Seitenleiste ganz oben auf **App** (blaues Symbol) klicken.
3. In der Mitte unter **TARGETS** auf **App** klicken, dann oben den Reiter **Signing & Capabilities**.
4. Haken bei **Automatically manage signing** setzen.
5. Bei **Team** deinen Namen auswählen (z. B. „Gabriel … (Personal Team)“).
6. Falls ein roter Fehler zur **Bundle Identifier** erscheint: hinten an `com.gabrielmaz.geoaffe` z. B. `2` anhängen.

## 5. iPhone vorbereiten

1. iPhone per Kabel an den Mac anschließen, auf dem iPhone **„Vertrauen“** tippen und Code eingeben.
2. Auf dem iPhone: **Einstellungen → Datenschutz & Sicherheit → Entwicklermodus** einschalten. Das iPhone startet neu, danach „Einschalten“ bestätigen.
   (Der Punkt erscheint erst, nachdem das iPhone einmal mit Xcode verbunden war.)

## 6. Starten

1. Oben in der Mitte von Xcode, neben „App“, auf die Geräteauswahl klicken und **dein iPhone** wählen.
2. Oben links auf den **▶ Play-Knopf** klicken (oder Cmd + R).
3. Beim ersten Mal kommt auf dem iPhone „Nicht vertrauenswürdiger Entwickler“:
   **Einstellungen → Allgemein → VPN & Geräteverwaltung** → deine Apple-ID antippen → **Vertrauen**.
4. Nochmal ▶ in Xcode klicken. Geoaffe startet auf deinem iPhone.

**Hinweis:** Mit einer kostenlosen Apple-ID läuft die App 7 Tage, danach einfach in Xcode nochmal ▶ drücken. Mit dem Entwicklerkonto (99 €/Jahr) fällt das weg.

## Updates holen (wenn Claude etwas geändert hat)

Im Terminal:

```
cd ~/Desktop/Geoaffe
git pull
npm run ios
```

Dann in Xcode ▶ drücken.

## Wenn etwas nicht klappt

Screenshot vom Terminal oder von Xcode (die rote Fehlermeldung) an Claude schicken.
