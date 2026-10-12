from sqlite3 import connect
import timeit

DB = "miniature_shop.db"
RUNS = 1000


def run_view_a(cursor):
    cursor.execute(
    """
        SELECT *
        FROM letzte_bestellung_a
        WHERE kunde_id = 42
        LIMIT 10000;
    """
    )
    cursor.fetchall()


def run_view_b(cursor):
    cursor.execute(
    """
        SELECT *
        FROM letzte_bestellung_b
        WHERE kunde_id = 42
        LIMIT 10000;
    """
    )
    cursor.fetchall()


def main():
    conn = connect(DB)
    cursor = conn.cursor()

    time_var_a = timeit.timeit(
        lambda: run_view_a(cursor),
        number=RUNS
    )

    time_var_b = timeit.timeit(
        lambda: run_view_b(cursor),
        number=RUNS
    )

    avg_a = time_var_a / RUNS
    avg_b = time_var_b / RUNS
    factor = avg_a / avg_b

    print("Average time view A:", avg_a)
    print("Average time view B:", avg_b)
    print("Difference factor:", factor)

    conn.close()


if __name__ == "__main__":
    main()