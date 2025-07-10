-- Customers table
/*

CREATE TABLE customers (
  customer_id NUMBER PRIMARY KEY,
  name        VARCHAR2(100),
  email       VARCHAR2(100)
);

-- Orders table
CREATE TABLE orders (
  order_id    NUMBER PRIMARY KEY,
  customer_id NUMBER,
  order_date  DATE,
  FOREIGN KEY (customer_id)
    REFERENCES customers(customer_id)
    ON DELETE CASCADE
);

-- Order Items table
CREATE TABLE order_items (
  item_id     NUMBER PRIMARY KEY,
  order_id    NUMBER,
  product     VARCHAR2(100),
  quantity    NUMBER,
  FOREIGN KEY (order_id)
    REFERENCES orders(order_id)
    ON DELETE CASCADE
);

*/
TRUNCATE TABLE order_items;
TRUNCATE TABLE orders;
TRUNCATE TABLE customers;

-- Insert customers
INSERT INTO customers VALUES (1, 'Alice', 'alice@example.com');
INSERT INTO customers VALUES (2, 'Bob', 'bob@example.com');

-- Insert orders
INSERT INTO orders VALUES (101, 1, DATE '2023-06-01');
INSERT INTO orders VALUES (102, 1, DATE '2023-06-05');
INSERT INTO orders VALUES (103, 2, DATE '2023-06-10');

-- Insert order items
INSERT INTO order_items VALUES (1001, 101, 'Keyboard', 2);
INSERT INTO order_items VALUES (1002, 101, 'Mouse', 1);
INSERT INTO order_items VALUES (1003, 102, 'Monitor', 1);
INSERT INTO order_items VALUES (1004, 103, 'Desk', 1);

COMMIT;


SELECT * FROM ORDER_ITEMS;

--DELETE FROM customers WHERE customer_id = 1;



ALTER TABLE customers modify partition by range (customer_id) (
    PARTITION p1 VALUES LESS THAN (2),
    PARTITION p2 VALUES LESS THAN (3)
) online;


ALTER TABLE orders modify partition by range (customer_id) (
    PARTITION p1 VALUES LESS THAN (2),
    PARTITION p2 VALUES LESS THAN (3)
) online;

ALTER TABLE customers modify partition by range (customer_id) (
    PARTITION p1 VALUES LESS THAN (2),
    PARTITION p2 VALUES LESS THAN (3)
) online;

ALTER TABLE ORDERS DROP PARTITION p1;

ALTER TABLE customers DROP PARTITION p1;

SELECT * FROM USER_DEPENDENCIES;


SELECT i.index_name, status i FROM user_indexes i;

SELECT
  a.table_name       AS child_table,
  a.constraint_name  AS fk_name,
  c.table_name       AS parent_table,
  b.column_name      AS child_column,
  d.column_name      AS parent_column, a.STATUS
FROM
  user_constraints a
  JOIN user_cons_columns b ON a.constraint_name = b.constraint_name
  JOIN user_constraints c ON a.r_constraint_name = c.constraint_name
  JOIN user_cons_columns d ON c.constraint_name = d.constraint_name AND b.position = d.position
WHERE
  a.constraint_type = 'R'
ORDER BY
  a.table_name, a.constraint_name;


ALTER TABLE orders DISABLE CONSTRAINT SYS_C008615;
