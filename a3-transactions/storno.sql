PRAGMA foreign_keys = ON;
PRAGMA journal_mode = DELETE;

-- Reverse the order of TechShop Wien we used in Transaction earlier

BEGIN TRANSACTION;

-- Put the wares back:
UPDATE artikel 
SET lagerbestand = lagerbestand + 5 
WHERE id = 1 -- Arduino Uno
-- Checks if the order has not already been marked as 'storniert'
AND (SELECT status
    FROM bestellung
    WHERE id = (SELECT MAX(id)
                FROM bestellung)
    ) != 'storniert'
;

UPDATE artikel
SET lagerbestand = lagerbestand + 2
WHERE id = 2 -- Raspberry Pi 4
AND (SELECT status
    FROM bestellung
    WHERE id = (SELECT MAX(id)
                FROM bestellung)
    ) != 'storniert'
; 

UPDATE artikel
SET lagerbestand = lagerbestand + 50
WHERE id = 3 --LED 5mm rot
AND (SELECT status
    FROM bestellung
    WHERE id = (SELECT MAX(id)
                FROM bestellung)
    ) != 'storniert'
;

-- document the movement of the wares
INSERT INTO lagerbewegung (
    artikel_id, 
    bestellung_id, 
    menge, 
    typ
)
SELECT 
    artikel_id, 
    bestellung_id, 
    menge,
    'storno'
FROM bestellposition
WHERE bestellung_id = (SELECT MAX(id) FROM bestellung)
AND (SELECT status
    FROM bestellung
    WHERE id = (SELECT MAX(id)
                FROM bestellung)
    ) != 'storniert'
;

-- Reset costumer credit
UPDATE kunde 
SET aktueller_kredit = aktueller_kredit - (
    SELECT gesamtwert 
    FROM bestellung 
    WHERE id = (SELECT MAX(id) FROM bestellung)
)
WHERE id = 1 -- TechShop Wien
AND (SELECT status
    FROM bestellung
    WHERE id = (SELECT MAX(id) FROM bestellung)
    ) != 'storniert'
;

-- Change bestellstatus to 'storniert'
-- Change status at the end, so the queries before can check for orders that aren't
-- marked as 'storniert' yet
UPDATE bestellung 
SET status = 'storniert'
WHERE id = (SELECT MAX(id) FROM bestellung)
;

COMMIT;