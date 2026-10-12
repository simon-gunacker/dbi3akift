import sqlite3
import random
from datetime import datetime, timedelta
from decimal import Decimal

random.seed(43)  # wanted to participate, but missed it by one!

MIN_BETRAG = 200       # 2.00 in cents
MAX_BETRAG = 200000    # 2,000.00 in cents

VORNAMEN = ["Ross", "Chandler", "Phoebe", "Gunther", "Susan", "Janice", "Carol", "Monica", "Rachel", "Joey"]
NACHNAMEN = ["Geller", "Green", "Bing", "Tribbiani", "Buffay", "Litman-Goralnik", "Willick", "Bunch", "Waltham", "Burke"]
ARTIKEL = ["Kaffeetasse", "Orangefarbenes Sofa", "Gitarre", "Tischfußball",
           "Türrahmen mit Spiegel", "Lederhose", "Plüschhummer",
           "Plüschente", "Plüschküken", "Pizza-Karton",  "Kappuccino"]
STATUS = ["neu", "bezahlt", "versendet", "geliefert", "on a break", "PIVOT!", "Unagi", "Moo Point", "Phalange", "Transponster"]

conn = sqlite3.connect("online_shop.db")

for t in ("bestellposition", "bestellung", "produkt", "kunde"):
    conn.execute(f"DROP TABLE IF EXISTS {t}")

conn.executescript(open("model.sql", encoding="utf-8").read())

for i in range(1, 10001):
    v, n = random.choice(VORNAMEN), random.choice(NACHNAMEN)
    conn.execute(
        "INSERT INTO kunde (vorname, nachname, email, geburtsdatum, telefon, adresse) VALUES (?, ?, ?, ?, ?, ?)",
        (v, n, f"{v}.{n}{i}@friends.com".lower(),
         (datetime(1960, 1, 1) + timedelta(days=random.randint(0, 15000))).date().isoformat(),
         f"+1 212 {random.randint(1000000, 9999999)}",
         f"Central Park West {random.randint(1, 99)}, New York"),
    )

for i in range(1, 10001):
    preis = Decimal(random.randint(MIN_BETRAG, MAX_BETRAG)) / Decimal(100)
    conn.execute(
        "INSERT INTO produkt (bezeichnung, preis, lagerbestand) VALUES (?, ?, ?)",
        (f"{random.choice(ARTIKEL)} {i}", float(preis), random.randint(0, 500)),
    )

for i in range(100000):
    datum = datetime(2024, 1, 1) + timedelta(seconds=random.randint(0, 2 * 365 * 24 * 3600))
    conn.execute(
        "INSERT INTO bestellung (kunde_id, bestelldatum, status) VALUES (?, ?, ?)",
        (random.randint(1, 10000), datum.strftime("%Y-%m-%d %H:%M:%S"), random.choice(STATUS)),
    )

for bestellung_id in range(1, 100001):
    for produkt_id in random.sample(range(1, 10001), 5): # 5 positionen pro bestellung
        conn.execute(
            "INSERT INTO bestellposition (bestellung_id, produkt_id, menge) VALUES (?, ?, ?)",
            (bestellung_id, produkt_id, random.randint(1, 10)), # menge max.10
        )

conn.commit()
conn.close()
