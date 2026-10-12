import random
import sqlite3

db_name = "shop.db"
SEED = 42

anzahl_kunden = 10000
anzahl_produkte = 10000
anzahl_bestellungen = 100000
position_pro_bestellung = 5

VORNAME = [
    "Anna", "Lukas", "Maria", "Jonas", "Sophie", "Felix", "Laura", "Paul",
    "Julia", "David", "Lena", "Tobias", "Sarah", "Michael", "Hannah",
    "Florian", "Katharina", "Stefan", "Lisa", "Daniel", "Eva", "Markus",
    "Nina", "Thomas", "Clara", "Andreas", "Elena", "Simon", "Marie", "Jan",
]

NACHNAMEN = [
    "Gruber", "Huber", "Bauer", "Wagner", "Müller", "Pichler", "Steiner",
    "Moser", "Mayer", "Hofer", "Leitner", "Berger", "Fuchs", "Eder",
    "Fischer", "Schmid", "Winkler", "Weber", "Schwarz", "Maier",
    "Schneider", "Reiter", "Mayr", "Schmidt", "Wimmer", "Egger", "Brunner",
    "Lang", "Baumgartner", "Auer",
]
 
MAIL_DOMAINS = ["gmail.com", "outlook.com", "gmx.at", "yahoo.com"]
 
STRASSEN = [
    "Hauptstraße", "Bahnhofstraße", "Schulgasse", "Gartenweg", "Dorfstraße",
    "Ringstraße", "Kirchengasse", "Waldweg", "Mühlgasse", "Birkenweg",
]
 
ORTE = [
    ("8010", "Graz"), ("1010", "Wien"), ("4020", "Linz"),
    ("5020", "Salzburg"), ("6020", "Innsbruck"), ("9020", "Klagenfurt"),
    ("3100", "St. Pölten"), ("6900", "Bregenz"),
]
 
# Produktnamen werden aus Adjektiv + Produktart + Nummer gebaut
PRODUKT_ADJEKTIVE = [
    "Klassisch", "Modern", "Kompakt", "Premium", "Mini", "Pro", "Eco",
    "Ultra", "Basic", "Deluxe",
]
PRODUKT_ARTEN = [
    "Kopfhörer", "Maus", "Tastatur", "Monitor", "Lampe", "Rucksack",
    "Wasserflasche", "Notizbuch", "Ladekabel", "Webcam", "Lautsprecher",
    "Handyhülle", "Stuhl", "Tisch", "Uhr",
]
 
STATUS_WERTE = ["offen", "bezahlt", "versendet", "geliefert", "storniert"]
STATUS_GEWICHTE = [5, 10, 15, 65, 5]

#Funktionen zum Erstellen von zufälligen Daten
def erzeuge_kunden(anzahl):
    kunden = []
    for kunden_id in range(anzahl):
        vorname = random.choice(VORNAME)
        nachname = random.choice(NACHNAMEN)
        email = f"{vorname.lower()}.{nachname.lower()}@{random.choice(MAIL_DOMAINS)}"
        strasse = f"{random.choice(STRASSEN)} {random.randint(1, 100)}"
        plz, ort = random.choice(ORTE)
        telefon = f"+43 {random.randint(660, 699)} {random.randint(1000000, 9999999)}"
        kunden.append((vorname, nachname, email, strasse, plz, ort, telefon))
    return kunden

def erzeuge_produkte(anzahl):
    produkte = []
    for produkt_id in range(1, anzahl + 1):
        bezeichnung = f"{random.choice(PRODUKT_ADJEKTIVE)} {random.choice(PRODUKT_ARTEN)} {produkt_id}"
        preis = round(random.uniform(5.0, 500.0), 2)
        lagerbestand = random.randint(0, 100)
        produkte.append((bezeichnung, preis, lagerbestand))
    return produkte

def erzeuge_bestellungen(anzahl, anzahl_kunden):
    bestellungen = []
    for bestellung_id in range(1, anzahl + 1):
        kunden_id = random.randint(1, anzahl_kunden)
        bestelldatum = f"2023-{random.randint(1, 12):02d}-{random.randint(1, 28):02d} {random.randint(0, 23):02d}:{random.randint(0, 59):02d}:{random.randint(0, 59):02d}"
        status = random.choices(STATUS_WERTE, weights=STATUS_GEWICHTE)[0]
        bestellungen.append((kunden_id, bestelldatum, status))
    return bestellungen

def erzeuge_bestellpositionen(anzahl_bestellungen, positionen_pro_bestellung, anzahl_produkte):
    positionen = []
    for bestellung_id in range(1, anzahl_bestellungen + 1):
        produkt_ids = random.sample(range(1, anzahl_produkte + 1), positionen_pro_bestellung)
        for produkt_id in produkt_ids:
            menge = random.randint(1, 10)
            positionen.append((bestellung_id, produkt_id, menge))
    return positionen