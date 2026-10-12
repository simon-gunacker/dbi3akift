import sqlite3
import timeit

conn = sqlite3.connect("shop.db")
KUNDE_ID = 42

def query(view, kunde_id):
    return conn.execute(
        f"SELECT * FROM {view} WHERE kunde_id = ?", (kunde_id,)
    ).fetchall()

def querry_all(view):
    return conn.execute(
        f"SELECT * FROM {view}"
    ).fetchall()

repeats = 1000
time_a = timeit.timeit(lambda: query("letzte_bestellung_a", KUNDE_ID), number=repeats)
time_b = timeit.timeit(lambda: query("letzte_bestellung_b", KUNDE_ID), number=repeats)

print(f"Time for query a: {time_a / repeats} seconds")
print(f"Time for query b: {time_b / repeats} seconds")
print(f"Time Faktor: {time_a / time_b:.1f} seconds")

repeats = 1000
time_a = timeit.timeit(lambda: querry_all("letzte_bestellung_a"), number=repeats)
time_b = timeit.timeit(lambda: querry_all("letzte_bestellung_b"), number=repeats)

print(f"Time for query all a: {time_a / repeats} seconds")
print(f"Time for query all b: {time_b / repeats} seconds")
print(f"Time Faktor: {time_a / time_b:.1f} seconds")