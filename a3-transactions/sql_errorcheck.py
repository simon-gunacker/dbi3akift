from sqlite3 import connect, Error

DB = "lager.db"

# use an input to select file we want to work with
sql_file = input("Which SQL file do you want to run? ")

# open sql file and read everything that is inside
file = open(sql_file, "r", encoding="utf-8")
sql = file.read()
file.close()

# connection to database
conn = connect(DB)

try:
    # run everything in the file
    conn.executescript(sql)
    print("It worked!")

# the CHECK's in the db create errors when their conditions are not met
# e.g. not enough stock --> CHECK (lagerbestand >= 0) Throws an error
except Error as err:
    # if an error occurs, print the sql error msg
    print("Something went wrong:", err)
    # rollback throws away all temporary changes since BEGIN TRANSACTION
    conn.rollback()
    # inform user that the rollback happened
    print("Everything was undone (rollback).")

# close the connection to the database
conn.close()