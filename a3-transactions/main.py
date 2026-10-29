from sqlite3 import connect

from handle_order import create_new_order, cancellation
from setup import fill_db

# config
DB = "db/shop.db"
MODEL = "db/model.sql"
DATA = "db/data.sql"
TABLES = [
    "bestellung", "bestellposition", "lagerbewegung", "artikel",
    "kunde"
    ]

def main():

    # creates db if not exists
    with connect(DB) as con:
        cur = con.cursor()

        # fill db, if it's empty or has no data
        fill_db(cur, DB, MODEL, DATA, TABLES)

        # bestellung 1
        kunde1 = 1
        bestellung1 = { 1: 5, 2: 2, 3: 50 } # artikel_id: menge

        print("Bestellung 1:\n-------------\n")
        create_new_order(cur, kunde1, bestellung1, TABLES)

        # bestellung 2
        kunde2 = 2
        bestellung2 = { 5: 40, 1: 110 }
        print("Bestellung 2:\n-------------\n")
        create_new_order(cur, kunde2, bestellung2, TABLES)

        # bestellung 3
        bestellung3 = { 5: 40 }
        print("Bestellung 3:\n-------------\n")
        create_new_order(cur, kunde2, bestellung3, TABLES)

        #cancel order
        cancellation(cur)

if __name__ == "__main__":
    main()

