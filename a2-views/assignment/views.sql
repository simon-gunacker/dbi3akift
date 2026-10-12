-- 3. View für eine vereinfachte Sicht

CREATE VIEW kunde_offentlich AS
    SELECT
        id AS kunde_id,
        vorname,
        nachname,
        email
    FROM kunde;

    -- Datenschutz

-- 4. View mit zusammengefassten Daten

CREATE VIEW bestellwert AS
    SELECT b.id AS bestellung_id, b.kunde_id, SUM(bp.menge * p.preis) AS gesamtwert
    FROM bestellung b
    JOIN bestellposition bp ON b.id = bp.bestellung_id
    JOIN produkt p ON p.id = bp.produkt_id
    GROUP BY b.id, b.kunde_id;

    --Summarize

-- 5. View als vereinfachte Schnittstelle

CREATE VIEW vereinfachte_schnittstelle AS
    SELECT
        b.id AS bestellung_id,
        b.kunde_id,
        b.bestelldatum,
        b.status AS bestellungstatus,
        k.vorname,
        k.nachname
    FROM bestellung b
    JOIN kunde k ON k.id=b.kunde_id;

    -- Simplify

    -- vereinfachte Abfrage

    -- SELECT * FROM vereinfachte_schnittstelle
    -- WHERE bestellungsatus = 'on a break' AND vorname = 'Ross';

-- 6. Views und Performance

-- 6.1.a.

CREATE VIEW letzte_bestellung_a AS
    SELECT
        b.kunde_id,
        b.id AS bestellung_id,
        b.bestelldatum
    FROM bestellung b
    WHERE b.id <= 10000
    AND bestelldatum = (
        SELECT MAX(b2.bestelldatum)
        FROM bestellung b2
        WHERE b.kunde_id = b2.kunde_id
        AND b2.id <=10000);

-- 6.1.b letzte_bestellung_b

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
        WHERE id <= 10000
        GROUP BY kunde_id
    ) letzte
        ON letzte.kunde_id = b.kunde_id
        AND letzte.bestelldatum = b.bestelldatum
        WHERE b.id <= 10000;
