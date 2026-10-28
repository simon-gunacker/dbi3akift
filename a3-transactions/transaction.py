
def insert_table(
    cur: object, table_name: str, cols: tuple, vals: list,
    return_id: bool = False
    ) -> list:
    if return_id:
        sql = f"INSERT INTO {table_name}{cols} VALUES({('?, '*len(vals))[:-2]}) RETURNING id"
    else:
        sql = f"INSERT INTO {table_name}{cols} VALUES({('?, '*len(vals))[:-2]})"
    res = cur.execute(sql, vals)

    return res.fetchall()

