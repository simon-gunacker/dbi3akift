## Views
 
**1. Zweck von Views:**
Ein View ist eine virtuelle Tabelle. Er zeigt Daten aus einer oder mehreren Tabellen an, sodass man sie einfacher ansehen und verwenden kann.
 
**2. Vorteile von Views:**
- Man kann wichtige Daten schneller abrufen
- Man kann nur bestimmte Daten anzeigen und so sensible Informationen schützen
- Man muss nicht jedes Mal eine komplizierte Abfrage neu schreiben
- Die eigentlichen Tabellen bleiben im Hintergrund
**3. Nachteile bzw. Gefahren von Views:**
- Ein View kann langsam sein, wenn die Abfrage dahinter kompliziert ist
- Ändern sich die zugrunde liegenden Tabellen, kann der View nicht mehr funktionieren
- Bei falsch eingestellten Berechtigungen können Personen Daten sehen, die sie nicht sehen sollten

## Performance
 
**4. Liefern die beiden Views tatsächlich dasselbe Ergebnis?**
Ja, ich habe es mit einem Python-Skript verglichen.
 
**5. Kann man von außen erkennen, dass die beiden Views intern unterschiedlich effizient umgesetzt sind?**
Nein, am `SELECT`-Statement sieht man keinen Unterschied, beide sind gleich aufgebaut. Nur die gemessene Laufzeit zeigt, dass intern etwas anders läuft.
 
**6. Wie unterscheiden sich die gemessenen Laufzeiten?**
Durchschnittlich 0,0365 Sekunden bei Variante A, 0,0077 Sekunden bei Variante B. A ist also ca. 4,75-mal langsamer.
 
**7. Warum ist es problematisch, dass die interne SQL-Abfrage einer View nicht sichtbar ist?**
Weil eine scheinbar einfache Abfrage in Wirklichkeit sehr teuer sein kann. Das macht es schwer, Performance-Probleme vorherzusehen, weil die Komplexität nicht im Code sichtbar ist, sondern in der View versteckt bleibt.
 
**8. Was zeigt EXPLAIN QUERY PLAN über die beiden Abfragen?**
Bei Variante A läuft eine `CORRELATED SCALAR SUBQUERY`, die für jede Zeile erneut ausgeführt wird und nochmal in `bestellung` sucht (`SEARCH b2`). Bei Variante B läuft eine `CO-ROUTINE`, die das Gruppierungsergebnis einmal vorab berechnet, dazu ein automatisch erstellter Index und ein Bloom-Filter für den Join. Der Plan zeigt also, was man dem SQL-Statement nicht ansieht: A wiederholt die Subquery, B rechnet nur einmal mit Indexunterstützung.
 
**9. Welche Unterschiede in der Verarbeitung erklären die gemessenen Laufzeiten?**
Variante A wiederholt die Suche nach dem spätesten Datum für jede Bestellung einzeln, der Aufwand wächst also mit jeder Bestellung mit. Variante B berechnet das Ergebnis einmal für alle Kunden und schlägt es danach nur nach. Dieser Unterschied im Skalierungsverhalten erklärt den gemessenen Faktor.
 
## Schlussfolgerung
 
**10. Kann eine View eine Abfrage vereinfachen, ohne dass dadurch die zugrunde liegende Komplexität und deren mögliche Auswirkungen auf die Performance verschwinden?**
Nein, eine View vereinfacht nur die Schreibweise, nicht die Arbeit dahinter. Obwohl beide Views gleich verwendet werden, unterscheidet sich ihre Laufzeit um den Faktor 4,79. Die Komplexität verschwindet also nicht, sie wird nur unsichtbar, kann aber trotzdem die Performance stark beeinflussen.
