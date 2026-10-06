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

products = {
    "name" : [
        "Computer", "Bildschirm", "Tastatur", "Maus", "Mikrofon",
        "Laptop", "Kamera", "HDMI-Kabel", "Stromkabel",
        "Festplatte", "Grafikkarte", "Prozessor"
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

customers = {
    "first_name": [
        "Daniel", "Markus", "David", "Hansi", "Hubert",
        "Pablo", "Sonia", "Sieglinde", "Simone", "Betti",
        "Gerfried"
    ],
    "last_name": [
        "Mustermann", "Maier", "Huber", "Schubert", "Escobar",
        "Beethoven", "Precht", "Presley", "Hanser", "Newton",
        "Kant", "Musterfrau"
    ],
    "email": [
        "haus@mail.to", "hund@mail.to", "baum@mail.to",
        "strasse@mail.to", "blume@mail.to", "katze@mail.to",
        "turtle@mail.to", "teich@mail.to", "stift@mail.to",
        "schere@mail.to", "maus@mail.to"
    ],
    "birth_date": [
        "0000-01-01", "1987-03-02", "2000-07-29", "1899-12-13",
        "1963-10-11", "1995-05-16", "2004-03-28", "1968-11-21",
        "1999-12-31", "2000-01-01"
    ],
    "phone": [
        "06601234567", "06647654321", "06769081726",
        "06603847291", "06645529038", "06768810452",
        "06602193746", "06647305918", "06765624087",
        "06609472615", "06641836029", "06763058194"
    ],
    "address": [
        "Hauptplatz 1, 8010 Graz",
        "Mariahilfer Straße 45, 1060 Wien",
        "Getreidegasse 12, 5020 Salzburg",
        "Maria-Theresien-Straße 8, 6020 Innsbruck",
        "Landstraße 33, 4020 Linz", "Herrengasse 17, 8010 Graz",
        "Kärntner Straße 21, 1010 Wien",
        "Bahnhofstraße 5, 9020 Klagenfurt",
        "Rathausplatz 3, 3100 St. Pölten",
        "Annenstraße 52, 8020 Graz",
        "Domgasse 9, 5020 Salzburg",
        "Hauptstraße 14, 7000 Eisenstadt"
    ]
}

orders = {
    "customer_id": range(1, 10001),
    "order_date": [
        "2025-01-14", "2025-02-27", "2025-04-03", "2025-05-19",
        "2025-06-30", "2025-08-12", "2025-09-24", "2025-11-06",
        "2025-12-18", "2026-02-09", "2026-05-21", "2026-10-05"
    ],
    "status": ["completed", "retoured", "failed"],
}

product_order = {
    "order_id": range(1, 100001),
    "product_id": range(1, 10001),
    "amount": [
        1, 2, 3, 4, 5, 6, 7, 8, 9, 10,
        100, 200, 300, 500, 1000, 5000
    ]
}

def insert_data(
     table_name: str, columns: dict, row_count: int,
     seed: int = None, database: str = DATABASE
    ) -> None:

    random.seed(seed) # takes curr time if seed's None

    # results: col1, col2, col3, etc.
    col_string = ', '.join(columns.keys())
    # results: ?, ?, ?, etc.
    val_string = '?, ' * len(columns.keys())

    with connect(database) as con:
        cur = con.cursor()

        for x in range(row_count):
            random_vals = []
            for _, vals in columns.items():
                if len(vals) == 0:
                    continue
                random_vals.append(random.choice(vals))
            # [:-2] - leave last ', ' out
            statement = f"INSERT INTO {table_name}({col_string}) VALUES({val_string[:-2]})"
            cur.execute(statement, random_vals)
            print(statement, "\n", random_vals)

def create_orders(
    table_name: str, order_d: dict, row_count: int,
    seed: int = None, database: str = DATABASE
    ):

    random.seed(seed)

    # results: col1, col2, col3, etc.
    col_string = ', '.join(order_d.keys())
    # results: ?, ?, ?, etc.
    val_string = '?, ' * len(order_d.keys())

    with connect(database) as con:
        cur = con.cursor()
        for order in order_d["order_id"]:
            rand_prod_id = random.choice(order_d['product_id'])
            rand_amount = random.choice(order_d['amount'])
            random_vals = [order, rand_prod_id, rand_amount]
            # [:-2] - leave last ', ' out
            statement = f"INSERT INTO {table_name}({col_string}) VALUES({val_string[:-2]})"
            cur.execute(statement, random_vals)
            print(statement, "\n", random_vals)

def main():

    insert_data("products", products, 10000)
    insert_data("customers", customers, 10000)
    insert_data("orders", orders, 100000)
    create_orders("product_order", product_order, 500000)

if __name__ == "__main__":
    main()
