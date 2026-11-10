BEGIN TRANSACTION;

-- Bestellung anlegen
INSERT INTO bestellung (kunde_id)
VALUES (1)
;

-- last_insert_rowid() würde nicht funktionieren, weil es immer wieder überschrieben wird, deswegen Temp-Tabelle:
CREATE TEMP TABLE akt AS SELECT last_insert_rowid() AS id;

-- Bestellpositionen einfügen
INSERT INTO bestellposition (bestellung_id, artikel_id, menge, einzelpreis) VALUES
((SELECT id FROM akt), 1, 5, 25.00),
((SELECT id FROM akt), 2, 2, 75.00),
((SELECT id FROM akt), 3, 50, 0.25)
;

-- Lagerbestand anpassen
UPDATE artikel SET lagerbestand = lagerbestand - 5 WHERE id = 1;
UPDATE artikel SET lagerbestand = lagerbestand - 2 WHERE id = 2;
UPDATE artikel SET lagerbestand = lagerbestand - 50 WHERE id = 3;

-- Gesamtwert der Bestellung updaten
UPDATE bestellung
SET gesamtwert = (SELECT SUM(menge * einzelpreis) FROM bestellposition
                  WHERE bestellung_id = bestellung.id),
    status = 'verarbeitet'
WHERE id = (SELECT id FROM akt);

-- Kundenkredit erhöhen
UPDATE kunde
SET aktueller_kredit = aktueller_kredit +
    (SELECT gesamtwert FROM bestellung WHERE id = (SELECT id FROM akt))
WHERE id = 1;

-- Lagerbewegungen protokollieren (negativ = Ausgang)
INSERT INTO lagerbewegung (artikel_id, bestellung_id, menge, typ)
SELECT artikel_id, bestellung_id, -menge, 'verkauf'
FROM bestellposition
WHERE bestellung_id = (SELECT id FROM akt);

--COMMIT;

DROP TABLE akt;

END;



-- STORNIERUNG

BEGIN TRANSACTION;

CREATE TEMP TABLE storno AS
SELECT id FROM bestellung WHERE id = 1 AND status <> 'storniert';

-- Status auf storniert setzen
UPDATE bestellung
SET status = 'storniert'
WHERE id = (SELECT id FROM storno);

-- Lagerbestand wieder erhöhen
UPDATE artikel
SET lagerbestand = lagerbestand + (
    SELECT menge FROM bestellposition
    WHERE bestellung_id = (SELECT id FROM storno) AND artikel_id = artikel.id)
WHERE id IN (SELECT artikel_id FROM bestellposition
             WHERE bestellung_id = (SELECT id FROM storno));

-- Kundenkredit verringern
UPDATE kunde
SET aktueller_kredit = aktueller_kredit -
    (SELECT gesamtwert FROM bestellung WHERE id = (SELECT id FROM storno))
WHERE id = (SELECT kunde_id FROM bestellung WHERE id = (SELECT id FROM storno));

-- Lagerbewegungen protokollieren (positiv = Eingang)
INSERT INTO lagerbewegung (artikel_id, bestellung_id, menge, typ)
SELECT artikel_id, bestellung_id, menge, 'storno'
FROM bestellposition
WHERE bestellung_id = (SELECT id FROM storno);

--COMMIT;

DROP TABLE storno;

END;



-- Reporting

-- Artikel unter Mindestbestand (Nachbestellung nötig)
SELECT id, name, lagerbestand, mindestbestand
FROM artikel
WHERE lagerbestand < mindestbestand;

-- Kunden mit mehr als 90% ausgeschöpftem Kreditlimit
SELECT id, name, aktueller_kredit, kreditlimit,
       ROUND(aktueller_kredit * 100.0 / kreditlimit, 1) AS auslastung_prozent
FROM kunde
WHERE aktueller_kredit > 0.9 * kreditlimit;

-- Umsatz des heutigen Tages (ohne Stornos)
SELECT COALESCE(SUM(gesamtwert), 0) AS umsatz_heute
FROM bestellung
WHERE date(datum) = date('now')
  AND status <> 'storniert';
