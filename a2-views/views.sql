DROP VIEW IF EXISTS letzte_bestellung_a;
DROP VIEW IF EXISTS letzte_bestellung_b;


DROP VIEW IF EXISTS kundenview;
DROP VIEW IF EXISTS bestellungsgesamtwertview;
DROP VIEW IF EXISTS bestellview;

CREATE VIEW kundenview AS
SELECT id, vorname, nachname, email
FROM kunde;

CREATE VIEW bestellungsgesamtwertview AS
SELECT b.id AS bestellnummer, b.kunde_id AS kundennummer, SUM(bp.menge * p.preis) AS gesamtpreis FROM bestellposition bp
JOIN bestellung b ON bp.bestellung_id = b.id
JOIN produkt p ON bp.produkt_id = p.id
GROUP BY b.id;

CREATE VIEW bestellview AS
SELECT b.kunde_id AS kundennummer, k.vorname AS kundenvorname, k.nachname AS kundennachname, b.id AS bestellnummer, b.bestelldatum AS bestelldatum, b.status AS bestellstatus FROM bestellung b
LEFT JOIN kunde k ON b.kunde_id = k.id;

/*
SELECT kundenvorname, kundennachname, bestellnummer FROM bestellview
WHERE bestellstatus LIKE 'in Bearbeitung';
*/

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
)
LIMIT 10000;

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
   AND letzte.bestelldatum = b.bestelldatum
LIMIT 10000;
 
/*
SELECT * FROM letzte_bestellung_a 
EXCEPT
SELECT * FROM letzte_bestellung_b;
*/