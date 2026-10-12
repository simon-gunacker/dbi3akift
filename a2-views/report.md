# Protokoll Binderbauer

### Was sind Views?

Views speichern die eigenen Dateien nicht, sie zeigen nur Daten aus bestehenden Tabellen in einer Form an und können jederzeit wieder aufgerufen werden.

Ihr Vorteile sind:

- sie vereinfachen komplexe SQL-Abfragen
- sind wiederverwendbar
- verbessern Übersichtlichkeit
- können sich nur auf gewissen Daten beziehen (Datenschutz)

Ihre Nachteile sind:

- bei komplexen Abfragen leidet die Performance
- können veraltete Annahmen haben und den Output verfälschen

### Aufgabe 6:

#### Liefern sie dasselbe Ergebnis?

Ja beide suchen nach dem selben Ergebnis.
Variante A verwendet eine Unterabfrage um das maximale Bestelldatum zu finden.

Variante B benutzt einen JOIN, dabei berechnet sie zuerst das maximale BEstelldatum und verbindet diese später mit der "bestellung" Tabelle

#### Warum ist es problematisch dass die interne SQL-Abfrage einer View bei der Verwendung nicht unmittelbar sichtbar ist?

Man kann beim Aufruf der View nicht erkennen was dort im Hintergrund für Berechnungen laufen. Das kann zu langen Laufzeiten führen, auch bei scheinbar simplen Abfragen.

> SELECT * FROM letzte_bestellung_b EXCEPT SELECT * FROM letzte_bestellung_a;

**Run Time: real 3.690 user 3.689192 sys 0.003131**

> SELECT * FROM letzte_bestellung_a EXCEPT SELECT * FROM letzte_bestellung_b;

**Run Time: real 3.692 user 3.690387 sys 0.003330**




Ziel war es 2 identisch-semantische SQL-Abfragen zu vergleichen.
Ich habe dabei ein python-skript erstellen müssen, welches 
beide Abfragen wiederholt aufruft und vergleicht.

Für die bestimmte Abfrage kunde_id = 42; habe ich 200 durchläufe durchführen lassen.
Das war die Zeit:

> Time for query a: 0.004396332010001061 seconds
>
> Time for query b: 0.0006849902600015411 seconds

Der "Time Faktor" zeigt time a / time b an. Dabei sieht man den unterschied zwischen der geschwindigkeit von time a und b. 

Hier ist zu sehen dass der unterschied ungefähr das 6-fache beträgt
-> Time Faktor: **6.4 seconds**

Als nächstes habe ich alle kunden_ids durchlaufen lassen. Das erstmals nur 3 mal da dieser Befehl länger dauert.

> Time for query all a: 3.630594634333344 seconds
>
>Time for query all b: 0.005131592999835751 seconds
>
>Time Faktor: **707.5 seconds**

Bei einem Wiederholung von 20 brauchte es schon sehr lange durch die Datenbank zu iterrieren. 

>Time for query all a: 4.999942860949977 seconds
>
>Time for query all b: 0.0062616535499728345 seconds
>
>Time Faktor: **798.5 seconds**

Es ist deutlich zu erkennen: je größer die Datenmengen sind, desdo größer wird der Faktor zwischen a und b. A steigt um einiges, b bleibt bei größeren Mengen stabiler.

#### QUERY PLAN

Mit EXPLAIN QUERY PLAN hab ich beide Varianten a und b wieder verglichen.

---

Das war der Output bei A:

> QUERY PLAN <br>
> |--SEARCH b USING INTEGER PRIMARY KEY (rowid<?) <br>
> `--CORRELATED SCALAR SUBQUERY 1  
>   `--SEARCH b2 USING INTEGER PRIMARY KEY (rowid<?) <br>

---

Das war der Output bei b:

> QUERY PLAN
> |--CO-ROUTINE letzte
> |  |--SEARCH bestellung USING INTEGER PRIMARY KEY (rowid<?)
> |  `--USE TEMP B-TREE FOR GROUP BY
> |--SEARCH b USING INTEGER PRIMARY KEY (rowid<?)
> |--BLOOM FILTER ON letzte (kunde_id=?)
> `--SEARCH letzte USING AUTOMATIC COVERING INDEX (kunde_id=?)

#### Was ich rausfinden konnte (hilfe von GPT-6)

**Variante A:** Verwendet eine korrelierte Unterabfrage (CORRELATED SCALAR SUBQUERY 1). Diese UNterabfrage hängt von der Aüßeren ab. 

**Variante B:** SQLite verarbeitet als erstes die Unterabfrage als CO-ROUTINE. Dabei werden die Bestellungen über GROUP BY gruppiert und in eine temporäre B-Tree-Struktur eingefügt. Zuletzt sicht SQLite die passenden Datensätze in b und verwendet einen automatischen Index für die Verknüpfung mit letzte. 