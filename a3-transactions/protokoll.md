# Bestellabwicklung – Protokoll

## Ausgangsdaten

```sql
SELECT * FROM kunde;
```

```
+----+--------------------+-------------+------------------+
| id |        name        | kreditlimit | aktueller_kredit |
+----+--------------------+-------------+------------------+
| 1  | TechShop Wien      | 5000        | 1200             |
| 2  | MakerSpace Graz    | 2000        | 0                |
| 3  | Elektronik Steiner | 10000       | 3500             |
+----+--------------------+-------------+------------------+
```

```sql
SELECT * FROM artikel;
```

```
+----+-----------------+-----------------+---------------+---------------+--------------+----------------+
| id |      name       |    kategorie    | einkaufspreis | verkaufspreis | lagerbestand | mindestbestand |
+----+-----------------+-----------------+---------------+---------------+--------------+----------------+
| 1  | Arduino Uno     | Mikrocontroller | 15            | 25            | 100          | 10             |
| 2  | Raspberry Pi 4  | Mikrocontroller | 45            | 75            | 50           | 5              |
| 3  | LED 5mm rot     | LED             | 0.1           | 0.25          | 1000         | 50             |
| 4  | Widerstand 220Ω | Widerstand      | 0.02          | 0.05          | 5000         | 100            |
| 5  | Breadboard      | Zubehör         | 3             | 8             | 30           | 5              |
+----+-----------------+-----------------+---------------+---------------+--------------+----------------+
```

```sql
SELECT * FROM lagerbewegung;
```

```
+----+------------+---------------+-------+---------------+---------------------+
| id | artikel_id | bestellung_id | menge |      typ      |        datum        |
+----+------------+---------------+-------+---------------+---------------------+
| 1  | 1          |               | 100   | nachlieferung | 2026-11-03 10:20:51 |
| 2  | 2          |               | 50    | nachlieferung | 2026-11-03 10:20:51 |
| 3  | 3          |               | 1000  | nachlieferung | 2026-11-03 10:20:51 |
| 4  | 4          |               | 5000  | nachlieferung | 2026-11-03 10:20:51 |
| 5  | 5          |               | 30    | nachlieferung | 2026-11-03 10:20:51 |
+----+------------+---------------+-------+---------------+---------------------+
```

---

## 1. Einfache Bestellung

Implementiere eine Transaktion für folgende Bestellung:

- **Kunde:** TechShop Wien (ID=1)
- **Artikel:** 5x Arduino Uno, 2x Raspberry Pi 4, 50x LED rot

Die Transaktion muss:

### 1.1 Neue Bestellung anlegen

```sql
SELECT * FROM bestellung;
```

```
+----+----------+---------------------+--------+------------+
| id | kunde_id |        datum        | status | gesamtwert |
+----+----------+---------------------+--------+------------+
| 1  | 1        | 2026-11-03 12:32:36 | offen  | 287.5      |
+----+----------+---------------------+--------+------------+
```

### 1.2 Bestellpositionen einfügen

```sql
SELECT * FROM bestellposition;
```

```
+---------------+------------+-------+-------------+
| bestellung_id | artikel_id | menge | einzelpreis |
+---------------+------------+-------+-------------+
| 1             | 1          | 5     | 25          |
| 1             | 2          | 2     | 75          |
| 1             | 3          | 50    | 0.25        |
+---------------+------------+-------+-------------+
```

### 1.3 Lagerbestand reduzieren

```sql
SELECT id, name, lagerbestand FROM artikel;
```

```
+----+-----------------+--------------+
| id |      name       | lagerbestand |
+----+-----------------+--------------+
| 1  | Arduino Uno     | 95           |
| 2  | Raspberry Pi 4  | 48           |
| 3  | LED 5mm rot     | 950          |
| 4  | Widerstand 220Ω | 5000         |
| 5  | Breadboard      | 30           |
+----+-----------------+--------------+
```

```sql
SELECT * FROM artikel;
```

