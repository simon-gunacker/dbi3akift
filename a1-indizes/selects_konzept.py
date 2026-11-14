import sqlite3
import time 

def time_(cursor, query):
    start = time.time()
    cursor.execute(query)
    cursor.fetchall()
    duration = time.time() - start
    print(f"Run Time {duration:.4f} sec")
    return duration

connection = sqlite3.connect("indizes.db")

cursor = connection.cursor() 

verteilung = """
    WITH cte_name AS(
        SELECT first_name, COUNT(*) AS count
        FROM PERSON
        GROUP BY first_name 
        ORDER BY count DESC
    )

    SELECT MIN(count), MAX(count), AVG(count)
    FROM cte_name ;
"""

cursor.execute(verteilung)
print(cursor.fetchone())

index_loeschen = """
    DROP INDEX IF EXISTS idx_first_name;
"""

cursor.execute(index_loeschen)

print("--- Ohne Index ---")
ohne_index = """
        SELECT * FROM PERSON WHERE first_name = 'Michael'
    """
times_ohne = []
for x in range(20):
    times_ohne.append(time_(cursor, ohne_index))

avg_ohne = sum(times_ohne) / len(times_ohne)
print(f"avg: {avg_ohne:.4f} sec")

index_erstellen = """
    CREATE INDEX idx_first_name ON PERSON(first_name);
"""
cursor.execute(index_erstellen)

print("--- Mit Index ---")

mit_index = """
        SELECT * FROM PERSON WHERE first_name = 'Michael';
    """

times_mit = []
for x in range(20):
    times_mit.append(time_(cursor, mit_index))

avg_ohne = sum(times_mit) / len(times_mit)
print(f"avg: {avg_ohne:.4f} sec")


connection.commit()
connection.close()