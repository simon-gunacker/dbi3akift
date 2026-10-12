
CREATE TABLE produkt (
id INTEGER PRIMARY KEY AUTOINCREMENT,
bezeichnung VARCHAR(255),
preis DECIMAL(10,2),
lagerbestand INTEGER
);

CREATE TABLE kunde(
id INTEGER PRIMARY KEY AUTOINCREMENT,
vorname VARCHAR (255),
nachname VARCHAR (255),
email VARCHAR (255),
geburtsdatum DATE,
telefon VARCHAR (255),
adresse VARCHAR(255)
);


CREATE TABLE bestellung (
id INTEGER PRIMARY KEY AUTOINCREMENT,
kunde_id INTEGER NOT NULL,
bestelldatum DATETIME,
status VARCHAR (255),
FOREIGN KEY(kunde_id) REFERENCES kunde(id)
);

CREATE TABLE bestellposition (
bestellung_id INTEGER NOT NULL,
produkt_id INTEGER NOT NULL,
menge INTEGER,
PRIMARY KEY(bestellung_id, produkt_id),
FOREIGN KEY(bestellung_id) REFERENCES bestellung(id),
FOREIGN KEY(produkt_id) REFERENCES produkt(id)
);







































/*CREATE TABLE produkt(
id INTEGER PRIMARY KEY AUTOINCREMENT,
bezeichnung VARCHAR(255),
preis DECIMAL(10,2),
lagerbestand INTEGER
);

CREATE TABLE kunde(
id INTEGER PRIMARY KEY AUTOINCREMENT,
vorname VARCHAR(255),
nachname VARCHAR(255),
email VARCHAR(255),
geburtsdatum DATE,
telefon VARCHAR(255),
adresse VARCHAR(255)
);

CREATE TABLE bestellung(
id INTEGER PRIMARY KEY AUTOINCREMENT,
kunde_id INTEGER NOT NULL,
bestelldatum DATETIME,
status VARCHAR(255),
FOREIGN KEY(kunde_id) REFERENCES kunde(id)
);

CREATE TABLE bestellposition(
bestellung_id INTEGER NOT NULL,
produkt_id INTEGER NOT NULL,
menge INTEGER,
PRIMARY KEY(bestellung_id, produkt_id),
FOREIGN KEY(bestellung_id) REFERENCES bestellung(id),
FOREIGN KEY(produkt_id) REFERENCES produkt(id)
);*/



