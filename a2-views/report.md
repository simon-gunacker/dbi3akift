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

Lorem ipsum dolor sit amet.

### Differences between run time

Lorem ipsum dolor sit amet.

### Problems of not visible SQL query during use

Lorem ipsum dolor sit amet.

### EXPLAIN QUERY PLAN

Lorem ipsum dolor sit amet.

## Conclusion

Lorem ipsum dolor sit amet.