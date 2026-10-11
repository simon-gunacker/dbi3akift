# Report: Views und Performance

## Views

**Zweck:** Eine View ist eine gespeicherte Abfrage, die man wie eine Tabelle verwenden kann. Die Daten werden dabei nicht kopiert, sondern bei jedem Zugriff neu berechnet.

**Vorteile:**

- Eine Abfrage kann schnell aus verschiedenen Perspektiven betrachtet werden, z. B. `SELECT * FROM order_overview WHERE bestellstatus = 'offen';`, ohne den Join jedes Mal neu zu schreiben.
- Reports lassen sich in einer Firma oder Abteilung einfach teilen: View anlegen und „Mach mal ein Select darauf!“.
- Erkenntnisse werden festgehalten. Braucht man später eine Verfeinerung, passt man die View an und alle Nutzer profitieren davon.
- Zugriffsschutz: `basic_data` zeigt nur Kundennummer, Name und E-Mail. Geburtsdatum, Telefon und Adresse bleiben verborgen.
- Weiterer Schutz: Man muss dem Betrachter nicht direkten Zugriff auf die Tabellen geben.

**Nachteile/Gefahren:**

- Die Komplexität der Abfrage ist von außen nicht sichtbar. Zwei Views können gleich aussehen, aber völlig unterschiedlich aufwendig sein.
- Ein Filter von außen wird nicht immer in die View übernommen (z. B. bei `LIMIT` in der View), dann wird trotzdem alles berechnet.
- Eine Änderung an der View wirkt sich auf alle Nutzer aus, auch wenn die das nicht mitbekommen.

## Performance

**Liefern beide Views dasselbe?** Ja. Beide liefern 9999 Zeilen, ein Abgleich mit `EXCEPT` in beide Richtungen ergibt keine Unterschiede. Es sind 9999 statt 10.000 Zeilen, weil ein Kunde keine Bestellung hat. Das `LIMIT 10000` schneidet bei diesen Daten nichts ab, der Vergleich ist also fair.

**Laufzeiten** (`SELECT * FROM ... WHERE kunde_id = 42`, gemessen mit `timeit`):

| View | Durchläufe | Zeit pro Abfrage |
|---|--:|--:|
| `letzte_bestellung_a` | 3 | 433,66 s (ca. 7,2 min) |
| `letzte_bestellung_b` | 1000 | 0,068 s |

View A ist ungefähr **6384-mal langsamer** als View B, obwohl beide gleich abgefragt werden und dasselbe Ergebnis liefern. Von außen kann man das nicht erkennen, erst die Messung zeigt es.

**Warum ist das problematisch?** Wer die View nur benutzt, sieht nur ein einfaches `SELECT` und kann nicht abschätzen, wie teuer es ist. So kann eine harmlos aussehende Abfrage plötzlich Minuten dauern.

**EXPLAIN QUERY PLAN:**

View A:
```
CO-ROUTINE letzte_bestellung_a
├── SCAN b
└── CORRELATED SCALAR SUBQUERY 3
    └── SEARCH b2
SCAN letzte_bestellung_a
```

View B:
```
CO-ROUTINE letzte_bestellung_b
├── CO-ROUTINE letzte
│   ├── SCAN bestellung
│   └── USE TEMP B-TREE FOR GROUP BY
├── SCAN b
├── BLOOM FILTER ON letzte (kunde_id=?)
└── SEARCH letzte USING AUTOMATIC COVERING INDEX (kunde_id=?)
SCAN letzte_bestellung_b
```

**Erklärung der Unterschiede:**

- Bei beiden Views wird wegen des `LIMIT` zuerst die ganze View berechnet (`CO-ROUTINE`), der Filter `kunde_id = 42` kommt erst am Schluss. Das ist bei A und B gleich.
- In A wird die Unterabfrage mit `MAX` für **jede** der 100.000 Bestellungen ausgeführt (korreliert). Da es keinen Index auf `kunde_id` gibt, geht sie dabei jedes Mal die ganze Tabelle durch, obwohl im Plan „SEARCH“ steht (im Bytecode mit `EXPLAIN` sieht man einen kompletten Durchlauf). Das sind ca. 100.000 × 100.000 = 10 Milliarden Zeilenzugriffe.
- In B wird das `MAX` pro Kunde nur **einmal** mit `GROUP BY` berechnet. Danach sucht SQLite über einen automatisch erstellten Index. Das sind nur ca. 200.000 Zeilenzugriffe plus 100.000 Indexsuchen.
- Test: Mit einem Index auf `bestellung(kunde_id)` braucht View A nur noch ca. 1 s.

## Schlussfolgerung

Ja. Eine View vereinfacht die Abfrage für den Benutzer, aber die Komplexität verschwindet dadurch nicht, sie wird nur versteckt. Die Datenbank führt trotzdem die ganze Abfrage aus, die in der View steckt. Das zeigen die Messungen: Beide Views werden gleich einfach abgefragt und liefern dasselbe, trotzdem braucht A 433,7 s und B 0,068 s. Warum, sieht man erst mit `EXPLAIN QUERY PLAN`. Views sind also praktisch, aber man sollte wissen, was in ihnen steckt.
