import sqlite3

db = sqlite3.connect(":memory:")
db.executescript(open("model.sql").read() + open("triger.sql").read())

for s in open("test.sql").read().split(";"):
    try:
        print(db.execute(s).fetchall())
    except sqlite3.Error as e:
        print("FEHLER:", e)
