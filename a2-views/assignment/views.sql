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
--View A Aufrufe = 10000 Zeit = 950.1127493749955sec

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
--View B Aufrufe = 10000 Zeit = 107.19593377198908sec


--man weiß nicht welche logik hinter dem view steckt -> keine Ahnung wie rechenintsiv die Abfrage ist
--und man weiß nicht wie die Abfage aufgebaut ist erschwert Fehlersuche 

--Kann man von außen erkennen, dass die beiden Views intern unterschiedlich effizient umgesetzt sind?
-- nö sieht von aussen ident aus

EXPLAIN QUERY PLAN
SELECT *
FROM letzte_bestellung_a
WHERE kunde_id = 42;

-- QUERY PLAN
-- |--SCAN b    -->vollständiger tabellen scan zeile für zeile
-- `--CORRELATED SCALAR SUBQUERY 3   -->für jede zeile in b wird eine unterabfrage ausgeführt
--    `--SEARCH b2





EXPLAIN QUERY PLAN
SELECT *
FROM letzte_bestellung_b
WHERE kunde_id = 42;

-- QUERY PLAN
-- |--CO-ROUTINE letzte
-- |  `--SCAN bestellung  -->erstllt co-routine mit einem vollständigen  tabellen scan asu
-- |--SCAN b -->vollständiger tabellen scan zeile für zeile
-- |--BLOOM FILTER ON letzte (kunde_id=?)  --> Bloom Filter vor. Das ist ein speicherbasierter Schnellfilter, der vorab prüft, ob eine gesuchte kunde_id überhaupt in der Co-Routine enthalten sein kann
-- `--SEARCH letzte USING AUTOMATIC PARTIAL COVERING INDEX (kunde_id=?)  -->da kein echter, permanenter Index existiert erstellt SQLite während der Abfrage im Arbeitsspeicher flüchtig einen eigenen Index dies kostet cpu zeit und ram ressouren



--nein kann  zwar eine abfrage zub schreiben vereinfachen um die gewünschten daten zu erhalten  aber die komplexität und perfomance muss trotzdem berücksichtigt werden