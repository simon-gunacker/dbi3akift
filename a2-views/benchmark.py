from seed import with_connect
import sqlite3
import timeit

def measure_view_a(conn, kunde_id: int):
    sql = """
        SELECT * 
        FROM letzte_bestellung_a 
        WHERE kunde_id = ?;
    """
    cursor = conn.execute(sql,
        (kunde_id),
    )
    return cursor.fetchall()

def measure_view_b(conn, kunde_id: int):
    sql = """
        SELECT * 
        FROM letzte_bestellung_b 
        WHERE kunde_id = ?;
    """
    cursor = conn.execute(sql,
        (kunde_id),
    )
    return cursor.fetchall()
