import sqlite3

conn = sqlite3.connect("transactions.db")
cursor = conn.cursor()

kunde_id = cursor.execute("SELECT id FROM kunde WHERE name = 'TechShop Wien'").fetchone()[0]

bestell_liste = [('Arduino Uno', 5), ('Raspberry Pi 4', 2), ('LED 5mm rot', 50)]
gesamtwert = 0.0
try: 
    cursor.execute("BEGIN TRANSACTION;")

    # Bestellung anlegen
    cursor.execute("INSERT INTO bestellung (kunde_id) VALUES (?)", (kunde_id,))
    bestell_id = cursor.lastrowid

    for name, menge in bestell_liste:
        artikel_id, einzelpreis = cursor.execute("SELECT id, verkaufspreis FROM artikel WHERE name = ?", (name,)).fetchone()

        # Bestellpositionen einfügen
        cursor.execute("INSERT INTO bestellposition (bestellung_id, artikel_id, menge, einzelpreis) VALUES (?,?,?,?)", (bestell_id, artikel_id, menge, einzelpreis))

        #Lagerbestand reduziweren 
        cursor.execute("UPDATE artikel SET lagerbestand = lagerbestand - ? WHERE id = ?", (menge, artikel_id))

        # Lagerbewegungen
        cursor.execute("INSERT INTO lagerbewegung (artikel_id, bestellung_id, menge, typ) VALUES (?,?,?,'verkauf')", (artikel_id, bestell_id, -menge))
        #Gesamtpreis 
        gesamtwert += einzelpreis * menge

    cursor.execute("UPDATE bestellung SET gesamtwert = ? WHERE id = ?", (gesamtwert, bestell_id))

    cursor.execute("UPDATE kunde SET aktueller_kredit = aktueller_kredit + ?  WHERE id = ?", (gesamtwert, kunde_id))
    
    conn.commit()

    print("alles hat funkuniert")
except sqlite3.IntegrityError as error:
    conn.rollback()
    print("Bestellung abgebrochen", error)

conn.close()