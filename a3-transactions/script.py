import sqlite3

conn = sqlite3.connect("transactions.db")
cursor = conn.cursor()

with open("model.sql", "r", encoding="utf-8") as f:
    model = f.read()

cursor.executescript(model)

print("Datenbank erstellt und mit daten befühlt")
conn.commit()
conn.close()
