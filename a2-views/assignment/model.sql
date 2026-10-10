
PRAGMA foreign_keys = ON;
DROP TABLE IF EXISTS bestellposition;
DROP TABLE IF EXISTS bestellung;
DROP TABLE IF EXISTS produkt;
DROP TABLE IF EXISTS kunde;

-- CREATE TABLE
--Kunde 
CREATE TABLE IF NOT EXISTS kunde(
    id INTEGER PRIMARY KEY AUTOINCREMENT, 
    vorname VARCHAR(255),
    nachname VARCHAR(255),
    email VARCHAR(255),
    geburtsdatum DATE,
    telefon VARCHAR(255),
    adresse VARCHAR(255),
    hausnummer INTEGER
);

--Produkt
CREATE TABLE IF NOT EXISTS produkt(
    id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, 
    bezeichnung VARCHAR(255) NOT NULL,
    preis DECIMAL,
    lagerbestand INTEGER
);

--Bestellung
CREATE TABLE IF NOT EXISTS bestellung(
    id INTEGER PRIMARY KEY AUTOINCREMENT, 
    kunde_id INTEGER NOT NULL,
    bestelldatum DATE,
    status VARCHAR(255),
    FOREIGN KEY (kunde_id) REFERENCES kunde (id)
);

--Bestellposition
CREATE TABLE IF NOT EXISTS bestellposition(
    bestellung_id INTEGER,
    produkt_id INTEGER,
    menge INTEGER,
    PRIMARY KEY (bestellung_id, produkt_id),
    FOREIGN KEY (produkt_id) REFERENCES produkt (id),
    FOREIGN KEY (bestellung_id) REFERENCES bestellung (id)
);
