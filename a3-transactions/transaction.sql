BEGIN TRANSACTION

-- Bestellung anlegen
INSERT INTO bestellung (kunde_id,gesamtwert)
VALUES (1, 0.00)
;

-- Bestellpositionen einfügen
INSERT INTO bestellposition (bestellung_id, artikel_id, menge, preis_einzel)
VALUES
(last_insert_rowid(), 1, 5, 25.00),
(last_insert_rowid(), 2, 2, 75.00),
(last_insert_rowid(), 3, 50, 0.25)
;

-- Lagerbestand anpassen
UPDATE artikel SET lagerbestand = lagerbestand - 5 WHERE id = 1;
UPDATE artikel SET lagerbestand = lagerbestand - 2 WHERE id = 2;
UPDATE artikel SET lagerbestand = lagerbestand - 50 WHERE id = 3;

-- Gesamtwert der Bestellung updaten
UPDATE bestellung
SET gesamtwert = (
    SELECT SUM(menge * preis_einzel)
    FROM bestellposition
    WHERE bestellung_id = last_insert_rowid()
)
WHERE id = last_insert_rowid();

UPDATE kunde SET aktueller_kredit =
aktueller_kredit - (SELECT gesamtwert FROM bestellung WHERE id = last_insert_rowid());

INSERT INTO lagerbewegung?

END;

/*
-- Kunden/Händler
CREATE TABLE kunde (
    id INTEGER PRIMARY KEY,
    name TEXT NOT NULL,
    kreditlimit DECIMAL(10,2) DEFAULT 0,
    aktueller_kredit DECIMAL(10,2) DEFAULT 0,
    CHECK (aktueller_kredit <= kreditlimit)
);

-- Lager-Bewegungen (für Nachverfolgung)
CREATE TABLE lagerbewegung (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    artikel_id INTEGER,
    bestellung_id INTEGER,
    menge INTEGER,  -- negativ = Ausgang, positiv = Eingang
    typ TEXT,  -- 'verkauf', 'nachlieferung', 'storno'
    datum DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (artikel_id) REFERENCES artikel(id)
);
*/
