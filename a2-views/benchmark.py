import sqlite3 
import timeit

DB = "shop.db"
WIEDERHOLUNGEN = 1000
WIEDERHOLUNGEN_ALLE = 5

def var_a (cursor):
    sql = """SELECT *
            FROM letzte_bestellung_a
            WHERE kunde_id = 42; """

    cursor.execute(sql).fetchall()

def var_b (cursor):
    sql = """SELECT *
            FROM letzte_bestellung_b
            WHERE kunde_id = 42; """

    cursor.execute(sql).fetchall()

def var_a_alle (cursor):
    sql = """SELECT *
            FROM letzte_bestellung_a;"""

    cursor.execute(sql).fetchall()

def var_b_alle (cursor):
    sql = """SELECT *
            FROM letzte_bestellung_b;"""

    cursor.execute(sql).fetchall()
    
def main():
    conn = sqlite3.connect(DB)
    cursor = conn.cursor()

    zeit_a = timeit.timeit(lambda: var_a(cursor), number=WIEDERHOLUNGEN) / WIEDERHOLUNGEN
    print(f"Variante A: {zeit_a:.6f} s")
    zeit_b = timeit.timeit(lambda: var_b(cursor), number=WIEDERHOLUNGEN) / WIEDERHOLUNGEN
    print(f"Variante B: {zeit_b:.6f} s")

    faktor = zeit_a / zeit_b
    print(f"Faktor: {faktor:.2f}")

    zeit_a = timeit.timeit(lambda: var_a_alle(cursor), number=WIEDERHOLUNGEN_ALLE) / WIEDERHOLUNGEN_ALLE
    print(f"Variante A (alle): {zeit_a:.6f} s")
    zeit_b = timeit.timeit(lambda: var_b_alle(cursor), number=WIEDERHOLUNGEN_ALLE) / WIEDERHOLUNGEN_ALLE
    print(f"Variante B (alle): {zeit_b:.6f} s")

    faktor = zeit_a / zeit_b
    print(f"Faktor: {faktor:.2f}")
    conn.close()

    
if __name__ == "__main__":
    main()