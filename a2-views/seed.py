import sqlite3 
import random
import calendar

DB = "shop.db"
SEED = 42
ANZAHL_KUNDEN = 10000
ANZAHL_PRODUKT = 10000
ANZAHL_BESTELLUNGEN = 100000
POSITIONEN_PRO_BESTELLUNG = 5

VORNAMEN = ["Daniela", "Sophia", "Simone", "Lisa", "Elisabeth", "Irina", "Christoph", "Philipp", "Michael", "Kersten"]
NACHNAMEN = ["Avanzini", "Laforteza", "Raj", "Maurer", "Pusterhofer", "Karner", "Kager", "Traussnigg", "Kobos", "Schmid"]
STRASSEN = ["Hauptplatz", "Grazer Vorstadt", "Conrad-von-Hötzendorf-Straße", "Bahnhofstraße",
            "Packer Straße", "Schulgasse", "Kirchengasse", "Lindenweg", "Mühlgasse", "Feldgasse"]
ORTE = ["8570 Voitsberg", "8580 Köflach", "8572 Bärnbach", "8591 Maria Lankowitz",
        "8582 Rosental an der Kainach", "8563 Ligist", "8562 Mooskirchen",
        "8152 Stallhofen", "8583 Edelschrott", "8010 Graz"]

BEZICHNUNGEN = ["Sleeves", "Deckbox", "Playmat", "Dice", "Booster", "Commander-Deck", 
                "Toploader", "Binder", "Boardgame", "Cardgame"]

STATUS = ["offen", "bezahlt", "versendet", "zugestellt", "storniert"]

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
    sql = "INSERT INTO bestellposition (bestellung_id, produkt_id, menge) VALUES (?, ?, ?)"
    cursor.executemany(sql, rows)

def create_kunden():
    for x in range(ANZAHL_KUNDEN):
        vorname = random.choice(VORNAMEN)
        nachname = random.choice(NACHNAMEN)
        email = f"{vorname}.{nachname}{x}@gmail.com".lower()
        jahr = random.randint(1980, 2004)
        monat = random.randint(1,12)
        tag = random.randint(1, calendar.monthrange(jahr, monat)[1])
        geburtsdatum = f"{jahr}-{monat:02d}-{tag:02d}"
        telefon = f"0680{random.randint(1000000, 9999999)}"
        strasse = random.choice(STRASSEN)
        ort = random.choice(ORTE)
        adresse = f"{strasse} {random.randint(1, 300)}, {ort}" 
        yield (vorname, nachname, email, geburtsdatum, telefon, adresse)

def create_produkt():
    for x in range(ANZAHL_PRODUKT):
        bezeichnung = f"{random.choice(BEZICHNUNGEN)} {x}"
        preis = round(random.uniform(10, 80), 2)
        lagerbestand = random.randint(0, 100)
        yield (bezeichnung, preis, lagerbestand)

def create_bestellung():
    for x in range(ANZAHL_BESTELLUNGEN):
        kunden_id = random.randint(1, ANZAHL_KUNDEN)
        jahr = random.randint(2024, 2025)
        monat = random.randint(1,12)
        tag = random.randint(1, calendar.monthrange(jahr, monat)[1])
        stunde = random.randint(0, 23)
        minute = random.randint(0, 59)
        sekunde = random.randint(0, 59)
        bestelldatum = f"{jahr}-{monat:02d}-{tag:02d} {stunde:02d}:{minute:02d}:{sekunde:02d}"
        satus = random.choice(STATUS)
        yield (kunden_id, bestelldatum, satus)

def create_bestellpos():
    for bestellung_id in range(1, ANZAHL_BESTELLUNGEN + 1):
        # 5 verschieden produkt ids für eine bestellung
        produkt_ids = random.sample(range(1, ANZAHL_PRODUKT + 1), POSITIONEN_PRO_BESTELLUNG)
        for produkt_id in produkt_ids:
            menge= random.randint(1, 5)
            yield (bestellung_id, produkt_id, menge)

def main():
    random.seed(SEED)
    conn = sqlite3.connect(DB)
    cursor = conn.cursor()
    
    cursor.execute("DELETE FROM kunde")
    cursor.execute("DELETE FROM produkt")
    cursor.execute("DELETE FROM bestellposition")
    cursor.execute("DELETE FROM bestellung")

    insert_kunde(cursor, create_kunden())
    insert_produkt(cursor, create_produkt())
    insert_bestellungen (cursor, create_bestellung())
    insert_bestellpos (cursor, create_bestellpos())

    conn.commit()
    conn.close()
    

if __name__ == "__main__":
    main()