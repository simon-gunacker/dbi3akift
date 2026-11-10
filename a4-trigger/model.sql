CREATE TABLE nutzer (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    name TEXT NOT NULL,
    konto_guthaben DECIMAL(10,2) DEFAULT 0 CHECK (konto_guthaben >= 0)
);

CREATE TABLE medium (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    titel TEXT NOT NULL,
    typ TEXT CHECK (typ IN ('buch', 'ebook')),
    bestand INTEGER DEFAULT 0 CHECK (bestand >= 0)
);

CREATE TABLE ausleihe (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    nutzer_id INTEGER,
    medium_id INTEGER,
    startdatum DATE DEFAULT CURRENT_DATE,
    rueckgabedatum DATE DEFAULT (date('now', '+14 day')),
    status TEXT DEFAULT 'aktiv',  -- aktiv, beendet, gemahnt, gesperrt
    FOREIGN KEY (nutzer_id) REFERENCES nutzer(id),
    FOREIGN KEY (medium_id) REFERENCES medium(id)
);

CREATE TABLE mahnung (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    ausleihe_id INTEGER,
    betrag DECIMAL(10,2),
    datum DATE DEFAULT CURRENT_DATE,
    FOREIGN KEY (ausleihe_id) REFERENCES ausleihe(id)
);

CREATE TABLE system_log (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    aktion TEXT,
    info TEXT,
    datum DATETIME DEFAULT CURRENT_TIMESTAMP
);