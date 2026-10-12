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
GROUP BY b.id;

CREATE VIEW bestellungen_kunden_einsicht AS
SELECT
    b.id AS bestellnummer,
    b.kunde_id AS kundennummer,
    b.bestelldatum AS bestelldatum,
    b.status AS bestellstatus,
    k.vorname AS vorname,
    k.nachname AS nachname
FROM bestellung b
JOIN kunde k ON k.id = b.kunde_id;
