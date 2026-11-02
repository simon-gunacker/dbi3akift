-- Artikel unter Mindestbestand
SELECT * AS nachzubestellen
FROM artikel
WHERE lagerbestand < mindestbestand;

-- Kunden nahe dem Kreditlimit
SELECT * AS limit_fast-ausgeschöpft
FROM kunde
WHERE aktueller_kredit >= (kreditlimit * 0.9);

-- Tagesumsatz

SELECT SUM(gesamtwert) AS Tagesumsatz
FROM bestellung
WHERE DATE(datum) = DATE('now', 'localtime')
AND status = 'verarbeitet';

-- Konsistenzprüfung
-- Arduino Uno
SELECT *
FROM artikel
WHERE id = 1
AND lagerbestand - (
    SELECT SUM(menge)
    FROM lagerbewegung
    WHERE artikel_id = 1
) != 100;

-- Raspberry Pi 4
SELECT *
FROM artikel
WHERE id = 2
AND lagerbestand - (
    SELECT SUM(menge)
    FROM lagerbewegung
    WHERE artikel_id = 2
) != 50;

-- LED 5mm rot
SELECT *
FROM artikel
WHERE id = 3
AND lagerbestand - (
    SELECT SUM(menge)
    FROM lagerbewegung
    WHERE artikel_id = 3
) != 1000;

-- Widerstand 220Ω
SELECT *
FROM artikel
WHERE id = 4
AND lagerbestand - (
    SELECT SUM(menge)
    FROM lagerbewegung
    WHERE artikel_id = 4
) != 5000;

-- Breadboard
SELECT *
FROM artikel
WHERE id = 5
AND lagerbestand - (
    SELECT SUM(menge)
    FROM lagerbewegung
    WHERE artikel_id = 5
) != 30;