BEGIN TRANSACTION;

-- restore stock
UPDATE artikel
SET lagerbestand = lagerbestand + (
    SELECT menge
    FROM bestellposition
    WHERE bestellposition.artikel_id = artikel.id
    AND bestellposition.bestellung_id = 1
)
WHERE id IN (
    SELECT artikel_id
    FROM bestellposition
    WHERE bestellung_id = 1
);

-- record the moving of the inventory
INSERT INTO lagerbewegung (
    artikel_id, bestellung_id, menge, typ
)
SELECT
    artikel_id,
    bestellung_id,
    menge,
    'storno'
FROM bestellposition
WHERE bestellung_id = 1;

-- reduce customer credit
UPDATE kunde
SET aktueller_kredit = aktueller_kredit - (
    SELECT gesamtwert
    FROM bestellung
    WHERE id = 1
)
WHERE id = (
    SELECT kunde_id
    FROM bestellung
    WHERE id = 1
);

-- Mark as cancelled
UPDATE bestellung
SET status = 'storniert'
WHERE id = 1
AND status = 'verarbeitet';

COMMIT;
