import sqlite3
import timeit

DB = "shop.db"
KUNDE_ID = 42
NUMER = 2000
REPEAT = 10

conn = sqlite3.connect(DB)

def query(view, kunde_id):
    return conn.execute(
        f"SELECT * FROM {view} WHERE kunde_id = ?", (kunde_id,)
    ).fetchall()

def querry_all(view):
    return conn.execute(
        f"SELECT * FROM {view}"
    ).fetchall()