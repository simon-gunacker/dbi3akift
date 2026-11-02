PRAGMA foreign_keys = ON;
PRAGMA journal_mode = DELETE;

-- Reverse the order of TechShop Wien we used in Transaction earlier

BEGIN TRANSACTION;

-- Change bestellstatus to 'storniert'
UPDATE bestellung 
SET status = 'storniert'
WHERE id = (SELECT MAX(id) FROM bestellung)
;

-- Put the wares back:
UPDATE artikel 
SET lagerbestand = lagerbestand + 5 
WHERE id = 1 -- Arduino Uno
;

UPDATE artikel
SET lagerbestand = lagerbestand + 2
WHERE id = 2 -- Raspberry Pi 4
; 

UPDATE artikel
SET lagerbestand = lagerbestand + 50
WHERE id = 3 --LED 5mm rot
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
;

-- Reset costumer credit
UPDATE kunde 
SET aktueller_kredit = aktueller_kredit - (
    SELECT gesamtwert 
    FROM bestellung 
    WHERE id = (SELECT MAX(id) FROM bestellung)
)
WHERE id = 1 -- TechShop Wien
;

COMMIT;