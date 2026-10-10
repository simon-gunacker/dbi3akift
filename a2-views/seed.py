from sqlite3 import connect
import random

connection = connect("onlineshop.db")
cursor = connection.cursor()

random.seed(42)

bezeichnung = ["Krustenbrot", "Baguette", "Vollkornbrot", "Semmel", "Sonnenblumenbrot", "Dachsteinbrot", "Roggenbrot", "Dinkelbrot"]

vorname = ["alexander", "anna", "claudia", "daniel", "daniela", "david", "dominik", "elias", "emilia", "emma", "felix", "florian", "hannah", "jakob", "julia", "julian", "katharina", "laura", "lena", "leonie", "lisa", "lukas", "maria", "marie", "maximilian", "melanie", "michael", "noah", "patrick", "paul", "sabrina", "sandra", "sarah", "sophie", "sophia", "stefan", "stefanie", "thomas", "tobias"] 
nachname = ["wagner", "gruber", "winkler", "weber", "huber", "bauer", "wimmer", "müller", "wallner", "wolf", "steiner", "pichler", "moser", "mayer", "hofer"]
emailanbieter = ["@gmail.com", "@outlook.com", "@yahoo.com", "@mail.com"]

straße = ["gasse", "weg", "straße"]

status = ["in Bearbeitung", "versendet", "in Zustellung", "eingelangt"]



for i in range(10000):
  cursor.execute(f"""
  INSERT INTO produkt VALUES ('{i}', '{bezeichnung[random.randint(0, 7)]}', '{round(random.uniform(0.1, 5), 2)}', '{random.randint(0, 42)}');
  """) 

for i in range(10000):
  firstname = vorname[random.randint(0, 38)]
  lastname = nachname[random.randint(0, 14)]

  year = random.randint(1934, 2005)
  month = random.randint(1, 12)
  date = 0
  
  if month == 2:
    if (year%4 == 0 and year%100 != 0) or (year%400 == 0):
      date = random.randint(1, 29)
    else:
      date = random.randint(1, 28)
  elif (month < 8 and month%2 != 0) or (month > 7 and month%2 == 0):
    date = random.randint(1, 31)
  else:
    date = random.randint(1, 30)

  cursor.execute(f"""
  INSERT INTO kunde VALUES ('{i}', '{firstname.capitalize()}', '{lastname.capitalize()}', '{firstname}.{lastname}@{emailanbieter[random.randint(0, 3)]}', '{year}-{month:02d}-{date:02d}', '0{random.randint(11100000000, 99999999999)}', 'Traum{straße[random.randint(0, 2)]} {random.randint(1, 42)}, {random.randint(1010, 1342)} Traumstadt');
  """) 

for i in range(100000):
  year = random.randint(2019, 2026)
  month = 0
  date = 0

  if year <= 2025:
    month = random.randint(1, 12)
  else:
    month = random.randint(1, 9)
  
  if month == 2:
    if (year%4 == 0 and year%100 != 0) or (year%400 == 0):
      date = random.randint(1, 29)
    else:
      date = random.randint(1, 28)
  elif (month < 8 and month%2 != 0) or (month > 7 and month%2 == 0):
    date = random.randint(1, 31)
  else:
    date = random.randint(1, 30)

  cursor.execute(f"""
  INSERT INTO bestellung VALUES ('{i}', '{random.randint(0,9999)}', '{year}-{month:02d}-{date:02d}', '{status[random.randint(0, 3)]}');
  """) 



for i in range(500000):
  cursor.execute(f"""
  INSERT INTO bestellposition VALUES ('{random.randint(1,100000)}', '{random.randint(1,10000)}', '{random.randint(1, 5)}');
  """) 


connection.commit()
connection.close()


