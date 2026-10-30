import sqlite3

conn = sqlite3.connect("datenbank.db")
conn.execute("PRAGMA foreign_keys = ON;")

conn.execute("BEGIN TRANSACTION;")

cursor_bestellung = conn.execute("INSERT INTO bestellung(kunde_id) VALUES(2);")
bestellung_id = cursor_bestellung.lastrowid

conn.executemany("""INSERT INTO bestellposition(bestellung_id, artikel_id, menge, einzelpreis) 
                    VALUES (?, ?, ?, (SELECT verkaufspreis FROM artikel WHERE id = ?));""",
                   [
                    (bestellung_id, 1, 25, 1),
                    (bestellung_id, 2, 48, 2),
                    (bestellung_id, 3, 950, 3),
                    (bestellung_id, 4, 5000, 4),
                    (bestellung_id, 5, 30, 5),
                   ] 
                )

conn.executemany("UPDATE artikel SET lagerbestand = lagerbestand - ? WHERE id = ?;",
                    [
                        (25, 1),
                        (48, 2),
                        (950, 3),
                        (5000, 4),
                        (30, 5)
                    ] 
                )

conn.execute("""UPDATE bestellung 
                SET gesamtwert = (SELECT SUM(menge * einzelpreis) 
                                FROM bestellposition
                                WHERE bestellung_id = ?) 
                WHERE id = ?;""",
            (bestellung_id, bestellung_id))

conn.execute("""UPDATE kunde 
                SET aktueller_kredit = aktueller_kredit + (SELECT gesamtwert FROM bestellung WHERE id = ?)
                WHERE id = ?;""",
            (bestellung_id, 2))

conn.execute("""INSERT INTO lagerbewegung (artikel_id, bestellung_id, menge, typ)
                SELECT artikel_id, bestellung_id, -menge, 'verkauf'
                FROM bestellposition
                WHERE bestellung_id = ?;""",
                (bestellung_id,))

conn.execute("END TRANSACTION;")
conn.close()


# WHAT HAPPENS?

# Mac a3-transactions % python3 validierung.py 
#Traceback (most recent call last):x
#  File "/a3-transactions/validierung.py", line 22, in <module>
#    conn.executemany("UPDATE artikel SET lagerbestand = lagerbestand - ? WHERE id = ?;",
#sqlite3.IntegrityError: CHECK constraint failed: lagerbestand >= 0

# Mac a3-transactions % python3 validierung.py
#Traceback (most recent call last):
#  File "/a3-transactions/validierung.py", line 39, in <module>
#    conn.execute("""UPDATE kunde 
#sqlite3.IntegrityError: CHECK constraint failed: aktueller_kredit <= kreditlimit