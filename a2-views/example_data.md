## Beispieldaten

### Tabelle 1: Produkte (produkte)

| id | bezeichnung | preis | lagerbestand |
|---|---|---|---|
| 101 | Laptop | 899.00 | 15 |
| 102 | Wireless Maus | 29.90 | 100 |
| 103 | Tastatur | 49.90 | 45 |

### Tabelle 2: Kunden (kunden)

| id | vorname | nachname | email |
|---|---|---|---|
| 1 | Anna | Schmidt | anna@example.com |
| 2 | Ben | Weber | ben@example.com |

### Tabelle 3: Bestellungen (bestellungen)

| id | kunde_id | bestelldatum | status |
|---|---|---|---|
| 5001 | 1 (Anna) | 2026-10-02 10:15 | versendet |
| 5002 | 2 (Ben) | 2026-10-02 11:30 | in Bearbeitung |
| 5003 | 1 (Anna) | 2026-10-02 14:00 | neu |

### Tabelle 4: Bestellpositionen (bestellung_details)

| bestellung_id | produkt_id | menge | Was das logisch bedeutet: |
|---|---|---|---|
| 5001 | 101 (Laptop) | 1 | Anna kauft in Bestellung 5001 1x Laptop |
| 5001 | 102 (Maus) | 1 | Anna kauft in Bestellung 5001 1x Maus |
| 5002 | 102 (Maus) | 5 | Ben kauft in Bestellung 5002 5x Mäuse |
| 5003 | 103 (Tastatur) | 2 | Anna kauft in Bestellung 5003 2x Tastaturen |