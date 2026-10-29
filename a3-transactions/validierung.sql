CREATE TRIGGER IF NOT EXISTS trigger_nachbestellung
BEFORE INSERT ON bestellposition
FOR EACH ROW
BEGIN
    UPDATE artikel
    SET lagerbestand = lagerbestand + (
        SELECT CASE 
            WHEN lagerbestand < new.menge THEN (new.menge - lagerbestand) 
            ELSE 0 -- falls genug artikel da da wehn klausel sonst null zurückgibt lagerbestand wäre sonst +null =null
        END
        FROM artikel WHERE id = new.artikel_id
    )
    WHERE id = new.artikel_id;

    INSERT INTO lagerbewegung (artikel_id, bestellung_id, menge, typ)
    SELECT 
        new.artikel_id
        ,new.bestellung_id
        ,(new.menge - lagerbestand) 
        ,'nachlieferung'
    FROM artikel 
    WHERE id = new.artikel_id AND lagerbestand < new.menge;

END;


-- CREATE  TRIGGER  IF NOT EXISTS trigger_lagerbestand
-- BEFORE UPDATE  ON artikel
-- FOR EACH ROW
-- WHEN new.lagerbestand < 0
-- BEGIN
-- SELECT RAISE (ROLLBACK, 'zu wenige Artikel im Lager');
-- END;



CREATE  TRIGGER  IF NOT EXISTS trigger_kreditlimit
BEFORE UPDATE  ON kunde
FOR EACH ROW
WHEN new.aktueller_kredit > new.kreditlimit
BEGIN
SELECT RAISE (ROLLBACK, 'zu geringer Kreditrahmen');
END;

BEGIN TRANSACTION


INSERT INTO bestellung (kunde_id)
VALUES  (1);
INSERT INTO bestellposition(bestellung_id,artikel_id,menge,einzelpreis)
VALUES(last_insert_rowid(),1,5,(SELECT verkaufspreis FROM artikel WHERE id = 1))
,(last_insert_rowid(),2,2,(SELECT verkaufspreis FROM artikel WHERE id = 2))
,(last_insert_rowid(),3,50,(SELECT verkaufspreis FROM artikel WHERE id = 3))
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

END TRANSACTION;