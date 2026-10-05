-- Settings
.headers on
.mode column
.timer on

-- ### Distribution ###

WITH name_counts AS (
    SELECT first_name, COUNT(*) AS freq
    FROM persons
    GROUP BY first_name
),
total AS (
    SELECT COUNT(*) AS total_rows
    FROM persons
)
SELECT
    nc.first_name,
    nc.freq,
    ROUND((CAST(nc.freq AS FLOAT) / t.total_rows) * 100, 2) AS relative_percentage
FROM name_counts nc, total t
ORDER BY nc.freq DESC
LIMIT 20;

-- Results:

-- first_name   freq   relative_percentage
-- -----------  -----  -------------------
-- Michael      11542  2.31               
-- David        7939   1.59               
-- James        7443   1.49               
-- Jennifer     7368   1.47               
-- John         7335   1.47               
-- Christopher  6913   1.38               
-- Robert       6830   1.37               
-- Jessica      5162   1.03               
-- Matthew      5093   1.02               
-- William      5027   1.01               
-- Joseph       4786   0.96               
-- Lisa         4750   0.95               
-- Daniel       4660   0.93               
-- Brian        4180   0.84               
-- Kimberly     4120   0.82               
-- Jason        3868   0.77               
-- Michelle     3844   0.77               
-- Amanda       3831   0.77               
-- Ashley       3796   0.76               
-- Elizabeth    3770   0.75               
-- Run Time: real 0.048 user 0.039629 sys 0.008192

------------------------------------------------------------------------------
-- ### Indexed & Unindexed ###

-- Unindexed
SELECT * FROM persons WHERE first_name = 'Anna';
-- DB Size: 11M
-- Search result for Anna: <Run Time: real 0.058 user 0.046865 sys 0.005283>

-- Indexed
CREATE INDEX idx_persons_first_name ON persons(first_name);
-- DB size: 18M
-- Search result for Anna: <Run Time: real 0.008 user 0.000123 sys 0.008036>
-- Difference: Real: -0,05, User: -0.046742, Sys: -0.002753

------------------------------------------------------------------------------

-- ### Bias ###

-- Second table bias =========================================================
CREATE TABLE persons_biased (
    id INTEGER PRIMARY KEY,
    first_name TEXT,
    last_name TEXT
);

INSERT INTO persons_biased (first_name, last_name)
SELECT 'Max', last_name FROM persons LIMIT 250000;

INSERT INTO persons_biased (first_name, last_name)
SELECT first_name, last_name FROM persons LIMIT 250000;
-- ===========================================================================

CREATE INDEX idx_biased_first_name ON persons_biased(first_name);

SELECT * FROM persons_biased WHERE first_name = 'Anna';
-- Search results: <Run Time: real 0.005 user 0.004795 sys 0.000546>
SELECT * FROM persons_biased WHERE first_name = 'Max';
-- Search results: Run Time: real 0.691 user 0.238792 sys 0.387872
