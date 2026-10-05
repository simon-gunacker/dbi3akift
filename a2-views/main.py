from sqlite import connect
import random
import json

DB = "test.db"
KUNDE_ROWS = 10000
PRODUKT_ROWS = 10000
BESTELLUNG_ROWS = 100000
BESTELLPOS_ROWS = 500000

def create_table_kunde(cursor): 
    cursor.execute("DROP TABLE IF EXISTS kunde")
    
    cursor.execute("""
        CREATE TABLE kunde (
            id INTEGER PRIMARY KEY AUTOINCREMENT, 
            vorname VARCHAR(255) NOT NULL,
            nachname VARCHAR(255) NOT NULL,
            email VARCHAR(255) NOT NULL,
            geburtsdatum DATE NOT NULL, 
            telefon VARCHAR(255) NOT NULL, 
            adresse VARCHAR(255) NOT NULL
        );
    """)

def create_table_produkt(cursor):
    cursor.execute("DROP TABLE IF EXISTS produkt")

    cursor.execute("""
        CREATE TABLE produkt (
        id INTEGER PRIMARY KEY AUTOINCREMENT, 
        bezeichnung VARCHAR(255) NOT NULL, 
        preis DECIMAL NOT NULL, 
        lagerbestand INTEGER NOT NULL
        );
    """)

def create_table_bestellung(cursor):
    cursor.execute("DROP TABLE IF EXISTS bestellung")

    cursor.execute("""
        CREATE TABLE bestellung (
        id INTEGER PRIMARY KEY AUTOINCREMENT, 
        kunde_id INTEGER NOT NULL, 
        bestelldatum DATETIME NOT NULL, 
        status VARCHAR(255) NOT NULL, 
        FOREIGN KEY (kunde_id) REFERENCES kunde(id)
        );
    """)

def create_table_bestellposition(cursor): 
    cursor.execute("DROP TABLE IF EXISTS bestellposition")

    cursor.execute("""
        CREATE TABLE bestellposition (
            bestellung_id INTEGER PRIMARY KEY AUTOINCREMENT, 
            produkt_id INTEGER PRIMARY KEY AUTOINCREMENT, 
            menge INTEGER NOT NULL, 
            FOREIGN KEY (bestellung_id) REFERENCES bestellung(id), 
            FOREIGN KEY (produkt_id) REFERENCES produkt(id)
        );
    """)

def create_kunden(kunde_rows) {

    with open ("./json_data/names.json", "r") as file:
        names_dict = json.load(file)

    for i in range(kunde_rows): 
        yield (
            random.choice(names_dict["vorname"]), 
            random.choice(names_dict["nachname"])
        )
}


if __name__ == "__main__"
    main()