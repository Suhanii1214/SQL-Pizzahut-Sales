CREATE DATABASE pizzahut;

CREATE TABLE orders(
	order_id INT NOT NULL,
    order_date date NOT NULL,
    order_time time NOT NULL,
    PRIMARY KEY(order_id)
);

CREATE TABLE order_details(
	order_details_id INT NOT NULL,
	order_id INT NOT NULL,
    pizza_id TEXT NOT NULL,
    quantity INT NOT NULL,
    PRIMARY KEY(order_details_id)
);

SELECT *
FROM order_details;