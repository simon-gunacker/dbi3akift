BEGIN TRANSACTION;

-- Create an order for MakerSpace Graz
INSERT INTO bestellung (kunde_id)
VALUES (2);

-- Add 50 Breadboards to the order
INSERT INTO bestellposition (
    bestellung_id, artikel_id, menge, einzelpreis
)
SELECT
    (SELECT MAX(id) FROM bestellung),  -- use the current highest order id
    id,
    50,
    verkaufspreis
FROM artikel
WHERE id = 5;

-- Try to reduce the stock by 50
-- should fail because only 30 Breadboards are available
UPDATE artikel
SET lagerbestand = lagerbestand - 50
WHERE id = 5;

-- Calculate the order total
UPDATE bestellung
SET gesamtwert = (
    SELECT SUM(menge * einzelpreis)
    FROM bestellposition
    WHERE bestellung_id = (SELECT MAX(id) FROM bestellung)
)
WHERE id = (SELECT MAX(id) FROM bestellung);

-- Increase customer credit
UPDATE kunde
SET aktueller_kredit = aktueller_kredit + (
    SELECT gesamtwert
    FROM bestellung
    WHERE id = (SELECT MAX(id) FROM bestellung)
)
WHERE id = 2;

COMMIT;
