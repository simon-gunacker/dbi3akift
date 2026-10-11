import sqlite3
import random
from datetime import date, datetime, timedelta
from pathlib import Path

# Fester Seed -> bei jedem Lauf dieselben Daten
random.seed(42)

DB_FILE = 'shop.db'
MODEL_FILE = Path(__file__).resolve().parent / "model.sql" #konkreter Pfad mit Path('Pfad') funktioniert nicht

N_KUNDEN = 10_000
N_PRODUKTE = 10_000
N_BESTELLUNGEN = 100_000
N_POSITIONEN = 500_000



# ---------------------------------------------------------------------------
# Datengrundlage bzw. Wertebereiche
# ---------------------------------------------------------------------------

VORNAMEN = [
    'Anna', 'Lena', 'Sarah', 'Julia', 'Laura', 'Hannah', 'Sophie', 'Lea', 'Marie', 'Katharina',
    'Elena', 'Emma', 'Mia', 'Johanna', 'Valentina', 'Theresa', 'Magdalena', 'Nina', 'Lisa', 'Eva',
    'Lukas', 'David', 'Tobias', 'Jakob', 'Maximilian', 'Felix', 'Paul', 'Elias', 'Simon', 'Florian',
    'Alexander', 'Fabian', 'Michael', 'Stefan', 'Thomas', 'Markus', 'Daniel', 'Sebastian', 'Jonas', 'Leon',
]

NACHNAMEN = [
    'Gruber', 'Huber', 'Wagner', 'Müller', 'Pichler', 'Steiner', 'Moser', 'Mayer', 'Hofer', 'Leitner',
    'Berger', 'Fuchs', 'Eder', 'Fischer', 'Schmid', 'Winkler', 'Weber', 'Schwarz', 'Maier', 'Schneider',
    'Reiter', 'Mayr', 'Schmidt', 'Wimmer', 'Egger', 'Brunner', 'Lang', 'Baumgartner', 'Auer', 'Binder',
    'Lechner', 'Wolf', 'Wallner', 'Aigner', 'Ebner', 'Koller', 'Lehner', 'Haas', 'Schuster', 'Holzer',
]

MAIL_DOMAINS = ['gmx.at', 'gmail.com', 'outlook.com', 'aon.at', 'chello.at', 'icloud.com', 'yahoo.de']

MOBIL_VORWAHLEN = ['650', '660', '664', '676', '680', '681', '688', '699']

STRASSEN = [
    'Hauptstraße', 'Bahnhofstraße', 'Schulgasse', 'Kirchengasse', 'Lindenweg', 'Gartengasse',
    'Mühlgasse', 'Feldweg', 'Waldstraße', 'Bergstraße', 'Ringstraße', 'Marktplatz',
    'Bachgasse', 'Am Anger', 'Rosenweg', 'Dorfstraße', 'Industriestraße', 'Parkstraße',
]

ORTE = [
    ('1010', 'Wien'), ('3100', 'St. Pölten'), ('4020', 'Linz'), ('5020', 'Salzburg'), ('6020', 'Innsbruck'),
    ('6900', 'Bregenz'), ('7000', 'Eisenstadt'), ('8010', 'Graz'), ('9020', 'Klagenfurt'),
]


KATEGORIEN = {
    'Elektronik': (['Kopfhörer', 'Smartphone', 'Tablet', 'Monitor', 'Tastatur', 'Maus', 'Ladegerät', 'Lautsprecher'], 9.99, 1299.00),
    'Haushalt':   (['Kaffeemaschine', 'Wasserkocher', 'Toaster', 'Staubsauger', 'Mixer', 'Bügeleisen'], 14.99, 499.00),
    'Kleidung':   (['T-Shirt', 'Pullover', 'Jeans', 'Jacke', 'Hemd', 'Kleid', 'Sneaker', 'Mütze'], 7.99, 189.00),
    'Sport':      (['Laufschuh', 'Yogamatte', 'Hantel', 'Fahrradhelm', 'Trinkflasche', 'Rucksack'], 4.99, 249.00),
    'Büro':       (['Kugelschreiber', 'Notizbuch', 'Ordner', 'Schreibtischlampe', 'Bürostuhl', 'Locher'], 0.99, 349.00),
    'Garten':     (['Gartenschlauch', 'Blumentopf', 'Rasenmäher', 'Gartenschere', 'Gießkanne', 'Liegestuhl'], 3.99, 599.00),
}

MARKEN = ['Alpina', 'Super', 'Vienna', 'Styria', 'Carinthia', 'Ostwind', 'Westwind', 'Standard', 'Pro', 'Basic']
EIGENSCHAFTEN = ['Classic', 'Premium', 'Eco', 'Mini', 'Max', 'Plus', 'Lite', 'Comfort', 'Sport', 'Edition']


