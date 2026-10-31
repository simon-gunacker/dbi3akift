import sqlite3

conn = sqlite3.connect("datenbank.db")
conn.execute("PRAGMA foreign_keys = ON;")

bestellung_id = 1

try:
    conn.execute("BEGIN TRANSACTION;")

    zeile = conn.execute("SELECT status FROM bestellung WHERE id = ?", (bestellung_id,)).fetchone()

    if zeile is None:
        raise ValueError("Bestellung existiert nicht.")
    if zeile[0] == "storniert":
        raise ValueError("Bestellung bereits storniert.")

    conn.execute("UPDATE bestellung SET status = ? WHERE id = ?;", ("storniert", bestellung_id))

    conn.execute("""UPDATE kunde 
                    SET aktueller_kredit = aktueller_kredit - (SELECT gesamtwert FROM bestellung WHERE id = ?)
                    WHERE id = (SELECT kunde_id FROM bestellung WHERE id = ?);""",
                (bestellung_id, bestellung_id))

    conn.execute("""INSERT INTO lagerbewegung (artikel_id, bestellung_id, menge, typ)
                    SELECT artikel_id, bestellung_id, +menge, 'storno'
                    FROM bestellposition
                    WHERE bestellung_id = ?;""",
                    (bestellung_id,))

    conn.execute("""UPDATE artikel
                    SET lagerbestand = lagerbestand + (SELECT menge
                                                        FROM bestellposition
                                                        WHERE bestellung_id = ?
                                                        AND artikel_id = artikel.id)
                    WHERE id IN (SELECT artikel_id FROM bestellposition WHERE bestellung_id = ?);""",
                    (bestellung_id, bestellung_id))

    conn.execute("COMMIT;")
    print("Storno erfolgreich.")

except (sqlite3.Error, ValueError) as error:
    conn.rollback()
    print("Storno abgebrochen: ", error)

finally:
    conn.close()


#sqlite> SELECT id, status FROM bestellung;
#1|storniert

#elisabeth@Mac a3-transactions % python3 storno.py
#Storno abgebrochen:  Bestellung bereits storniert.