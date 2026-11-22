from sqlite3 import connect

conn = connect("./library.db")

cursor = conn.cursor()
cursor.executescript(open("./SQL/library.sql").read())
cursor.executescript(open("./SQL/data.sql").read())
conn.commit()
conn.close()