from sqlite3 import connect
from faker import Faker

fake = Faker()

connection = connect("Kunden.db")
cursor = connection.cursor()


cursor.execute("""
CREATE TABLE IF NOT EXISTS personen (
  id INTEGER PRIMARY KEY,
  vorname TEXT,
  nachname TEXT
);
""")

for i in range(500000):
  fullname = (fake.name()).split()
  firstname = fullname[0]
  lastname = fullname[(len(fullname))-1]
  cursor.execute(f"""
  INSERT INTO personen VALUES ('{i}', '{firstname}', '{lastname}');
  """) 

connection.commit()
connection.close()