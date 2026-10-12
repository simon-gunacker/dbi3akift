# Report Views and Performance
Setup: SQLite DB mit 10000 Kunden, 10000 Produkte, 100000 Bestellungen, 500000 Bestellpositionen, Random Seed 43.

Beide Views letzte_bestellung_a und letzte_bestellung_b berücksichtigen identisch nur die ersten 10.000 Bestellungen (id <= 10000).
## Views

Eine View kann man als gespeicherte Abfrage sehen. Sie speichert normalerweise keine eigenen Daten, sondern greift auf die Daten aus den Tabellen zu.

Ein Vorteil ist, dass man nicht jedes Mal das ganze SELECT-Statement schreiben muss. Zum Beispiel zeigt kunde_offentlich nur Kundennummer, Vorname, Nachname und E-Mail. Geburtsdatum, Telefon und Adresse werden nicht angezeigt. Das kann für den Datenschutz sinnvoll sein.

Auch bei bestellwert ist eine View praktisch. Ohne die View müsste ich jedes Mal die Tabellen verbinden und die Berechnung SUM(menge * preis) schreiben. Mit der View ist diese Abfrage einmal definiert und kann danach einfacher verwendet werden.

Ähnlich funktioniert vereinfachte_schnittstelle. Die View verbindet bestellung und kunde und stellt die wichtigsten Informationen gemeinsam bereit. Zum Beispiel kann ich dann einfach schreiben:


SELECT * 
FROM vereinfachte_schnittstelle
WHERE bestellungstatus = 'on a break' 
AND vorname = 'Ross';


Ohne die View müsste ich dafür den JOIN mit der Kundentabelle selbst schreiben.

Ein weiterer Vorteil ist eine Art Schnittstelle zwischen den Tabellen und den Abfragen. Wenn sich die Tabellen im Hintergrund ändern, kann man unter Umständen nur die View anpassen, während die Abfragen auf die View gleich bleiben.

Views haben aber auch Nachteile. 
Sie hängen von den Tabellen und Spalten ab. Wenn eine benötigte Spalte entfernt oder geändert wird, kann die View nicht mehr funktionieren. Außerdem speichert eine normale View kein fertiges Ergebnis. Die Abfrage dahinter muss bei der Verwendung weiterhin verarbeitet werden.

Das ist besonders bei komplexen Views wichtig. Ein einfaches SELECT wie:

SELECT *
FROM letzte_bestellung_a;

kann im Hintergrund eine viel aufwendigere Abfrage ausführen. Diesen Aufwand sieht man der kurzen Abfrage nicht direkt an.

## Performance

Die Views letzte_bestellung_a und letzte_bestellung_b liefern dasselbe Ergebnis. benchmark.py vergleicht die vollständigen, sortierten Ergebnislisten beider Views: Sie sind identisch (6.334 Zeilen).

Für den Vergleich habe ich zuerst beide Views gleich abgefragt:

SELECT *
FROM letzte_bestellung_a
WHERE kunde_id = 42;

und:

SELECT *
FROM letzte_bestellung_b
WHERE kunde_id = 42;

Die Anzahl der Wiederholungen wurde so gewählt, dass jede View ungefähr 30 Sekunden gemessen wurde.

View A - letzte_bestellung_a - 0,836 ms durchschnittliche Laufzeit liefern 22.868 Wiederholungen
View B - letzte_bestellung_b - 0,544 ms durchschnittliche Laufzeit liefern 32.234 Wiederholungen

Der Faktor ist:

0,836 / 0,544 ca. 1,54

View A war bei dieser Abfrage also ungefähr 1,5-mal langsamer als View B (es war eh eine Einzelmessung und der Faktor ist nur grobe Große)

Der Unterschied ist hier relativ klein. Durch WHERE kunde_id = 42 wird nur ein bestimmter Kunde abgefragt. Bei View A muss die korrelierte Sub-Select dadurch nur für die relevanten Bestellungen ausgeführt werden.

Zusätzlich habe ich die Views ohne den Filter getestet. Diese Messung wurde direkt in der SQLite-Shell mit .timer on gemacht:

SELECT COUNT(*)
FROM letzte_bestellung_a;

und:

SELECT COUNT(*)
FROM letzte_bestellung_b;

Dabei bekam ich:

- View A: 3,281 s
- View B: 0,006 s

Das ergibt ungefähr:

3,281 / 0,006 ca. 547

View A war bei dieser zusätzlichen Messung also ungefähr 500-mal langsamer.

Diese Messung zeigt deutlich, wie stark der Filter kunde_id = 42 den Unterschied beeinflusst.

Bei View A wird die Sub-Select abhängig von den äußeren Bestellungen immer wieder ausgeführt. Da kein Index auf kunde_id vorhanden ist, kann SQLite die Suche nach dem maximalen Bestelldatum nicht direkt über einen solchen Index machen. Dadurch kann viel Arbeit wiederholt werden.

View B berechnet dagegen zuerst mit GROUP BY das maximale Bestelldatum pro Kunde und verbindet dieses Ergebnis danach mit den Bestellungen. Die Berechnung muss dadurch nicht für jede einzelne Bestellung neu gemacht werden.

## EXPLAIN QUERY PLAN mit WHERE kunde_id=42

Nach den Laufzeitmessungen habe ich mit EXPLAIN QUERY PLAN untersucht, warum sich die beiden Views unterschiedlich verhalten.

