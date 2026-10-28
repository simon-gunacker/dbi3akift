--run after transaction.sql
BEGIN TRANSACTION;

-- 1.
INSERT INTO bestellung (kunde_id) VALUES 
(2);

-- 2.
INSERT INTO bestellposition (bestellung_id, artikel_id, menge, einzelpreis) VALUES (
    2,
    5,   -- Breadboard
    50,  -- lagerbestand eigentlich nur 30        
    (SELECT verkaufspreis FROM artikel WHERE id = 5)
);

-- 3.
UPDATE artikel SET lagerbestand = lagerbestand - 50  WHERE id = 5;

-- 4.
UPDATE bestellung SET gesamtwert = (
    SELECT SUM( menge * einzelpreis) FROM bestellposition WHERE bestellung_id = 2
)
WHERE id = 2;

-- 5.
UPDATE kunde SET 
aktueller_kredit = aktueller_kredit + (SELECT gesamtwert FROM bestellung WHERE id =2)
WHERE id = 2;

--6. 

INSERT INTO lagerbewegung (artikel_id, bestellung_id, menge, typ) VALUES
(5, 2, -50, 'verkauf');

COMMIT;