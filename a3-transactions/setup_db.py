import os
from sqlite3 import connect

from handle_order import DB

MODEL = "model.sql"
DATA = "data.sql"

def main():
    if DB not in os.listdir():
        with open(DB, "w") as f:
            pass
        with open(MODEL, "r") as m, open(DATA, "r") as d:
            model = m.read()
            data = d.read()
        with connect(DB) as con:
            con.executescript(model)
            con.executescript(data)
            print(model, "\n", data)

    else:
        print(f"Database already exists")

if __name__ == "__main__":
    main()
