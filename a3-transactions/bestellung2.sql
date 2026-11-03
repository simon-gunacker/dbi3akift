.bail ON

PRAGMA foreign_keys = ON;

BEGIN TRANSACTION;

INSERT INTO bestellung(kunde_id) VALUES(2);

INSERT INTO bestellposition(bestellung_id, artikel_id, menge, einzelpreis) VALUES
(2,3,970,(SELECT verkaufspreis FROM artikel WHERE id=3)),
(2,5,27, (SELECT verkaufspreis FROM artikel WHERE id=5));

UPDATE artikel SET lagerbestand = lagerbestand - 
(SELECT menge FROM bestellposition WHERE artikel_id=3 and bestellung_id=2)
WHERE id=3;

UPDATE artikel SET lagerbestand = lagerbestand - 
(SELECT menge FROM bestellposition WHERE bestellung_id=2 and artikel_id=5)
WHERE id= 5;



UPDATE bestellung SET gesamtwert=
(SELECT menge * einzelpreis AS preis FROM bestellposition WHERE bestellung_id=2 and artikel_id=3)+
(SELECT menge * einzelpreis AS preis FROM bestellposition WHERE bestellung_id=2 and artikel_id=5)
WHERE id = 2;

UPDATE kunde SET aktueller_kredit = aktueller_kredit +(SELECT gesamtwert FROM  bestellung WHERE id= 2)
WHERE id =2;

INSERT INTO lagerbewegung(artikel_id, bestellung_id, menge,typ) VALUES
(3,2,-970,'verkauf'),
(5,2,-27,'verkauf');
COMMIT;