.bail on

BEGIN TRANSACTION;

-- Bestellung als storniert markieren
UPDATE bestellung
SET status = 'storniert'
WHERE id = 1;

-- Kundenkredit zurücksetzen
UPDATE kunde
SET aktueller_kredit = aktueller_kredit - (
    SELECT gesamtwert
    FROM bestellung
    WHERE id = 1
)
WHERE id = 1;

-- Lagerbestand zurücksetzen
UPDATE artikel
SET lagerbestand = lagerbestand + (
    SELECT menge
    FROM bestellposition bp
    WHERE bp.artikel_id = artikel_id
    AND bp.bestellung_id = 1
)
WHERE id IN (
    SELECT artikel_id
    FROM bestellposition
    WHERE bestellung_id = 1
);

-- Lagerbewegung
INSERT INTO lagerbewegung (artikel_id, bestellung_id, menge, typ)
SELECT artikel_id, bestellung_id, menge, 'storno'
FROM bestellposition
WHERE bestellung_id = 1;
