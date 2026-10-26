BEGIN TRANSACTION;

-- 1.
INSERT INTO bestellung (kunde_id) VALUES 
(1);

--2.
INSERT INTO bestellposition (bestellung_id, artikel_id, menge, einzelpreis) VALUES (
    (SELECT MAX(id) FROM bestellung),            -- newest order
    1,                                           -- Arduino Uno
    5,                                           -- quantity
    (SELECT verkaufspreis FROM artikel WHERE id = 1)  -- current price
);

INSERT INTO bestellposition (bestellung_id, artikel_id, menge, einzelpreis) VALUES (
    (SELECT MAX(id) FROM bestellung),          
    2,                                           
    2,                                           
    (SELECT verkaufspreis FROM artikel WHERE id = 2)  
);

INSERT INTO bestellposition (bestellung_id, artikel_id, menge, einzelpreis) VALUES (
    (SELECT MAX(id) FROM bestellung),
    3,
    50,             
    (SELECT verkaufspreis FROM artikel WHERE id = 3)
);

--3.
UPDATE artikel SET lagerbestand = lagerbestand - 5  WHERE id = 1;
UPDATE artikel SET lagerbestand = lagerbestand - 2  WHERE id = 2;
UPDATE artikel SET lagerbestand = lagerbestand - 50  WHERE id = 3;



