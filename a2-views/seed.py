import sqlite3 
import random

DB = "shop.db"
SEED = 42

VORNAMEN = ["Daniela", "Sophia", "Simone", "Lisa", "Elisabeth", "Irina", "Christoph", "Philipp", "Michael", "Kersten"]
NACHNAMEN = ["Avanzini", "Laforteza", "Raj", "Maurer", "Pusterhofer", "Karner", "Kager", "Traussnigg", "Kobos", "Schmid"]
STRASSEN = ["Hauptplatz", "Grazer Vorstadt", "Conrad-von-Hötzendorf-Straße", "Bahnhofstraße",
            "Packer Straße", "Schulgasse", "Kirchengasse", "Lindenweg", "Mühlgasse", "Feldgasse"]
ORTE = ["8570 Voitsberg", "8580 Köflach", "8572 Bärnbach", "8591 Maria Lankowitz",
        "8582 Rosental an der Kainach", "8563 Ligist", "8562 Mooskirchen",
        "8152 Stallhofen", "8583 Edelschrott", "8010 Graz"]

def insert_kunde ():
    pass

def insert_produkt():
    pass

def insert_bestellungen():
    pass

def insert_bestellpos():
    pass

def main():
    random.seed(42)
    sqlite3.connect(DB)


if __name__ == "__main__":
    main()