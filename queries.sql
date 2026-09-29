-- enter seperately before starting queries
.headers ON
.timer ON
.mode column

-- Statement to create index
CREATE INDEX idx_vorname
ON personen(vorname);

-- Statement to remove index
DROP INDEX idx_vorname;

-- Statement to count how often each name appears
SELECT 
    vorname, 
    COUNT(*) AS total
FROM personen
GROUP BY vorname;

-- Query to show the relatve frequenciy of each name
WITH nameCounts AS (
    SELECT
        vorname,
        COUNT(*) AS total
    FROM personen
    GROUP BY vorname
)
SELECT
    vorname,
    total,
    -- OVER () makes SQL keep the table rows instead of merging them into one
    ROUND(total * 100.0 / SUM(total) OVER (), 3) AS prozent
FROM nameCounts
ORDER BY total DESC;

-- Query to calculate the Variance
WITH nameCounts AS (
    SELECT
        vorname,
        COUNT(*) AS total
    FROM personen
    GROUP BY vorname
)
SELECT
    AVG(total) AS avg, 
    MIN(total) AS min, 
    MAX(total) AS max, 
    -- can't use just created variables in the calculation in the same statement
    ROUND(AVG(total * total) - AVG(total) * AVG(total), 3) AS var
FROM nameCounts;
    



