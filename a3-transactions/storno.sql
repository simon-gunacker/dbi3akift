BEGIN TRANSACTION;

CREATE TEMP TABLE storno_id (id INTEGER);
INSERT INTO temp.storno_id (id) VALUES (4);

UPDATE bestellung
SET datum = date("now"), status = "storniert"
WHERE status = "offen" AND id = (SELECT id FROM temp.storno_id);

UPDATE artikel as a
SET lagerbestand = a.lagerbestand + (lb.menge * -1)
FROM lagerbewegung as lb
WHERE a.id = lb.artikel_id AND lb.bestellung_id = (SELECT id FROM temp.storno_id);

INSERT INTO lagerbewegung (artikel_id, bestellung_id, menge, typ)
SELECT artikel_id , bestellung_id , menge * -1, "storno" as typ
FROM lagerbewegung
WHERE bestellung_id = (SELECT id FROM temp.storno_id);


WITH total_amount AS (
        SELECT gesamtwert as amount
        FROM bestellung as b
        WHERE b.id = (SELECT id FROM temp.storno_id))
UPDATE kunde
SET aktueller_kredit = aktueller_kredit  + ((SELECT amount FROM total_amount) * -1)
WHERE id = (SELECT kunde_id FROM bestellung WHERE id = (SELECT id FROM temp.storno_id));

DROP TABLE temp.storno_id;

COMMIT;
