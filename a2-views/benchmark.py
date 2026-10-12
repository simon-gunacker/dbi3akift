import sqlite3
import timeit

def testQuery(cursor, view):
    curmain.execute(f"SELECT * FROM '{view}' WHERE kunde_id = 42 LIMIT 10000")

reruns = 10000
timeList = []

if __name__ == "__main__":
    dbmain =  sqlite3.connect("mydb.db")
    curmain = dbmain.cursor()
    timeList.append(timeit.timeit(lambda: testQuery(curmain, "letzte_bestellung_a"),number = reruns))
    dbmain.close()


    dbmain =  sqlite3.connect("mydb.db")
    curmain = dbmain.cursor()
    timeList.append(timeit.timeit(lambda: testQuery(curmain, "letzte_bestellung_b"),number = reruns))
    dbmain.close()

    subselAvg = timeList[0] / reruns
    joinAvg = timeList[1] / reruns
    addString = ""
    if subselAvg > joinAvg: addString = f"Join is faster by a factor of: {subselAvg / joinAvg:.2f}."
    else: addString = f"Subselect is faster by a factor of: {joinAvg / subselAvg:.2f}."
    print(f"Subselect Average time: {subselAvg:.2f} Seconds \nJoinselect Average time: {joinAvg:.2f} Seconds \n" + addString)

