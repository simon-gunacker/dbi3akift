CREATE VIEW IF NOT EXISTS basic_data AS
SELECT id, vorname, nachname, email FROM  kunde;

SELECT bestellung.id AS bestellnumer
,bestellung.kunde_id AS kundennummer
,sum(produkt.preis * bestellposition.menge) AS gesamtwert
FROM bestellung
JOIN bestellposition on bestellung.id = bestellposition.bestellung_id
JOIN produkt on bestellposition.produkt_id = produkt.id
GROUP BY bestellung.id, bestellung.kunde_id;

select * from produkt;

select * from bestellposition;

CREATE VIEW IF NOT EXISTS sumvalue_orders AS
SELECT bestellung.id AS bestellnummer
,bestellung.kunde_id AS kundennummer
,sum(produkt.preis * bestellposition.menge) AS gesamtwert
FROM bestellung
JOIN bestellposition on bestellung.id = bestellposition.bestellung_id
JOIN produkt on bestellposition.produkt_id = produkt.id
GROUP BY bestellung.id, bestellung.kunde_id;

SELECT bestellung.id AS bestellnummer
,kunde.id AS kundennummer
,bestellung.bestelldatum AS bestelldatum
,bestellung.status AS bestellstatus, 
concat(kunde.vorname, ' ', kunde.nachname) kundenname
FROM bestellung
JOIN kunde ON bestellung.kunde_id = kunde.id
;

CREATE VIEW IF NOT EXISTS order_overview AS
SELECT bestellung.id AS bestellnummer
,kunde.id AS kundennummer
,bestellung.bestelldatum AS bestelldatum
,bestellung.status AS bestellstatus, 
concat(kunde.vorname, ' ', kunde.nachname) kundenname
FROM bestellung
JOIN kunde ON bestellung.kunde_id = kunde.id
;

SELECT * FROM order_overview WHERE bestellstatus = 'offen';

CREATE VIEW IF NOT EXISTS letzte_bestellung_a AS
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

CREATE VIEW IF NOT EXISTS letzte_bestellung_b AS
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

SELECT *
FROM letzte_bestellung_a
WHERE kunde_id = 42;

SELECT *
FROM letzte_bestellung_b
WHERE kunde_id = 42;

EXPLAIN QUERY PLAN
SELECT *
FROM letzte_bestellung_a
WHERE kunde_id = 42;

EXPLAIN QUERY PLAN
SELECT *
FROM letzte_bestellung_b
WHERE kunde_id = 42;

