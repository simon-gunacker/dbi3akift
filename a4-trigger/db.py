"""
Creates an empty database.
"""

import sqlite3
import sys
from pathlib import Path

BASE_DIR = Path(__file__).parent


name = input("Database name: ").strip()
if not name.endswith(".db"):
    name += ".db"
db = BASE_DIR / name

if db.exists():
    print(f"{db.name} already exists.")
    sys.exit(1)

sqlite3.connect(db).close()

print(f"Created: {db}")