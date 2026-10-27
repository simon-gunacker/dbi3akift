CREATE  TRIGGER  IF NOT EXISTS trigger_lagerbestand
BEFORE UPDATE  ON artikel
FOR EACH ROW
WHEN new.lagerbestand < 0
BEGIN
SELECT RAISE (ROLLBACK, 'zu wenige Artikel im Lager');
END;


CREATE  TRIGGER  IF NOT EXISTS trigger_kreditlimit
BEFORE UPDATE  ON kunde
FOR EACH ROW
WHEN new.aktueller_kredit > new.kreditlimit
BEGIN
SELECT RAISE (ROLLBACK, 'zu geringer Kreditrahmen');
END;

BEGIN TRANSACTION

SELECT kreditlimit
FROM kunde 

INSERT INTO bestellung (kunde_id)
VALUES  (1);

INSERT INTO bestellposition(bestellung_id,artikel_id,menge)
VALUES(last_insert_rowid(),1,5)
,(last_insert_rowid(),2,2)
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
    WHERE bestellung_id = last_insert_rowid()
)
WHERE id=last_insert_rowid();

UPDATE kunde
SET aktueller_kredit = aktueller_kredit+(
    SELECT gesamtwert
    FROM bestellung
    WHERE id = last_insert_rowid()
)
WHERE id =(
    SELECT kunde_id
    FROM bestellung
    WHERE id = last_insert_rowid()
);


INSERT INTO lagerbewegung (artikel_id, bestellung_id, menge, typ)
VALUES  
(1,last_insert_rowid(),-5,'verkauf')
,(2,last_insert_rowid(),-2,'verkauf')
,(3,last_insert_rowid(),-50,'verkauf')
;

END TRANSACTION