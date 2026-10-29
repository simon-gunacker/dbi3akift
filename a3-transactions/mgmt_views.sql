CREATE VIEW v_artikel_nachbestellung AS
SELECT 
    id 
    ,name
    ,lagerbestand
    ,mindestbestand
    ,(mindestbestand - lagerbestand) AS zubestellende_menge 
FROM artikel
WHERE lagerbestand < mindestbestand;

CREATE VIEW v_kunden_kreditlimit AS
SELECT 
    id AS kunde_id
    ,name
    ,kreditlimit
    ,aktueller_kredit
    ,ROUND((aktueller_kredit * 100.0) / kreditlimit, 2) AS kreditlimit_prozent
FROM kunde
WHERE kreditlimit > 0 
    AND (aktueller_kredit * 1.0 / kreditlimit) > 0.90;

CREATE VIEW v_tagesumsatz AS
SELECT 
     DATE(datum)
    ,SUM(gesamtwert) AS tagesumsatz
FROM bestellung
WHERE DATE(datum)= DATE('now')
    AND status != 'storniert';

CREATE VIEW v_lager_konsistenz AS
SELECT
id
,name
,ist_bestand
,(start_bestand + sum_bewegungen) AS soll_bestand
FROM(
    SELECT 
    a.id
    ,a.name
    ,a.lagerbestand  AS ist_bestand
    ,CASE a.id
        WHEN 1 THEN 100 --ARDUINO
        WHEN 2 THEN 50 --RASPI
        WHEN 3 THEN 1000 --LED
        WHEN 4 THEN 5000 --Widerstand
        WHEN 5 THEN 30 --Breadboard
        ELSE 0
    END AS start_bestand  
    ,COALESCE(SUM(lb.menge),0) AS sum_bewegungen--COALESCE fängt  null ab und wandelt es in 0 um,um  die brechnung zu gewährleisten
FROM artikel a 
LEFT JOIN lagerbewegung lb ON a.id =lb.artikel_id
GROUP BY a.id
)AS subquery;
-- test
