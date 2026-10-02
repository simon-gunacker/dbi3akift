import sqlite3
from pathlib import Path

# Original DB kopieren
Path("personen_bias.db").write_bytes(Path("personen.db").read_bytes())

conn = sqlite3.connect("personen_bias.db")
cursor = conn.cursor()

# Index aus der neuen DB entfernen (wurde ja bisher nur kopiert)
cursor.execute("DROP INDEX IF EXISTS idx_personen_vorname")

# Jeder 2. Vorname ist jetzt "Sonia"
cursor.execute("UPDATE personen SET vorname = 'Sonia' WHERE id % 2 = 0")
conn.commit()

cursor.execute("VACUUM")

# Checken obs passt
cursor.execute("SELECT COUNT(*) FROM personen WHERE vorname = 'Sonia'")
anzahl = cursor.fetchone()[0]
print(f"{anzahl} von 500000 Personen heißen Sonia ({anzahl / 500000 * 100:.2f}) %")

conn.close()