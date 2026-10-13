from sqlite3 import connect
import timeit

def abfrageA(conn):
    conn.execute("SELECT * FROM letzte_bestellung_a WHERE kunde_id = 42;").fetchall()

def abfrageB(conn):
    conn.execute("SELECT * FROM letzte_bestellung_b WHERE kunde_id = 42;").fetchall()



#------main----
def main():


    with connect("model.db") as conn:
        n=1000
        totalA = timeit.timeit(lambda: abfrageA(conn), number = n)
        totalB = timeit.timeit(lambda: abfrageB(conn), number = n)
        AvgA = totalA/n
        AvgB = totalB/n
        faktor = AvgA/AvgB

        print(f"Average A: {AvgA:.4f} s, Average B: {AvgB:.4f} s ")
        print (f"A ist {faktor:.1f} mal langsamer als B")
    conn.close()

if __name__ == "__main__":
    main()
