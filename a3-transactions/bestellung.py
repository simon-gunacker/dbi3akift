import sqlite3

conn = sqlite3.connect("datenbank.db")
conn.execute("PRAGMA foreign_keys = ON;")

conn.execute("BEGIN TRANSACTION;")

cursor_bestellung = conn.execute("INSERT INTO bestellung(kunde_id) VALUES(1);")

conn.execute("END TRANSACTION;")


conn.close()