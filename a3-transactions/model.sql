-- Artikel im Lager
CREATE TABLE artikel (
    id INTEGER PRIMARY KEY,
    name TEXT NOT NULL,
    kategorie TEXT,
    einkaufspreis DECIMAL(10,2),
    verkaufspreis DECIMAL(10,2),
    lagerbestand INTEGER DEFAULT 0,
    mindestbestand INTEGER DEFAULT 5,
    CHECK (lagerbestand >= 0),
    CHECK (verkaufspreis > einkaufspreis)
);

-- Kunden/Händler
CREATE TABLE kunde (
    id INTEGER PRIMARY KEY,
    name TEXT NOT NULL,
    kreditlimit DECIMAL(10,2) DEFAULT 0,
    aktueller_kredit DECIMAL(10,2) DEFAULT 0,
    CHECK (aktueller_kredit <= kreditlimit)
);

-- Bestellungen
CREATE TABLE bestellung (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    kunde_id INTEGER NOT NULL,
    datum DATETIME DEFAULT CURRENT_TIMESTAMP,
    status TEXT DEFAULT 'offen',  -- offen, verarbeitet, storniert
    gesamtwert DECIMAL(10,2) DEFAULT 0,
    FOREIGN KEY (kunde_id) REFERENCES kunde(id)
);

-- Einzelne Positionen einer Bestellung
CREATE TABLE bestellposition (
    bestellung_id INTEGER,
    artikel_id INTEGER,
    menge INTEGER,
    einzelpreis DECIMAL(10,2),
    PRIMARY KEY (bestellung_id, artikel_id),
    FOREIGN KEY (bestellung_id) REFERENCES bestellung(id),
    FOREIGN KEY (artikel_id) REFERENCES artikel(id),
    CHECK (menge > 0)
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