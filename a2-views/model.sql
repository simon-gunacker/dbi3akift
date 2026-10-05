CREATE TABLE IF NOT EXISTS products (
        id INTEGER PRIMARY KEY AUTOINCREMENT
        , name VARCHAR
        , price FLOAT
        , inventory INTEGER
    );

CREATE TABLE IF NOT EXISTS customers (
        id INTEGER PRIMARY KEY AUTOINCREMENT
        , first_name VARCHAR
        , last_name VARCHAR
        , email VARCHAR
        , birth_date DATE
        , phone VARCHAR
        , address VARCHAR
    );

CREATE TABLE IF NOT EXISTS orders (
        id INTEGER PRIMARY KEY AUTOINCREMENT
        , customer_id INTEGER
        , order_date DATE
        , status VARCHAR
        , FOREIGN KEY (customer_id)
            REFERENCES customers(id)
    );

CREATE TABLE IF NOT EXISTS product_order (
        order_id INTEGER
        , product_id INTEGER
        , amount INTEGER
        , PRIMARY KEY (order_id, product_id)
        , FOREIGN KEY (order_id)
            REFERENCES orders(id)
        , FOREIGN KEY (product_id)
            REFERENCES products(id)
    );
