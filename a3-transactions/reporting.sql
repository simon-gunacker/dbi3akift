PRAGMA foreign_keys = ON;

SELECT id, name, lagerbestand, mindestbestand
FROM artikel
WHERE lagerbestand <=  mindestbestand
;

SELECT id, name, aktueller_kredit, kreditlimit
FROM kunde
WHERE (kreditlimit * 0.9) < aktueller_kredit
;

SELECT SUM(gesamtwert)
FROM bestellung 
WHERE status != 'storniert'
AND date(datum) = date('now')
;

SELECT
    a.id, 
    a.name, 
    a.lagerbestand, 
    SUM(l.menge) AS Bewegungen, 
    a.lagerbestand - SUM(l.menge) AS Startbestand
FROM artikel a 
JOIN lagerbewegung l 
    ON l.artikel_id = a.id
GROUP BY a.id
;