STATUS = ['geliefert', 'versendet', 'bezahlt', 'offen', 'storniert']


GEBURT_VON = date(1926, 1, 1)
GEBURT_BIS = date(2008, 12, 31)

BESTELLUNG_VON = datetime(2022, 1, 1)
BESTELLUNG_BIS = datetime(2025, 12, 31, 23, 59, 59)

MAX_MENGE = 5


# ---------------------------------------------------------------------------
# Hilfsfunktionen
# ---------------------------------------------------------------------------

def zufallsdatum(von, bis):
    tage = (bis - von).days
    return von + timedelta(days=random.randint(0, tage))


def zufallszeitpunkt(von, bis):
    sekunden = int((bis - von).total_seconds())
    return von + timedelta(seconds=random.randint(0, sekunden))


# ---------------------------------------------------------------------------
# Daten erzeugen
# ---------------------------------------------------------------------------

def erzeuge_kunden():
    kunden = []

    for kunde_id in range(1, N_KUNDEN + 1):
        vorname = random.choice(VORNAMEN)
        nachname = random.choice(NACHNAMEN)

        # id im Mail-Namen -> E-Mail-Adressen sind eindeutig
        email = f'kunde{kunde_id}@{random.choice(MAIL_DOMAINS)}'
        geburtsdatum = zufallsdatum(GEBURT_VON, GEBURT_BIS).isoformat()
        telefon = f'+43 {random.choice(MOBIL_VORWAHLEN)} {random.randint(1000000, 9999999)}'
        plz, ort = random.choice(ORTE)
        adresse = f'{random.choice(STRASSEN)} {random.randint(1, 150)}, {plz} {ort}'
        kunden.append((kunde_id, vorname, nachname, email, geburtsdatum, telefon, adresse))
    return kunden


def erzeuge_produkte():
    produkte = []

    for produkt_id in range(1, N_PRODUKTE + 1):
        produktarten, preis_von, preis_bis = random.choice(list(KATEGORIEN.values()))
        bezeichnung = f'{random.choice(MARKEN)} {random.choice(produktarten)} {random.choice(EIGENSCHAFTEN)} {random.randint(100, 999)}'
        preis = round(random.uniform(preis_von, preis_bis), 2)
        lagerbestand = random.randint(0, 500)
        produkte.append((produkt_id, bezeichnung, preis, lagerbestand))
    return produkte


def erzeuge_bestellungen():
    bestellungen = []
    for bestellung_id in range(1, N_BESTELLUNGEN + 1):
        zeitpunkt = zufallszeitpunkt(BESTELLUNG_VON, BESTELLUNG_BIS)
        kunde_id = random.randint(1, N_KUNDEN)
        status = random.choice(STATUS)
        bestellungen.append((bestellung_id, kunde_id, zeitpunkt.strftime('%Y-%m-%d %H:%M:%S'), status))
    return bestellungen


def erzeuge_positionen():
    pro_bestellung = N_POSITIONEN // N_BESTELLUNGEN
    positionen = []
    for bestellung_id in range(1, N_BESTELLUNGEN + 1):
        # random.sample -> kein Produkt doppelt in derselben Bestellung (Primärschlüssel!)
        for produkt_id in random.sample(range(1, N_PRODUKTE + 1), pro_bestellung):
            positionen.append((bestellung_id, produkt_id, random.randint(1, MAX_MENGE)))
    return positionen


# ---------------------------------------------------------------------------
# In die Datenbank schreiben
# ---------------------------------------------------------------------------

con = sqlite3.connect(DB_FILE)
cursor = con.cursor()
cursor.execute('PRAGMA foreign_keys = ON')

cursor.executescript(MODEL_FILE.read_text(encoding='utf-8'))

def batch_insert(sql, daten, batch_size=10_000):
    batch = []

    for row in daten:
        batch.append(row)

        if len(batch) == batch_size:
            cursor.executemany(sql, batch)
            batch = []

    if batch:
        cursor.executemany(sql, batch)


batch_insert('INSERT INTO kunde VALUES (?, ?, ?, ?, ?, ?, ?)', erzeuge_kunden())
batch_insert('INSERT INTO produkt VALUES (?, ?, ?, ?)', erzeuge_produkte())
batch_insert('INSERT INTO bestellung VALUES (?, ?, ?, ?)', erzeuge_bestellungen())
batch_insert('INSERT INTO bestellposition VALUES (?, ?, ?)', erzeuge_positionen())

con.commit()

for tabelle in ['kunde', 'produkt', 'bestellung', 'bestellposition']:
    print(f'{tabelle}: {cursor.execute(f"SELECT COUNT(*) FROM {tabelle}").fetchone()[0]}')

con.close()
