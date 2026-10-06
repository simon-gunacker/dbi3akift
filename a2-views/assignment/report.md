# Fragen und Antworten: Views und Performance

## Views
---
### Welchen Zweck haben Views?

Sie definieren eine feste Abfrage als virtuelle Tabelle. Sie bieten Zugriffskontrolle, Vereinfachung komplexer Abfragen, Wartbarkeit und Konsistenz.

---

### Welche Vorteile bieten Views gegenüber dem direkten Zugriff auf Tabellen?

Zugriffskontrolle: Sensible Daten können ausgeblendet werden.
Vereinfachung komplizierter Abfragen in dem sie nur einmal geschrieben werden müssen.

Wartbarkeit: Bei Änderungen in der Datenbank kann die Logik der View angepasst werden ohne das Code anderweitig umgeschrieben werden muss. 

Konsistenz: Komplexe Berechnungen können in einer View zusammengefasst werden,dadurch kann sichergestellt werden, dass allen Anwendungen exakt die selbe Logik zugrunde liegt.

---

### Welche Nachteile bzw. Gefahren können entstehen?

Performance(„Black Box“-Effekt"):Die innere Logik ist nicht sichtbar,sodass nicht ersichtlich ist wieviel Rechnleistung nötig ist.

Erschwerte Fehlersuche und Wartung:Man sieht nur den Aufruf der View und musss die zugrundeliegende SQL-Definition separat auslesen

Kettenabhängigkeiten („Dependency Hell“):Wenn Views auf anderen Views aufbauen können Änderungen andere Views unbrauchbar machen.

Einschränkungen bei Schreiboperationen:In z.B: SQLite sind Views standardmäßig read-only, sobald sie eine gewisse Komplexität überschreiten.

---
---
## Performance
---
### Liefern die beiden Views tatsächlich dasselbe Ergebnis?

Ja: 
```sql
SELECT *
FROM letzte_bestellung_a
WHERE kunde_id = 42;
WHERE kunde_id = 42;
```
```text
--> 42|5212|2026-07-17 06:53:10
```
```sql
SELECT *
FROM letzte_bestellung_b
WHERE kunde_id = 42;
```
```text
-->42|5212|2026-07-17 06:53:10
```

---

### Wie unterscheiden sich die gemessenen Laufzeiten?

View A benötigt bei 1000 Aufrufen  rund 93,43 Sekunden (ca. 1:33 min)
und bei 10.000 Aufrufen  rund 950,11 Sekunden (ca. 15:50 min)

View B benötigt bei 1.000 Aufrufen rund 10,21 Sekunden 
und bei 10.000 Aufrufen rund 107,19 Sekunden(ca. 1:47 min)

---

### Warum ist es problematisch, dass die interne SQL-Abfrage einer View bei der Verwendung nicht unmittelbar sichtbar ist?

Die Performance ist nicht abzuschätzen, die Fehlersuche ist erschwert und es können versteckte Abhängigkeiten entstehen.

---

### Was zeigt EXPLAIN QUERY PLAN über die beiden Abfragen?

```text
QUERY PLAN
|--SCAN b   
`--CORRELATED SCALAR SUBQUERY 3    
   `--SEARCH b2
```
SCAN -> Es wird  ein Full Table Scan der Tabelle b durchgeführt. 
CORRELATED SCALAR SUBQUERY 3 ->
Scalar -> ein Wert wird zurückgegeben 
Correlated Subquery -> die Werte ändern sich in abhängikeit der aktuellen zeile der äuseren Abfrage
Search->sagt das nur ein subset von Tabellen Zeilen gesucht wird.
```text
 QUERY PLAN
|--CO-ROUTINE letzte
|  `--SCAN bestellung  
|--SCAN b 
|--BLOOM FILTER ON letzte (kunde_id=?)  
`--SEARCH letzte USING AUTOMATIC PARTIAL COVERING INDEX (kunde_id=?) 
```
SQLite lagert die Unterabfrage in eine temporäre  Co-Routine aus und scannt dafür die Tabelle bestellung.Danch wird dieTabelle b eingelesen.Der Bloomfilter,(" eine probabilistische* Datenstruktur, mit deren Hilfe sehr schnell festgestellt werden kann, welche Daten in einem Datenstrom schon einmal vorgekommen sind und welche erstmals auftreten**)schließt nicht vorhanden Kunden-IDs aus
Die letzte Zeile nützt zur Suche  einen kurzzeitig erstellten Index im RAM.

  


---

### Welche Unterschiede in der Verarbeitung erklären die gemessenen Laufzeiten?

Variante A sucht zeile für zeile während Variante B einen durch den Optimizer (siehe: https://de.wikipedia.org/w/index.php?title=Abfrageoptimierer&oldid=267843644)erstellten Index benutzt und damit deutlich schneller ist.

---

*auch: Wahrscheinlichkeitsaussage

**https://de.wikipedia.org/w/index.php?title=Bloomfilter&oldid=260174336
