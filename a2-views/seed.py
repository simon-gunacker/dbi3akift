from sqlite3 import connect
import random
from tkinter.font import names

random.seed(42)

produkt_list = ["Äpfel", "Bananen", "Orangen", "Trauben", "Kiwis", "Mangos", "Ananas", "Erdbeeren", "Himbeeren", "Blaubeeren"]
kunde_list = ["Max", "Anna", "Lukas", "Sophie", "Leon", "Emma", "Paul", "Mia", "Felix", "Lena"]
kunde_list_nachname = ["Müller", "Schmidt", "Schneider", "Fischer", "Weber", "Meyer", "Wagner", "Becker", "Schulz", "Hoffmann"]


def convert_dict(cursor, row):
    result_dict = {}
    col_infos = cursor.description

    for i in range(len(col_infos)):
        name_col = col_infos[i][0]
        value = row[i]
        result_dict[name_col] = value

    return result_dict

def with_connect(db):
    def decorator(function):
        def wrapper(*args, **kwargs):
            with connect(db) as conn:
                conn.row_factory = convert_dict
                result = function(conn, *args, **kwargs)
                return result

        return wrapper

    return decorator

produkt = []
for i in range(1, 10001):
    bezeichnung = f"{random.choice(produkt_list)}"
    preis = round(random.uniform(1.0, 100.0), 2)
    lagerbestand = random.randint(0, 100)
    produkt.append((i, bezeichnung, preis, lagerbestand))

kunde = []
for i in range(1, 10001):
    vorname = f"{random.choice(kunde_list)}"
    nachname = f"{random.choice(kunde_list_nachname)}"
    email = f"{vorname.lower()}.{nachname.lower()}@gmail.com"
    geburtsdatum = f"{random.randint(1950, 2000)}-{random.randint(1, 12):02d}-{random.randint(1, 28):02d}"
    telefon = f"+49 {random.randint(1000000000, 9999999999)}"
    adresse = f"{random.randint(1, 100)} {random.choice(['Hauptstraße', 'Bahnhofstraße', 'Gartenweg', 'Schulstraße'])}, {random.randint(10000, 99999)} {random.choice(['Berlin', 'Hamburg', 'München', 'Köln', 'Frankfurt'])}"
    kunde.append((i, vorname, nachname, email, geburtsdatum, telefon, adresse))

bestellung = []
for i in range(1, 1000001):
    kunde_id = random.randint(1, 1001)
    bestelldatum = f"{random.randint(2020, 2024)}-{random.randint(1, 12):02d}-{random.randint(1, 28):02d}"
    status = random.choice(["offen", "versendet", "storniert"])
    bestellung.append((i, kunde_id, bestelldatum, status))

bestellposition = []
used_pairs = set()

while len(bestellposition) < 500000:
    bestellung_id = random.randint(1, 100001)
    produkt_id = random.randint(1, 10001)
    pair = (bestellung_id, produkt_id)

    if pair in used_pairs:
        continue

    used_pairs.add(pair)
    menge = random.randint(1, 100)
    bestellposition.append((bestellung_id, produkt_id, menge))


@with_connect("shop.db")
def create_tables(conn):
    with open("model.sql", "r") as f:
        conn.executescript(f.read())

    
@with_connect("shop.db")
def insert_data(conn):
    conn.executemany(
    "INSERT INTO produkt (id, bezeichnung, preis, lagerbestand) VALUES (?, ?, ?, ?)",
    produkt
    )

    conn.executemany(
    "INSERT INTO kunde (id, vorname, nachname, email, geburtsdatum, telefon, adresse) VALUES (?, ?, ?, ?, ?, ?, ?)",
    kunde
    )

    conn.executemany(
    "INSERT INTO bestellung (id, kunde_id, bestelldatum, status) VALUES (?, ?, ?, ?)",
    bestellung
    )

    conn.executemany(
    "INSERT INTO bestellposition (bestellung_id, produkt_id, menge) VALUES (?, ?, ?)",
    bestellposition
    )


if __name__ == "__main__":
    create_tables()
    insert_data()
    print("Data inserted successfully")