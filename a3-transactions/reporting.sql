-- Find articles that need to be reordered
SELECT
    id,
    name,
    lagerbestand,
    mindestbestand
FROM artikel
WHERE lagerbestand < mindestbestand;


-- Find customers who have used more than 90% of their credit limit
SELECT
    id,
    name,
    aktueller_kredit,
    kreditlimit
FROM kunde
WHERE aktueller_kredit > (kreditlimit * 90 / 100);


-- Calculate today's sales (Tagesumsatz)
SELECT
    SUM(gesamtwert) AS tagesumsatz
FROM bestellung
WHERE status = 'verarbeitet'
AND DATE(datum) = DATE(CURRENT_TIMESTAMP);


-- Show the total stock movements for each article
SELECT
    artikel_id,
    SUM(menge) AS gesamte_bewegung
FROM lagerbewegung
GROUP BY artikel_id;


-- Calculate the original inventory based on the movements
SELECT
    a.id,
    a.name,
    a.lagerbestand AS aktueller_bestand,
    SUM(l.menge) AS lagerbewegungen,
    a.lagerbestand - SUM(l.menge) AS start_bestand
FROM artikel a
JOIN lagerbewegung l
    ON a.id = l.artikel_id
GROUP BY a.id;

-- Reporting test:
-- I changed the following directly in the sqlite shell to test the reports:
--
-- UPDATE artikel
-- SET lagerbestand = 3
-- WHERE id = 5;
--
-- UPDATE kunde
-- SET aktueller_kredit = 4600
-- WHERE id = 1;
--
-- Results:

-- Choose an assignment task:
-- 1 - Einfache Bestellung
-- 2 - Validierung Lagerbestand
-- 3 - Validierung Kreditlimit
-- 4 - Stornierung
-- 5 - Reporting und Konsistenzprüfung
-- Select task: 5
-- ['id', 'name', 'lagerbestand', 'mindestbestand']
-- (5, 'Breadboard', 3, 5)
-- ['id', 'name', 'aktueller_kredit', 'kreditlimit']
-- (1, 'TechShop Wien', 4600, 5000)
-- ['tagesumsatz']
-- (287.5,)
-- ['artikel_id', 'gesamte_bewegung']
-- (1, -5)
-- (2, -2)
-- (3, -50)
-- ['id', 'name', 'aktueller_bestand', 'lagerbewegungen', 'start_bestand']
-- (1, 'Arduino Uno', 95, -5, 100)
-- (2, 'Raspberry Pi 4', 48, -2, 50)
-- (3, 'LED 5mm rot', 950, -50, 1000)

-- Breadboard appears because its stock is below the minimum.
-- TechShop Wien appears because 92% of its credit limit is used.
-- Today's sales show 287.5.
