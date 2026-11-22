from sqlite3 import connect

DB = 'bibliothek.db'
TABLES = 'tables.sql'
DATA = 'data.sql'
TRIGGERS = 'triggers.sql'
VIEWS = 'views.sql'

with open(DB, "w"):
    pass

with open(TABLES,"r") as tab, open(DATA, "r") as dat\
    , open(TRIGGERS) as trig, open(VIEWS, "r") as view:
        tables=tab.read()
        data=dat.read()
        triggers=trig.read()
        views=view.read()
        with connect(DB) as con:
            con.executescript(tables)
            con.executescript(data)
            con.executescript(triggers)
            con.executescript(views)
