-- Aufgabe 3
DROP VIEW IF EXISTS kundeninfo;
CREATE VIEW kundeninfo AS
    SELECT id AS kundennummer, vorname, nachname, email
    FROM kunde;

-- Aufgabe 4
DROP VIEW IF EXISTS gesamtwert_bestellung;
CREATE VIEW gesamtwert_bestellung AS 
    SELECT bestellung.id AS bestellnummer, 
        bestellung_id AS kundennummer,
        SUM(bestellposition.menge * produkt.preis) AS gesamtwert
    FROM bestellposition
    JOIN bestellung ON bestellung.id =  bestellposition.bestellung_id
    JOIN produkt ON produkt.id = bestellposition.produkt_id
    GROUP BY bestellung.id;