import sqlite3
from faker import Faker
from math import sqrt
import time

faker = Faker()
genbase = 500000

con = sqlite3.connect("mydb.db")
cur = con.cursor()
if input("Delete database?: ")  == ("Y" or "y"):
    cur.execute("DROP TABLE IF EXISTS personen")
con.commit()
cur.execute("CREATE TABLE IF NOT EXISTS personen(id, vorname, nachname)")

def generatedata(dbcon, genrange: int,genmult: int = 1, first_namelist: list = [], last_namelist: list = []):
    dbcursor = dbcon.cursor()
    start = time.perf_counter()
    fillcheck = dbcursor.execute("SELECT COUNT(*) FROM personen").fetchall()[0][0]
    if genrange - fillcheck > 0:
        manylist = []
        genrange -= fillcheck
        genrange = int(genrange / genmult)
        for y in range(genmult):
            for x in range(genrange):
                first_name = faker.first_name() if y >= len(first_namelist) else first_namelist[y]
                last_name = faker.last_name() if y >= len(last_namelist) else last_namelist[y]
                manylist.append((first_name, last_name))

            dbcursor.executemany("INSERT INTO personen(vorname,nachname) VALUES(?, ?)", manylist)
            manylist.clear()
        dbcursor.execute("CREATE INDEX IF NOT EXISTS idx_firstname ON personen (vorname) ")
        dbcursor.execute("CREATE INDEX IF NOT EXISTS idx_lastname_firstname ON personen (nachname, vorname) ")
        dbcon.commit()
        timedelta = time.perf_counter() - start
        print(f"Es brauchte {timedelta} Sekunden um die Datenbank zu füllen.")
        dbcon.close()

def calculatevariance_py(dbcon, genbase, column = "concat(vorname, ' ', nachname)"):
    dbcursor = dbcon.cursor()
    start = time.perf_counter()
    uniquenamespercount = [row[0] for row in dbcursor.execute(f"SELECT COUNT(*) FROM personen GROUP BY {column}").fetchall()]
    uniquenamestotal = len(uniquenamespercount)
    avg = genbase / uniquenamestotal
    summe = sum((count - avg)**2 for count in uniquenamespercount)
    print(f"Varianz: {summe/uniquenamestotal}")
    print(f"Durchschnittliche Abweichung in Prozent: {sqrt(summe/uniquenamestotal)/avg}%")
    timedelta = time.perf_counter() - start
    print(f"Es brauchte {timedelta} Sekunden um die Varianz mit Python zu berechnen.")
    dbcon.close()

def calculatevariance_sql(dbcon, column = "concat(vorname, ' ', nachname)"):
    dbcursor = dbcon.cursor()
    start = time.perf_counter()
    totaluniquenamecount, totalnamecount, avg, variance  = dbcursor.execute(f"""
    WITH UniqueNameCounts AS (
        SELECT COUNT (*) AS UniqueNameCount
        FROM personen
        GROUP BY {column}
        ),
    Averages AS (
        SELECT AVG(UniqueNameCount) AS Average FROM UniqueNameCounts
         ),
    TotalCount AS (
        SELECT COUNT(*) as TotalNameCount FROM personen
        )
    SELECT
        COUNT(*) AS UniqueNamesTotal,
        TotalNameCount,
        Average,
        AVG((UniqueNameCount - Average) * (UniqueNameCount - Average)) AS variance
    FROM UniqueNameCounts, Averages, TotalCount
    """).fetchone()
    print(f"Varianz: {variance}")
    print(f"Durchschnittliche Abweichung in Prozent: {sqrt(variance)/avg}%")
    timedelta = time.perf_counter() - start
    print(f"Es brauchte {timedelta} Sekunden um die Varianz mit SQL zu berechnen.")
    dbcon.close()

generatedata(sqlite3.connect("mydb.db"), genbase, 3, ["Joe", "Joe"], ["Schmoe", "Schmoe"])
calculatevariance_py(sqlite3.connect("mydb.db"), genbase)
calculatevariance_sql(sqlite3.connect("mydb.db"))
if input() == ("Y" or "y"):
    cur.execute("DROP INDEX idx_firstname")
    cur.execute("DROP INDEX idx_lastname_firstname")
    con.commit()
con.close()
