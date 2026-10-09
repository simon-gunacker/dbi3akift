PRAGMA foreign_keys = ON;

CREATE TABLE IF NOT EXISTS produkt (
    id INTEGER PRIMARY KEY,
    bezeichnung VARCHAR(255),
    preis DECIMAL, 
    lagerbestand INTEGER
);

CREATE TABLE IF NOT EXISTS kunde (
    id INTEGER PRIMARY KEY, 
    vorname VARCHAR(255), 
    nachname VARCHAR(255), 
    email VARCHAR(255), 
    geburtsdatum DATE, 
    telefon VARCHAR(20), 
    adresse VARCHAR(255)
);

CREATE TABLE IF NOT EXISTS bestellung (
    id INTEGER PRIMARY KEY,
    kunde_id INTEGER NOT NULL,
    bestelldatum DATETIME,
    status VARCHAR(255),
    FOREIGN KEY (kunde_id) REFERENCES kunde(id)
);

CREATE TABLE IF NOT EXISTS bestellposition ( 
    bestellung_id INTEGER NOT NULL,
    produkt_id INTEGER NOT NULL,
    menge INTEGER, 
    PRIMARY KEY (bestellung_id, produkt_id),
    FOREIGN KEY (bestellung_id) REFERENCES bestellung(id), 
    FOREIGN KEY (produkt_id) REFERENCES produkt(id)
);

