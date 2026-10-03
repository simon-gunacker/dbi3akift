CREATE TABLE kunde (
    id            INTEGER PRIMARY KEY,
    vorname       VARCHAR(25),
    nachname      VARCHAR(25),
    email         VARCHAR(50),
    geburtsdatum  DATE,
    telefon       VARCHAR(30),
    adresse       VARCHAR(100)
);

CREATE TABLE produkt (
    id            INTEGER PRIMARY KEY,
    bezeichnung   VARCHAR(50),
    preis         DECIMAL(10,2),
    lagerbestand  INTEGER
);

CREATE TABLE bestellung (
    id            INTEGER PRIMARY KEY,
    kunde_id      INTEGER NOT NULL,
    bestelldatum  DATETIME,
    status        VARCHAR(25),
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