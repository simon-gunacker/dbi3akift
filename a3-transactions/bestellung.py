import sqlite3 

conn = sqlite3.connect("transactions.db")
cursor = conn.cursor()

kunde_id = cursor.execute("SELECT id FROM kunde WHERE name = 'TechShop Wien'").fetchone()[0]

bestellung = [('Arduino Uno', 5), ('Raspberry Pi 4', 2), ('LED 5mm rot', 50)]
gesamtwert = 0.0

cursor.execute("BEGIN TRANSACTION;")
# Bestellung anlegen
cursor.execute("INSERT INTO bestellung (kunde_id) VALUES (?)", (kunde_id,))

bestellung_id = cursor.lastrowid

for name, menge in bestellung:
    artikel_id, einzelpreis= cursor.execute("SELECT id, verkaufspreis FROM artikel WHERE name = ?", (name,)).fetchone()

    # Bestellpositionen einfügen
    cursor.execute("INSERT INTO bestellposition (bestellung_id, artikel_id, menge, einzelpreis) VALUES (?,?,?,?)", (bestellung_id, artikel_id, menge, einzelpreis))

    #Lagerbestand reduziweren 
    cursor.execute("UPDATE artikel SET lagerbestand = lagerbestand - ? WHERE id = ?", (menge, artikel_id))

    # Lagerbewegungen
    cursor.execute("INSERT INTO lagerbewegung (artikel_id, bestellung_id, menge, typ) VALUES (?,?,?, 'verkauf')", (artikel_id, bestellung_id, -menge),)

    #Gesamtpreis 
    gesamtwert += menge * einzelpreis

# Gesamtwert eintragen
cursor.execute("UPDATE bestellung SET gesamtwert = ? WHERE id = ?", (gesamtwert, bestellung_id))

# Kundenkredit erhöhen
cursor.execute("UPDATE kunde SET aktueller_kredit = aktueller_kredit + ?  WHERE id = ?", (gesamtwert, kunde_id))


print("alles hat funkuniert")
conn.commit()
conn.close()