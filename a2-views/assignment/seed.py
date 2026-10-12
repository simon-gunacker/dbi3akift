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
 
MAIL_DOMAINS = ["gmail.com", "outlook.com", "gmx.at", "web.de", "yahoo.com"]
 
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
