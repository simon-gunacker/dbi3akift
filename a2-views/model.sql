CREATE TABLE kunde (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    vorname varchar,
    nachname varchar,
    email varchar,
    geburtsdatum date,
    telefon varchar,
    adresse varchar
);

CREATE TABLE produkt (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    bezeichnung varchar,
    preis decimal,
    lagerbestand integer
);

CREATE TABLE bestellung (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    kunde_id INTEGER NOT NULL,
    bestelldatum datetime,
    status varchar,
    FOREIGN KEY (kunde_id) REFERENCES kunde(id)
);

CREATE TABLE bestellposition (
    bestellung_id INTEGER NOT NULL,
    produkt_id INTEGER NOT NULL,
    menge integer,
    PRIMARY KEY (bestellung_id, produkt_id),
    FOREIGN KEY (bestellung_id) REFERENCES bestellung(id),
    FOREIGN KEY (produkt_id) REFERENCES produkt(id)
);