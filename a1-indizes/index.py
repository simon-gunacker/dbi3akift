import sqlite3
import time
from pathlib import Path

DB_DATEI = input("Welche Datenbank? (personen.db oder personen_bias.db) ")

if not Path(DB_DATEI).exists():
    print(f"Datei '{DB_DATEI}' gibt es nicht.")
    exit()

# Eingabe Name
name = input("Nach welchem Vornamen soll gesucht werden? ")

conn = sqlite3.connect(DB_DATEI)
cursor = conn.cursor()

def suche():
    start = time.perf_counter() # perf_counter für genaue zeitmessung, genauer als time()
    cursor.execute("SELECT * FROM personen WHERE vorname = ?", (name, ))
    treffer = cursor.fetchall()
    dauer = (time.perf_counter() - start) * 1000
    print(f"    {len(treffer)} Treffer in {dauer:.3f} ms")

def groesse():
    mb = Path(DB_DATEI).stat().st_size / 1024 / 1024
    print(f"    Dateigröße: {mb:.1f} MB")

# Ausgangszustand: KEIN Index
cursor.execute("DROP INDEX IF EXISTS idx_personen_vorname")
conn.commit()
cursor.execute("VACUUM") # schreibt DB neu, räumt auf damit Dateigröße wieder passt, gibt Speicherplatz wieder frei

# OHNE Index
print("OHNE Index:")
groesse()
for i in range(3):
    suche()

# Index anlegen. Hier wird Speicher größer! (bei Vacuum dann wieder kleiner)
cursor.execute("CREATE INDEX idx_personen_vorname ON personen(vorname)")
conn.commit()

# MIT Index
print("MIT Index:")
groesse()
for i in range(3):
    suche()

conn.close()