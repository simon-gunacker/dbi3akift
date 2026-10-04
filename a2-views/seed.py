import sqlite3
import names
import random

conn = sqlite3.connect("datenbank.db")
random.seed(1) # Startwert 1

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

SEED = 1

def kunde_vornamen():
    liste_vornamen = []

    liste_vornamen.extend(random.choices(names.kunde_vorname_w, k=5_000))
    liste_vornamen.extend(random.choices(names.kunde_vorname_m, k=5_000))

    random.shuffle(liste_vornamen)

    return liste_vornamen

def kunde_nachnamen():
    liste_nachnamen = []

    liste_nachnamen.extend(random.choices(names.kunde_nachnamen, k=10_000))

    return liste_nachnamen

def kunde_email():
    liste_email = []

    for i in range(5):
        random_zeichen = random.choices(names.zeichen, k=5)
        random_zeichen.append(str(i))

        benutzername = "".join(random_zeichen)
        domain = "seed.py" 
        email = f"{benutzername}@{domain}"

        liste_email.append(email)

    return liste_email
print(kunde_email())


