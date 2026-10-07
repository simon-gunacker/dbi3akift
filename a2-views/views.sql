CREATE VIEW IF NOT EXISTS customers_view AS
SELECT id, first_name, last_name, email
    FROM customers;

CREATE VIEW IF NOT EXISTS total AS
SELECT po.order_id, po.product_id, po.amount * p.price AS "total"
    , p.price AS "single_price", po.amount
    FROM orders o
        JOIN product_order po
        ON o.id = po.order_id
            JOIN products p
            ON po.product_id = p.id
;

CREATE VIEW IF NOT EXISTS orders_names AS
SELECT o.id AS "order_id", o.customer_id, o.order_date, o.status,
    c.first_name, c.last_name
    FROM orders o
        JOIN customers c
        ON o.customer_id = c.id
;

CREATE VIEW IF NOT EXISTS letzte_bestellung_a AS
SELECT
    o.customer_id,
    o.id AS order_id,
    o.order_date
FROM orders o
WHERE o.order_date = (
    SELECT MAX(o2.order_date)
    FROM orders o2
    WHERE o2.customer_id = o.customer_id
);

CREATE VIEW IF NOT EXISTS letzte_bestellung_b AS
SELECT
    o.customer_id,
    o.id AS order_id,
    o.order_date
FROM orders o
JOIN (
    SELECT
        customer_id,
        MAX(order_date) AS order_date
    FROM orders
    GROUP BY customer_id
) letzte
    ON letzte.customer_id = o.customer_id
   AND letzte.order_date = o.order_date;
