from pathlib import Path
import sqlite3

DB_FILE = 'techshop.db'
MODEL_FILE = Path(__file__).resolve().parent / "model.sql"

con = sqlite3.connect(DB_FILE)
cursor = con.cursor()
cursor.execute('PRAGMA foreign_keys = ON')

cursor.executescript(MODEL_FILE.read_text(encoding='utf-8'))

con.close()
