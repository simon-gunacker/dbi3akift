import sqlite3
import timeit

conn = sqlite3.connect("datenbank.db")
cursor = conn.cursor()

print("letzte_bestellung_a")
def query_a():
    cursor.execute("SELECT * FROM letzte_bestellung_a WHERE kunde_id = 42").fetchall()

#individual = timeit.timeit(query_a, number= 10)
#print(f"10 Durchläufe: {individual:.6f}")

time = timeit.timeit(query_a, number=10000)
average = time / 10000
print(f"Durchschnittliche Zeit pro Abfrage: {average:.6f}")

cursor.execute("EXPLAIN QUERY PLAN SELECT * FROM letzte_bestellung_a WHERE kunde_id = 42")
for zeile in cursor.fetchall():
    print(zeile)

print("letzte_bestellung_b")
def query_b():
    cursor.execute("SELECT * FROM letzte_bestellung_b WHERE kunde_id = 42").fetchall()

#individual_b = timeit.timeit(query_b, number= 10)
#print(f"10 Durchläufe: {individual_b:.6f}")

time_b = timeit.timeit(query_b, number=10000)
average_b = time_b / 10000
print(f"Durchschnittliche Zeit pro Abfrage: {average_b:.6f}")

cursor.execute("EXPLAIN QUERY PLAN SELECT * FROM letzte_bestellung_b WHERE kunde_id = 42")
for zeile in cursor.fetchall():
    print(zeile)

faktor = average / average_b
print(f"Faktor: {faktor:.2f}")

conn.commit()
conn.close()