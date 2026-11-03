import sqlite3


if __name__ == "__main__":
    db = sqlite3.connect("mydb.db")
    cur = db.cursor()
    [cur.execute(instruction) for instruction in open("database.sql", "r").read().split(";")]
    db.commit()
    [cur.execute(instruction) for instruction in open("transaction_safe.sql", "r").read().split(";")]
    #[cur.execute(instruction) for instruction in open("storno.sql", "r").read().split(";")]
    [print(cur.execute(instruction).fetchall()) for instruction in open("check.sql", "r").read().split(";")]
