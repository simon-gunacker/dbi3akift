from sqlite3 import connect
from names_generator import generate_name
import numpy as np


import statements, get_variance as gv

def db():
    with connect(statements.database) as conn:
        curs = conn.cursor()
        conn.execute(statements.table)
        stats = statements.generate_names(
            curs, statements.insert, False
            )
        mean = np.mean(stats)
        print(stats)
        print(np.std(stats), mean)
        conn.commit()


def main():
    db()

if __name__ =="__main__":
    main()
