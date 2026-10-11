# REPORT ON VIEWS

## Views

### Purpose of views

If the view is a complicated sql query and is needed multiple times, it doesn't have to be written over and over again. Instead, it has to be written only once and can be viewed by just a simple SELECT command:

```sql
SELECT * FROM view_name;
```

If certain people should have limited access to a database, you could create views with all the information they are allowed to see and only let them access those.

### Advantages of views

- Access can be limited for a person only to that view;
- If the information of a complicated sql query is needed, it only needs to be written and executed once;

### Disadvantages of views

- If the original table is changed or deleted, the view may "suddenly" not work (e.g. column used in the view gets deleted);
- It uses disk space;

## Performance

### Do bolth views return the same result?

No, not at all.

```
letzte_bestellung_a: 147.60304849999375
letzte_bestellung_b: 0.09490330002154224
letzte_bestellung_a: 224.0972096999758
letzte_bestellung_b: 0.2196115999831818
letzte_bestellung_a: 366.96272699997644
letzte_bestellung_b: 0.20670150002115406
letzte_bestellung_a: 363.63357869998435
letzte_bestellung_b: 0.19968259998131543
letzte_bestellung_a: 364.2330582999857
letzte_bestellung_b: 0.21546989999478683
letzte_bestellung_a: 360.68301870001596
letzte_bestellung_b: 0.19559770001797006
letzte_bestellung_a: 164.16262039999128
letzte_bestellung_b: 0.04448949999641627
letzte_bestellung_a: 80.44148819998372
letzte_bestellung_b: 0.04820960000506602
letzte_bestellung_a: 80.88962910001283
letzte_bestellung_b: 0.0455587999895215
letzte_bestellung_a: 80.94656460001715
letzte_bestellung_b: 0.04418579998309724
```

### Differences between run time

As can be seen above, there is a significant difference between a and b. The average of version **a** is **223.3652943199937** seconds, and the average od version **b** is **0.13144102999940516** seconds. That is a difference of **223.2338532899943** seconds. That is approxmately a factor of **1699.36**.

### Problems of not visible SQL query during use

The not immediately apparent SQL query of a view is problematic because 
- it is not immediately clear from which table the information of the view comes from
- when issues appear (performance, wrong output), it is hard to know why

### EXPLAIN QUERY PLAN

```
sqlite> .eqp on
sqlite> SELECT * FROM letzte_bestellung_a WHERE kunde_id = 42;
QUERY PLAN
|--CO-ROUTINE letzte_bestellung_a
|  |--SCAN b
|  `--CORRELATED SCALAR SUBQUERY 3
|     `--SEARCH b2
`--SCAN letzte_bestellung_a
╭──────────┬───────────────┬──────────────╮
│ kunde_id │ bestellung_id │ bestelldatum │
╞══════════╪═══════════════╪══════════════╡
│       42 │         15180 │ 2026-04-15   │
╰──────────┴───────────────┴──────────────╯
sqlite> SELECT * FROM letzte_bestellung_b WHERE kunde_id = 42;
QUERY PLAN
|--CO-ROUTINE letzte_bestellung_b
|  |--CO-ROUTINE letzte
|  |  |--SCAN bestellung
|  |  `--USE TEMP B-TREE FOR GROUP BY
|  |--SCAN b
|  |--BLOOM FILTER ON letzte (kunde_id=?)
|  `--SEARCH letzte USING AUTOMATIC COVERING INDEX (kunde_id=?)
`--SCAN letzte_bestellung_b
╭──────────┬───────────────┬──────────────╮
│ kunde_id │ bestellung_id │ bestelldatum │
╞══════════╪═══════════════╪══════════════╡
│       42 │         15180 │ 2026-04-15   │
╰──────────┴───────────────┴──────────────╯
```

### Difference between processing

The first method is in this case definitely way slower than the second one. 
The second one uses a ```GROUP BY``` while the first one scans everything. This doesn't automatically mean that the first method is bad. When dealing with little data, the second ones extra effort is probably not worth it. But when dealing with a lot of data, like in this case, the second one is definitely wiser.

## Conclusion

A View can definitely simplify a query and speed up the time to write one based on the same combination of tables, like we saw above, where a query which used a complex structure only needed to be written once and a simple ```SELECT``` could be just added to look for further information.
However, unlike a 'normal query', it uses disk space and, depending on how it is written, does not change the performance (like in "letzte_bestellung_b") or could even be worse (like in "letzte_bestellung_a") since it is not fexible and cannot be easily adjusted to a situation. 