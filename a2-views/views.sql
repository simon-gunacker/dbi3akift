DROP VIEW IF EXISTS letzte_bestellung_b;
DROP VIEW IF EXISTS letzte_bestellung_a;
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

-- Aufgabe 6:
CREATE VIEW letzte_bestellung_a AS
SELECT b.kunde_id, b.id AS bestellung_id, b.bestelldatum
FROM bestellung b
WHERE b.bestelldatum = (
        SELECT MAX(b2.bestelldatum)
        FROM bestellung b2
        WHERE b2.kunde_id = b.kunde_id
);

CREATE VIEW letzte_bestellung_b AS
SELECT b.kunde_id, b.id AS bestellung_id, b.bestelldatum
FROM bestellung b
JOIN (
        SELECT kunde_id, MAX(bestelldatum) AS bestelldatum
        FROM bestellung
        GROUP BY kunde_id
) letzte
ON letzte.kunde_id = b.kunde_id
AND letzte.bestelldatum = b.bestelldatum;