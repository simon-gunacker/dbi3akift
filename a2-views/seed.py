import sqlite3

conn = sqlite3.connect("datenbank.db")

conn.executescript(
    """
    PRAGMA foreign_keys = ON;

    CREATE TABLE IF NOT EXISTS kunde (
        id INTEGER PRIMARY KEY AUTOINCREMENT
        , vorname VARCHAR NOT NULL
        , nachname VARCHAR NOT NULL
        , email VARCHAR NOT NULL
        , geburtsdatum date NOT NULL
        , telefon VARCHAR NOT NULL
        , adresse VARCHAR NOT NULL
        );

    CREATE TABLE IF NOT EXISTS produkt (
        id INTEGER PRIMARY KEY AUTOINCREMENT
        , bezeichnung VARCHAR NOT NULL
        , preis DECIMAL NOT NULL
        , lagerbestand INTEGER
    );

    CREATE TABLE IF NOT EXISTS bestellung (
        id INTEGER PRIMARY KEY AUTOINCREMENT
        , kunde_id INT NOT NULL
        , bestelldatum DATETIME
        , status VARCHAR NOT NULL
        , FOREIGN KEY (kunde_id) REFERENCES kunde(id)
    );

    CREATE TABLE IF NOT EXISTS bestellposition (
        bestellung_id INTEGER NOT NULL
        , produkt_id INTEGER NOT NULL
        , menge INTEGER NOT NULL
        , PRIMARY KEY (bestellung_id, produkt_id)
        , FOREIGN KEY (bestellung_id) REFERENCES bestellung(id)
        , FOREIGN KEY (produkt_id) REFERENCES produkt(id)
    );

    """
)