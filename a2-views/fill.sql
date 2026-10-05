CREATE TABLE IF NOT EXIST kunde (
	id INTEGER PRIMARY KEY,
	vorname VARCHAR,
	nachname VARCHAR,
	email VARCHAR,
	geburtsdatum DATE,
	telefon VARCHAR,
	adresse VARCHAR
);

CREATE TABLE IF NOT EXIST bestellposition (
	bestellung_id INTEGER PRIMARY KEY,
	produkt_id INTEGER PRIMARY KEY,
	FOREIGN KEY(bestellung_id) REFERENCES bestellung(id),
	FOREIGN KEY(produkt_id) REFERENCES produkt(id)
);

CREATE TABLE IF NOT EXIST bestellung (
	id INTEGER PRIMARY KEY,
	kunde_id INTEGER,
	bestelldatum DATE,
	status VARCHAR,
	FOREIGN KEY(kunde_id) REFERENCES kunde(id)
);
CREATE TABLE IF NOT EXIST produkt (
	id INTEGER PRIMARY KEY,
	bezeichnung VARCHAR,
	preis DECIMAL,
	lagerbestand INTEGER
);