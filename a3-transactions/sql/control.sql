-- Min stock
SELECT id, name, kategorie, lagerbestand, mindestbestand
FROM artikel
WHERE lagerbestand < mindestbestand;

-- Check credit
SELECT id, name, kreditlimit, aktueller_kredit, 
    ROUND((aktueller_kredit * 100.0 / kreditlimit), 2) AS utilization
FROM kunde
WHERE kreditlimit > 0 AND (aktueller_kredit * 1.0 / kreditlimit) >= 0.9;

-- Today's revenue
SELECT COUNT(id) SUM(gesamtwert)
FROM bestellung
WHERE status = 'verarbeitet' 
AND DATE(datum) = DATE('now');

-- Check inventory
SELECT 
    a.id, 
    a.name, 
    a.lagerbestand
    SUM(lb.menge) AS movement_sum
FROM artikel a
LEFT JOIN lagerbewegung lb ON a.id = lb.artikel_id
GROUP BY a.id, a.name, a.lagerbestand;
