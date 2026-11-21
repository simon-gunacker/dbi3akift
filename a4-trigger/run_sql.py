import sqlite3

# Ask which database and which SQL file to use
db_name = input("Database: ")
sql_file = input("SQL file: ")

# Read the SQL file
with open(sql_file, encoding="utf-8") as f:
    sql = f.read()

# Connect to the database and run the SQL
conn = sqlite3.connect(db_name)
conn.executescript(sql)
conn.close()

print("Done!")