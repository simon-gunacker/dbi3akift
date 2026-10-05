import sqlite3 

conn = sqlite3.connect("datenbank.db")
cursor = conn.cursor()

cursor.execute("DROP TABLE IF EXISTS kunde")
cursor.execute("DROP TABLE IF EXISTS produkt")
cursor.execute("DROP TABLE IF EXISTS bestellung")
cursor.execute("DROP TABLE IF EXISTS bestellposition")

table = """
    CREATE TABLE IF NOT EXISTS kunde(
        id INTEGER PRIMARY KEY AUTOINCREMENT, 
        vorname VARCHAR(255),
        nachname VARCHAR(255),
        email VARCHAR(255),
        geburtsdatum DATE,
        telefon VARCHAR(255),
        adresse VARCHAR(255)
    );

    CREATE TABLE IF NOT EXISTS bestellung(
        id INTEGER PRIMARY KEY AUTOINCREMENT, 
        kunde_id INTEGER NOT NULL,
        bestelldatum DATE,
        status VARCHAR(255),
        FOREIGN KEY (kunde_id) REFERENCES kunde (id)
    );

    CREATE TABLE IF NOT EXISTS bestellposition(
        bestellung_id INTEGER,
        produkt_id INTEGER,
        menge INTEGER,
        PRIMARY KEY (bestellung_id, produkt_id),
        FOREIGN KEY (produkt_id) REFERENCES kunde (id),
        FOREIGN KEY (bestellung_id) REFERENCES kunde (id)
    );

    CREATE TABLE IF NOT EXISTS produkt(
        id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, 
        bezeichnung VARCHAR(255) NOT NULL,
        preis DECIMAL,
        lagerbestand INTEGER
    );
"""

cursor.execute(table)



conn.commit()
conn.close()