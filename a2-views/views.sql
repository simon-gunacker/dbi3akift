DROP VIEW IF EXISTS kundenview;
DROP VIEW IF EXISTS bestellungsgesamtwertview;

CREATE VIEW kundenview AS
SELECT id, vorname, nachname, email
FROM kunde;

CREATE VIEW bestellungsgesamtwertview AS
SELECT b.id AS bestellnummer, b.kunde_id AS kundennummer, SUM(bp.menge * p.preis) AS gesamtpreis FROM bestellposition bp
JOIN bestellung b ON bp.bestellung_id = b.id
JOIN produkt p ON bp.produkt_id = p.id
GROUP BY b.id;