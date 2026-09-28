from sqlite3 import connect
from names_generator import generate_name
import numpy as np


import statements as s

def db(
    database: str, execute_insert: bool = True, create_index: bool = False
    ) -> None:
    dataset_count = 500000
    with connect(database) as con:
        con.execute(s.table)
        if create_index:
            con.execute(s.index)
        s.fill_db(
            con, s.insert, dataset_count, execute_insert
            )
        curs = con.cursor()
        res = curs.execute(s.select_duplicate_names).fetchall()
        res = sorted(list(map(lambda x: x[0], res)))
        # print(round(sum(res)/len(res), 1))
        print(f"Varianz: {round(np.var(res), 2)} "
              f"- Standardabweichung: {round(np.std(res), 2)}")
        con.commit()

def main():
    db(s.database, execute_insert=False)
    db(s.db_indexed, execute_insert=False, create_index=True)


if __name__ == "__main__":
    main()
