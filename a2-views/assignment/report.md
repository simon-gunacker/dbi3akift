# Report: Views und Performance

---

## 3. View für eine vereinfachte Sicht

```sql
DROP VIEW IF EXISTS kunde_view;
CREATE VIEW IF NOT EXISTS kunde_view AS
SELECT id, vorname, nachname, email
FROM kunde;
```

```sql
SELECT * FROM kunde_view LIMIT 5;
```

| id | vorname | nachname | email |
|---|---|---|---|
| 1 | Felix | Mayr | Felix.Mayr1@icloud.com |
| 2 | Katharina | Wagner | Katharina.Wagner2@yahoo.com |
| 3 | Lena | Winmer | Lena.Winmer3@gmx.at |
| 4 | Katharina | Steiner | Katharina.Steiner4@outlook.com |
| 5 | Sarah | Huber | Sarah.Huber5@gmx.at |

**Vorteil:** Die View bietet mehr Datenschutz, und man bekommt nicht so viele Informationen, die man nicht braucht.

---

## 4. View mit zusammengefassten Daten

```sql
DROP VIEW IF EXISTS gesamtwertBestellung;
CREATE VIEW IF NOT EXISTS gesamtwertBestellung AS
SELECT bestellung.id AS Bestellnummer,
       bestellung.kunde_id AS Kundennummer,
       SUM(bestellposition.menge * produkt.preis) AS Gesamtwert
FROM bestellung
JOIN bestellposition ON bestellung.id = bestellposition.bestellung_id
JOIN produkt ON bestellposition.produkt_id = produkt.id
GROUP BY bestellung.id;
```

```sql
SELECT * FROM gesamtwertBestellung LIMIT 5;
```

| Bestellnummer | Kundennummer | Gesamtwert |
|---|---|---|
| 1 | 4857 | 2022.7 |
| 2 | 1253 | 1349.05 |
| 3 | 6487 | 2139.79 |
| 4 | 4085 | 660.92 |
| 5 | 1041 | 3122.2 |

---

## 5. View als vereinfachte Schnittstelle

```sql
DROP VIEW IF EXISTS bestellungMitKunde;
CREATE VIEW IF NOT EXISTS bestellungMitKunde AS
SELECT bestellung.id AS Bestellnummer,
       bestellung.kunde_id AS Kundennummer,
       bestellung.bestelldatum AS Bestelldatum,
       bestellung.status AS Bestellstatus,
       kunde.vorname AS Vorname,
       kunde.nachname AS Nachname
FROM bestellung
JOIN kunde ON bestellung.kunde_id = kunde.id;
```

```sql
SELECT * FROM bestellungMitKunde LIMIT 5;
```

| Bestellnummer | Kundennummer | Bestelldatum | Bestellstatus | Vorname | Nachname |
|---|---|---|---|---|---|
| 1 | 4857 | 2026-05-17 04:08:49 | geliefert | Stefan | Moser |
| 2 | 1253 | 2026-06-01 18:50:45 | geliefert | Nina | Berger |
| 3 | 6487 | 2026-03-24 22:59:34 | versendet | Laura | Winkler |
| 4 | 4085 | 2024-04-05 03:48:20 | geliefert | Nina | Schmidt |
| 5 | 1041 | 2024-03-04 13:36:39 | storniert | Simon | Egger |

### Beispielabfrage: Welche Bestellungen von Anna Gruber sind storniert?

**Mit View:**

```sql
SELECT * FROM bestellungMitKunde
WHERE Vorname = 'Anna' AND Nachname = 'Gruber' AND Bestellstatus = 'storniert';
```

**Ohne View:**

```sql
SELECT bestellung.id AS Bestellnummer,
       bestellung.kunde_id AS Kundennummer,
       bestellung.bestelldatum AS Bestelldatum,
       bestellung.status AS Bestellstatus,
       kunde.vorname AS Vorname,
       kunde.nachname AS Nachname
FROM bestellung
JOIN kunde ON bestellung.kunde_id = kunde.id
WHERE kunde.vorname = 'Anna' AND kunde.nachname = 'Gruber' AND bestellung.status = 'storniert';
```

Beide Abfragen liefern dasselbe Ergebnis:

| Bestellnummer | Kundennummer | Bestelldatum | Bestellstatus | Vorname | Nachname |
|---|---|---|---|---|---|
| 4149 | 2438 | 2024-03-12 05:47:52 | storniert | Anna | Gruber |
| 4857 | 1432 | 2022-08-26 16:13:24 | storniert | Anna | Gruber |
| 6295 | 2438 | 2022-12-20 11:56:06 | storniert | Anna | Gruber |
| 11044 | 5037 | 2025-12-26 13:10:34 | storniert | Anna | Gruber |
| 16880 | 1868 | 2026-06-06 12:24:57 | storniert | Anna | Gruber |

