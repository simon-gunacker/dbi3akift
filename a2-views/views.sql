-- erste View

CREATE VIEW IF NOT EXISTS kunden_oeffentlich AS
SELECT id, vorname, nachname, email
FROM kunde;

-- Vorteil: kann wiederverwendet werden, um die Daten zu filtern, ohne die Originaltabellen zu verändern.
-- Kann auch für Datenschutz und Sicherheit verwendet werden, indem nur bestimmte Spalten für die Öffentlichkeit zugänglich gemacht werden.


-- zweite View
CREATE VIEW IF NOT EXISTS bestellwert AS
SELECT
    b.id AS bestallung_id,
    b.kunde_id,
    SUM(p.preis * bp.menge) AS gesamtwert
FROM bestellung b
JOIN bestellposition bp ON b.id = bp.bestellung_id
JOIN produkt p ON bp.produkt_id = p.id
GROUP BY b.id, b.kunde_id;

-- drittes View

CREATE VIEW IF NOT EXISTS bestellungen_mit_kunden AS
SELECT
    b.id AS bestellung_id,
    b.kunde_id,
    k.vorname,
    k.nachname,
    b.bestelldatum,
    b.status
FROM bestellung b
JOIN kunde k ON b.kunde_id = k.id;

-- vierte View
CREATE VIEW IF NOT EXISTS letzte_bestellung_a AS
SELECT
    b.kunde_id,
    b.id AS bestellung_id,
    b.bestelldatum
FROM bestellung b
WHERE b.id <= 10000 AND b.bestelldatum = (
    SELECT MAX(bestelldatum)
    FROM bestellung b2
    WHERE b2.kunde_id = b.kunde_id
    AND b2.id <= 10000
);

CREATE VIEW IF NOT EXISTS letzte_bestellung_b AS
SELECT
    b.kunde_id,
    b.id AS bestellung_id,
    b.bestelldatum
    FROM bestellung b
JOIN(
    SELECT kunde_id, MAX(bestelldatum) AS bestelldatum
    FROM bestellung
    WHERE id <= 10000
    GROUP BY kunde_id
) letzte
    ON letzte.kunde_id = b.kunde_id AND letzte.bestelldatum = b.bestelldatum
    WHERE b.id <= 10000;