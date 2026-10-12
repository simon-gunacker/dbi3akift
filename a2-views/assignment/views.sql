-- mit .read in der database erzeugen

CREATE VIEW kundendaten_beschraenkte_einsicht AS
SELECT
    id AS kundennummer,
    vorname,
    nachname,
    email
FROM kunde;

CREATE VIEW gesamtwert_bestellung_einsicht AS
SELECT 
    b.id AS bestellnummer,
    b.kunde_id AS kundennummer,
    SUM(bp.menge * p.preis) AS gesamtwert
FROM bestellung b
JOIN bestellposition bp ON bp.bestellung_id = b.id
JOIN produkt p ON bp.produkt_id = p.id
GROUP BY b.id