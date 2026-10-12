-- mit .read in der database erzeugen

CREATE TABLE kunde (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    vorname VARCHAR,
    nachname VARCHAR,
    email VARCHAR,
    geburtsdatum DATE,
    telefon VARCHAR,
    adresse VARCHAR
);

CREATE TABLE produkt (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    bezeichnung VARCHAR,
    preis DECIMAL(10,2),
    lagerbestand INTEGER
);

CREATE TABLE bestellung (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    kunde_id INTEGER,
    bestelldatum DATE,
    status VARCHAR,
    FOREIGN KEY (kunde_id) REFERENCES kunde(id)
);

CREATE TABLE bestellposition (
    bestellung_id INTEGER,
    produkt_id INTEGER,
    menge INTEGER,
    PRIMARY KEY (bestellung_id, produkt_id),
    FOREIGN KEY (bestellung_id) REFERENCES bestellung(id),
    FOREIGN KEY (produkt_id) REFERENCES produkt(id)
);