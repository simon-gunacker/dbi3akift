from sqlite3 import connect

SRC_PATH = 'db/'

DB = 'bibliothek.db'

TABLES = SRC_PATH + 'tables.sql'
DATA = SRC_PATH + 'data.sql'
TRIGGERS = 'triggers.sql'
VIEWS = SRC_PATH + 'views.sql'

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
            print(f'{TABLES} executed')
            con.executescript(data)
            print(f'{DATA} executed')
            con.executescript(views)
            print(f'{VIEWS} executed')
            con.executescript(triggers)
            print(f'{TRIGGERS} executed')
