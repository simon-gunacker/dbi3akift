#!usr/bin/env python3

import sqlite3

def run_reports(db="warehouse.db"):
    with sqlite3.connect(db) as conn:
        cursor = conn.cursor()
        cursor.execute("PRAGMA journal_mode = WAL;")

        # Minimum stock level
        cursor.execute(
            """
            SELECT id, name, kategorie, lagerbestand, mindestbestand
            FROM artikel
            WHERE lagerbestand < mindestbestand;
            """
        )
        rows = cursor.fetchall()

        if not rows:
            print("Stock levels are above minimum.")

        for row in rows:
            print(f"ID: {row[0]} | Category:{row[1]} | Stock: {row[3]} | Min: {row[4]}")


        # Close to max credit
        cursor.execute(
            """
            SELECT id, name, kreditlimit, aktueller_kredit, 
                ROUND((aktueller_kredit * 100.0 / kreditlimit), 2) AS auslastung
            FROM kunde
            WHERE kreditlimit > 0 AND (aktueller_kredit * 1.0 / kreditlimit) >= 0.9;
            """
        )

        for row in rows:
            print(f"Customer: {row[1]} | Limit: {row[2]} | Used: {row[3]} ({row[4]}%)")


        # Today's revenue
        # COALESC -> gives back given value for python,
        # `COALESCE(SUM(<item>), 0)` -> if the SUM returns `NULL`, COALESCE returns `0`
        cursor.execute(
            """
            SELECT COUNT(id) COALESC(SUM(gesamtwert), 0)
            FROM bestellung
            WHERE status = 'verarbeitet' 
            AND DATE(datum) = DATE('now');
            """
        )
        count, revenue = cursor.fetchone()
        print(f"Processed orders today: {count} | Total revenue: {revenue:.2f}")


        # Inventory check
        cursor.execute(
            """
            SELECT 
                a.id, 
                a.name, 
                a.lagerbestand
                COALESCE(SUM(lb.menge), 0) AS movement_sum
            FROM artikel a
            LEFT JOIN lagerbewegung lb ON a.id = lb.artikel_id
            GROUP BY a.id, a.name, a.lagerbestand;
            """
        )
        for row in cursor.fetchall():
            print(f"Article ID {row[0]}: {row[1]} | Current stock: {row[2]} | Total movement: {row[3]}")


if __name__ == "__main__":
    run_reports()
