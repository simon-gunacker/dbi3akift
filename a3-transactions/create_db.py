import sqlite3

DB = "lager.db"
conn = sqlite3.connect(DB)

#open the db-connection and read the model file to create the tables
with open("model.sql", encoding="utf-8") as file:
    conn.executescript(file.read())
conn.close()

print("lager.db created succesfully")
