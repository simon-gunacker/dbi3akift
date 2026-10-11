DROP VIEW IF EXISTS informationen_pro_bestellung;
DROP VIEW IF EXISTS gesamtwert_pro_bestellung;
DROP VIEW IF EXISTS kunde_informationen;

-- Aufgabe 3
CREATE VIEW kunde_informationen AS
SELECT id, vorname, nachname, email
FROM kunde;

-- Aufgabe 4
CREATE VIEW gesamtwert_pro_bestellung AS
SELECT b.id AS Bestellung_Nr, b.kunde_id AS Kunde_ID, SUM(p.preis * bp.menge) AS Gesamtwert
FROM bestellung b
INNER JOIN bestellposition bp ON b.id = bp.bestellung_id
INNER JOIN produkt p ON bp.produkt_id = p.id
GROUP BY b.id
ORDER BY b.id ASC
;

-- Aufgabe 5: bestellung und kunde
CREATE VIEW informationen_pro_bestellung AS
SELECT b.id AS Bestellung_Nr, b.kunde_id AS Kunde_ID, b.bestelldatum AS Bestelldatum, b.status AS Status,
        k.vorname AS Vorname, k.nachname AS Nachname
FROM kunde k
INNER JOIN bestellung b ON b.kunde_id = k.id
;