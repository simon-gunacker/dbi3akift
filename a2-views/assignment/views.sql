-- Aufgabe 3
DROP VIEW IF EXISTS kundeninfo;
CREATE VIEW kundeninfo AS
    SELECT id AS kundennummer, vorname, nachname, email
    FROM kunde;

-- Aufgabe 4
DROP VIEW IF EXISTS gesamtwert_bestellung;
CREATE VIEW gesamtwert_bestellung AS 
    SELECT bestellung.id AS bestellnummer, 
        bestellung_id.kunde_id AS kundennummer,
        SUM(bestellposition.menge * produkt.preis) AS gesamtwert
    FROM bestellposition
    JOIN bestellung ON bestellung.id =  bestellposition.bestellung_id
    JOIN produkt ON produkt.id = bestellposition.produkt_id
    GROUP BY bestellung.id;

-- Aufgabe 5
DROP VIEW IF EXISTS wichtige_info; 
CREATE VIEW wichtige_info AS
    SELECT b.id AS bestellnummer, b.kunde_id AS kundennummer, b.bestelldatum, b.status AS bestellstatus,
            kunde.vorname AS vorname, kunde.nachname AS nachname
    FROM bestellung b
    JOIN kunde ON kunde.id = b.kunde_id;

--  ohne view 
SELECT b.id AS bestellnummer, b.kunde_id AS kundennummer,
            kunde.vorname AS vorname, kunde.nachname AS nachname
    FROM bestellung b
    JOIN kunde ON kunde.id = b.kunde_id
    WHERE b.status = 'Versendet';

-- mit view 
SELECT * 
FROM wichtige_info
WHERE bestellstatus = 'Versendet';

--Aufgabe 6:
DROP VIEW IF EXISTS letzte_bestellung_a;
CREATE VIEW letzte_bestellung_a AS 
    SELECT
        b.kunde_id,
        b.id AS bestellung_id,
        b.bestelldatum
    FROM bestellung b
    WHERE b.bestelldatum = (
        SELECT MAX(b2.bestelldatum)
        FROM bestellung b2
        WHERE b2.kunde_id = b.kunde_id);

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
        GROUP BY kunde_id
    ) letzte
        ON letzte.kunde_id = b.kunde_id
    AND letzte.bestelldatum = b.bestelldatum;