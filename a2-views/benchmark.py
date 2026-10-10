import sqlite3
import timeit

def testQuery(cursor, view):
    curmain.execute(f"SELECT * FROM '{view}'")

timeList = []

if __name__ == "__main__":
    dbmain =  sqlite3.connect("mydb.db")
    curmain = dbmain.cursor()
    timeList.append(timeit.repeat(lambda: testQuery(curmain, "subselect_view_a"), repeat = 10 ,number=10))
    dbmain.close()


    dbmain =  sqlite3.connect("mydb.db")
    curmain = dbmain.cursor()
    timeList.append(timeit.repeat(lambda: testQuery(curmain, "joinselect_view_b") , repeat=10 ,number=10))
    dbmain.close()


    print(f"Subselect Average time: {sum(timeList[0])/len(timeList[0])} Seconds \nJoinselect Average time: {sum(timeList[1])/len(timeList[1])} Seconds")

