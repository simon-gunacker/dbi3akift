#!usr/bin/env python3

import sqlite3


def execute_simple_order(kunde_id, items, db="warehouse.db"):

    try:
        with sqlite3.connect(db) as conn:
            cursor = conn.cursor()
            cursor.execute("PRAGMA journal_mode = WAL;")
            cursor.execute("BEGIN TRANSACTION;")

            # Add order
            cursor.execute(
                "INSERT INTO bestellung (kunde_id) VALUES (?);", (kunde_id,)
            )

            # Get last order
            bestellung_id = cursor.lastrowid
            # For total value calculation
            total_value = 0.0

            # Add ordered item
            for artikel_id, menge, preis in items:
                cursor.execute(
                    "INSERT INTO bestellposition (bestellung_id, artikel_id, menge, einzelpreis) VALUES (?, ?, ?, ?);", 
                    (bestellung_id, artikel_id, menge, preis)
                )

                # Update storage
                cursor.execute(
                    "UPDATE artikel SET lagerbestand = lagerbestand - ? WHERE id = ?;", 
                    (menge, artikel_id)
                )

                # Update order movement
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

            cursor.execute("COMMIT")
            print(f"Order created successfully! Order value: {total_value:.2f}")

    except sqlite3.IntegrityError as err: # Integrity error triggerd by sql (CHECK)
        cursor.execute("ROLLBACK")
        raise

    except sqlite3.Error as err:
        cursor.execute("ROLLBACK")
        print(f"Transfare failed. Rolled back changes. Error: {err}")
        raise


if __name__ == '__main__':
    items = [
            (1, 5, 25.00), # 5x Arduino
            (2, 2, 75.00), # 2x Raspberry Pi
            (3, 50, 0.25)  # 50x led
        ]
    test_advance = [
        (2, 500, 75.00),
        (2, 100, 75.00)
    ]
    # Simple order
    execute_simple_order(kunde_id=1, items=items)
    # Advanced order
    execute_simple_order(kunde_id=2, items=test_advance) # Invalid Stock
    execute_simple_order(kunde_id=1, items=test_advance) #Invalid Credit
