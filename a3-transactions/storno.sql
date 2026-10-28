--run after transaction.sql
BEGIN TRANSACTION;

UPDATE bestellung SET status = 'storniert' WHERE id=1;

UPDATE artikel SET lagerbestand = lagerbestand + 5  WHERE id = 1;
UPDATE artikel SET lagerbestand = lagerbestand + 2  WHERE id = 2;
UPDATE artikel SET lagerbestand = lagerbestand + 50  WHERE id = 3;

INSERT INTO lagerbewegung (artikel_id, bestellung_id, menge, typ) VALUES
(1, 1, 5, 'storno');

INSERT INTO lagerbewegung (artikel_id, bestellung_id, menge, typ) VALUES
(2, 1, 2, 'storno');

INSERT INTO lagerbewegung (artikel_id, bestellung_id, menge, typ) VALUES
(3, 1, 50, 'storno');

UPDATE kunde SET 
aktueller_kredit = aktueller_kredit - (SELECT gesamtwert FROM bestellung WHERE id =1)
WHERE id = 1;

COMMIT;