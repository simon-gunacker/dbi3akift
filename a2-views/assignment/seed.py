import sqlite3 
import random 

conn = sqlite3.connect("datenbank.db")
cursor = conn.cursor()

random.seed(1)

with open("model.sql", "r", encoding="utf-8") as f:
    model = f.read()

cursor.executescript(model)

## kunde
first = ["Bilal", "Thomas", "Manuel", "Asmir", "Marin", "Diyar", "Mario", "Yusuf", "Jakob", "Yunus"]
last = ["Anwar", "Ferhat", "Michael", "Ibrahim", "Salah", "Furkan", "Arda", "Mehmet", "Ali", "Bara"]
kunde = []
for i in range(10000):
    first_name = random.choice(first)
    last_name = random.choice(last)
    email = f"{first_name}.{last_name}{i}@gmail.com"

    jahr = random.randint(1950, 2020)
    monat = random.randint(1, 12)
    tag = random.randint(1 ,28)
    geburtsdatum = f"{jahr}-{monat:02d}-{tag:02d}"

    telefon = f"{random.randint(100000000, 999999999)}"

    adress = ["Seestraße", "Blumenstraße", "Sonnenweg", "Birkenstraße", "Waldgasse", "Rosenweg", "Ahornstraße", "Lindenweg", "Fichtenstraße", "Kirschgasse"]
    adresse = random.choice(adress)
    hausnummer = random.randint(1, 9)
    kunde.append((first_name, last_name, email, geburtsdatum, telefon, adresse, hausnummer))

cursor.executemany("INSERT INTO kunde (vorname, nachname, email, geburtsdatum, telefon, adresse, hausnummer) VALUES (?,?,?,?,?,?,?)", kunde)

## produkt
bezeichnung = ["Hammer", "Schraubenzieher", "Zange", "Wasserwaage", "Spachtel",
                "Kombizange","Bohrmaschine", "Akkuschrauber", "Säge", "Feile", "Maßband",
                  "Schleifpapier", "Schraubendreher-Set", "Handschuhe", "Leiter", "Cuttermesser"]
preis = [10.00, 20.55, 19.99, 5.45, 33.20, 89.99, 59.99, 24.99, 7.99, 6.49, 3.99, 29.99, 9.99, 119.99, 4.99]
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
    jahr = random.randint(1950, 2020)
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

bestellposition = []
kombinationen = set()

while len(bestellposition) < 500000:
    bestellung = random.choice(bestellungen_id)
    produkt = random.choice(produkte_id)

    # Keine doppelte Bestellung mit demselben Produkt
    if (bestellung, produkt) not in kombinationen:
        kombinationen.add((bestellung, produkt))
        bestellposition.append((bestellung, produkt, random.choice(menge)))

cursor.executemany("INSERT INTO bestellposition (bestellung_id, produkt_id, menge) VALUES (?,?,?)", bestellposition)
print("Datenbank erfolgreich erstellt und befüllt!")
conn.commit()
conn.close()