PRAGMA foreign_keys = ON;
PRAGMA journal_mode = DELETE;

-- Kunde: MakerSpace Graz (ID = 2)
-- Artikel: 40 x Raspberry Pi (ID = 2)
--          50 x Arduino Uno (ID = 1)
BEGIN TRANSACTION;

-- create the order-id
INSERT INTO bestellung (kunde_id)
VALUES (2)
;

-- create the order positions, using the current highest order id
INSERT INTO bestellposition (
    bestellung_id,
    artikel_id,
    menge,
    einzelpreis
    )
SELECT
    (SELECT MAX(id) FROM bestellung),
    id,
    40,
    verkaufspreis
FROM artikel
WHERE id = 2  -- Raspberry Pi 4
;

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
    50,
    verkaufspreis
FROM artikel
WHERE id = 1 -- Arduino Uno
;


-- Reduce stock
UPDATE artikel
SET lagerbestand = lagerbestand - 50
WHERE id = 1 -- Arduino Uno
;

UPDATE artikel
SET lagerbestand = lagerbestand - 40
WHERE id = 2 -- Raspberry Pi 4
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
WHERE id = 2 -- MakerSpace Graz
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