CREATE VIEW kunden_short AS
    SELECT id, vorname, nachname, email
    FROM kunde
;


CREATE VIEW order_total AS
    SELECT
        best.id,
        best.kunde_id,
        SUM(bestpos.menge * prod.preis) AS total
    FROM bestellung best
    JOIN bestellposition bestpos
        ON bestpos.bestellung_id = best.id
    JOIN produkt prod
        ON bestpos.produkt_id = prod.id
    GROUP BY best.id, best.kunde_id
;

CREATE VIEW order_overview AS
    SELECT 
        best.id AS bestellung_id, 
        cons.id AS kunde_id,
        best.bestelldatum, 
        best.status, 
        cons.vorname, 
        cons.nachname
    FROM bestellung best
    JOIN kunde cons 
        ON cons.id = best.kunde_id
;

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
;

CREATE VIEW AS letzte_bestellung_b AS
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
;