CREATE TABLE IF NOT EXISTS kunde (
	id INTEGER PRIMARY KEY,
	vorname VARCHAR NOT NULL,
	nachname VARCHAR NOT NULL,
	email VARCHAR UNIQUE,
	geburtsdatum DATE NOT NULL,
	telefon VARCHAR UNIQUE,
	adresse VARCHAR NOT NULL
);

CREATE TABLE IF NOT EXISTS bestellposition (
	bestellung_id INTEGER,
	produkt_id INTEGER,
	menge INTEGER,
	PRIMARY KEY (bestellung_id, produkt_id),
	FOREIGN KEY(bestellung_id) REFERENCES bestellung(id),
	FOREIGN KEY(produkt_id) REFERENCES produkt(id)
);

CREATE TABLE IF NOT EXISTS bestellung (
	id INTEGER PRIMARY KEY,
	kunde_id INTEGER,
	bestelldatum DATE,
	status VARCHAR,
	FOREIGN KEY(kunde_id) REFERENCES kunde(id)
);
CREATE TABLE IF NOT EXISTS produkt (
	id INTEGER PRIMARY KEY,
	bezeichnung VARCHAR,
	preis DECIMAL,
	lagerbestand INTEGER
);

