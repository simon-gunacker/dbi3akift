PRAGMA foreign_keys = ON;
PRAGMA journal_mode = DELETE;

-- Kunde: TechShop Wien (ID=1)
-- Artikel: 5x Arduino Uno, 2x Raspberry Pi 4, 50x LED rot
BEGIN TRANSACTION;

-- create the order-id
INSERT INTO bestellung (kunde_id)
VALUES (1)
;

-- create the order positions, using the current highest order id
-- creates the Arduino Uno order position
INSERT INTO bestellposition (
    bestellung_id,
    artikel_id,
    menge,
    einzelpreis
    )
SELECT
    (SELECT MAX(id) FROM bestellung),
    id,
    5,
    verkaufspreis
FROM artikel
WHERE id = 1  -- ID 1 = Arduino Uno
;

-- creates the Raspberry Pi 4 order position
INSERT INTO bestellposition (
    bestellung_id,
    artikel_id,
    menge,
    einzelpreis
)
SELECT
    (SELECT MAX(id) FROM bestellung),
    id,
    2,
    verkaufspreis
FROM artikel
WHERE id = 2  -- ID 2 = Raspberry Pi 4
;

-- creates the LED 5mm rot order positions
INSERT INTO bestellposition (
    bestellung_id,
    artikel_id,
    menge,
    einzelpreis
)
SELECT
    (SELECT MAX(id) FROM bestellung),
    id,
    50,
    verkaufspreis
FROM artikel
WHERE id = 3  -- ID 3 = LED 5mm rot
;

-- Reduce stock
UPDATE artikel
SET lagerbestand = lagerbestand - 5
WHERE id = 1 -- Arduino Uno
;

UPDATE artikel
SET lagerbestand = lagerbestand - 2
WHERE id = 2 -- Raspberry Pi 4
; 

UPDATE artikel
SET lagerbestand = lagerbestand - 50
WHERE id = 3 --LED 5mm rot
;

-- Calculate and set total value
UPDATE bestellung
SET gesamtwert = (
    -- Goes over all positions from latest order, sums up the price of everything
    SELECT SUM(menge * einzelpreis) -- statement in brackets happens per row, SUM happens at the end
    FROM bestellposition
    WHERE bestellung_id = (SELECT MAX(id) FROM bestellung)
)
WHERE id = (SELECT MAX(id) FROM bestellung)
;

-- Increase customer credit
UPDATE kunde 
SET aktueller_kredit = aktueller_kredit + (
    SELECT gesamtwert
    FROM bestellung
    WHERE id = (SELECT MAX(id) FROM bestellung)
)
WHERE id = 1 -- ID 1 = TechShop Wien
;

-- Log stock movements
INSERT INTO lagerbewegung (
    artikel_id,
    bestellung_id, 
    menge, 
    typ
)
SELECT 
    artikel_id, 
    bestellung_id,
    - menge, -- negative, since outgoing movement
    'verkauf'
FROM bestellposition -- using this table so we get all ordered items
WHERE bestellung_id = (SELECT MAX(id) FROM bestellung)
;


COMMIT;