Mit der View ist die Abfrage einfacher und kürzer. Ohne View muss man jedes Mal die ganze Abfrage mit dem JOIN schreiben.

---

## 6. Views und Performance

### 6.1 Views erstellen

```sql
DROP VIEW IF EXISTS letzte_bestellung_a;
CREATE VIEW letzte_bestellung_a AS
SELECT
    b.kunde_id,
    b.id AS bestellung_id,
    b.bestelldatum
FROM bestellung b
WHERE b.id <= 10000
  AND b.bestelldatum = (
    SELECT MAX(b2.bestelldatum)
    FROM bestellung b2
    WHERE b2.kunde_id = b.kunde_id
      AND b2.id <= 10000
);

DROP VIEW IF EXISTS letzte_bestellung_b;
CREATE VIEW letzte_bestellung_b AS
SELECT
    b.kunde_id,
    b.id AS bestellung_id,
    b.bestelldatum
FROM bestellung b
JOIN (
    SELECT
        kunde_id,
        MAX(bestelldatum) AS bestelldatum
    FROM bestellung
    WHERE id <= 10000
    GROUP BY kunde_id
) letzte
    ON letzte.kunde_id = b.kunde_id
   AND letzte.bestelldatum = b.bestelldatum
WHERE b.id <= 10000;
```

Die Einschränkung `id <= 10000` steht in beiden Views außen **und** in der Unterabfrage, damit beide Views genau dieselben 10.000 Bestellungen betrachten.

### 6.2 Liefern beide Views dasselbe Ergebnis?

```sql
SELECT * FROM letzte_bestellung_a EXCEPT SELECT * FROM letzte_bestellung_b;
SELECT * FROM letzte_bestellung_b EXCEPT SELECT * FROM letzte_bestellung_a;
```

**Ergebnis:** keine Zeilen → beide Views liefern dieselben Ergebnisse.

Erste Zeitmessung in sqlite mit `.timer on`:

| Abfrage | Zeilen | Laufzeit |
|---|---|---|
| `SELECT COUNT(*) FROM letzte_bestellung_a;` | 6279 | 16,944 s |
| `SELECT COUNT(*) FROM letzte_bestellung_b;` | 6279 | 0,027 s |

Beide Views liefern gleich viele Zeilen (6279). View A ist damit ca. 630-mal langsamer als View B.

### 6.3–6.4 Benchmark (`benchmark.py`)

Beide Views werden auf dieselbe Weise abgefragt:

```sql
SELECT * FROM letzte_bestellung_a WHERE kunde_id = 42;
SELECT * FROM letzte_bestellung_b WHERE kunde_id = 42;
```

**Wie oft wird jede Abfrage ausgeführt?**

- Einzelne Abfrage (vorher gemessen): View A ca. 0,008 s, View B ca. 0,004 s.
- Mit `n = 1000` dauert der Benchmark ca. 8 Sekunden für View A und ca. 4 Sekunden für View B.
- Mehrere Durchläufe ergeben fast dieselben Werte, also ist `n = 1000` genug für einen aussagekräftigen Durchschnittswert.

### 6.5 Faktor

Jede Abfrage wurde 1000-mal ausgeführt, daraus wurde der Durchschnitt berechnet:

| | View A | View B |
|---|---|---|
| Durchschnitt pro Abfrage | 0,0067 s | 0,0032 s |

View A ist ca. **2,1-mal** langsamer als View B.

### 6.6 Kann man von außen erkennen, dass die Views unterschiedlich effizient sind?

**Nur die Laufzeit (noch ohne `EXPLAIN QUERY PLAN`):**

Nein. Beide Views werden gleich abgefragt (`SELECT * FROM ... WHERE kunde_id = 42`) und liefern dasselbe Ergebnis. Erst durch die Zeitmessung sieht man, dass View A langsamer ist:

| Wo | Abfrage | View A | View B | Faktor |
|---|---|---|---|---|
| 6.2 (sqlite, `.timer on`) | `SELECT COUNT(*)` | 16,9 s | 0,027 s | ca. 630-mal |
| 6.3–6.5 (`benchmark.py`, n = 1000) | `WHERE kunde_id = 42` | 0,0067 s | 0,0032 s | ca. 2,1-mal |

**Danach mit `EXPLAIN QUERY PLAN`: Warum?**

```sql
EXPLAIN QUERY PLAN SELECT * FROM letzte_bestellung_a WHERE kunde_id = 42;
```

```
QUERY PLAN
|--SEARCH b USING INTEGER PRIMARY KEY (rowid<?)
`--CORRELATED SCALAR SUBQUERY 3
   `--SEARCH b2 USING INTEGER PRIMARY KEY (rowid<?)
```

```sql
EXPLAIN QUERY PLAN SELECT * FROM letzte_bestellung_b WHERE kunde_id = 42;
```

