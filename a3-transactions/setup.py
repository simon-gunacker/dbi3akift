

def fill_db(
    cur: object, db: str, model_file: str, data_file: str,
    tables: list
    ) -> None:

    table_count = len(
        cur.execute(
            "SELECT name FROM sqlite_master WHERE type='table'"
            ).fetchall()
        )
    if table_count == 0:
        with open(model_file, "r") as m:
            model = m.read()
            cur.executescript(model)
            print(f"Created {*tables, } from '{model_file}'")
    kunden_count = len(
            cur.execute(
                "SELECT * FROM kunde"
                ).fetchall()
        )
    if kunden_count == 0:
        with open(data_file, "r") as d:
            data = d.read()
            cur.executescript(data)
            print(f"Data from '{data_file}' inserted\n")


if __name__ == "__main__":
    main()
