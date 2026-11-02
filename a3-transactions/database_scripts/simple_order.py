#!usr/bin/env python3

import sqlite3

def execute_simple_order(db="warehouse.db", kunde_id=1):
    items = [
        (1, 5, 25.00), # 5x Arduino
        (2, 2, 75.00), # 2x Raspberry Pi
        (3, 50, 0.25)  # 50x led
    ]

    try:
        with sqlite3.connect(db) as conn:
            cursor = conn.cursor()
            cursor.execute("PRAGMA journal_mode = WAL;")
            cursor.execute("BEGIN TRANSACTION;")

            cursor.execute(
                "INSERT INTO bestellung (kunde_id) VALUES (?);", (kunde_id,)
            )

            # Get last order
            bestellung_id = cursor.lastrowid
            # For total value calculation
            total_value = 0.0

            for artikel_id, menge, preis in items:
                cursor.execute(
                    "INSERT INTO bestellposition (bestellung_id, artikel_id, menge, einzelpreis) VALUES (?, ?, ?, ?);", 
                    (bestellung_id, artikel_id, menge, preis)
                )

                cursor.execute(
                    "UPDATE artikel SET lagerbestand = lagerbestand - ? WHERE id = ?;", 
                    (menge, artikel_id)
                )

                cursor.execute(
                    "INSERT INTO lagerbewegung (artikel_id, bestellung_id, menge, typ) VALUES (?, ?, ?, 'verkauf');", 
                    (artikel_id, bestellung_id, -menge)
                )

                total_value += (menge * preis)

            # Update total value
            cursor.execute(
                "UPDATE bestellung SET gesamtwert = ? WHERE id = ?;", 
                (total_value, bestellung_id)
            )

            # Increase Customer Credit
            cursor.execute(
                "UPDATE kunde SET aktueller_kredit = aktueller_kredit + ? WHERE id = ?;", 
                (total_value, kunde_id)
            )

            cursor.commit()
            print(f"Order created successfully! Order value: {total_value:.2f}")

    except sqlite3.Error as err:
        cursor.rollback()
        print(f"Transfare failed. Rolled back changes. Error: {err}")
        raise


if __name__ == '__main__':
    execute_simple_order()
