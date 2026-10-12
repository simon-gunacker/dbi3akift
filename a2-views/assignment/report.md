# Report: Views und Performance

## Views

**Welchen Zweck haben Views?**
Eine View ist eine gespeicherte SELECT-Abfrage mit einem Namen.
Man kann sie wie eine Tabelle benutzen, aber sie speichert keine eigenen Daten.

**Welche Vorteile haben Views?**
- Datenschutz: Die View `kunde_view` zeigt nur Kundennummer, Vorname,
  Nachname und E-Mail. Telefon, Adresse und Geburtsdatum bleiben verborgen.
- Einfachheit: Der JOIN wird nur einmal in der View geschrieben.
  Beispiel: "Welche Bestellungen von Anna Gruber sind storniert?"
  Mit der View `bestellungMitKunde` ist die Abfrage kurz,
  ohne View muss man jedes Mal den ganzen JOIN schreiben.
- Zugriffsrechte: Man kann Benutzern nur Zugriff auf die View geben.

**Welche Nachteile oder Gefahren gibt es?**
Man sieht nicht, was in der View steckt. Eine View kann sehr langsam sein,
ohne dass der Benutzer es merkt. Zwei Views können von außen gleich
aussehen, aber intern ganz unterschiedlich arbeiten.

## Performance

**Liefern beide Views dasselbe Ergebnis?**
Ja. Beide Views liefern 6279 Zeilen. Die Abfrage mit `EXCEPT`
hat keine Zeilen zurückgegeben, also sind die Ergebnisse gleich.

**Wie unterscheiden sich die Laufzeiten?**

| Abfrage | View A | View B | Faktor |
|---|---|---|---|
| `SELECT COUNT(*)` (ohne Filter) | 17,256 s | 0,028 s | ca. 600 |
| `WHERE kunde_id = 42` (n = 1000) | 0,0065 s | 0,0031 s | ca. 2 |

Ohne Filter ist View A ca. 600-mal langsamer. Mit `WHERE kunde_id = 42`
ist der Unterschied kleiner, weil SQLite den Filter in die View
übernimmt und weniger Zeilen bearbeiten muss.

**Warum ist es problematisch, dass man die Abfrage nicht sieht?**
Der Benutzer schreibt für beide Views die gleiche Abfrage und kann nicht
erkennen, dass View A viel langsamer ist. Man merkt es nur, wenn man
die Laufzeit misst.

**Was zeigt EXPLAIN QUERY PLAN?**
- View A: `CORRELATED SCALAR SUBQUERY`. Die Unterabfrage wird für
  jede Zeile neu ausgeführt.
- View B: `CO-ROUTINE letzte`. Die letzte Bestellung pro Kunde wird
  nur einmal berechnet. Für den JOIN benutzt SQLite einen
  automatischen Index (`AUTOMATIC PARTIAL COVERING INDEX`).

**Was erklärt die Laufzeiten?**
View A wiederholt die Arbeit für jede Bestellung
(ca. 10.000 × 10.000 Zeilen). View B macht die Arbeit nur einmal
und sucht dann schnell mit einem Index.

## Schlussfolgerung

Ja, eine View kann eine Abfrage vereinfachen, aber die Komplexität
verschwindet nicht. Sie ist nur versteckt. Meine Messungen zeigen das:
Beide Views werden gleich benutzt und liefern dasselbe Ergebnis,
aber View A brauchte 17 Sekunden und View B nur 0,03 Sekunden.
Deshalb sollte man bei Views auch auf die Performance achten.
