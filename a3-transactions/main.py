from sqlite3 import connect

from handle_order import create_new_order
from cancellation import cancel_order
from setup import fill_db

# config
DB = "db/shop.db"
MODEL = "db/model.sql"
DATA = "db/data.sql"
VIEWS = "db/views.sql"
TABLES = [
    ["kunde", "(id, name, kreditlimit, aktueller_kredit)"],
    ["artikel", "(id, name, kategorie, einkaufspreis, verkaufspreis, lagerbestand, mindestbestand)"],
    ["bestellung", "(id, kunde_id, datum, status, gesamtwert)"],
    ["bestellposition", "(bestellung_id, artikel_id, menge, einzelpreis)"],
    ["lagerbewegung", "(id, artikel_id, bestellung_id, menge, typ, datum)"]
    ]

def print_tables(cur: object, tables: list=TABLES) -> None:

    for table in tables:
        results = cur.execute(
            f"SELECT * FROM {table[0]}").fetchall()
        table_str = f"\n{table[0].capitalize()} {table[1]}:"
        delimiter = "\n" + "-"*len(table_str)
        print(f"{delimiter}{table_str}{delimiter}")
        for result in results:
            print(f"\t{result}")

def print_artikel(
    cur: object,  bestellung: dict, nr: int
    ) -> None:

    best_str = f"\nBestellung {nr} - Artikel:"
    delimiter = "\n" + "-"*100
    print(f"{delimiter}\n{best_str}{delimiter}")
    for artikel_id, menge in bestellung.items():
        name = cur.execute(
            f"SELECT name FROM artikel WHERE id={artikel_id}"
            ).fetchone()[0]
        print(f"{name}: {menge} Stück")
    print()

def main():

    with connect(DB) as con:
        cur = con.cursor()

        # fill db, if it's empty or has no data and create views
        fill_db(cur, DB, MODEL, DATA, VIEWS, TABLES)

        # bestellung 1 - Aufgabe
        kunde1 = 1
        bestellung1 = { 1: 5, 2: 2, 3: 50 } # artikel_id: menge
        print_artikel(cur, bestellung1, 1)
        create_new_order(cur, kunde1, bestellung1, TABLES)

        # bestellung 2 - zum testen
        kunde2 = 2
        bestellung2 = { 5: 40, 1: 110 }
        print_artikel(cur, bestellung2, 2)
        create_new_order(cur, kunde2, bestellung2, TABLES)

        # bestellung 3 - zum testen
        bestellung3 = { 5: 40 }
        print_artikel(cur, bestellung3, 3)
        create_new_order(cur, kunde2, bestellung3, TABLES)

        # bestellung 4 - trigger views
        kunde3 = 3
        bestellung4 = { 2: 80, 4: 4950}
        print_artikel(cur, bestellung4, 4)
        create_new_order(cur, kunde3, bestellung4, TABLES)

        #cancel order
        print(f"\n{'-'*100}\n\nStorno: \n{'-'* 100}")
        cancel_order(cur)
        print("-"*100)

        print_tables(cur)

if __name__ == "__main__":
    main()

