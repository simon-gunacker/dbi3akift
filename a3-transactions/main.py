#!usr/bin/env python3

import sqlite3

def new_order(conn, kunde_id, ):
    try:
        with sqlite3.connect("warehouse.db") as conn:
            cursor = conn.cursor()
            cursor.execute("PRAGMA journal_mode = WAL;")
            cursor.execute("BEGIN TRANSACTION;")

            cursor.execute(
                "INSERT INTO bestellung (kunde_id) VALUES (?);", (kunde_id,)
            )
            #TODO: Implement rest of the sql querry.

            cursor.commit()
            print("Order created successfully!")

    except sqlite3.Error as err:
        cursor.rollback()
        print(f"Transfare failed. Rolled back changes. Error: {err}")
        raise

#if __name__ == '__main__':
