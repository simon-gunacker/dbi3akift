BEGIN TRANSACTION;

-- neue Bestellung anlegen
INSERT INTO bestellung (kunde_id, status, gesamtwert)
VALUES (1, 'offen', 0.0);

-------------------------------------------------------
--Bestellpositionen anlegen
-- Arduino Uno
INSERT INTO bestellposition
VALUES (1, 1, 5, 25.00);

-- Raspberry Pi 4
INSERT INTO bestellposition
VALUES (1, 2, 2, 75.00);

-- LED rot
INSERT INTO bestellposition
VALUES (1, 3, 50, 0.25);

-------------------------------------------------------
-- Lagerbestand verändern
-- Arduino Uno
UPDATE artikel
SET lagerbestand = lagerbestand - 5
WHERE id = 1;

-- Raspberry Pi 4
UPDATE artikel
SET lagerbestand = lagerbestand - 2
WHERE id = 2;

-- LED rot
UPDATE artikel
SET lagerbestand = lagerbestand - 50
WHERE id = 3;

-------------------------------------------------------
-- Gesamtwert berechnen + in bestellung eintragen

UPDATE bestellung
SET gesamtwert = (
    SELECT SUM(einzelpreis * menge)
    FROM bestellposition
    WHERE bestellung_id = 1
)
WHERE id = 1;

-------------------------------------------------------
-- Kundenkredit erhöhen

UPDATE kunde
SET aktueller_kredit = aktueller_kredit + (
    SELECT SUM(einzelpreis * menge)
    FROM bestellposition
    WHERE bestellung_id = 1
)
WHERE id = 1;

-------------------------------------------------------
-- Lagerbewegung dokumentieren

-- Arduino Uno
INSERT INTO lagerbewegung (artikel_id, bestellung_id, menge, typ)
VALUES (1, 1, -5, 'verkauf');

-- Raspberry Pi 4
INSERT INTO lagerbewegung (artikel_id, bestellung_id, menge, typ)
VALUES (2, 1, -2, 'verkauf');

-- LED rot
INSERT INTO lagerbewegung (artikel_id, bestellung_id, menge, typ)
VALUES (3, 1, -50, 'verkauf');

END;