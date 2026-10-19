BEGIN TRANSACTION


SELECT kreditlimit
FROM kunde 

INSERT INTO bestellung (kunde_id)
VALUES  (1);

INSERT INTO bestellposition(artikel_id,menge)
VALUES(1,5)

INSERT INTO bestellposition(artikel_id,menge)
VALUES(2,2)

INSERT INTO bestellposition(artikel_id,menge)
VALUES(3,50)

UPDATE artikel
SET lagerbestand = lagerbestand -5
WHERE id = 1;

UPDATE artikel
SET lagerbestand = lagerbestand -2
WHERE id = 2;

UPDATE artikel
SET lagerbestand = lagerbestand -50
WHERE id = 3;

-- UPDATE bestellung 
-- SET gesamtwert



END TRANSACTION