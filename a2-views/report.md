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

---
## Performance
**Funktion von timeit**
´´´python
    import timeit
    laufzeit = timeit.timeit(stmt=..., number=100)
´´´
- **stmt** (Statement): Den Code, den ich messen will. Das kann ein String-Befehl sein oder am einfachsten eine lambda-Funktion bzw. eine Funktion ohne Argumente.
- **number**: Wie oft der Code ausgeführt werden soll (Standard ist $1.000.000$).
- **Rückgabewert**: Die Gesamtlaufzeit in Sekunden für alle number-Durchläufe zusammen.

**Performance mit LIMIT**
- Starte Benchmark für kunde_id = 42
- Wiederholungen = 50000...
- View A - Gesamt: 61.7019s | Schnitt pro Aufruf: 0.001234s
- View B - Gesamt: 61.7661s | Schnitt pro Aufruf: 0.001235s
- Der Test hat: 123.4693 Sekunden gebraucht.

**Performance ohne LIMIT**
- Starte Benchmark für kunde_id = 42
- Wiederholungen = 100...
- View A - Gesamt: 4.8780s | Schnitt pro Aufruf: 0.048780s
- View B - Gesamt: 0.7519s | Schnitt pro Aufruf: 0.007519s
- Der Test hat: 5.63 Sekunden gebraucht.

---
## Nachteile von Views
- Versteckte Komplexität
- Keine eigenen Indizes
- Write-Einschränkungen (read-only => kein insert)

---
## Query plan
- Bestellung A
´´´sql 
EXPLAIN QUERY PLAN 
SELECT * FROM letzte_bestellung_a WHERE kunde_id = 42;
QUERY PLAN
|--SCAN b
`--CORRELATED SCALAR SUBQUERY 3
   `--SEARCH b2
´´´
    - **CORRELATED SCALAR SUBQUERY**: Das ist das Hauptproblem. Das Wort "CORRELATED" bedeutet, dass die Subquery für jede einzelne Zeile der äußeren Tabelle neu ausgeführt werden muss.

- Bestellung B
´´´sql
    EXPLAIN QUERY PLAN 
    SELECT * FROM letzte_bestellung_b WHERE kunde_id = 42;
    QUERY PLAN
    |--CO-ROUTINE letzte
    |  `--SCAN bestellung
    |--SCAN b
    |--BLOOM FILTER ON letzte (kunde_id=?)
    `--SEARCH letzte USING AUTOMATIC PARTIAL COVERING INDEX (kunde_id=?)
´´´

