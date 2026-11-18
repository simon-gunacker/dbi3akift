#!/bin/bash

sqlite3 :memory: <<EOF
PRAGMA foreign_keys = ON;
.headers on
.mode column
.timer on
.read create_tables.sql
EOF
