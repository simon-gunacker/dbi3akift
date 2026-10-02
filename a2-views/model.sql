CREATE TABLE IF NOT EXISTS kunde (
  id INTEGER PRIMARY KEY,
  vorname VARCHAR,
  nachname VARCHAR,
  email VARCHAR,
  geburtsdatum DATE,
  telefon VARCHAR,
  adresse VARCHAR
);

CREATE TABLE IF NOT EXISTS produkt (
  id INTEGER PRIMARY KEY,
  bezeichnung VARCHAR,
  preis DECIMAL,
  lagerbestand INTEGER
);

CREATE TABLE IF NOT EXISTS bestellung (
  id INTEGER PRIMARY KEY,
  kunde_id INTEGER NOT NULL REFERENCES kunde(id),
  bestelldatum DATETIME, 
  status VARCHAR
);

CREATE TABLE IF NOT EXISTS bestellposition (
  bestellung_id INTEGER NOT NULL,
  produkt_id INTEGER NOT NULL,
  menge INTEGER,
  PRIMARY KEY (bestellung_id, produkt_id),
  FOREIGN KEY (bestellung_id) REFERENCES bestellung(id),
  FOREIGN KEY (produkt_id) REFERENCES produkt(id)
);

