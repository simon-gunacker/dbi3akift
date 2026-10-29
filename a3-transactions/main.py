from sqlite3 import connect

from handle_order import create_transaction
from setup import fill_db

# config
DB = "shop.db"
MODEL = "model.sql"
DATA = "data.sql"
TABLES = [
    "bestellung", "bestellposition", "lagerbewegung", "artikel", "kunde"
    ]

# bestellung
kunde_id = 1
bestellung1 = {
        1: 500,
        2: 2,
        3: 50
    }

def main():
    with connect(DB) as con:
        cur = con.cursor()

        # fill db, if it's empty or has no data
        fill_db(cur, DB, MODEL, DATA, TABLES)

        try:
            create_transaction(cur, 1, bestellung1, TABLES)
        except Exception as e:
            print(e)

if __name__ == "__main__":
    main()

