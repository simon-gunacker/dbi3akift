from sqlite3 import connect
import timeit

from seed import DATABASE

def select_view(select: str, db: str = DATABASE):
    with connect(db) as con:
        con.execute(select)

def main():
    a = "SELECT * FROM letzte_bestellung_a WHERE customer_id = 42"
    b = "SELECT * FROM letzte_bestellung_b WHERE customer_id = 42"

    time_a = timeit.timeit(lambda: select_view(a), number=1000)\
        / 1000
    time_b = timeit.timeit(lambda: select_view(b), number=1000)\
        / 1000

    print(
        "Der SELECT alle Kunden mit der id 42 von view a "
        f"dauert im Schnitt:\n\t{time_a:.2f}s."
        "\nDer gleiche SELECT von view b dauert "
        f"durchschnittlich: \n\t{time_b:.2f}s"
          )

if __name__ == "__main__":
    main()
