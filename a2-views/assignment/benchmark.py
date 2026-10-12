import sqlite3
import timeit

SECONDS = 30 # aproximated total runtime per view

conn = sqlite3.connect("online_shop.db")

# 1. Check if both views return same result

a = conn.execute("SELECT * FROM letzte_bestellung_a ORDER BY 1, 2").fetchall()
b = conn.execute("SELECT * FROM letzte_bestellung_b ORDER BY 1, 2").fetchall()
print("identical:", a == b, f"({len(a)} rows)")

# 2. Time the same query on both views

times = {}
for view in ( "letzte_bestellung_a","letzte_bestellung_b"):
    sql = f"SELECT * FROM {view} WHERE kunde_id = 42"
    run = lambda: conn.execute(sql).fetchall()
    single = timeit.timeit(run, number=1)
    n = max(3, int(SECONDS / single))
    total = timeit.timeit(run, number=n)
    times[view] = total / n
    print(f"{view}: {times[view] *1000:.3f} ms per query ({n} runs)")

# 3. Factor
slow, fast = max(times.values()), min(times.values())
print(f"factor: {slow / fast:.1f}x")

conn.close()
