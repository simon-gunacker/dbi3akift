import sqlite3

conn = sqlite3.connect("datenbank.db")

with open("schema.sql", "r", encoding="utf-8") as file:
    sql_script = file.read()

conn.executescript(sql_script)

conn.commit()
conn.close()

print("Database created successfully!")
