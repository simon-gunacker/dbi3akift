BEGIN TRANSACTION;

UPDATE bestellung
SET status = 'storniert'
WHERE id = 1; 

UPDATE lagerbewegung 
SET menge = menge * -1, typ = 'storno'
WHERE bestellung_id = 1;

UPDATE artikel
SET lagerbestand = lagerbestand + 5
WHERE id = 1; 

UPDATE artikel
SET lagerbestand = lagerbestand + 2
WHERE id = 2; 

UPDATE artikel
SET lagerbestand = lagerbestand + 50
WHERE id = 3; 


UPDATE kunde
SET aktueller_kredit = aktueller_kredit -
(
    SELECT gesamtwert
    FROM bestellung
    WHERE id = 1
)
WHERE id = 1; 

COMMIT;




