import sqlite3 
import random 

conn = sqlite3.connect("datenbank.db")
cursor = conn.cursor()

random.seed(1)

cursor.execute("PRAGMA foreign_keys = ON")
cursor.execute("DROP TABLE IF EXISTS bestellposition")
cursor.execute("DROP TABLE IF EXISTS bestellung")
cursor.execute("DROP TABLE IF EXISTS produkt")
cursor.execute("DROP TABLE IF EXISTS kunde")

## CREATE TABLE
table = """
    CREATE TABLE IF NOT EXISTS kunde(
        id INTEGER PRIMARY KEY AUTOINCREMENT, 
        vorname VARCHAR(255),
        nachname VARCHAR(255),
        email VARCHAR(255),
        geburtsdatum DATE,
        telefon VARCHAR(255),
        adresse VARCHAR(255),
        hausnummer INTEGER
    );

    CREATE TABLE IF NOT EXISTS produkt(
            id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, 
            bezeichnung VARCHAR(255) NOT NULL,
            preis DECIMAL,
            lagerbestand INTEGER
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
        FOREIGN KEY (produkt_id) REFERENCES produkt (id),
        FOREIGN KEY (bestellung_id) REFERENCES bestellung (id)
    );
"""
cursor.executescript(table)

## kunde
first = ["Bilal", "Thomas", "Manuel", "Asmir", "Marin", "Diyar", "Mario", "Yusuf", "Jakob", "Yunus"]
last = ["Anwar", "Ferhat", "Michael", "Ibrahim", "Salah", "Furkan", "Arda", "Mehmet", "Ali", "Bara"]
kunde = []
for i in range(10000):
    first_name = random.choice(first)
    last_name = random.choice(last)
    email = f"{first_name}.{last_name}{i}@gmail.com"

    jahr = random.randint(2000, 2020)
    monat = random.randint(1, 12)
    tag = random.randint(1 ,28)
    geburtsdatum = f"{jahr}-{monat:02d}-{tag:02d}"

    telefon = f"{random.randint(100000000, 999999999)}"

    adress = ["Seestraße", "Blumenstraße", "Sonnenweg", "Birkenstraße", "Waldgasse", "Rosenweg", "Ahornstraße", "Lindenweg", "Fichtenstraße", "Kirschgasse"]
    adresse = random.choice(adress)
    hausnummer = random.randint(0, 9)
    kunde.append((first_name, last_name, email, geburtsdatum, telefon, adresse, hausnummer))

cursor.executemany("INSERT INTO kunde (vorname, nachname, email, geburtsdatum, telefon, adresse, hausnummer) VALUES (?,?,?,?,?,?,?)", kunde)

## produkt
bezeichnung = ["Hammer", "Schraubenzieher", "Zange", "Wasserwaage", "Spachtel", "Kombizange"]
preis = [10.00, 55.99, 20.55, 19.99, 5.45, 33.20]
lagerbestand = [0, 10, 55, 100, 99, 2, 7, 89, 43]
produkte = []

for produkt in range(10000):
    produkte.append((random.choice(bezeichnung), random.choice(preis), random.choice(lagerbestand)))

cursor.executemany("INSERT INTO produkt (bezeichnung, preis, lagerbestand) VALUES (?, ?, ?)", produkte)

## bestellung 
cursor.execute("SELECT id FROM kunde")
kunden_id = cursor.fetchall()

status = ["In Bearbeitung", "Versendet", "Zugestellt"]
kunden_ids = []
for row in kunden_id:
    kunden_ids.append(row[0])

bestellungen = []

for i in range(100000):
    monat = random.randint(1, 12)
    tag = random.randint(1, 28)
    jahr = random.randint(2000, 2020)
    datum = f"{jahr}-{monat:02d}-{tag:02d}"
    bestellungen.append((random.choice(kunden_ids), datum, random.choice(status)))

cursor.executemany("INSERT INTO bestellung (kunde_id, bestelldatum, status) VALUES (?, ?, ?)", bestellungen)

## bestellposition
cursor.execute("SELECT id FROM bestellung")
bestellung_id = cursor.fetchall()

cursor.execute("SELECT id FROM produkt")
produkt_id = cursor.fetchall()

bestellungen_id = []
for best_id in bestellung_id:
    bestellungen_id.append(best_id[0])

produkte_id = []
for prodk_id in produkt_id:
    produkte_id.append(prodk_id[0])

menge = [1, 2, 3, 4, 5, 6, 7, 8, 9]

bestellposition = set()

while len(bestellposition) < 500000:
    bestellposition.add((
        random.choice(bestellungen_id),
        random.choice(produkte_id),
        random.choice(menge)
    ))

cursor.executemany("INSERT INTO bestellposition (bestellung_id, produkt_id, menge) VALUES (?,?,?)", bestellposition)

conn.commit()
conn.close()