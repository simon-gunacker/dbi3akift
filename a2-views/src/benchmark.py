import sqlite3

db_name = 'onlineshop.db'
conn = sqlite3.connect(db_name)
cursor = conn.cursor()