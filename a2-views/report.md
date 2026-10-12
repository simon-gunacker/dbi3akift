## Datenbank erstellen und mit Testdaten befüllen
1. Produkt Tabelle befüllen mit 10_000 Produkten. Meine Idee viele Produkte zu erstellen mit der Wortendung auf Zeug. Mit dem random von python.
2. Einen Kunden erstellen. Diese ID mir ausgeben und auf dieser id eine bestellung erstellen. 
3. Zu den einen Kunden eine Bestellung erstellen. Diese bestellung bekommt dann ein Datum und einen random status. Diese bestell id lasse ich mir ausgeben und übergebe sie an bestellposition.
4. In der Bestellposition insert ich die bestellung_id was ich übergeben habe. Dann lasse ich zufällig entscheiden wie viele produkte der kunde gekauft hat. Dann wird ein produkt zufällig ausgeben und dazu zufällig menge Und das so oft bis der kunde keine Produkte mehr auf dieser bestellung gekauft hat. 
---

## Namensgenerierung JSON
- Überlegung wie bekomme ich zufällige Vornamen zusammen ohne libary. Meine Idee Konsonaten und Vokale in die JSON zu speichern und dann immer paar zu bilden. zb K + V + K + V -> 4 Buchstaben => Lina, Niko, Karo Das nennt man in der Sprachwissenschaft eine offene Silbe.
- Bei Deutsche Nachnamen bestehen fast immer aus einem Stamm/Wort + einer typischen Endung.
- Adressen enden auch alle in einem Schema.

---
## View erstellen
- Eine View ist eine *gespeicherte SQL-Abfrage*, die sich nach außen hin verhält wie eine virtuelle Tabelle sie speichert selbst aber **keine eigenen Daten**.
- Jedes Mal, wenn ich *SELECT * FROM view_name;* aufrufe, führt die Datenbank im Hintergrund live das definierte SELECT-Statement auf den echten Tabellen aus.
**Überlegung**
1. Datenschutz: Wenn ich einen Mitarbeiter rechte gebe Views zu nutzen kann ich das mit den Views eingrenzen was er sehen kann.
2. Vereinfachung: Bei großen Selects mit vielen Joins oder viele subselects können die selects mit view sehr klein werden.
**Schnittstelle**
- Mit so einem View muss ich nicht wissen wie die Tabelle zusammenhängen. So kann ich ganz einfach die Abfrage erweitern.
- Spart auch Zeilen, macht den Select übersichtlicher

## Nachteile von Views
- Versteckte Komplexität, kann gleich ausschauen aber sehr ineffizient sein (laufzeit).
- Keine eigenen Indizes
- Write-Einschränkungen (read-only => kein insert)

---
## Performance
**Funktion von timeit**
```python
    import timeit
    laufzeit = timeit.timeit(stmt=..., number=100)
```
- **stmt** (Statement): Den Code, den ich messen will. Das kann ein String-Befehl sein oder am einfachsten eine lambda-Funktion bzw. eine Funktion ohne Argumente.
- **number**: Wie oft der Code ausgeführt werden soll (Standard ist $1.000.000$).
- **Rückgabewert**: Die Gesamtlaufzeit in Sekunden für alle number-Durchläufe zusammen.

Die beiden Views `letzte_bestellung_a` und `letzte_bestellung_b` sollen dasselbe liefern. Das habe ich mit `EXCEPT` in beide Richtungen geprüft: Beide Ergebnisse waren leer, also liefern sie dasselbe. (Gezeigt in benchmark.py)

Die Einschränkung auf die ersten 10.000 Bestellungen steht im `SELECT` des Benchmarks:
```sql
SELECT * FROM letzte_bestellung_a WHERE kunde_id = 42 AND bestellung_id <= 10000;
```

**Ergebnis**
```
View A - Gesamt: 4.7786s | Schnitt pro Aufruf: 0.047786s
View B - Gesamt: 0.4780s | Schnitt pro Aufruf: 0.004780s
Sind die Ausgaben vom Performance check identisch: True
Der Test hat: 77.88 Sekunden gebraucht.
```

- **Faktor ≈ 10**: Variante A ist etwa zehnmal langsamer als Variante B.
Von außen sehen die Abfragen identisch aus und liefern dasselbe Ergebnis. Der Unterschied zeigt sich nur an der Laufzeit.
- **Unterschied**: A führt die Teilabfrage pro Zeile neu aus und durchsucht dabei die Tabelle ohne Index. B aggregiert nur einmal und nutzt einen automatischen Index.

---
## Query Plan
**Variante A**
```
EXPLAIN QUERY PLAN SELECT * FROM letzte_bestellung_a WHERE kunde_id = 42 AND bestellung_id <= 10000;
|--SEARCH b USING INTEGER PRIMARY KEY (rowid<?)
`--CORRELATED SCALAR SUBQUERY 3
   `--SEARCH b2
```
- *CORRELATED SCALAR SUBQUERY*: Die Subquery hängt von der äußeren Zeile ab und läuft deshalb für jede Zeile neu. Bei `SEARCH b2` steht kein `USING …`, die Subquery nutzt also keinen Index auf `kunde_id`.

**Variante B**
```
EXPLAIN QUERY PLAN SELECT * FROM letzte_bestellung_b WHERE kunde_id = 42 AND bestellung_id <= 10000;
|--CO-ROUTINE letzte
|  `--SCAN bestellung
|--SEARCH b USING INTEGER PRIMARY KEY (rowid<?)
|--BLOOM FILTER ON letzte (kunde_id=?)
`--SEARCH letzte USING AUTOMATIC PARTIAL COVERING INDEX (kunde_id=?)
```
- Die Aggregation (`MAX` je Kunde) läuft **einmal** (`CO-ROUTINE letzte`). SQLite legt für dieses Zwischenergebnis selbst einen Index an (`AUTOMATIC PARTIAL COVERING INDEX`). Der `BLOOM FILTER` sortiert Nichttreffer schnell aus.

## Schlussfolgerung
Nein. Eine View vereinfacht nur das Schreiben der Abfrage, die Komplexität bleibt bestehen. Bei meinen Messungen war die View mit (A) etwa zehnmal langsamer als die mit dem Join (B), obwohl `SELECT` und Ergebnis identisch sind. **Wer Views benutzt, muss deshalb ihre Definition und ihren Query Plan kennen.**