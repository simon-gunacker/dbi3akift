BEGIN TRANSACTION;

INSERT INTO bestellung (kunde_id, gesamtwert)
VALUES (1, 
    (SELECT 5 * (
            SELECT verkaufspreis
            FROM artikel
            WHERE id = 1
        ) + 2 *
        (
            SELECT verkaufspreis
            FROM artikel
            WHERE id = 2
        ) + 50 *
        ( 
            SELECT verkaufspreis
            FROM artikel
            WHERE id = 3
        )
    )
);

INSERT INTO bestellposition (bestellung_id, artikel_id, menge, einzelpreis)
VALUES (1, 1, 5, 
(SELECT verkaufspreis
FROM artikel
WHERE id = 1)
);

INSERT INTO bestellposition (bestellung_id, artikel_id, menge, einzelpreis)
VALUES (1, 2, 2, 
(SELECT verkaufspreis
FROM artikel
WHERE id = 2)
);

INSERT INTO bestellposition (bestellung_id, artikel_id, menge, einzelpreis)
VALUES (1, 3, 50, 
(SELECT verkaufspreis
FROM artikel
WHERE id = 3)
);


INSERT INTO lagerbewegung (artikel_id, bestellung_id, menge, typ)
VALUES (1, 1, -5, 'verkauf');

INSERT INTO lagerbewegung (artikel_id, bestellung_id, menge, typ)
VALUES (1, 2, -2, 'verkauf');

INSERT INTO lagerbewegung (artikel_id, bestellung_id, menge, typ)
VALUES (1, 3, -50, 'verkauf');



UPDATE artikel
SET lagerbestand = lagerbestand - 5
WHERE id = 1; 

UPDATE artikel
SET lagerbestand = lagerbestand - 2
WHERE id = 2; 

UPDATE artikel
SET lagerbestand = lagerbestand - 50
WHERE id = 3; 


UPDATE kunde
SET aktueller_kredit = aktueller_kredit +
(
    SELECT gesamtwert
    FROM bestellung
    WHERE id = 1
)
WHERE id = 1; 

COMMIT;