```
QUERY PLAN
|--CO-ROUTINE letzte
|  `--SEARCH bestellung USING INTEGER PRIMARY KEY (rowid<?)
|--SEARCH b USING INTEGER PRIMARY KEY (rowid<?)
|--BLOOM FILTER ON letzte (kunde_id=?)
`--SEARCH letzte USING AUTOMATIC PARTIAL COVERING INDEX (kunde_id=?)
```

`EXPLAIN QUERY PLAN` führt die Abfrage nicht aus, sondern zeigt nur den Plan, wie SQLite die Abfrage ausführen wird (Laufzeit: 0,000 s).

- **View A:** `CORRELATED SCALAR SUBQUERY` → die Unterabfrage wird für jede Zeile neu ausgeführt.
- **View B:** `CO-ROUTINE letzte` → die letzte Bestellung pro Kunde wird nur einmal berechnet. Danach sucht SQLite mit einem automatischen Index.

---

## 7. Untersuchung

### Views

**Welchen Zweck haben Views?**

Eine View ist eine gespeicherte Abfrage mit einem Namen. Man kann sie wie eine Tabelle benutzen, aber sie speichert keine eigenen Daten.

**Welche Vorteile haben Views?**

- **Daten filtern:** Man kann nur die Daten auswählen, die man braucht.
- **Datenschutz:** Man zeigt nur die Daten, die man wirklich braucht (z. B. `kunde_view` ohne Telefon, Adresse und Geburtsdatum).
- **Einfachheit:** Der JOIN steckt schon in der View (z. B. „Welche Bestellungen von Anna Gruber sind storniert?“ mit `bestellungMitKunde`).
- **Zugriffsrechte:** Man kann Benutzern nur Zugriff auf die View geben.

**Welche Nachteile oder Gefahren gibt es?**

Man sieht nicht, was in der View steckt. Eine View kann sehr langsam sein, ohne dass der Benutzer es merkt. Zwei Views können von außen gleich aussehen, aber intern ganz unterschiedlich arbeiten.

### Performance

**Liefern beide Views dasselbe Ergebnis?**

Ja. Beide Views liefern 6279 Zeilen. Die Abfragen mit `EXCEPT` haben keine Zeilen zurückgegeben, also sind die Ergebnisse gleich.

**Wie unterscheiden sich die gemessenen Laufzeiten?**

Ergebnis von `benchmark.py` (n = 1000, `WHERE kunde_id = 42`):

| | View A | View B |
|---|---|---|
| Durchschnitt pro Abfrage | 0,0067 s | 0,0032 s |

View A ist ca. 2,1-mal langsamer als View B.

**Warum ist es problematisch, dass man die Abfrage nicht sieht?**

Der Benutzer schreibt für beide Views die gleiche Abfrage und kann nicht erkennen, dass View A viel langsamer ist. Man merkt es nur, wenn man die Laufzeit misst.

**Was zeigt `EXPLAIN QUERY PLAN`?**

- **View A:** `CORRELATED SCALAR SUBQUERY`. Die Unterabfrage wird für jede Zeile neu ausgeführt.
- **View B:** `CO-ROUTINE letzte`. Die letzte Bestellung pro Kunde wird nur einmal berechnet. Für den JOIN benutzt SQLite einen automatischen Index (`AUTOMATIC PARTIAL COVERING INDEX`).

**Welche Unterschiede in der Verarbeitung erklären die gemessenen Laufzeiten?**

View A verwendet eine korrelierte Unterabfrage. Für jede Bestellung wird das letzte Bestelldatum des Kunden neu berechnet. Bei 10.000 Bestellungen bedeutet das ca. 10.000 × 10.000 gelesene Zeilen. Deshalb ist View A langsam.

View B berechnet zuerst einmal eine temporäre Tabelle (`letzte`) mit dem letzten Bestelldatum jedes Kunden. Danach wird jede Bestellung mit dieser Tabelle verglichen. Dafür erstellt SQLite automatisch einen Index, damit die Suche schnell ist. Die Arbeit wird also nur einmal gemacht. Deshalb ist View B viel schneller.

---

## Schlussfolgerung

Ja. Eine View kann eine Abfrage vereinfachen, aber die Komplexität verschwindet nicht. Sie ist nur in der View versteckt.

Meine Messungen zeigen das: Beide Views werden gleich abgefragt und liefern dasselbe Ergebnis (6279 Zeilen). Trotzdem ist View A langsamer:

- mit `WHERE kunde_id = 42` (Benchmark, n = 1000) ca. 2,1-mal,
- mit `SELECT COUNT(*)` ca. 630-mal (16,9 s statt 0,027 s).

Der Grund ist die korrelierte Unterabfrage in View A, die man von außen nicht sieht. Deshalb sollte man bei Views auch auf die Performance achten.
