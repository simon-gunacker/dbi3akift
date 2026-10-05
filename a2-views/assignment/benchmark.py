import sqlite3
import timeit

db_name = 'onlineshop.db'
conn = sqlite3.connect(db_name)
cursor = conn.cursor()

SQL_STRING_VIEW_A= 'SELECT * FROM letzte_bestellung_a WHERE kunde_id = 42;'

SQL_STRING_VIEW_B='SELECT * FROM letzte_bestellung_b WHERE kunde_id = 42;'

TRIALS=1000

def benchmark(cursor,sql_string):
        cursor.execute(sql_string)
        cursor.fetchall()

execution_time_a=timeit.timeit(lambda:benchmark(cursor,SQL_STRING_VIEW_A),number=TRIALS)
execution_time_b=timeit.timeit(lambda:benchmark(cursor,SQL_STRING_VIEW_B),number=TRIALS)
#lambda da tiemit ein callable erhält

print(f"View A Aufrufe = {TRIALS} Zeit = {execution_time_a }sec")
print(f"View B Aufrufe = {TRIALS} Zeit = {execution_time_b }sec")

conn.close()