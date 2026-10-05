import random
from sqlite3 import connect

"""
Schreibe eine seed.py, welche die Datenbank mit zufällig erzeugten Testdaten befüllt.
Die Datengrundlage und die Wertebereiche müssen im vorgegebenen Code enthalten sein (die Verwendung der faker-lib ist an dieser Stelle ausgeschlossen).
Verwende weiters einen festen Random Seed, sodass bei jedem Programmlauf dieselben Daten erzeugt werden.
Verwende folgende Tabellengrößen:
    Tabelle Anzahl
    produkt 10.000
    bestellposition 500.000
    bestellung 100.000
    kunde 10.000
Die erzeugten Daten sollen realistisch genug sein, um sinnvolle SQL-Abfragen und Performance-Messungen zu ermöglichen.

"""

DATABASE = "shop.db"

product = {
    "name" : [
        "Computer", "Bildschirm", "Tastatur", "Maus", "Mikrofon",
        "Laptop", "Kamera", "HDMI-Kabel", "Stromkabel", "Festplatte",
        "Grafikkarte", "Prozessor"
        ]
    , "price" : [
        499.99, 149.99, 19.99, 9.99, 12.99, 349.99,
        24.99, 7.99, 2.99, 199.99, 169.99, 49.99
        ]
    , "inventory" : [
        0, 1, 2, 3, 10, 20, 30, 100, 200, 300, 600, 1200,
        2400, 750, 42
        ]
}

random.seed(1)

for x in range(5):
    print(random.choice(product["name"]))
    print(random.choice(product["name"]))
    print(random.choice(product["name"]))
    print('\n')

with connect(DATABASE) as con:
    cur = con.cursor()
    cur.execute(
        """INSERT INTO ? (?)
            VALUES (?)

        """, ("products", list(product.keys()),
              ("Hi", 2.0, 2))
    )

# print(
#     """INSERT INTO ? (?)
#         VALUES (?)
#
#     """, ("products", product.keys(),
#             map(lambda x: random.choice(product[x]), product))
# )

def create_inserts(
    database: str, table_name: str, colums: dict,
    row_count: int, seed: int = None
    ) -> None:

    random.seed(seed) # takes curr time if seed's None

    with connect(database) as con:
        cur = con.cursor()
        cur.execute(
            """INSERT INTO ?

            """
            )
