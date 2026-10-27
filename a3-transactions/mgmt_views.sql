CREATE VIEW v_artikel_nachbestellung AS
SELECT 
    id 
    ,name
    ,lagerbestand
    ,mindestbestand
FROM artikel
WHERE lagerbestand < mindestbestand;