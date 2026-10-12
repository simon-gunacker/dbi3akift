
-----------3--------------
DROP VIEW IF EXISTS kunde_view;
CREATE VIEW kunde_view AS
SELECT id, vorname, nachname, email
FROM kunde;

----------4---------------------
DROP VIEW IF EXISTS gesamtwertBestellung;
CREATE VIEW gesamtwertBestellung AS
SELECT bestellung.id AS Bestellnummer, bestellung.kunde_id AS Kundennummer, ROUND(sum(bestellposition.menge *produkt.preis),2) as Gesamtwert
FROM bestellung
JOIN bestellposition ON bestellung.id = bestellposition.bestellung_id
JOIN produkt ON bestellposition.produkt_id = produkt.id
GROUP BY bestellung.id;

---------5.---------
DROP VIEW IF EXISTS bestellungMitKunde;
CREATE VIEW bestellungMitKunde AS
SELECT bestellung.id AS Bestellnummer, bestellung.kunde_id AS Kundennummer, bestellung.bestelldatum AS Bestelldatum, bestellung.status AS Bestellstatus,  kunde.vorname AS Vorname, kunde.nachname AS Nachname
FROM bestellung
JOIN kunde ON bestellung.kunde_id = kunde.id;

---Welche Bestellungen von Anna Gruber sind storniert?
----mit view
SELECT * FROM bestellungMitKunde WHERE Vorname = 'Anna' and Nachname = 'Gruber' and Bestellstatus = 'storniert';
-- Mit der View ist die Abfrage einfacher und kürzer.

---ohne view
SELECT bestellung.id AS Bestellnummer, bestellung.kunde_id AS kundennummer, bestellung.bestelldatum AS Bestelldatum, bestellung.status AS Bestellstatus, kunde.vorname AS Vorname, kunde.nachname AS Nachname
FROM bestellung
JOIN kunde ON  bestellung.kunde_id = kunde.id
WHERE Vorname = 'Anna' and Nachname = 'Gruber' and Bestellstatus = 'storniert';
-- Ohne View muss man jedes Mal die ganze Abfrage mit dem JOIN schreiben.


--------6------------
---1. Erstelle die Views letzte_bestellung_a und letzte_bestellung_b
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

-- 2.- Überprüfe, dass beide Views dieselben Ergebnisse liefern



/*

sqlite> .timer on
sqlite> SELECT COUNT(*) FROM letzte_bestellung_a;
+----------+
| COUNT(*) |
+----------+
| 6279     |
+----------+
Run Time: real 17.256 user 17.243152 sys 0.007125
sqlite> SELECT COUNT(*) FROM letzte_bestellung_b;
+----------+
| COUNT(*) |
+----------+
| 6279     |
+----------+
Run Time: real 0.028 user 0.027442 sys 0.000000


*/
