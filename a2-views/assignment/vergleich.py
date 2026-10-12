import sqlite3

conn = sqlite3.connect("datenbank.db")

cursor = conn.cursor()

letzte_bestellung_a = """
    SELECT * 
    FROM letzte_bestellung_a
    LIMIT 100;
"""

letzte_bestellung_b = """
    SELECT * 
    FROM letzte_bestellung_b
    LIMIT 100;
"""

bestellung_a = cursor.execute(letzte_bestellung_a).fetchall()
bestellung_b = cursor.execute(letzte_bestellung_b).fetchall()

if sorted(bestellung_a) == sorted(bestellung_b):
    print("beide Views liefern dieselben Ergebnisse")
else:
    print("Views liefern unterschiedliche Ergebnisse")

conn.commit()
conn.close()
