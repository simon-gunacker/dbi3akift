.bail ON
PRAGMA foreign_keys = ON;
BEGIN TRANSACTION;

UPDATE OR ROLLBACK bestellung SET status= 'storniert' 
WHERE  id=1;

INSERT INTO lagerbewegung(artikel_id, bestellung_id, menge, typ)VALUES
(1, 1, 5, 'storno'),
(2, 1, 2, 'storno'),
(3, 1, 50, 'storno');

UPDATE OR ROLLBACK kunde SET aktueller_kredit = aktueller_kredit -
(SELECT gesamtwert FROM bestellung WHERE id = 1)
WHERE id=1;

UPDATE OR ROLLBACK artikel SET lagerbestand = lagerbestand +
(SELECT menge FROM bestellposition WHERE bestellung_id=1 AND artikel_id =1)
WHERE id =1;

UPDATE OR ROLLBACK artikel SET lagerbestand = lagerbestand +
(SELECT menge FROM bestellposition WHERE bestellung_id=1 AND artikel_id=2)
WHERE id =2;

UPDATE OR ROLLBACK artikel SET lagerbestand = lagerbestand +
(SELECT menge FROM bestellposition WHERE bestellung_id=1 AND artikel_id=3)
WHERE id=3;

COMMIT;