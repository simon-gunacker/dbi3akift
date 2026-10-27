BEGIN TRANSACTION


UPDATE artikel
SET lagerbestand = lagerbestand + (
SELECT bp.menge
FROM bestellposition bp
WHERE bp.bestellung_id = 1 AND bp.artikel_id =artikel.id
)
WHERE id IN(
    SELECT artikel_id
    FROM bestellposition
    WHERE bestellung_id=1
);



UPDATE kunde
SET aktueller_kredit = aktueller_kredit - (
    SELECT gesamtwert 
    FROM bestellung 
    WHERE id = 1
)
WHERE id = (
    SELECT kunde_id 
    FROM bestellung 
    WHERE id = 1
);

INSERT INTO lagerbewegung (artikel_id, bestellung_id, menge, typ)
SELECT artikel_id, bestellung_id, menge , 'storno'
FROM bestellposition
WHERE bestellung_id =1;

UPDATE bestellung 
SET gesamtwert =0
WHERE id=1;

END TRANSACTION;