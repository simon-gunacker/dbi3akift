import os # Betriebsystemmodul um zu prüfen ob datei schon existiert
import sqlite3

DB_FILE = "test_lager.db"
SCHEMA_FILE = "schema_db.sql"
TESTDATA_FILE = "testdaten.sql"
VIEWS_FILE = "mgmt_views.sql"

if os.path.exists(DB_FILE):# DB löschen falls sie existiert
    os.remove(DB_FILE)
   

conn = sqlite3.connect(DB_FILE)# DB erstellen und verbinden
cursor = conn.cursor()


with open(SCHEMA_FILE, "r", encoding="utf-8") as f:# einlesn und ausführen
    schema_sql = f.read()
cursor.executescript(schema_sql)

with open(TESTDATA_FILE, "r", encoding="utf-8") as f:# einlesn und ausführen
    testdata_sql = f.read()
cursor.executescript(testdata_sql)

with open(VIEWS_FILE, "r", encoding="utf-8") as f:
    views_sql = f.read()
cursor.executescript(views_sql)

conn.commit()
conn.close()
