.bail ON
PRAGMA foreign_keys = ON;

BEGIN TRANSACTION;

INSERT INTO bestellung(kunde_id)VALUES
(2);

INSERT INTO bestellposition(bestellung_id, artikel_id, menge, einzelpreis)VALUES
(2, 1, 80, (SELECT verkaufspreis FROM artikel WHERE id=1)),
(2, 2, 1, (SELECT verkaufspreis FROM artikel WHERE id=2));

UPDATE OR ROLLBACK artikel SET lagerbestand= lagerbestand - 
(SELECT menge FROM bestellposition WHERE bestellung_id =2 AND artikel_id=1)
WHERE id= 1;

UPDATE OR ROLLBACK artikel SET lagerbestand = lagerbestand -
(SELECT menge FROM bestellposition WHERE bestellung_id =2 AND artikel_id=2)
WHERE id=2;

UPDATE OR ROLLBACK bestellung SET gesamtwert =
(SELECT menge* einzelpreis AS preis FROM bestellposition 
WHERE bestellung_id=2 AND artikel_id = 1) + 
(SELECT menge * einzelpreis AS preis FROM bestellposition
WHERE bestellung_id=2 AND artikel_id=2 )
WHERE id =2;

UPDATE OR ROLLBACK kunde SET aktueller_kredit= aktueller_kredit +
(SELECT gesamtwert FROM bestellung WHERE id=2)
WHERE id =2;

INSERT INTO lagerbewegung(artikel_id, bestellung_id, menge,typ) VALUES
(1,2,-80,'verkauf'),
(2,2,-1,'verkauf');

COMMIT;