
import sqlite3

database = "datenbank.db"

sql_files = {
    "1": "einfache_bestellung.sql",
    "2": "validierung_lagerbestand.sql",
    "3": "validierung_kredit.sql",
    "4": "stornierung.sql",
    "5": "reporting.sql"
}

print("Choose an assignment task:")
print("1 - Einfache Bestellung")
print("2 - Validierung Lagerbestand")
print("3 - Validierung Kreditlimit")
print("4 - Stornierung")
print("5 - Reporting und Konsistenzprüfung")

choice = input("Select task: ")

# Check if selection is in dictionary
if choice in sql_files:

    filename = sql_files[choice]

    # no database connection first
    connection = None

    try:
        with open(filename) as file:
            commands = file.read()

        connection = sqlite3.connect(database)

        connection.execute("PRAGMA foreign_keys = ON")

        # show results of the reporting queries
        if choice == "5":

            # Split the SQL file into individual queries
            queries = commands.split(";")

            for query in queries:
                if query.strip():

                    cursor = connection.execute(query)

                    # Display the query results
                    if cursor.description:
                        print([column[0] for column in cursor.description])
                        rows = cursor.fetchall()

                        for row in rows:
                            print(row)
        else:

            connection.executescript(commands)

        print("SQL file ran successfully!")

    # Catch database errors and file errors (for example, if the SQL file cannot be opened)
    except (sqlite3.Error, OSError) as error:

        print("Something went wrong:", error)

        # Roll back changes if a database connection exists
        if connection is not None:
            connection.rollback()
            print("Changes were rolled back.")

    finally:
        # Close connection
        if connection is not None:
            connection.close()

# If the user enters an invalid selection (other than 1-5)
else:
    print("Invalid choice!")
