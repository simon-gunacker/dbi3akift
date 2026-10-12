import sqlite3
import timeit

def testQuery(cursor, view):
    curmain.execute(f"SELECT * FROM '{view}' WHERE kunde_id = 42")

timeList = []

if __name__ == "__main__":
    dbmain =  sqlite3.connect("mydb.db")
    curmain = dbmain.cursor()
    timeList.append(timeit.repeat(lambda: testQuery(curmain, "letzte_bestellung_a"), repeat = 1 ,number=100))
    dbmain.close()


    dbmain =  sqlite3.connect("mydb.db")
    curmain = dbmain.cursor()
    timeList.append(timeit.repeat(lambda: testQuery(curmain, "letzte_bestellung_b") , repeat= 1 ,number=100))
    dbmain.close()

    subselAvg = sum(timeList[0])/len(timeList[0])
    joinAvg = sum(timeList[1])/len(timeList[1])
    addString = ""
    if subselAvg > joinAvg: addString = f"Join is faster by a factor of: {subselAvg / joinAvg:.2f}."
    else: addString = f"Subselect is faster by a factor of: {joinAvg / subselAvg:.2f}."
    print(f"Subselect Average time: {subselAvg:.2f} Seconds \nJoinselect Average time: {joinAvg:.2f} Seconds \n" + addString)

