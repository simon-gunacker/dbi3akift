CREATE TABLE produkt (
    id INT PRIMARY KEY,
    bezeichnung VARCHAR(255) NOT NULL,
    preis decimal NOT NULL,
    lagerbestand INT NOT NULL
)

CREATE TABLE bestellposition (
    bestellung_id INT PRIMARY KEY,
    produkt_id INT PRIMARY KEY,
    menge INT NOT NULL

    FOREIGN KEY (bestellung_id) REFERENCES bestellung(id),
    FOREIGN KEY (produkt_id) REFERENCES produkt(id)
)

CREATE TABLE bestellung (
    id INT PRIMARY KEY,
    kunden_id INT FOREIGN KEY,
    bestelldatum DATETIME,
    status VARCHAR(255) NOT NULL

    FOREIGN KEY (kunden_id) REFERENCES kunde(id)
)

CREATE TABLE kunde (
    id INT PRIMARY KEY,
    vorname VARCHAR(255) NOT NULL,
    nachname VARCHAR(255) NOT NULL,
    email VARCHAR(255) NOT NULL,
    geburtsdatum DATE,
    telefon VARCHAR(255) NOT NULL,
    adresse VARCHAR(255) NOT NULL
)

