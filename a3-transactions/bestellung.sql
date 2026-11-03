PRAGMA foreign_keys = ON;

BEGIN TRANSACTION;

INSERT INTO bestellung(kunde_id) VALUES(1);

INSERT INTO bestellposition(bestellung_id, artikel_id, menge, einzelpreis) VALUES
(1,1,5,(SELECT verkaufspreis FROM artikel WHERE id=1)),
(1,2,2, (SELECT verkaufspreis FROM artikel WHERE id=2)),
(1,3,50, (SELECT verkaufspreis FROM artikel WHERE id=3));

UPDATE artikel SET lagerbestand = lagerbestand - 
(SELECT menge FROM bestellposition WHERE artikel_id=1 and bestellung_id=1)
WHERE id=1;

UPDATE artikel SET lagerbestand = lagerbestand - 
(SELECT menge FROM bestellposition WHERE bestellung_id=1 and artikel_id=2)
WHERE id= 2;

UPDATE artikel SET lagerbestand = lagerbestand -
(SELECT menge FROM bestellposition WHERE bestellung_id=1 and artikel_id=3)
WHERE id=3;

UPDATE bestellung SET gesamtwert=
(SELECT menge * einzelpreis AS preis FROM bestellposition WHERE bestellung_id=1 and artikel_id=1)+
(SELECT menge * einzelpreis AS preis FROM bestellposition WHERE bestellung_id=1 and artikel_id=2)+
(SELECT menge * einzelpreis AS preis FROM bestellposition WHERE bestellung_id=1 and artikel_id=3)
WHERE id = 1;

UPDATE kunde SET aktueller_kredit = aktueller_kredit +(SELECT gesamtwert FROM  bestellung WHERE id= 1)
WHERE id =1;

INSERT INTO lagerbewegung(artikel_id, bestellung_id, menge,typ) VALUES
(1,1,-5,'verkauf'),
(2,1,-2,'verkauf'),
(3,1,-50,'verkauf');

COMMIT;