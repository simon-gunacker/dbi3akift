CREATE TABLE IF NOT EXISTS nutzer (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    name TEXT NOT NULL,
    konto_guthaben DECIMAL(10,2) DEFAULT 0 CHECK (konto_guthaben >= 0)
);

CREATE TABLE IF NOT EXISTS medium (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    titel TEXT NOT NULL,
    typ TEXT CHECK (typ IN ('buch', 'ebook')),
    bestand INTEGER DEFAULT 0 CHECK (bestand >= 0)
);

CREATE TABLE IF NOT EXISTS ausleihe (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    nutzer_id INTEGER,
    medium_id INTEGER,
    startdatum DATE DEFAULT (DATE('now')),
    rueckgabedatum DATE DEFAULT (DATE('now', '+14 day')),
    status TEXT DEFAULT 'aktiv',  -- aktiv, beendet, gemahnt, gesperrt
    FOREIGN KEY (nutzer_id) REFERENCES nutzer(id),
    FOREIGN KEY (medium_id) REFERENCES medium(id)
);

CREATE TABLE IF NOT EXISTS  mahnung (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    ausleihe_id INTEGER,
    betrag DECIMAL(10,2),
    datum DATE DEFAULT (DATE('now')),
    CHECK(betrag > 0),
    FOREIGN KEY (ausleihe_id) REFERENCES ausleihe(id)
);

CREATE TABLE IF NOT EXISTS  system_log (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    aktion TEXT,
    info TEXT,
    datum DATETIME DEFAULT CURRENT_TIMESTAMP
);

INSERT INTO nutzer (name, konto_guthaben) VALUES
('Anna Muster', 10.00),
('Ben Beispiel', 5.00);

INSERT INTO medium (titel, typ, bestand) VALUES
('Der Zauberberg', 'buch', 3),
('Programmieren lernen mit Python', 'buch', 1),
('Digitale Welten', 'ebook', 9999);
