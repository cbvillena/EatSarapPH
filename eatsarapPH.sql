DROP DATABASE IF EXISTS eatsarap;
CREATE DATABASE IF NOT EXISTS eatsarap;
USE eatsarap;

DROP TABLE IF EXISTS store;
DROP TABLE IF EXISTS statusTbl;
DROP TABLE IF EXISTS customer;
DROP TABLE IF EXISTS menu;
DROP TABLE IF EXISTS custorder;

CREATE TABLE IF NOT EXISTS store (
    store_id int NOT NULL,
    storename varchar(255),
	storeaddress varchar(255),
    phonenumber bigint,
    emailaddress varchar(255),
	storephoto_url varchar(255),
	servicecharge int,
    PRIMARY KEY (store_id)
);

INSERT INTO store VALUES(1, 'Burger Town', '7114 Kundiman Street, Sampaloc 1008, Manila, Philippines', 987362513, 'btown@gmail.com','images/store/store1.png', 5);

CREATE TABLE IF NOT EXISTS statusTbl (
    status_id int NOT NULL AUTO_INCREMENT,
    status_name varchar(50),
    PRIMARY KEY (status_id)
);

INSERT INTO statusTbl VALUES
    (1, 'Dine in'),
    (2, 'Take out'),
    (3, 'Delivery'),
    (4, 'Bill out');
    
CREATE TABLE IF NOT EXISTS customer (
    customer_id int NOT NULL,
    customer_identity varchar(255),
	status int,
    PRIMARY KEY (customer_id)
);

INSERT INTO customer VALUES(1, '5', 0);
INSERT INTO customer VALUES(2, '5', 0);

CREATE TABLE IF NOT EXISTS menu (
    item_id int NOT NULL AUTO_INCREMENT,
	store_id int,
    item_name varchar(50),
	price double,
	description varchar(255),
	itemphoto_url varchar(255),
	category_name varchar(255),
    PRIMARY KEY (item_id),
	FOREIGN KEY (store_id) REFERENCES store(store_id) ON DELETE CASCADE ON UPDATE CASCADE
);

INSERT INTO menu VALUES
	(1, 1, 'Nacho chips', 70.00, 'Sample description', 'images/store/nacho.jpg', 'Appetizers'),
	(2, 1, 'Fish and chips', 120.00, 'Sample description', 'images/store/nacho.jpg', 'Appetizers'),
	(3, 1, 'Pumpkin soup', 50.00, 'Sample description', 'sample.jpg', 'Appetizers'),
	(4, 1, 'Buffalo wings', 150.00, 'Sample description', 'sample.jpg', 'Appetizers'),
	(5, 1, 'Nacho chips', 70.00, 'Sample description', 'sample.jpg', 'Appetizers'),
	(6, 1, 'Beef Burger', 90.00, 'Sample description', 'sample.jpg', 'Regular Burgers'),
	(7, 1, 'Fish Burger', 90.00, 'Sample description', 'sample.jpg', 'Regular Burgers'),
	(8, 1, 'Tuna pesto', 90.00, 'Sample description', 'sample.jpg', 'Light orders'),
	(9, 1, 'Tuna sandwich', 100.00, 'Sample description', 'sample.jpg', 'Light orders'),
	(10, 1, 'Ceasar salad', 70.00, 'Sample description', 'sample.jpg', 'Light orders'),
	(11, 1, 'Brutus Burger', 160.00, 'Sample description', 'sample.jpg', 'Specialty Burgers'),
	(12, 1, 'Double stacked burger', 210.00, 'Sample description', 'sample.jpg', 'Specialty Burgers'),
	(13, 1, 'Talk of the town', 180.00, 'Sample description', 'sample.jpg', 'Specialty Burgers'),
	(14, 1, 'On the fly', 170.00, 'Sample description', 'sample.jpg', 'Specialty Burgers'),
	(15, 1, 'Mango bits', 50.00, 'Sample description', 'sample.jpg', 'Desserts'),
	(16, 1, 'Black forest', 70.00, 'Sample description', 'sample.jpg', 'Desserts'),
	(17, 1, 'Kula shaker', 80.00, 'Sample description', 'sample.jpg', 'Desserts'),
	(18, 1, 'Burger and chips', 170.00, 'Sample description', 'sample.jpg', 'Combos'),
	(19, 1, 'All in', 250.00, 'Sample description', 'sample.jpg', 'Combos'),
	(20, 1, 'Soda', 30.00, 'Sample description', 'sample.jpg', 'Beverages'),
	(21, 1, 'Frap, frap, frap', 70.00, 'Sample description', 'sample.jpg', 'Beverages'),
	(22, 1, 'Beer', 70.00, 'Sample description', 'sample.jpg', 'Beverages');
	
CREATE TABLE IF NOT EXISTS custorder (
    order_id int NOT NULL AUTO_INCREMENT,
	store_id int,
	customer_id int,
    item_id int,
	quantity int,
    PRIMARY KEY (order_id),
	FOREIGN KEY (store_id) REFERENCES store(store_id) ON DELETE CASCADE ON UPDATE CASCADE,
	FOREIGN KEY (item_id) REFERENCES menu(item_id) ON DELETE CASCADE ON UPDATE CASCADE,
	FOREIGN KEY (customer_id) REFERENCES customer(customer_id) ON DELETE CASCADE ON UPDATE CASCADE
);

INSERT INTO custorder VALUES
    (1, 1, 1, 1, 1),
    (2, 1, 1, 2, 1),
    (3, 1, 1, 6, 1);