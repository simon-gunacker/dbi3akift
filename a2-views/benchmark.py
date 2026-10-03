from seed import with_connect
import sqlite3
import timeit
import time

def measure_view_a(conn, kunde_id: int):
    sql = f"""
        SELECT * 
        FROM letzte_bestellung_a 
        WHERE kunde_id = {kunde_id};
    """
    cursor = conn.execute(sql)
    return cursor.fetchall()

def measure_view_b(conn, kunde_id: int):
    sql = f"""
        SELECT * 
        FROM letzte_bestellung_b 
        WHERE kunde_id = {kunde_id};
    """
    cursor = conn.execute(sql)
    return cursor.fetchall()

@with_connect("shop.db")
def test(conn, kunde_id: int, repeat: int):
    print(f"Starte Benchmark für kunde_id = {kunde_id}\nWiederholungen = {repeat}...")

    time_a = timeit.timeit(
        lambda: measure_view_a(conn, kunde_id), number=repeat
    )
    avg_a = time_a / repeat

    time_b = timeit.timeit(
        lambda: measure_view_b(conn, kunde_id), number=repeat
    )
    avg_b = time_b / repeat

    print(f"View A - Gesamt: {time_a:.4f}s | Schnitt pro Aufruf: {avg_a:.6f}s")
    print(f"View B - Gesamt: {time_b:.4f}s | Schnitt pro Aufruf: {avg_b:.6f}s")

if __name__ == "__main__":
    start_time = time.perf_counter()
    test(kunde_id=42, repeat=100)
    end_time = time.perf_counter()
    print(f"Der Test hat: {(end_time - start_time):.2f} Sekunden gebraucht.")
