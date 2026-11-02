from sqlite3 import connect

conn = connect("./shop.db")

cursor = conn.cursor()
cursor.executescript(open("./SQL/model.sql").read())
cursor.executescript(open("./SQL/example_data.sql").read())
cursor.executescript(open("./SQL/automatic_transaction_validation.sql").read())
conn.commit()
conn.close()