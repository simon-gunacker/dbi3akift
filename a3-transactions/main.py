from sqlite3 import connect

from handle_order import create_new_order, execute_order
from setup import fill_db
from constraints import check_constraint

# config
DB = "shop.db"
MODEL = "model.sql"
DATA = "data.sql"
TABLES = [
    "bestellung", "bestellposition", "lagerbewegung", "artikel", "kunde"
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
        1: 120,
        2:
    }

def main():
    with connect(DB) as con:
        cur = con.cursor()

        # fill db, if it's empty or has no data
        fill_db(cur, DB, MODEL, DATA, TABLES)

        # bestellung 1
        execute_order(cur, kunde1, bestellung1, TABLES)


if __name__ == "__main__":
    main()

