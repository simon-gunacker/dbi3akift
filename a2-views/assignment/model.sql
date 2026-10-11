DROP TABLE IF EXISTS bestellposition;
DROP TABLE IF EXISTS bestellung;
DROP TABLE IF EXISTS produkt;
DROP TABLE IF EXISTS kunde;

CREATE TABLE kunde (
    id           INTEGER PRIMARY KEY,
    vorname      VARCHAR,
    nachname     VARCHAR,
    email        VARCHAR,
    geburtsdatum DATE,
    telefon      VARCHAR,
    adresse      VARCHAR
);

CREATE TABLE produkt (
    id           INTEGER PRIMARY KEY,
    bezeichnung  VARCHAR,
    preis        DECIMAL(10, 2),
    lagerbestand INTEGER
);

CREATE TABLE bestellung (
    id           INTEGER PRIMARY KEY,
    kunde_id     INTEGER NOT NULL,
    bestelldatum DATETIME,
    status       VARCHAR,
    FOREIGN KEY (kunde_id) REFERENCES kunde(id)
);

CREATE TABLE bestellposition (
    bestellung_id INTEGER NOT NULL,
    produkt_id    INTEGER NOT NULL,
    menge         INTEGER,
    PRIMARY KEY (bestellung_id, produkt_id),
    FOREIGN KEY (bestellung_id) REFERENCES bestellung(id),
    FOREIGN KEY (produkt_id)    REFERENCES produkt(id)
);
