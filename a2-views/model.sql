PRAGMA foreign_keys = ON;

CREATE TABLE IF NOT EXISTS kunde (
    id            INTEGER NOT NULL,
    vorname       VARCHAR(255),
    nachname      VARCHAR(255),
    email         VARCHAR(255),
    geburtsdatum  DATE,
    telefon       VARCHAR(255),
    adresse       VARCHAR(255),
    PRIMARY KEY (id)
);

CREATE TABLE IF NOT EXISTS produkt (
    id            INTEGER NOT NULL,
    bezeichnung   VARCHAR(255),
    preis         DECIMAL,
    lagerbestand  INTEGER,
    PRIMARY KEY (id)
);

CREATE TABLE IF NOT EXISTS bestellung (
    id            INTEGER NOT NULL,
    kunde_id      INTEGER,
    bestelldatum  DATE,
    status        VARCHAR(255),
    PRIMARY KEY (id),
    FOREIGN KEY (kunde_id) REFERENCES kunde(id)
);

CREATE TABLE IF NOT EXISTS bestellposition (
    bestellung_id INTEGER NOT NULL,
    produkt_id    INTEGER NOT NULL,
    menge         INTEGER,
    PRIMARY KEY (produkt_id, bestellung_id),
    FOREIGN KEY (bestellung_id) REFERENCES bestellung(id),
    FOREIGN KEY (produkt_id) REFERENCES produkt(id)
);
