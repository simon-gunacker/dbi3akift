#!/bin/bash

sqlite3 :memory: <<EOF
.headers on
.mode column
.timer on
.read create_tables.sql
EOF
