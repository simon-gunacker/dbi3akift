.headers on
.mode column

-- Wie viele unterschiedliche Namen gibt es?
SELECT  COUNT(DISTINCT vorname) AS versch_vornamen,
        COUNT(DISTINCT nachname) AS versch_nachnamen
FROM personen;

-- 10 häufigste Vornamen mit Prozentanteil
WITH vornamen_haeufigkeit AS (
    SELECT vorname, COUNT(*) AS anzahl
    FROM personen
    GROUP BY vorname
)
SELECT vorname, anzahl, ROUND(100.0 * anzahl / 500000, 3) AS Prozentanteil
FROM vornamen_haeufigkeit
ORDER BY anzahl DESC
LIMIT 10;

-- Wie gleichmäßig? Seltenster, häufigster, durchschnittlicher Vorname
WITH vornamen_haeufigkeit AS (
    SELECT vorname, COUNT(*) AS anzahl
    FROM personen
    GROUP BY vorname
)
SELECT  MIN(anzahl) AS seltenster,
        MAX(anzahl) AS haeufigster,
        ROUND(AVG(anzahl),1) AS durchschnitt
FROM vornamen_haeufigkeit;

-- 10 häufigste Nachnamen mit Prozentanteil
WITH nachnamen_haeufigkeit AS (
    SELECT nachname, COUNT(*) AS anzahl
    FROM personen
    GROUP BY nachname
)
SELECT nachname, anzahl, ROUND(100.0 * anzahl / 500000, 3) AS Prozentanteil
FROM nachnamen_haeufigkeit
ORDER BY anzahl DESC
LIMIT 10;

-- Wie gleichmäßig? Seltenster, häufigster, durchschnittlicher Nachname
WITH nachnamen_haeufigkeit AS (
    SELECT nachname, COUNT(*) AS anzahl
    FROM personen
    GROUP BY nachname
)
SELECT  MIN(anzahl) AS seltenster,
        MAX(anzahl) AS haeufigster,
        ROUND(AVG(anzahl),1) AS durchschnitt
FROM nachnamen_haeufigkeit;