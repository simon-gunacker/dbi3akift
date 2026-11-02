import os
import sqlite3

DB_FILE = "test_lager.db"
SCHEMA_FILE = "schema_db.sql"
TESTDATA_FILE = "testdaten.sql"
VIEWS_FILE = "mgmt_views.sql"
VALIDATION_FILE = "validierung.sql"  

if os.path.exists(DB_FILE):
    os.remove(DB_FILE)


conn = sqlite3.connect(DB_FILE)
cursor = conn.cursor()


with open(SCHEMA_FILE, "r", encoding="utf-8") as f:
    schema_sql = f.read()
cursor.executescript(schema_sql)

with open(TESTDATA_FILE, "r", encoding="utf-8") as f:
    testdata_sql = f.read()
cursor.executescript(testdata_sql)


with open(VIEWS_FILE, "r", encoding="utf-8") as f:
    views_sql = f.read()
cursor.executescript(views_sql)


cursor.execute("UPDATE kunde SET aktueller_kredit = 4800.0 WHERE id = 1;")
cursor.execute("UPDATE artikel SET lagerbestand = 2 WHERE id = 1;")

with open(VALIDATION_FILE, "r", encoding="utf-8") as f:
    validation_sql = f.read()
cursor.executescript(validation_sql)

conn.commit()


print("\nLagerbewegung:")
for row in cursor.execute("SELECT * FROM lagerbewegung"):
    print(row)

print("\nBestellung:")
for row in cursor.execute("SELECT id, status, gesamtwert FROM bestellung"):
    print(row)

conn.close()