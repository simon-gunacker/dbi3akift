import sqlite3
import data
import random
from datetime import date, datetime, timedelta

conn = sqlite3.connect("model.db")
random.seed(1) # Startwert 1

with open("model.sql") as model:
    db_model = model.read()
    conn.executescript(db_model)

def kunde_vornamen():
    liste_vornamen = []

    liste_vornamen.extend(random.choices(data.kunde_vorname_w, k=5_000))
    liste_vornamen.extend(random.choices(data.kunde_vorname_m, k=5_000))

    random.shuffle(liste_vornamen)

    return liste_vornamen

def kunde_nachnamen():
    liste_nachnamen = []

    liste_nachnamen.extend(random.choices(data.kunde_nachnamen, k=10_000))

    return liste_nachnamen

def kunde_email():
    liste_email = []

    for i in range(10_000):
        random_zeichen = random.choices(data.zeichen, k=5)
        random_zeichen.append(str(i))

        benutzername = "".join(random_zeichen)
        domain = "seed.py" 
        email = f"{benutzername}@{domain}"

        liste_email.append(email)

    return liste_email

def kunde_geburtsdatum():
    datum_laufend = date(1950, 1, 1)
    datum_bis = date(2007, 12, 31)

    geburtstage = [datum_laufend]

    while datum_laufend < datum_bis:
        datum_laufend += timedelta(days=1)
        geburtstage.append(datum_laufend)
    
    liste_geburtstage = random.choices(geburtstage, k=10_000)

    return liste_geburtstage

def kunde_telefonnummer():
    liste_telefonnummern = []
    
    for i in range(10_000):
        vorwahl = "0" + random.choice(data.vorwahlen)
        telefonnummer = vorwahl + str(i)

        while len(telefonnummer) <= 10:
            telefonnummer += str(random.randint(0, 9))

        liste_telefonnummern.append(telefonnummer)
    return liste_telefonnummern


def kunde_adresse():
    liste_adressen = []

    liste_adressen.extend(random.choices(data.adressen, k=10_000))

    return liste_adressen

def produkt_bezeichnung():
    liste_produkte = []

    liste_produkte.extend(random.choices(data.produkt_namen, k=10_000))

    return liste_produkte

def produkt_preis():
    liste_preise = []

    while len(liste_preise) < 10_000:
        preis = round(random.uniform(2, 12), 2)
        liste_preise.append(preis)
    
    return liste_preise

def produkt_lagerbestand():
    liste_lagerbestand = []

    while len(liste_lagerbestand) < 10_000:
        lager = random.randint(0, 250)
        liste_lagerbestand.append(lager)

    return liste_lagerbestand

def bestellung_kunde_id():
    kunde_ids = []
    ids = conn.execute("SELECT id FROM kunde").fetchall()

    for i in ids:
        kunde_ids.append(i[0])

    liste_kunde_id = []
    liste_kunde_id.extend(random.choices(kunde_ids, k = 100_000))

    return liste_kunde_id

def bestellung_bestelldatum():
    datum_start = datetime(year=2010, month=10, day=1)
    datum_bis = datetime(year=2026, month=10, day=7)

    sekunden = int((datum_bis - datum_start).total_seconds())
    #zufalls_tag = datum_start + timedelta(seconds=(random.randint(0, sekunden)))
    
    liste_bestelldatum = [(datum_start + timedelta(seconds=(random.randint(0, sekunden)))) for i in range(100_000)]
        
    return liste_bestelldatum

def bestellung_status():
    statusse = ["in_bearbeitung", "unterwegs", "zugestellt", "storniert"]
    
    liste_status = []
    liste_status.extend(random.choices(statusse, k=100_000))

    return liste_status

def bestellposition():
    # geteilter primärschlüssel, daher zusammen in einer funktion
    bestellung_ids = []
    bestell_ids = conn.execute("SELECT id FROM bestellung").fetchall()
    for i in bestell_ids:
        bestellung_ids.append(i[0])

    produkt_ids = []
    prod_ids = conn.execute("SELECT id FROM produkt").fetchall()
    for i in prod_ids:
        produkt_ids.append(i[0])
    
    ganze_position = []
    for b in bestellung_ids:
        produkte = random.sample(produkt_ids, k=5)
        for p in produkte:
            menge = random.randint(1,25)
            ganze_position.append((b, p, menge))

    return ganze_position

zipped_kunde = zip(kunde_vornamen(), kunde_nachnamen(), kunde_email(), kunde_geburtsdatum(), kunde_telefonnummer(), kunde_adresse())
conn.executemany("INSERT INTO kunde(vorname, nachname, email, geburtsdatum, telefon, adresse) VALUES(?,?,?,?,?,?)", zipped_kunde)
conn.commit()

zipped_produkt = zip(produkt_bezeichnung(), produkt_preis(), produkt_lagerbestand())
conn.executemany("INSERT INTO produkt(bezeichnung, preis, lagerbestand) VALUES(?,?,?)", zipped_produkt)
conn.commit()

zipped_bestellung = zip(bestellung_kunde_id(), bestellung_bestelldatum(), bestellung_status())
conn.executemany("INSERT INTO bestellung(kunde_id, bestelldatum, status) VALUES(?,?,?)", zipped_bestellung)
conn.commit()

conn.executemany("INSERT INTO bestellposition(bestellung_id, produkt_id, menge) VALUES (?,?,?)", bestellposition())
conn.commit()

conn.close()
