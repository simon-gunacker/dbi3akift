from sqlite3 import connect
import timeit

conn = connect("./onlineshop.db")

# number of iterations
N_ITERATIONS = 100

def select_view_a(conn):
    sql = """
    SELECT * FROM letzte_bestellung_a
    WHERE kunde_id = 100;
    """
    cursor = conn.cursor()
    cursor.execute(sql)
    cursor.fetchall()




def select_view_b(conn):
    sql = """
    SELECT * FROM letzte_bestellung_b
    WHERE kunde_id = 100;
    """
    cursor = conn.cursor()
    cursor.execute(sql)
    cursor.fetchall()



time_view_a = timeit.timeit(lambda:select_view_a(conn), number=N_ITERATIONS)

time_view_b = timeit.timeit(lambda:select_view_b(conn), number=N_ITERATIONS)


print(f"Die erste View benötigt {time_view_a} Sekunden für den Select.")
print(f"Die zweite View benötigt {time_view_b} Sekunden für den Select.")