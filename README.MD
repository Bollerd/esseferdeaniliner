# Esse fer de Aniliner

Für die Nicht-Pfälzer unter uns: Bei dieser App geht es um das Essen in der Kantine der BASF. Es gibt zwar eine offizielle iOS App, diese App ist allerdings eher eine Web App als eine native iOS App. Daher habe ich  eine wesentlich kleinere  und übersichtlichere Aoo geschrieben, denn "Esse fer de Aniliner" hat gerade mal eine Größe von knapp 2 MB verglichen mit den 72 MB von "BASF Gastronomie".

Wichtig war mir ein schneller Überblick über alle Essen, die es in einer Woche in der gewählten Kantine gibt. Und nicht nur die Essen für einen einzelnen Tag. Die Bilder sind mir persönlich in der Listübersicht unwichtig und daher in meiner App Version nicht vorhanden.

## Funktionen der App

In der Listansicht sind alle für die Zukunft aktuell verfügbaren Tage und deren Essen für die gewählte Kantine angezeigt. In der Listansicht kann über das Einstellungs Icon die gewünschte Kantine gewählt werden. Es können in Listansicht auch Esen direkt anhand der wichtigsten Allergene direkt ausgefiltert werden. Es sind nicht alle Filter implementiert die möglich wären, da für uns  in der Familie nur Gluten, Soja, Süßungsmittel und (Wal-)Nüsse relevant sind.

Die Allergene sind auf der Detailseite des Essens mit der Zuordnung ihrer Bedeutung zu ihrem Text anzeigbar.

Zusätzlich hat die App eine Widget Anzeige für die gewählte Kantine am heutigen Tag. Später am Tag zeigt das Widget dann schon das Essen für den nächsten Tag an.

Außerdem hat die App eine Siri Integration. Über die Kurzbefehle App kann ein Sprachbefehl für die App erstellt werden, der dann die Speiseplaninformation entweder in einer Textbox anzeigt oder per Sprachausgabe vorliest.

## Technische Informationen

Die Daten bezieht die App von der original "BASF Gastronomie" App. Allerdings sind teilweise Informationen aus der original App in diese App kopiert und sofern sich die Informationen dort ändern würden, müsste der Code in meiner App angepasst werden. Dabei geht es zum Beispiel um die Allergene und Zusatzstoff Informationen. Deren Schlüssel wurden von mir aus der BASF App kopiert und in meiner App hinterlegt. Würden sich diese Schlüssel ändern, ist der Code bei meiner App ebenfalls anzupassen.

Die Bildanzeige ist minimal verpixelt da ich bei der App mit den Grafikfiltern von Swift experimentiert habe. Wer keine Bilder im Gameboy Stil mag, kann diesen Filter aus dem Code entfernen oder andere Filter ausprobieren. Die Filtereffekte sind in der Funktion getDishImage des struc MenuData in der Datei ConfigData. Je nach verwendetem Filter sind dann die Parameter scale, radius und/oder intensity zu setzen.

Die Siri Integration wird durch die structs SiriIntent und AppShortcuts in der Datei Model realisiert.

## Notwendige Anpassungen
Die App kann mit dem vorhandenen Code aus Github direkt 1:1 verwendet werden.

## App Screenshots

### Listübersicht
![Listübersicht](https://ios.dbweb.info/wp-content/uploads/2024/11/esse1-scaled.jpg)

### Detailanzeige
![Detail](https://ios.dbweb.info/wp-content/uploads/2024/11/esse4-scaled.jpg)

### Widget Anzeige
![Widget](https://ios.dbweb.info/wp-content/uploads/2024/11/esse3-scaled.jpg)

### Siri Integration
![Siri](https://ios.dbweb.info/wp-content/uploads/2024/11/esse5-scaled.jpg)
