CREATE VIEW view_kunde AS
SELECT 
    id AS kundennummer
    ,vorname
    ,nachname
    ,email
FROM kunde;
--eingeschränkter datenzugriff (Datenschutz)


CREATE VIEW view_bestellung_gesamtwert AS
SELECT 
    b.id AS bestellnummer
    ,b.kunde_id AS kundennummer
    ,SUM(bp.menge * p.preis) AS gesamtwert
FROM bestellung b
JOIN bestellposition bp ON b.id = bp.bestellung_id
JOIN product p ON bp.produkt_id = p.id
GROUP BY b.id, b.kunde_id;

CREATE VIEW view_vereinfachte_schnittstelle AS
SELECT 
     b.id AS bestellnummer
    ,k.id AS kundennummer
    ,b.bestelldatum
    ,b.status AS bestellstatus
    ,k.vorname 
    ,k.nachname
FROM bestellung b
JOIN kunde k ON b.kunde_id= k.id;



--veinfachte Abfrage
SELECT *
FROM view_vereinfachte_schnittstelle
WHERE bestellstatus= 'Zugestellt / Abgeholt'
AND  vorname='Simon';

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
);

SELECT *
FROM letzte_bestellung_a
WHERE kunde_id = 42;
--42|5212|2026-07-17 06:53:10

--View A Aufrufe = 1000 Zeit = 93.4351860480092sec

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
   AND letzte.bestelldatum = b.bestelldatum;


SELECT *
FROM letzte_bestellung_b
WHERE kunde_id = 42;
--42|5212|2026-07-17 06:53:10

-- View B Aufrufe = 1000 Zeit = 10.218509223981528sec