```
+----+-----------------+-----------------+---------------+---------------+--------------+----------------+
| id |      name       |    kategorie    | einkaufspreis | verkaufspreis | lagerbestand | mindestbestand |
+----+-----------------+-----------------+---------------+---------------+--------------+----------------+
| 1  | Arduino Uno     | Mikrocontroller | 15            | 25            | 95           | 10             |
| 2  | Raspberry Pi 4  | Mikrocontroller | 45            | 75            | 48           | 5              |
| 3  | LED 5mm rot     | LED             | 0.1           | 0.25          | 950          | 50             |
| 4  | Widerstand 220Ω | Widerstand      | 0.02          | 0.05          | 5000         | 100            |
| 5  | Breadboard      | Zubehör         | 3             | 8             | 30           | 5              |
+----+-----------------+-----------------+---------------+---------------+--------------+----------------+
```

### 1.4 Gesamtwert berechnen und eintragen

```sql
SELECT * FROM bestellung;
```

```
+----+----------+---------------------+--------+------------+
| id | kunde_id |        datum        | status | gesamtwert |
+----+----------+---------------------+--------+------------+
| 1  | 1        | 2026-11-03 12:32:36 | offen  | 287.5      |
+----+----------+---------------------+--------+------------+
```

### 1.5 Kundenkredit erhöhen

```sql
SELECT * FROM kunde;
```

```
+----+--------------------+-------------+------------------+
| id |        name        | kreditlimit | aktueller_kredit |
+----+--------------------+-------------+------------------+
| 1  | TechShop Wien      | 5000        | 1487.5           |
| 2  | MakerSpace Graz    | 2000        | 0                |
| 3  | Elektronik Steiner | 10000       | 3500             |
+----+--------------------+-------------+------------------+
```

### 1.6 Lagerbewegungen protokollieren

```sql
SELECT * FROM lagerbewegung;
```

```
+----+------------+---------------+-------+---------------+---------------------+
| id | artikel_id | bestellung_id | menge |      typ      |        datum        |
+----+------------+---------------+-------+---------------+---------------------+
| 1  | 1          |               | 100   | nachlieferung | 2026-11-03 10:20:51 |
| 2  | 2          |               | 50    | nachlieferung | 2026-11-03 10:20:51 |
| 3  | 3          |               | 1000  | nachlieferung | 2026-11-03 10:20:51 |
| 4  | 4          |               | 5000  | nachlieferung | 2026-11-03 10:20:51 |
| 5  | 5          |               | 30    | nachlieferung | 2026-11-03 10:20:51 |
| 6  | 1          | 1             | -5    | verkauf       | 2026-11-03 12:32:36 |
| 7  | 2          | 1             | -2    | verkauf       | 2026-11-03 12:32:36 |
| 8  | 3          | 1             | -50   | verkauf       | 2026-11-03 12:32:36 |
+----+------------+---------------+-------+---------------+---------------------+
```

---

## 2. Erweiterte Validierung

Erweitere deine Lösung (neue Datei!) um automatische Fehlerbehandlung:
Constraints sorgen automatisch für Rollback bei Problemen.

### 2.1 Was passiert bei zu wenig Lagerbestand?

**Zu wenig Lagerbestand:** Das UPDATE auf `artikel` verletzt den CHECK-Constraint `lagerbestand >= 0`. Durch `OR ROLLBACK` und `.bail on` wird die gesamte Transaktion rückgängig gemacht. Es bleibt keine halbe Bestellung in der Datenbank.

```bash
sqlite3 lager.db < validierung_lager.sql
```

```
CHECK constraint failed: lagerbestand >=0 (19)
```

### 2.2 Was passiert, wenn das Kreditlimit überschritten wird?

**Kreditlimit überschritten:** Das UPDATE auf `kunde` verletzt den CHECK `aktueller_kredit <= kreditlimit`. Alle vorherigen Schritte werden zurückgerollt, auch die bereits reduzierten Lagerbestände.

```bash
sqlite3 lager.db < validierung_kredit.sql
```

```
CHECK constraint failed: aktueller_kredit<=kreditlimit (19)
```

---

## 3. Stornierung

Erstelle eine Transaktion, um Bestellungen zu stornieren.

```sql
SELECT * FROM bestellung;
```

