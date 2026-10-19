BEGIN TRANSACTION


SELECT kreditlimit
FROM kunde 

INSERT INTO bestellung (kunde_id)
VALUES  (1);

INSERT INTO bestellposition(bestellung_id,artikel_id,menge)
VALUES(last_insert_rowid(),1,5)
,(last_insert_rowid(),2,2),
,(last_insert_rowid(),3,50)
;


UPDATE artikel
SET lagerbestand = lagerbestand -5
WHERE id = 1;

UPDATE artikel
SET lagerbestand = lagerbestand -2
WHERE id = 2;

UPDATE artikel
SET lagerbestand = lagerbestand -50
WHERE id = 3;

UPDATE bestellung 
SET gesamtwert =(
    SELECT SUM(MENGE * einzelpreis)
    FROM bestellposition
    WHERE bestellung_id = 1 AND artikel_id = 1
)
WHERE id=1;

UPDATE bestellung 
SET gesamtwert = gesamtwert+(
    SELECT SUM(MENGE * einzelpreis)
    FROM bestellposition
    WHERE bestellung_id = 1 AND artikel_id =2
)
WHERE id=1;

UPDATE bestellung 
SET gesamtwert =gesamtwert+(
    SELECT SUM(MENGE * einzelpreis)
    FROM bestellposition
    WHERE bestellung_id = 1 AND artikel_id = 3
)
WHERE id=1;

UPDATE kunde
SET aktueller_kredit = aktueller_kredit+(
    SELECT gesamtwert
    FROM bestellung
    WHERE id = 1
)
WHERE id = 1;


INSERT INTO lagerbewegung (artikel_id, bestellung_id, menge, typ)
VALUES  
(1,1,-5,'verkauf')
,(2,1,-2,'verkauf')
,(3,1,-50,'verkauf')
;
--todo last_insert_rowid()

END TRANSACTION