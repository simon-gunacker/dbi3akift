from sqlite3 import connect
from names_generator import generate_name

import sql, get_variance as gv

# with connect(sql.database) as conn:


print(generate_name(style='capital'))

with connect(sql.database) as conn:
    curs = conn.cursor()
    curs.execute(sql.table)
    gv.generate_names(curs, sql.insert)
