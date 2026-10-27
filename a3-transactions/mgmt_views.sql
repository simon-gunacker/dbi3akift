CREATE VIEW v_artikel_nachbestellung AS
SELECT 
    id 
    ,name
    ,lagerbestand
    ,mindestbestand
FROM artikel
WHERE lagerbestand < mindestbestand;

CREATE VIEW v_kunden_kreditlimit AS
SELECT 
SELECT 
    id AS kunde_id
    ,name
    ,kreditlimit
    ,aktueller_kredit
    ,ROUND((aktueller_kredit * 100.0) / kreditlimit, 2) AS kreditlimit_prozent
FROM kunde
WHERE kreditlimit > 0 
  AND (aktueller_kredit * 1.0 / kreditlimit) > 0.90;