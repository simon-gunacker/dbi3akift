.bail ON
PRAGMA foreign_keys = ON;

BEGIN TRANSACTION;

INSERT INTO bestellung(kunde_id) VALUES (2);

INSERT INTO bestellposition(bestellung_id, artikel_id, menge, einzelpreis) VALUES
(2, 5, 31,(SELECT verkaufspreis FROM artikel WHERE id=5)),
(2, 4, 30, (SELECT verkaufspreis FROM artikel WHERE id=4));

UPDATE OR ROLLBACK artikel SET lagerbestand = lagerbestand - 
(SELECT menge FROM bestellposition WHERE bestellung_id=2 AND artikel_id=5)
WHERE id=5;

UPDATE OR ROLLBACK artikel SET lagerbestand = lagerbestand -
(SELECT menge FROM bestellposition WHERE bestellung_id=2 AND artikel_id=4) 
WHERE id =4;

UPDATE OR ROLLBACK bestellung SET gesamtwert =
(SELECT menge * einzelpreis AS preis FROM bestellposition WHERE bestellung_id=2 AND artikel_id=5)+
(SELECT menge * einzelpreis AS preis FROM bestellposition WHERE bestellung_id=2 AND artikel_id=4)
WHERE id =2;

UPDATE OR ROLLBACK kunde SET aktueller_kredit = aktueller_kredit +
(SELECT gesamtwert FROM bestellung WHERE id=2)
WHERE id =2;


INSERT INTO lagerbewegung(artikel_id, bestellung_id, menge, typ) VALUES
(5, 2, -31, 'verkauf'),
(4, 2, -30, 'verkauf');

COMMIT;