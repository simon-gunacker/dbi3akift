SELECT id, name
FROM artikel
WHERE lagerbestand < mindestbestand;

SELECT id, name
FROM kunde
WHERE kreditlimit * 0.9 <= aktueller_kredit;

SELECT SUM(lb.menge * a.verkaufspreis)
FROM lagerbestand as lb
JOIN artikel on a.id = lb.artikel_id
WHERE lb.datum = CURRENT_DATE;

WITH total_amount AS (
    SELECT SUM(menge) as amount, artikel_id
    FROM lagerbewegung
    GROUP BY artikel_id
)
SELECT a.id
FROM artikel as a
JOIN total_amount as ta ON ta.artikel_id = a.id
WHERE ta.amount != a.lagerbestand;
