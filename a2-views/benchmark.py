import sqlite3
import timeit
import time

WIEDERHOLUNG = 10

conn = sqlite3.connect("model.db")

startzeit_abfrage = time.perf_counter()

zeit_a = timeit.timeit(lambda: conn.execute("SELECT * FROM letzte_bestellung_a WHERE kunde_id = 42 LIMIT 10000;").fetchall(), number=WIEDERHOLUNG)
zeit_a_einzel = zeit_a / WIEDERHOLUNG
minuten_a = zeit_a_einzel // 60
sekunden_a = zeit_a_einzel % 60

zeit_b = timeit.timeit(lambda: conn.execute("SELECT * FROM letzte_bestellung_b WHERE kunde_id = 42 LIMIT 10000;").fetchall(), number=WIEDERHOLUNG)
zeit_b_einzel = zeit_b / WIEDERHOLUNG
minuten_b = zeit_b_einzel // 60
sekunden_b = zeit_b_einzel % 60

print(f"Ergebnis A für 1 Ausführung: {int(minuten_a)} Minuten {sekunden_a:.3f} Sekunden")
print(f"Ergebnis B für 1 Ausführung: {int(minuten_b)} Minuten {sekunden_b:.3f} Sekunden")

faktor = zeit_a / zeit_b
print(f"Fakor: {faktor:.3f}")

gesamtzeit_abfrage = time.perf_counter() - startzeit_abfrage
print(f"Gesamtdauer: {int(gesamtzeit_abfrage // 60)} Minuten {gesamtzeit_abfrage % 60:.3f} Sekunden")

conn.close()
