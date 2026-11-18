#!/bin/bash

sqlite3 :memory: <<EOF
PRAGMA foreign_keys = ON;
.headers on
.mode column
.timer on
.read create_tables.sql
.read insert_data.sql
.read trigger_bestandsverwaltung.sql
EOF
