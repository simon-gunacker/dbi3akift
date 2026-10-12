PRAGMA foreign_keys = ON;
-- matters because SQLite ignores foreign keys by default, and it must be set again in every new connection.

CREATE TABLE kunde (
    id INTEGER PRIMARY KEY,
    vorname VARCHAR(50) NOT NULL,
    nachname VARCHAR(50) NOT NULL,
    email VARCHAR NOT NULL UNIQUE,
    geburtsdatum DATE,
    telefon VARCHAR(30),
    adresse VARCHAR(200)
);

CREATE TABLE produkt (
    id INTEGER PRIMARY KEY,
    bezeichnung VARCHAR(50) NOT NULL,
    preis DECIMAL(10,2) NOT NULL,
    lagerbestand INTEGER NOT NULL DEFAULT 0
);

CREATE TABLE bestellung (
    id INTEGER PRIMARY KEY,
    kunde_id INTEGER NOT NULL,
    bestelldatum DATETIME NOT NULL,
    status VARCHAR(20) NOT NULL,
    FOREIGN KEY (kunde_id) REFERENCES kunde(id)
);

CREATE TABLE bestellposition (
    bestellung_id INTEGER NOT NULL,
    produkt_id INTEGER NOT NULL,
    menge INTEGER NOT NULL DEFAULT 1,
    PRIMARY KEY (bestellung_id, produkt_id),
    FOREIGN KEY (bestellung_id) REFERENCES bestellung(id),
    FOREIGN KEY (produkt_id) REFERENCES produkt(id)
);
