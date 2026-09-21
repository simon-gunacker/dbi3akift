from sqlite3 import connect
from names_generator import generate_name


table = """
    CREATE TABLE person (
        id INT PRIMARY KEY
        , first_name VARCHAR(255)
        , last_name VARCHAR(255)
)
"""

i = 0
equal_one = 0
greater_two = 0
all_counts = set()
names = {}

for x in range(500000):
    name = generate_name()
    if name in names:
        names[name] += 1
    else:
        names[name] = 1

for name, count in names.items():
    if count > 1:
        i += 1
    if count > 2:
        greater_two += 1
    if count == 1:
        equal_one += 1
    all_counts.add(count)

print(f"{i} names were generated more than once, {greater_two} names generated twice or more\n"
      f"{equal_one} generated once. {sorted(all_counts, reverse=True)}")
