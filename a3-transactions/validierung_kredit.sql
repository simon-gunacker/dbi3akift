
-- Credit limit exceeded test

BEGIN TRANSACTION;

-- create order for MakerSpace Graz
INSERT INTO bestellung (kunde_id)
VALUES (2);

-- add 30 Raspberry Pi 4 units
INSERT INTO bestellposition (
    bestellung_id, artikel_id, menge, einzelpreis
)
SELECT
    (SELECT MAX(id) FROM bestellung),
    id,
    30,
    verkaufspreis
FROM artikel
WHERE id = 2;

-- reduce inventory
UPDATE artikel
SET lagerbestand = lagerbestand - 30
WHERE id = 2;

-- calculate order total
UPDATE bestellung
SET gesamtwert = (
    SELECT SUM(menge * einzelpreis)
    FROM bestellposition
    WHERE bestellung_id = (SELECT MAX(id) FROM bestellung)
)
WHERE id = (SELECT MAX(id) FROM bestellung);

-- Update customer credit
-- should fail because 2250 exceeds the 2000 credit limit
UPDATE kunde
SET aktueller_kredit = aktueller_kredit + (
    SELECT gesamtwert
    FROM bestellung
    WHERE id = (SELECT MAX(id) FROM bestellung)
)
WHERE id = 2;

COMMIT;
