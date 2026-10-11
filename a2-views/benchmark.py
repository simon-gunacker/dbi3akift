from sqlite3 import connect
import timeit

connection = connect("onlineshop.db")
cursor = connection.cursor()



def a():
    cursor.execute(f"""
    SELECT *
    FROM letzte_bestellung_a
    WHERE kunde_id = 42;
    """) 

def b():
    cursor.execute(f"""
    SELECT *
    FROM letzte_bestellung_b
    WHERE kunde_id = 42;
    """) 

for r in range(10):
    atime = timeit.timeit(a, number=1)
    print(f"letzte_bestellung_a: {atime}")

    btime = timeit.timeit(b, number=1)
    print(f"letzte_bestellung_b: {btime}")
