from sqlite3 import connect
import random
import names
from generator_dates import GeneratorDates

connection = connect("onlineshop.db")
cursor = connection.cursor()

random.seed(42)

emailanbieter = ["@gmail.com", "@outlook.at", "@yahoo.com", "@mail.de"]
status = ["bestellung angekommen", "versendet", "zustellung", "angekommen"]


# foreign key error unique key violation
# people shouln't have ordered things when they weren't born

for i in range(10000):
  cursor.execute(f"""
  INSERT INTO podukt VALUES ('{i}', '{bezeichnung}', '{preis}', '{lagerbestand}');
  """) 

for i in range(10000):
  firstname = names.get_first_name()
  lastname = names.get_last_name()
  cursor.execute(f"""
  INSERT INTO kunde VALUES ('{i}', '{names.get_first_name()}', '{name.get_last_name}', '{firstname}.{lastname}{emailanbieter[random.randint(0, 3)]}', '{geburtsdatum}', '0{random.randint(11100000000, 99999999999)}', '{adresse}');
  """) 

for i in range(100000):
  cursor.execute(f"""
  INSERT INTO bestellung VALUES ('{i}', '{random.randint(1,10000)}', '{bestelldatum}', '{status[random.randint(0, 3)]}');
  """) 

for i in range(500000):
  cursor.execute(f"""
  INSERT INTO bestellposition VALUES ('{random.randint(1,100000)}', '{random.randint(1,10000)}', '{menge}');
  """) 


connection.commit()
connection.close()


