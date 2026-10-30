import sqlite3

conn = sqlite3.connect("datenbank.db")
conn.execute("PRAGMA foreign_keys = ON;")

conn.execute("BEGIN TRANSACTION;")

cursor_bestellung = conn.execute("INSERT INTO bestellung(kunde_id) VALUES(1);")
bestellung_id = cursor_bestellung.lastrowid  # letzte id

conn.executemany("""INSERT INTO bestellposition(bestellung_id, artikel_id, menge, einzelpreis) 
                    VALUES (?, ?, ?, (SELECT verkaufspreis FROM artikel WHERE id = ?));""",
                   [
                    (bestellung_id, 1, 5, 1),
                    (bestellung_id, 2, 2, 2),
                    (bestellung_id, 3, 50, 3),
                   ] 
                )

conn.executemany("UPDATE artikel SET lagerbestand = lagerbestand - ? WHERE id = ?;",
                    [
                        (5, 1),
                        (2, 2),
                        (50, 3),
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
            (bestellung_id, 1))

conn.execute("""INSERT INTO lagerbewegung (artikel_id, bestellung_id, menge, typ)
                SELECT artikel_id, bestellung_id, -menge, 'verkauf'
                FROM bestellposition
                WHERE bestellung_id = ?;""",
                (bestellung_id,))

conn.execute("END TRANSACTION;")


conn.close()