**Report**

For this assignment I created a test database for an online shop. I wrote a Python script that fills the database with randomly generated data. After that, I wrote several Views and compared the runtime of two given queries with one another by writing a benchmark script.

**Views**

A View in SQLite is like a function in code: You can give a query a name and save it inside the database. After that, you can access this query like you would any other table across all sessions. This allows you to save time and make accessing data easier, also for less experienced users.
However, "hiding" the query within the view makes it harder to spot higher runtimes and complexity costs.

**Benchmark Tests**

For the benchmark tests we had to compare 2 given selects. My script runs those selects (that are stored as views) 1000 times and returns the average runtime as well as the difference factor. My results were:

A ≈ 0.0353 s  
B ≈ 0.00626 s  
Faktor ≈ 5.64

This shows that View "A" had a significantly longer runtime than View "B".
In order to see what is causing this difference, the assignment prompted us to use "EXPLAIN QUERY PLAN".
Running this on both selects gave me the outputs:

View A:  
SCAN b  
CORRELATED SCALAR SUBQUERY  
SEARCH b2

View B:  
SCAN b  
BLOOM FILTER ON letzte  
SEARCH letzte USING AUTOMATIC PARTIAL COVERING INDEX

This shows that View A recalculates MAX(bestelldatum) for each relevant outer row, while View B first groups the data by customer to find MAX(bestelldatum) and then joins this result back to bestellung.

**Final thoughts**

Views help make a database easier and faster to navigate, but they cannot change the complexity of a query itself, since they only give a name to it.