```
+----+----------+---------------------+-----------+------------+
| id | kunde_id |        datum        |  status   | gesamtwert |
+----+----------+---------------------+-----------+------------+
| 1  | 1        | 2026-11-03 12:32:36 | storniert | 287.5      |
+----+----------+---------------------+-----------+------------+
```

```sql
SELECT * FROM lagerbewegung;
```

```
+----+------------+---------------+-------+---------------+---------------------+
| id | artikel_id | bestellung_id | menge |      typ      |        datum        |
+----+------------+---------------+-------+---------------+---------------------+
| 1  | 1          |               | 100   | nachlieferung | 2026-11-03 10:20:51 |
| 2  | 2          |               | 50    | nachlieferung | 2026-11-03 10:20:51 |
| 3  | 3          |               | 1000  | nachlieferung | 2026-11-03 10:20:51 |
| 4  | 4          |               | 5000  | nachlieferung | 2026-11-03 10:20:51 |
| 5  | 5          |               | 30    | nachlieferung | 2026-11-03 10:20:51 |
| 6  | 1          | 1             | -5    | verkauf       | 2026-11-03 12:32:36 |
| 7  | 2          | 1             | -2    | verkauf       | 2026-11-03 12:32:36 |
| 8  | 3          | 1             | -50   | verkauf       | 2026-11-03 12:32:36 |
| 9  | 1          | 1             | 5     | storno        | 2026-11-03 12:57:51 |
| 10 | 2          | 1             | 2     | storno        | 2026-11-03 12:57:51 |
| 11 | 3          | 1             | 50    | storno        | 2026-11-03 12:57:51 |
+----+------------+---------------+-------+---------------+---------------------+
```

```sql
SELECT id, lagerbestand FROM artikel WHERE id IN (1,2);
```

```
+----+--------------+
| id | lagerbestand |
+----+--------------+
| 1  | 100          |
| 2  | 50           |
+----+--------------+
```

```sql
SELECT * FROM kunde;
```

```
+----+--------------------+-------------+------------------+
| id |        name        | kreditlimit | aktueller_kredit |
+----+--------------------+-------------+------------------+
| 1  | TechShop Wien      | 5000        | 1200             |
| 2  | MakerSpace Graz    | 2000        | 0                |
| 3  | Elektronik Steiner | 10000       | 3500             |
+----+--------------------+-------------+------------------+
```

---

## 4. Reporting und Konsistenzprüfung

Erstelle Abfragen für das Management:

### 4.1 Artikel, die unter Mindestbestand gefallen sind (Nachbestellung nötig)

```sql
SELECT id, name FROM artikel WHERE lagerbestand < mindestbestand;
```

```
+----+-------------+
| id |    name     |
+----+-------------+
| 3  | LED 5mm rot |
| 5  | Breadboard  |
+----+-------------+
```

### 4.2 Kunden, die ihr Kreditlimit fast ausgeschöpft haben (>90 %)

```sql
SELECT * FROM kunde WHERE aktueller_kredit > (kreditlimit * 0.90);
```

### 4.3 Umsatz des heutigen Tages

```sql
SELECT SUM(gesamtwert) FROM bestellung
WHERE DATE(datum) = DATE('now') AND status = 'offen';
```

```
+-----------------+
| SUM(gesamtwert) |
+-----------------+
| 458.5           |
+-----------------+
```

### 4.4 Konsistenzprüfung: Stimmen Lagerbewegungen mit aktuellem Bestand überein?

Ja. Damit die Prüfung funktioniert, wurde der Anfangsbestand als `nachlieferung` in `lagerbewegung` erfasst.

```sql
SELECT a.id, a.name, a.lagerbestand, SUM(l.menge)
FROM artikel a
JOIN lagerbewegung l ON a.id = artikel_id
GROUP BY a.id;
```

```
+----+-----------------+--------------+--------------+
| id |      name       | lagerbestand | SUM(l.menge) |
+----+-----------------+--------------+--------------+
| 1  | Arduino Uno     | 100          | 100          |
| 2  | Raspberry Pi 4  | 50           | 50           |
| 3  | LED 5mm rot     | 30           | 30           |
| 4  | Widerstand 220Ω | 5000         | 5000         |
| 5  | Breadboard      | 3            | 3            |
+----+-----------------+--------------+--------------+
```
