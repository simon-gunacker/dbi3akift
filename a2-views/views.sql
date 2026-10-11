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