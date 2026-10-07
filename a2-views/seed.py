import sqlite3 
import random

DB = "shop.db"
SEED = 42
ANZAHL_KUNDEN = 10000

VORNAMEN = ["Daniela", "Sophia", "Simone", "Lisa", "Elisabeth", "Irina", "Christoph", "Philipp", "Michael", "Kersten"]
NACHNAMEN = ["Avanzini", "Laforteza", "Raj", "Maurer", "Pusterhofer", "Karner", "Kager", "Traussnigg", "Kobos", "Schmid"]
STRASSEN = ["Hauptplatz", "Grazer Vorstadt", "Conrad-von-Hötzendorf-Straße", "Bahnhofstraße",
            "Packer Straße", "Schulgasse", "Kirchengasse", "Lindenweg", "Mühlgasse", "Feldgasse"]
ORTE = ["8570 Voitsberg", "8580 Köflach", "8572 Bärnbach", "8591 Maria Lankowitz",
        "8582 Rosental an der Kainach", "8563 Ligist", "8562 Mooskirchen",
        "8152 Stallhofen", "8583 Edelschrott", "8010 Graz"]

def insert_kunde (cursor, rows):
    sql = "INSERT INTO kunde (vorname, nachname, email, geburtsdatum, telefon, adresse) VALUES (?, ?, ?, ?, ?, ?)"
    cursor.executemany(sql, rows)

def insert_produkt(cursor, rows):
    sql = "INSERT INTO produkt (bezeichnung, preis, lagerbestand) VALUES (?, ?, ?)"
    cursor.executemany(sql, rows)

def insert_bestellungen(cursor, rows):
    sql = "INSERT INTO bestellung (kunde_id, bestelldatum, status) VALUES (?, ?, ?)"
    cursor.executemany(sql, rows)

def insert_bestellpos(cursor, rows):
    sql = "INSERT INTO bestellposition (bestellunf_id, produkt_id, menge) VALUES (?, ?, ?)"
    cursor.executemany(sql, rows)

def create_kunden():
    for x in range(ANZAHL_KUNDEN):
        vorname = random.choice(VORNAMEN)
        nachname = random.choice(NACHNAMEN)
        email = f"{vorname}.{nachname}{x}@gmail.com".lower()
        geburtsdatum = f"{random.randint(1980, 2004)}-{random.randint(1,12):02d}-{random.randint(1,28):02d}"
        telefon = f"0680{random.randint(1000000, 9999999)}"
        strasse = random.choice(STRASSEN)
        ort = random.choice(ORTE)
        adresse = f"{strasse} {random.randint(1, 300)}, {ort}" 
        yield (vorname, nachname, email, geburtsdatum, telefon, adresse)

def create_produkt():
    return []

def create_bestellung():
    return []

def create_bestellpos():
    return []

def main():
    random.seed(SEED)
    conn = sqlite3.connect(DB)
    cursor = conn.cursor()
    
    insert_kunde(cursor, create_kunden())
    #insert_produkt(cursor, create_produkt())
    #insert_bestellungen (cursor, create_bestellung())
    #insert_bestellpos (cursor, create_bestellpos())


    conn.commit()
    conn.close()
    

if __name__ == "__main__":
    main()