database = "../persons.db"

table = """
    CREATE TABLE person (
        id INT PRIMARY KEY AUTOINCREMENT
        , first_name VARCHAR(255)
        , last_name VARCHAR(255)
);
"""

insert = """
    INSERT INTO person (first_name, last_name)
    VALUES (?, ?)
"""
