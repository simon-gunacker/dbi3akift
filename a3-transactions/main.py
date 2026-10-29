from sqlite3 import connect
import sqlite3

from handle_order import execute_order
from setup import fill_db

# config
DB = "shop.db"
MODEL = "model.sql"
DATA = "data.sql"
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
        5: 50
        # 2: 100
    }

def main():
    with connect(DB) as con:
        cur = con.cursor()


        # fill db, if it's empty or has no data
        fill_db(cur, DB, MODEL, DATA, TABLES)

        # bestellung 1
        # print("Bestellung 1:\n-------------\n")
        # execute_order(cur, kunde1, bestellung1, TABLES)

        # bestellung 2
        print("Bestellung 2:\n-------------\n")
        execute_order(cur, kunde2, bestellung2, TABLES)



if __name__ == "__main__":
    main()

