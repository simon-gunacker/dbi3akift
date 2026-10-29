from sqlite3 import connect

from handle_order import create_new_order
from setup import fill_db

# config
DB = "db/shop.db"
MODEL = "db/model.sql"
DATA = "db/data.sql"
TABLES = [
    "bestellung", "bestellposition", "lagerbewegung", "artikel",
    "kunde"
    ]

# bestellung(en)
kunde1 = 1
bestellung1 = {
        # artikel_id: menge
        1: 5,
        2: 2,
        3: 50
    }

kunde2 = 2
bestellung2 = {
        5: 40,
        1: 110
    }

bestellung3 = {
        5: 40
    }

def main():


    with connect(DB) as con:


        cur = con.cursor()

        # fill db, if it's empty or has no data
        fill_db(cur, DB, MODEL, DATA, TABLES)

        # bestellung 1
        print("Bestellung 1:\n-------------\n")
        create_new_order(cur, kunde1, bestellung1, TABLES)

        # bestellung 2
        print("Bestellung 2:\n-------------\n")
        create_new_order(cur, kunde2, bestellung2, TABLES)

        # bestellung 3
        print("Bestellung 3:\n-------------\n")
        create_new_order(cur, kunde2, bestellung3, TABLES)

if __name__ == "__main__":
    main()

