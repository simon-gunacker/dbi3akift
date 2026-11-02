import os
import sqlite3

# Dateinamen definieren
DB_FILE = "test_lager.db"
SCHEMA_FILE = "schema_db.sql"
TESTDATA_FILE = "testdaten.sql"
VIEWS_FILE = "mgmt_views.sql"
TRANSACTION_FILE = "transactionen.sql"
STORNO_FILE = "stornierung.sql"

if os.path.exists(DB_FILE):
    os.remove(DB_FILE)

conn = sqlite3.connect(DB_FILE)
cursor = conn.cursor()

with open(SCHEMA_FILE, "r", encoding="utf-8") as f:
    cursor.executescript(f.read())


with open(TESTDATA_FILE, "r", encoding="utf-8") as f:
    cursor.executescript(f.read())


with open(VIEWS_FILE, "r", encoding="utf-8") as f:
    cursor.executescript(f.read())

with open(TRANSACTION_FILE, "r", encoding="utf-8") as f:
    cursor.executescript(f.read())

conn.commit()


print("NACH DER TRANSAKTION")

print("\nBestellung:")
for row in cursor.execute("SELECT * FROM bestellung"):
    print(row)

print("\nBestellposition:")
for row in cursor.execute("SELECT * FROM bestellposition"):
    print(row)

print("\nArtikel:")
for row in cursor.execute("SELECT id, name, lagerbestand, verkaufspreis FROM artikel"):
    print(row)


print("\nVIEW Tagesumsatz:")
for row in cursor.execute("SELECT * FROM v_tagesumsatz"):
    print(row)

print("\nVIEW Lagerkonsistenz:")
for row in cursor.execute("SELECT * FROM v_lager_konsistenz"):
    print(row)


with open(STORNO_FILE, "r", encoding="utf-8") as f:
    cursor.executescript(f.read())

conn.commit()

print("\nNACH DER STORNIERUNG ")

print("\nBestellung:")
for row in cursor.execute("SELECT * FROM bestellung"):
    print(row)

print("\nArtikel:")
for row in cursor.execute("SELECT id, name, lagerbestand, verkaufspreis FROM artikel"):
    print(row)

print("\nLagerkonsistenz nach Storno:")
for row in cursor.execute("SELECT * FROM v_lager_konsistenz"):
    print(row)

# Nachbestellung
cursor.execute("UPDATE artikel SET lagerbestand = 5 WHERE id = 1;")
conn.commit()

print("\nArtikel Nachbestellung (v_artikel_nachbestellung):")
for row in cursor.execute("SELECT * FROM v_artikel_nachbestellung"):
    print(row)

# Kreditlimit 
cursor.execute("UPDATE kunde SET aktueller_kredit = 4600 WHERE id = 1;")
conn.commit()

print("\nVIEW Kreditlimit:")
for row in cursor.execute("SELECT * FROM v_kunden_kreditlimit"):
    print(row)


conn.close()