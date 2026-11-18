#!/bin/bash

sqlite3 :memory: <<EOF
PRAGMA foreign_keys = ON;
.headers on
.mode column
.timer on
.read create_tables.sql
.read insert_data.sql
.read trigger_bestandsverwaltung.sql
.read trigger_ausleihe_mahnung.sql
.read trigger_e_book.sql
.read trigger_aufraeumen.sql
.read trigger_logging.sql
.read tests.sql
EOF
