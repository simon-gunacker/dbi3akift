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


CREATE VIEW letzte_bestellung_a AS
SELECT
    b.kunde_id,
    b.id AS bestellung_id,
    b.bestelldatum
FROM bestellung b
WHERE b.bestelldatum = (
    SELECT MAX(b2.bestelldatum)
    FROM bestellung b2
    WHERE b2.kunde_id = b.kunde_id
);

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