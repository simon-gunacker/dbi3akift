
PRAGMA foreign_keys = ON;

-- 1. Articles
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

-- 2. Customers
CREATE TABLE kunde (
    id INTEGER PRIMARY KEY,
    name TEXT NOT NULL,
    kreditlimit DECIMAL(10,2) DEFAULT 0,
    aktueller_kredit DECIMAL(10,2) DEFAULT 0,
    CHECK (aktueller_kredit <= kreditlimit)
);

-- 3. Orders
CREATE TABLE bestellung (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    kunde_id INTEGER NOT NULL,
    datum DATETIME DEFAULT CURRENT_TIMESTAMP,
    status TEXT DEFAULT 'offen',
    gesamtwert DECIMAL(10,2) DEFAULT 0,
    FOREIGN KEY (kunde_id) REFERENCES kunde(id)
);

-- 4. Order positions
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

-- 5. Inventory movements
CREATE TABLE lagerbewegung (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    artikel_id INTEGER,
    bestellung_id INTEGER,
    menge INTEGER,
    typ TEXT,
    datum DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (artikel_id) REFERENCES artikel(id)
);

-- Test data: Articles
INSERT INTO artikel VALUES
(1, 'Arduino Uno', 'Mikrocontroller', 15.00, 25.00, 100, 10),
(2, 'Raspberry Pi 4', 'Mikrocontroller', 45.00, 75.00, 50, 5),
(3, 'LED 5mm rot', 'LED', 0.10, 0.25, 1000, 50),
(4, 'Widerstand 220Ω', 'Widerstand', 0.02, 0.05, 5000, 100),
(5, 'Breadboard', 'Zubehör', 3.00, 8.00, 30, 5);

-- Test data: Customers
INSERT INTO kunde VALUES
(1, 'TechShop Wien', 5000.00, 1200.00),
(2, 'MakerSpace Graz', 2000.00, 0.00),
(3, 'Elektronik Steiner', 10000.00, 3500.00);