### View A

SEARCH b USING INTEGER PRIMARY KEY (rowid<?)
CORRELATED SCALAR SUBQUERY
SEARCH b2 USING INTEGER PRIMARY KEY (rowid<?)

Wichtig hier ist CORRELATED SCALAR SUBQUERY

Das bedeutet, dass die Sub-Select von der aktuellen Zeile der äußeren Abfrage abhängig ist. Sie wird deshalb für die relevanten äußeren Zeilen wiederholt ausgeführt.

Der Plan zeigt außerdem, dass kein Index auf kunde_id verwendet wird. Die Suche läuft über den Primärschlüssel der Bestellung und die entsprechenden rowid-Werte.

### View B

CO-ROUTINE letzte
SEARCH bestellung USING INTEGER PRIMARY KEY (rowid<?)
SEARCH b USING INTEGER PRIMARY KEY (rowid<?)
BLOOM FILTER ON letzte (kunde_id=?)
SEARCH letzte USING AUTOMATIC PARTIAL COVERING INDEX (kunde_id=?)

Bei View B wird das Ergebnis der Sub-Select zuerst berechnet. Dabei wird mit GROUP BY das maximale Bestelldatum für die Kunden bestimmt.

Danach wird dieses Ergebnis mit der Bestellungstabelle verbunden. SQLite verwendet dafür unter anderem einen automatisch angelegten Index.

Der wichtigste Unterschied zwischen den beiden Views ist deshalb:

- View A: Die SubSelect hängt von der äußeren Abfrage ab und wird wiederholt ausgeführt.
- View B: Die maximalen Bestelldaten werden zuerst berechnet und danach mit einem JOIN verbunden.

Das erklärt, warum View B vor allem bei einer Abfrage über viele Bestellungen deutlich schneller sein kann.

Warum ist der Faktor mit Filter klein und ohne Filter groß?

Der Unterschied kommt von der korrelierten SubSelect in View A. Sie läuft für
jede Zeile der äußeren Abfrage einmal. Wie oft das ist, hängt vom Filter ab.

Mit kunde_id = 42: SQLite wendet den Filter schon auf die äußere Abfrage an.
Nur die wenigen Bestellungen von Kunde 42 bestehen ihn, also läuft die
Sub-Select nur ca. einmal bis wenige Male, jeweils mit einem Scan über bis zu
10000 Zeilen. Dazu kommt der Scan der äußeren Abfrage. A liest also insgesamt
ca. 2 bis 3 mal 10000 Zeilen. View B liest auch ca. 2 mal 10000 Zeilen (einmal
für das MAX pro Kunde, einmal für die äußere Tabelle). Beide machen ähnlich viel
Arbeit, darum ist der Faktor nur 1,5.

Ohne Filter: besteht jede der 10000 Bestellungen die äußere Abfrage.
A führt die Sub-Select 10000 Mal aus, und weil es keinen Index auf kunde_id
gibt, liest jede Ausführung bis zu 10000 Zeilen. Das sind geschätzt ca.
10000 x 10000 = 100 Millionen gelesene Zeilen (Schätzung, keine Messung).
B berechnet das MAX pro Kunde nur einmal und verbindet das Ergebnis danach,
bleibt also bei ca. 2 mal 10000 Zeilen. Darum dauert A 3,281 s und B nur 0,006 s.

Die Arbeit von B wächst also kaum, wenn der Filter wegfällt, die Arbeit von A
wächst stark. Mit dem Filter versteckt sich dieser Unterschied, ohne Filter
sieht man ihn.

## Warum ist die Komplexität einer View problematisch?

Von außen kann eine View wie eine normale Tabelle aussehen:

SELECT *
FROM letzte_bestellung_a;

Man sieht dabei nicht sofort, wie viel Arbeit im Hintergrund passiert.

Das ist ein Problem, wenn mehrere Views ähnliche Ergebnisse liefern, aber intern unterschiedlich aufgebaut sind. Beide Views liefern bei meinem Test dasselbe Ergebnis, trotzdem gibt es einen deutlichen Unterschied bei der Laufzeit.

Mit kunde_id = 42 war View A ungefähr 1,5-mal langsamer. Ohne diesen Filter war View A bei meiner zusätzlichen Messung ungefähr 500-mal langsamer.

Wenn man nur die kurze Abfrage auf die View sieht, würde man diesen Unterschied nicht erwarten.

## Schlussfolgerung

Kann eine View eine Abfrage vereinfachen, ohne dass die zugrunde liegende Komplexität und deren Auswirkungen auf die Performance verschwinden?

Ja. Eine View nimmt Schreibarbeit ab. Man kann eine komplizierte Abfrage einmal definieren und danach einfacher verwenden. Die eigentliche Arbeit im Hintergrund verschwindet dadurch aber nicht.

Meine Messungen zeigen das deutlich. letzte_bestellung_a und letzte_bestellung_b liefern dasselbe Ergebnis, sind aber unterschiedlich schnell. Bei der Abfrage mit kunde_id = 42 war A ungefähr 1,5-mal langsamer. Ohne den Filter war der Unterschied bei meiner zusätzlichen Messung ungefähr 500-mal.

Deshalb sollte man bei Views nicht nur darauf schauen, wie einfach die Abfrage von außen aussieht. Es ist auch wichtig zu wissen, was hinter der View passiert und welche Auswirkungen das auf die Performance hat.
