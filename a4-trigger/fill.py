import sqlite3

db = sqlite3.connect("mydb.db")
cur = db.cursor()


if __name__ == "__main__":
    [cur.execute(instruction) for instruction in open("database.sql", "r").read().split(";")]
    [cur.execute(instruction) for instruction in open("triggers.sql", "r").read().split("üö")]
    [cur.execute(instruction) for instruction in open("ausleihen.sql", "r").read().split("üö")]
    db.commit()
