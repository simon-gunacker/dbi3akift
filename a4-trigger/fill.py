import sqlite3

db = sqlite3.connect("mydb.db")
cur = db.cursor()


if __name__ == "__main__":
    [cur.execute(instruction) for instruction in open("database.sql", "r").read().split(";")]
    cur.executescript(open("triggers.sql", "r").read())
    cur.execute(open("user_handling.sql","r").read().split(";")[0])
    db.commit()

    #important user-data stuff
    cur.execute(open("user_handling.sql","r").read().split(";")[1],(1, "", 1, "", 1))
    cur.executescript(open("ausleihen.sql","r").read())
    cur.executescript(open("rueckgabe.sql","r").read())
    cur.execute("INSERT INTO ausleihe(nutzer_id, medium_id, rueckgabedatum) VALUES(2, 2, (DATE('now'))) ")
    cur.executescript(open("mahnung.sql","r").read())
    cur.execute("INSERT INTO ausleihe(nutzer_id, medium_id, rueckgabedatum) VALUES(2, 2, (DATE('now', '-' || ? || ' days'))) ", (1,))
    cur.executescript(open("mahnung.sql","r").read())
    cur.execute("INSERT INTO ausleihe(nutzer_id, medium_id, rueckgabedatum) VALUES(2, 2, (DATE('now', '-' || ? || ' days'))) ", (1,))
    cur.executescript(open("mahnung.sql","r").read())
    cur.execute("DELETE FROM nutzer WHERE id = 1")


    #[cur.execute(instruction) for instruction in open("triggers.sql", "r").read().split("üö")]
    #[cur.execute(instruction) for instruction in open("ausleihen.sql", "r").read().split("üö")]
    db.commit()
