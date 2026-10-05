WITH base AS (
    SELECT vorname, COUNT(*) AS anzahl
    FROM personen
    GROUP BY vorname
)
SELECT vorname,anzahl * 100.0 / (SELECT COUNT(*) FROM personen)
FROM base
ORDER BY 2 desc
;

WITH base AS (
    SELECT vorname, COUNT(*) AS anzahl
    FROM personen
    GROUP BY vorname
)
SELECT vorname,
       anzahl,
       anzahl * 100.0 / (SELECT COUNT(*) FROM personen) AS prozent
FROM base
ORDER BY anzahl DESC
LIMIT 10;

WITH base AS (
    SELECT vorname, COUNT(*) AS anzahl
    FROM personen
    GROUP BY vorname
)
SELECT COUNT(*)                      AS distinct_namen,
       SUM(anzahl)                   AS gesamt,
       100.0 / COUNT(*)              AS erwartet_prozent,
       MIN(anzahl)                   AS min_anzahl,
       MAX(anzahl)                   AS max_anzahl,
       AVG(anzahl)                   AS avg_anzahl,
       MAX(anzahl) * 1.0 / AVG(anzahl) AS max_zu_avg
FROM base;

