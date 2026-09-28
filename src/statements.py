from names_generator import generate_name

database = "../persons.db"

table = """
CREATE TABLE IF NOT EXISTS person (
    id INTEGER PRIMARY KEY AUTOINCREMENT
    , first_name VARCHAR(255)
    , last_name VARCHAR(255)
);
"""

insert = """
    INSERT INTO person (first_name, last_name)
    VALUES (?, ?)
"""

select_duplicate_names = """
    SELECT first_name, last_name
    FROM person
    GROUP BY first_name, last_name
"""

def generate_names(connection: object, insert: str, ex: bool = True) -> None:

    # total_count = 0
    greater_one = 0
    equal_one = 0
    all_counts = set()
    names = {} # key = name & value = name count

    for x in range(500000):
        name = generate_name(style='capital')
        if ex:
            connection.execute(insert, name.split())
        if name not in names.keys():
            names[name] = 0
        names[name] += 1
    for name, count in names.items():
        # total_count += count
        if count == 1:
            equal_one += 1
        elif count > 1:
            greater_one += 1
        all_counts.add(count)
    print(names)
    return list(names.values())

