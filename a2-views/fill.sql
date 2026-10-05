CREATE TABLE IF NOT EXIST kunde (
	id INTEGER PRIMARY KEY,
	vorname VARCHAR,
	nachname VARCHAR,
	email VARCHAR,
	geburtsdatum DATE,
	telefon VARCHAR,
	adresse VARCHAR
);

CREATE TABLE IF NOT EXIST bestellung (
	id INTEGER PRIMARY KEY,
	kunde_id INTEGER,
	bestelldatum DATE,
	status VARCHAR,
	FOREIGN KEY(kunde_id) REFERENCES kunde(id)
);