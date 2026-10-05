import sqlite3

db_name = 'onlineshop.db'
conn = sqlite3.connect(db_name)
cursor = conn.cursor()

SQL_STRING_VIEW_A= 'SELECT * FROM letzte_bestellung_a WHERE kunde_id = 42;'

SQL_STRING_VIEW_B='SELECT * FROM letzte_bestellung_b WHERE kunde_id = 42;'