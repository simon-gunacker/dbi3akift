PRAGMA foreign_keys = ON;

CREATE TABLE produkt (
    id INT PRIMARY KEY,
    bezeichnung VARCHAR(255) NOT NULL,
    preis DECIMAL NOT NULL,
    lagerbestand INT NOT NULL
);

CREATE TABLE kunde (
    id INT PRIMARY KEY,
    vorname VARCHAR(255) NOT NULL,
    nachname VARCHAR(255) NOT NULL,
    email VARCHAR(255) NOT NULL,
    geburtsdatum DATE,
    telefon VARCHAR(255) NOT NULL,
    adresse VARCHAR(255) NOT NULL
);

CREATE TABLE bestellung (
    id INT PRIMARY KEY,
    kunden_id INTEGER NOT NULL,
    bestelldatum DATETIME,
    status VARCHAR(255) NOT NULL,

    FOREIGN KEY (kunden_id) REFERENCES kunde(id)
);

CREATE TABLE bestellposition (
    bestellung_id INT NOT NULL,
    produkt_id INT NOT NULL,
    menge INT,

    PRIMARY KEY (bestellung_id, produkt_id),
    FOREIGN KEY (bestellung_id) REFERENCES bestellung(id),
    FOREIGN KEY (produkt_id) REFERENCES produkt(id)
);

