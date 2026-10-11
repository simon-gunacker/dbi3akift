import sqlite3
import timeit

def abfrage_a():
    conn = sqlite3.connect("shop.db")
    conn.execute("SELECT * FROM letzte_bestellung_a WHERE kunde_id = 42").fetchall()
    conn.close()

def abfrage_b():
    conn = sqlite3.connect("shop.db")
    conn.execute("SELECT * FROM letzte_bestellung_b WHERE kunde_id = 42").fetchall()
    conn.close()

N_A = 3      # ca. 7 min pro Lauf -> ca. 20 min
N_B = 1000   # ca. 0,07 s pro Lauf -> ca. 70 s

zeit_a = timeit.timeit(abfrage_a, number=N_A) / N_A
zeit_b = timeit.timeit(abfrage_b, number=N_B) / N_B

print(f"View A: {zeit_a:.4f} s pro Abfrage")
print(f"View B: {zeit_b:.4f} s pro Abfrage")
print(f"Faktor: {zeit_a / zeit_b:.0f}")
