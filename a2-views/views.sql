CREATE VIEW IF NOT EXISTS gesamtpreis_bestellung AS
SELECT
    sum(p.preis * bp.menge) AS gesamtpreis,
    k.id as kunde_id,
    bp.bestellung_id
FROM bestellposition as bp
LEFT JOIN produkt AS p ON
    bp.produkt_id = p.id
LEFT JOIN bestellung AS b ON
    bp.bestellung_id = b.id
LEFT JOIN kunde AS k ON
    b.kunde_id = k.id
GROUP BY bp.bestellung_id;


CREATE VIEW IF NOT EXISTS bestellung_view AS
SELECT
    b.id as bestellung_id,
    k.id as kunde_id,
    b.bestelldatum,
    b.status,
    k.vorname,
    k.nachname
FROM bestellung as b
LEFT JOIN kunde AS k ON
    b.kunde_id = k.id;


CREATE VIEW IF NOT EXISTS join_view AS
SELECT
    *
FROM bestellposition as bp
LEFT JOIN produkt AS p ON
    bp.produkt_id = p.id
LEFT JOIN bestellung AS b ON
    bp.bestellung_id = b.id
LEFT JOIN kunde AS k ON
    b.kunde_id = k.id;

CREATE VIEW IF NOT EXISTS subselect_view_a AS
SELECT
    b.kunde_id,
    b.id AS bestellung_id,
    b.bestelldatum
FROM bestellung b
WHERE b.bestelldatum = (
    SELECT MAX(b2.bestelldatum)
    FROM bestellung b2
    WHERE b2.kunde_id = b.kunde_id
    LIMIT 10000
);


CREATE VIEW IF NOT EXISTS joinselect_view_b AS
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
    LIMIT 10000
    ) letzte
        ON letzte.kunde_id = b.kunde_id
        AND letzte.bestelldatum = b.bestelldatum;
