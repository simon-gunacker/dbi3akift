-- Creating database
CREATE TABLE IF NOT EXIST kunde (
    id INTEGER PRIMERY KEY AUTOINCREMENT,
    vorname VARCHAR,
    nachname VARCHAR,
    email VARCHAR,
    geburtsdatum DATE,
    telefon VARCHAR,
    adresse VARCHAR
)

CREATE TABLE IF NOT EXIST bestellung (
    id INTEGER PRIMARY KEY,
    kunde_id INTEGER,
    bestelldatum DATETIME,
    status VARCHAR
    FOREIGN KEY (kunde_id) REFERENCES kunde(id)
)

CREATE TABLE IF NOT EXIST bestellposition (
    bestellung_id INTEGER,
    produkt_id INTEGER,
    menge INTEGER
    FOREIGN KEY (bestellung_id) REFERENCES bestellung (id)
    FOREIGN KEY (produkt_id) REFERENCES produkt (id)
)

CREATE TABLE IF NOT EXIST produkt (
    id INTEGER PRIMARY KEY,
    bezeichung VARCHAR,
    preis DECIMAL,
    lagerbestand INTEGER
)