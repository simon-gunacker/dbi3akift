#!usr/bin/env python3

from database_setup import setup_database
from simple_order import execute_simple_order
from advanced_order import execute_advanced_order
from cancell import cancell_order
from report import run_reports

def main():
    db = "warehouse.db"

    print("=== STEP 1: Intitialize Database ===")
    setup_database(db)

    print("=== STEP 2: Create Simple Order ===")
    execute_simple_order(db)

    print("=== STEP 3: Create Advanced Order ===")
    print("--- Test Oreder 1: Valid Order ---")
    execute_advanced_order(db, kunde_id=2, items=[(4, 50, 0.05)])

    print("\n--- Test Oreder 2: Invalid Stock ---")
    execute_advanced_order(db, kunde_id=2, items=[(2, 500, 75.00)])

    print("\n--- Test Oreder 3: Invalid Credit ---")
    execute_advanced_order(db, kunde_id=1, items=[(2, 100, 75.00)])

    print("=== STEP 4: Cancel Order (order 1) ===")
    cancell_order(db, order_id=1)

    print("=== STEP 5: Creating Report ===")
    run_reports(db)

if __name__ == '__main__':
    main()
