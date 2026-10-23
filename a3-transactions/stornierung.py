import sqlite3

conn = sqlite3.connect("transactions.db")
cursor = conn.cursor()


bestell_id = 1

try: 
    cursor.execute("BEGIN TRANSACTION;")

    bestellung = cursor.execute("SELECT kunde_id, gesamtwert FROM bestellung WHERE id = ?", (bestell_id,)).fetchone()
    # gibts es überhaupt eine bestellung falls nicht dann soll sofort ein error kommen 
    if bestellung is None:
        raise ValueError("Bestellung gibts nicht")

    kunde_id, gesamtwert = bestellung

    stoniert = cursor.execute("SELECT COUNT(*) FROM lagerbewegung WHERE bestellung_id = ? AND typ = 'storno'", (bestell_id,)).fetchone()[0]
    # Wenn es schon mal stoniert wurde dann soll verhindert werden das man nochmal stonieren kann 
    if stoniert > 0:
        raise ValueError("bereits stoniert")

    positionen = cursor.execute("SELECT artikel_id, menge FROM bestellposition WHERE bestellung_id = ?", (bestell_id,)).fetchall()

    
    for artikel_id, menge in positionen:
        cursor.execute("UPDATE artikel SET lagerbestand = lagerbestand + ? WHERE id = ?", (menge, artikel_id))
        cursor.execute("INSERT INTO lagerbewegung (artikel_id, bestellung_id, menge, typ) VALUES (?,?,?,'storno')", (artikel_id, bestell_id, menge))

    cursor.execute("UPDATE kunde SET aktueller_kredit = aktueller_kredit - ? WHERE id = ?", (gesamtwert, kunde_id))

    print("bestellung storniert")
    conn.commit()

except (sqlite3.IntegrityError, ValueError) as error:
    conn.rollback()
    print("abgebrochen", error)

conn.close()
