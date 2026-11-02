BEGIN TRANSACTION;

-- neue Bestellung anlegen
INSERT INTO bestellung (kunde_id, status)
VALUES (1, 'offen');

-- ID der Bestellung als "current_order_id" speichern
SELECT MAX(id) AS current_order_id
FROM bestellung;

-------------------------------------------------------
--Bestellpositionen anlegen
-- Arduino Uno
INSERT INTO bestellposition
VALUES (current_order_id, 1, 5, 25.00)

-- Raspberry Pi 4
INSERT INTO bestellposition
VALUES (current_order_id, 2, 2, 75.00)

-- LED rot
INSERT INTO bestellposition
VALUES (current_order_id, 3, 50, 0.25)

-------------------------------------------------------
-- Lagerbestand verändern
-- Arduino Uno
UPDATE artikel
SET lagerbestand = lagebestand - 5
WHERE id = 1;

-- Raspberry Pi 4
UPDATE artikel
SET lagerbestand = lagebestand - 2
WHERE id = 2;

-- LED rot
UPDATE artikel
SET lagerbestand = lagebestand - 50
WHERE id = 3;

-------------------------------------------------------

END;