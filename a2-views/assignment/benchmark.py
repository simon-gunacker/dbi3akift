import sqlite3
import timeit

conn = sqlite3.connect("datenbank.db")
cursor = conn.cursor()

print("letzte_bestellung_a")
def query_a():
    cursor.execute("SELECT * FROM letzte_bestellung_a LIMIT 10000").fetchall()

time = timeit.timeit(query_a, number=10)
average = time / 10
print(f"Durchschnittliche Zeit pro Abfrage: {average:.4f}")


print("letzte_bestellung_b")
def query_b():
    cursor.execute("SELECT * FROM letzte_bestellung_b LIMIT 10000").fetchall()

time_b = timeit.timeit(query_b, number=10)
average_b = time_b / 10
print(f"Durchschnittliche Zeit pro Abfrage: {average_b:.4f}")


faktor = average / average_b
print(f"Faktor: {faktor:.2f}")


print("EXPLAIN QUERY PLAN A")
cursor.execute("EXPLAIN QUERY PLAN SELECT * FROM letzte_bestellung_a LIMIT 10000")
for zeile in cursor.fetchall():
    print(zeile)

print("EXPLAIN QUERY PLAN B")
cursor.execute("EXPLAIN QUERY PLAN SELECT * FROM letzte_bestellung_b LIMIT 10000")
for zeile in cursor.fetchall():
    print(zeile)
conn.commit()
conn.close()