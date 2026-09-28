from names_generator import generate_name

database = "../persons.db"
db_indexed = "../persons_indexed.db"

table = """
    CREATE TABLE IF NOT EXISTS person (
        id INTEGER PRIMARY KEY AUTOINCREMENT
        , first_name VARCHAR(255)
        , last_name VARCHAR(255)
    )
"""

index = """
    CREATE INDEX p_index
    ON person (first_name, last_name);
"""

insert = """
    INSERT INTO person (first_name, last_name)
    VALUES (?, ?)
"""

select_duplicate_names = """
    SELECT COUNT(*)
    FROM person
    GROUP BY first_name, last_name

"""

def fill_db(
    connection: object, insert: str, dataset_count: int, execute_insert
    ) -> None:

    for x in range(dataset_count):
        name = generate_name(style='capital')
        if execute_insert:
            connection.execute(insert, name.split())
