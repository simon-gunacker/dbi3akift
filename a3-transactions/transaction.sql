PRAGMA journal_mode = WAL;

begin transaction;

INSERT INTO bestellung (kunde_id) VALUES (1);

-- Arduino
INSERT INTO bestellposition (bestellung_id, artikel_id, menge, einzelpreis) 
VALUES (
    (SELECT MAX(id) FROM bestellung WHERE kunde_id = 1), 
    1, 
    5, 
    25.00
);
UPDATE artikel SET lagerbestand = lagerbestand - 5 WHERE id = 1;
-- Update warehouse movement
INSERT INTO lagerbewegung (artikel_id, bestellung_id, menge, typ)
VALUES (
    1,
    (SELECT MAX(id) FROM bestellung WHERE kunde_id = 1),
    -5,
    'verkauf'
);

-- Raspberry pi
INSERT INTO bestellposition (bestellung_id, artikel_id, menge, einzelpreis) 
VALUES (
    (SELECT MAX(id) FROM bestellung WHERE kunde_id = 1), 
    2, 
    2, 
    75.00
);
UPDATE artikel SET lagerbestand = lagerbestand - 2 WHERE id = 2;
-- Update warehouse movement
INSERT INTO lagerbewegung (artikel_id, bestellung_id, menge, typ)
VALUES (
    2,
    (SELECT MAX(id) FROM bestellung WHERE kunde_id = 1),
    -2,
    'verkauf'
);

--LED
INSERT INTO bestellposition (bestellung_id, artikel_id, menge, einzelpreis) 
VALUES (
    (SELECT MAX(id) FROM bestellung WHERE kunde_id = 1), 
    3, 
    50, 
    0.25
);
UPDATE artikel SET lagerbestand = lagerbestand - 50 WHERE id = 3;
-- Update warehouse movement
INSERT INTO lagerbewegung (artikel_id, bestellung_id, menge, typ)
VALUES (
    3,
    (SELECT MAX(id) FROM bestellung WHERE kunde_id = 1),
    -50,
    'verkauf'
);


-- Calculate total value
UPDATE bestellung SET gesamtwert = (
    SELECT SUM(menge * einzelpreis)
    FROM bestellposition
    WHERE bestellung_id = (SELECT MAX(id) FROM bestellung WHERE kunde_id = 1)
)
WHERE id = (SELECT MAX(id) FROM bestellung WHERE kunde_id = 1);


-- Increase Customer Credit
UPDATE kunde SET aktueller_kredit = aktueller_kredit + (
    SELECT SUM(menge * einzelpreis)
    FROM bestellposition
    WHERE bestellung_id = (SELECT MAX(id) FROM bestellung WHERE kunde_id = 1)
)
WHERE id = 1;

commit;
