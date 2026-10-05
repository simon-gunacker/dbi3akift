# Index in SQLite

## Geenrating Databank with Python Script

Creating the databank `index.db` using the faker python library to generate the 
dummy data.
With the `sqlite3` library creating the connection to the data bank and 
managing the cursor object.

## Calculating the Data Spread

To calculate the data spread with names, we need to look at the data frequency. 
As **names cannot be numerically compared** to one another like 
numbers can, we need to check how often do the same name appear and check it's 
relative percantage, which gives us an overview of how even the distribution is.
In case of an even, uniform distribution, the relative percentage should be the same. 

For example: if we have 100 possible first names, out of the 500,000 data 
every name should apper around 5,000 times (500,000/100 = 1%).

**Settings**
```sql
.headers on
.mode column
.timer on
```

**With the following querry:**

```sql
WITH name_counts AS (
    SELECT first_name, COUNT(*) AS freq
    FROM persons
    GROUP BY first_name
),
total AS (
    SELECT COUNT(*) AS total_rows
    FROM persons
)
SELECT
    nc.first_name,
    nc.freq,
    ROUND((CAST(nc.freq AS FLOAT) / t.total_rows) * 100, 2) AS relative_percentage
FROM name_counts nc, total t
ORDER BY nc.freq DESC
LIMIT 20;
```

**which results:**

```bash
first_name   freq   relative_percentage
-----------  -----  -------------------
Michael      11542  2.31               
David        7939   1.59               
James        7443   1.49               
Jennifer     7368   1.47               
John         7335   1.47               
Christopher  6913   1.38               
Robert       6830   1.37               
Jessica      5162   1.03               
Matthew      5093   1.02               
William      5027   1.01               
Joseph       4786   0.96               
Lisa         4750   0.95               
Daniel       4660   0.93               
Brian        4180   0.84               
Kimberly     4120   0.82               
Jason        3868   0.77               
Michelle     3844   0.77               
Amanda       3831   0.77               
Ashley       3796   0.76               
Elizabeth    3770   0.75               
Run Time: real 0.048 user 0.039629 sys 0.008192
```

This top 20 names shows that the uniformity is relatively large, as al names have 
a similar frequency.

## Performance Unindexed & Indexed

In order to analyze the performance difference of an unindexed and an indexed search,
We simply look at a `SELECT` querry with and without an index.

### Selecting a name from persons un indexed:

```sql
SELECT * FROM persons WHERE first_name = 'Anna';
```
The results:
- DB Size: 11MB
- `Run time: real 0.058 user 0.046865 sys 0.005283`

### Selecting the same name after creating an index

Creating the index on the `persons` table on the `first_name`.

```sql
CREATE INDEX idx_persons_first_name ON persons(first_name);
```

After the index is created, the data bank size has grown significantly.
From the **previous 11MB** it became **18MB**.

```sql
SELECT * FROM persons WHERE first_name = 'Anna';
```

After runing the same `SELECT` for the name "Anna", the results are:

`Run Time: real 0.008 user 0.000123 sys 0.008036`

The difference in run time: `Real: -0,05, User: -0.046742, Sys: -0.002753`

## Bias & Index

Creating a second table `persons_biased` where 50% of the first names are `Max` 
the rest is randomised.

```sql
CREATE TABLE persons_biased (
    id INTEGER PRIMARY KEY,
    first_name TEXT,
    last_name TEXT
);

INSERT INTO persons_biased (first_name, last_name)
SELECT 'Max', last_name FROM persons LIMIT 250000;

INSERT INTO persons_biased (first_name, last_name)
SELECT first_name, last_name FROM persons LIMIT 250000;
```

After the table is created and the names are inserted, we make an index.
Similarly as before, but this time on the newly created table `persons_biased`
on the `first_name`.

```sql
CREATE INDEX idx_biased_first_name ON persons_biased(first_name);
```

After the index is created, we run the querries:

```sql
SELECT * FROM persons_biased WHERE first_name = 'Anna';
```

Results of the querry:
`Run Time: real 0.004 user 0.001203 sys 0.003309`

```sql
SELECT * FROM persons_biased WHERE first_name = 'Max';
```

Results of the querry:
`Run Time: real 0.331 user 0.088573 sys 0.222302`

Using indexes are adventageous if the data we are looking for is sparse and spread out.
But it looses it's advantage as soon as there are a high amount of duplicat data, SQLite needs to look through. In this case the first name `Max` takes up half of the table.

## Summarised

Indexes are a great tool to perform searches/quarries faster and more efficiently 
sacrificing storage space, if the dat ban, we are working with, hase minimal amounts 
of duplicat data.

But the drawback is the additional storage space it requires, especially on larger databases, as well as the worst than nominal search speeds if there are large amounts of duplicat data, like in our case the first name `Max`.
