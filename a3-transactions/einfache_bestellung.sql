BEGIN TRANSACTION;

-- Create a new order for TechShop Wien (customer ID 1)
INSERT INTO bestellung (kunde_id)
VALUES (1);


-- Insert order positions

-- 5x Arduino Uno
INSERT INTO bestellposition (
    bestellung_id, artikel_id, menge, einzelpreis
)
SELECT
    (SELECT MAX(id) FROM bestellung),
    id,
    5,
    verkaufspreis
FROM artikel
WHERE id = 1;

-- 2x Raspberry Pi 4
INSERT INTO bestellposition (
    bestellung_id, artikel_id, menge, einzelpreis
)
SELECT
    (SELECT MAX(id) FROM bestellung),
    id,
    2,
    verkaufspreis
FROM artikel
WHERE id = 2;

-- 50x LED 5mm rot
INSERT INTO bestellposition (
    bestellung_id, artikel_id, menge, einzelpreis
)
SELECT
    (SELECT MAX(id) FROM bestellung),
    id,
    50,
    verkaufspreis
FROM artikel
WHERE id = 3;


-- Reduce inventory
UPDATE artikel
SET lagerbestand = lagerbestand - 5
WHERE id = 1;

UPDATE artikel
SET lagerbestand = lagerbestand - 2
WHERE id = 2;

UPDATE artikel
SET lagerbestand = lagerbestand - 50
WHERE id = 3;


-- Calculate and save the order total
UPDATE bestellung
SET gesamtwert = (
    SELECT SUM(menge * einzelpreis)
    FROM bestellposition
    WHERE bestellung_id = (SELECT MAX(id) FROM bestellung)
)
WHERE id = (SELECT MAX(id) FROM bestellung);


-- increase customer credit
UPDATE kunde
SET aktueller_kredit = aktueller_kredit + (
    SELECT gesamtwert
    FROM bestellung
    WHERE id = (SELECT MAX(id) FROM bestellung)
)
WHERE id = 1;


-- record inventory movement
INSERT INTO lagerbewegung (
    artikel_id, bestellung_id, menge, typ
)
SELECT
    artikel_id,
    bestellung_id,
    -menge,
    'verkauf'
FROM bestellposition
WHERE bestellung_id = (SELECT MAX(id) FROM bestellung);


-- Mark the order as processed
UPDATE bestellung
SET status = 'verarbeitet'
WHERE id = (SELECT MAX(id) FROM bestellung);


COMMIT;
