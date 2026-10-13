
-----------3--View für eine vereinfachte Sicht-------
.mode table
DROP VIEW IF EXISTS kunde_view;
CREATE VIEW IF NOT EXISTS kunde_view AS
SELECT id, vorname, nachname, email
FROM kunde;

SELECT * FROM kunde_view LIMIT 5;

----------4--___-View mit zusammengefassten Daten---------View con datos resumidos

DROP VIEW IF EXISTS gesamtwertBestellung;
CREATE VIEW IF NOT EXISTS gesamtwertBestellung AS SELECT bestellung.id AS Bestellnummer, bestellung.kunde_id, SUM(bestellposition.menge * produkt.preis) AS  Gesamtwert FROM bestellung JOIN bestellposition ON bestellung.id = bestellposition.bestellung_id JOIN produkt ON bestellposition.produkt_id = produkt.id GROUP BY bestellung.id;

SELECT * FROM gesamtwertBestellung LIMIT 5;


------5.-----View als vereinfachte Schnittstelle---View como interfaz simplificada

DROP VIEW IF EXISTS bestellungMitKunde;
CREATE VIEW IF NOT EXISTS bestellungMitKunde AS SELECT bestellung.id AS Bestellnummer, bestellung.kunde_id AS Kundennummer, bestellung.bestelldatum AS Bestelldatum, bestellung.status AS Bestellstatus, kunde.vorname AS Vorname, kunde.nachname AS Nachname FROM bestellung JOIN kunde ON bestellung.kunde_id = kunde.id;

SELECT * FROM  bestellungMitKunde LIMIT 5;


---Welche Bestellungen von Anna Gruber sind storniert?
----mit view
SELECT * FROM bestellungMitKunde WHERE Vorname = 'Anna' AND Nachname = 'Gruber' AND  Bestellstatus = 'storniert' LIMIT 5;

---ohne view
SELECT bestellung.id AS Bestellnummer, bestellung.kunde_id AS Kundennummer, bestellung.bestelldatum AS  Bestelldatum, bestellung.status AS  Bestellstatus, kunde.vorname AS Vorname, kunde.nachname AS Nachname FROM bestellung JOIN kunde ON  bestellung.kunde_id = kunde.id WHERE Vorname= 'Anna' AND Nachname = 'Gruber' AND Bestellstatus = 'storniert' LIMIT 5;

--------6------------Views und Performance
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

-- 2. Überprüfe, dass beide Views dieselben Ergebnisse liefern
SELECT * FROM letzte_bestellung_a EXCEPT SELECT * FROM letzte_bestellung_b;
SELECT * FROM letzte_bestellung_b EXCEPT SELECT * FROM letzte_bestellung_a;


.timer on
SELECT COUNT(*) FROM letzte_bestellung_a;

SELECT COUNT(*) FROM letzte_bestellung_b;

---6---Wichtig----

EXPLAIN QUERY PLAN SELECT * FROM letzte_bestellung_a WHERE kunde_id = 42;
EXPLAIN QUERY PLAN SELECT * FROM letzte_bestellung_b WHERE kunde_id = 42;

