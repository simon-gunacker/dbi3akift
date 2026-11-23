import sqlite3

db = sqlite3.connect("mydb.db")
cur = db.cursor()


if __name__ == "__main__":
    [cur.execute(instruction) for instruction in open("database.sql", "r").read().split(";")]
    cur.executescript(open("triggers.sql", "r").read())
    cur.execute(open("user_handling.sql","r").read().split(";")[0])

    #important user-data stuff
    cur.execute(open("user_handling.sql","r").read().split(";")[1],(1, "", 1, "", 1))
    print("\nAusleihe-Test:")
    print(f'Ausleihe before ausleihe: {cur.execute("SELECT * FROM ausleihe WHERE nutzer_id = 1 AND medium_id = 1").fetchall()}')
    cur.executescript(open("ausleihen.sql","r").read())
    print(f'Ausleihe after ausleihe: {cur.execute("SELECT * FROM ausleihe WHERE nutzer_id = 1 AND medium_id = 1").fetchall()}')
    print(f'System_log after : {cur.execute("SELECT * FROM system_log WHERE aktion = 'Ausleihe'").fetchall()}')
    print("\nRückgabe-Test:")
    print(f'Ausleihe before rueckgabe: {cur.execute("SELECT * FROM ausleihe WHERE nutzer_id = 1 AND medium_id = 1").fetchall()}')
    cur.executescript(open("rueckgabe.sql","r").read())
    print(f'Ausleihe after rueckgabe: {cur.execute("SELECT * FROM ausleihe WHERE nutzer_id = 1 AND medium_id = 1").fetchall()}')
    print(f'System_log after rueckgabe: {cur.execute("SELECT * FROM system_log WHERE aktion = 'Rueckgabe'").fetchall()}')
    print("\nMahnungs-Test:")
    print(f'Ausleihe before Test_data: {cur.execute("SELECT * FROM ausleihe WHERE nutzer_id = 2 AND medium_id = 2").fetchall()}')
    cur.execute("INSERT INTO ausleihe(nutzer_id, medium_id, rueckgabedatum) VALUES(2, 2, (DATE('now', '-' || ? || ' days'))) ", (1,))
    print(f'Ausleihe after Test_data and before mahnung: {cur.execute("SELECT * FROM ausleihe WHERE nutzer_id = 2 AND medium_id = 2").fetchall()}')
    print(f'Mahnung before mahnung: {cur.execute("SELECT * FROM mahnung WHERE ausleihe_id = (SELECT id FROM ausleihe WHERE nutzer_id = 2 AND medium_id = 2)").fetchall()}')
    print(f'Nutzer before mahnung: {cur.execute("SELECT * FROM nutzer WHERE id = 2").fetchall()}')
    cur.executescript(open("mahnung.sql","r").read())
    print(f'Ausleihe after mahnung: {cur.execute("SELECT * FROM ausleihe WHERE nutzer_id = 2 AND medium_id = 2").fetchall()}')
    print(f'Mahnung after mahnung: {cur.execute("SELECT * FROM mahnung WHERE ausleihe_id = (SELECT id FROM ausleihe WHERE nutzer_id = 2 AND medium_id = 2)").fetchall()}')
    print(f'Nutzer after mahnung: {cur.execute("SELECT * FROM nutzer WHERE id = 2").fetchall()}')
    print("System_log after mahnung:")
    [print(instruction) for instruction in cur.execute("SELECT * FROM system_log WHERE aktion = 'Mahnung' OR aktion = 'Zahlung' OR aktion = 'Sperrung'").fetchall()]
    print("\nSperrungs-Test:")
    try:
        cur.execute("INSERT INTO ausleihe(nutzer_id, medium_id, rueckgabedatum) VALUES(2, 2, (DATE('now', '-' || ? || ' days'))) ", (1,))
    except sqlite3.IntegrityError as e:
        print(e)
    #cur.execute("INSERT INTO ausleihe(nutzer_id, medium_id, rueckgabedatum) VALUES(2, 2, (DATE('now', '-' || ? || ' days'))) ", (1,))
    #cur.executescript(open("mahnung.sql","r").read())
    print("\nDelete-Test:")
    print(f'Nutzer before delete: {cur.execute("SELECT * FROM nutzer WHERE id = 1").fetchall()}')
    print(f'Mahnung before delete: {cur.execute("SELECT * FROM mahnung WHERE ausleihe_id = (SELECT id FROM ausleihe WHERE nutzer_id = 1)").fetchall()}')
    print(f'Ausleihe before delete: {cur.execute("SELECT * FROM ausleihe WHERE nutzer_id = 1").fetchall()}')
    print(f'System_log before delete: {cur.execute("SELECT * FROM system_log WHERE aktion = 'Loeschung'").fetchall()}')
    cur.execute("DELETE FROM nutzer WHERE id = 1")
    print(f'Nutzer after delete: {cur.execute("SELECT * FROM nutzer WHERE id = 1").fetchall()}')
    print(f'Mahnung after delete: {cur.execute("SELECT * FROM mahnung WHERE ausleihe_id = (SELECT id FROM ausleihe WHERE nutzer_id = 1)").fetchall()}')
    print(f'Ausleihe after delete: {cur.execute("SELECT * FROM ausleihe WHERE nutzer_id = 1").fetchall()}')
    print(f'System_log after delete: {cur.execute("SELECT * FROM system_log WHERE aktion = 'Loeschung'").fetchall()}')
    print("\nBestands-Test")
    try:
        cur.execute("UPDATE medium SET bestand = bestand - 2 WHERE id = 2 ")
    except sqlite3.IntegrityError as e:
        print(e)
    print("\nMahnbetrag-Test:")
    try:
        cur.execute("INSERT INTO mahnung(ausleihe_id, betrag) VALUES(2, -3)")
    except sqlite3.IntegrityError as e:
        print(e)
    db.commit()
