-- creating database:
CREATE DATABASE bank;
use bank;

-- creating table:
CREATE TABLE bank_details(
product char(10),
quantity INT,
price REAL,
purchase_cost DECIMAL(6,2),
estimated_sale_price FLOAT
);
-- define the structure of table:
DESCRIBE bank_details;

-- inserting values into the table:
SELECT * from bank_details;
INSERT INTO bank_details VALUES('paycard',3,330,8008,9009);
INSERT INTO bank_details VALUES('paypoint',4,200,8000,6800);

-- inserting new column to the table:
ALTER TABLE bank_details ADD COLUMN geo_location VARCHAR(20);
DESCRIBE bank_details;

-- selecting geo location where product is paycard:
SELECT geo_location from bank_details where product = 'paycard';
SELECT char_length(product) FROM bank_details where product = 'paycard';

-- changing the product field from char to varchar:
ALTER TABLE bank_details MODIFY product varchar(10);
DESCRIBE bank_details;

-- creating new table bank_holiday:
CREATE TABLE bank_holiday(
holiday DATE,
start_time DATETIME,
end_time TIMESTAMP
);
DESCRIBE bank_holiday;
SELECT * from bank_holiday;

-- inserting values in bank_holiday:
INSERT INTO bank_holiday VALUES(
current_date(),
current_date(),
current_date()
);
SELECT * from bank_holiday;

-- update bank holidays:
UPDATE bank_holiday set holiday = date_add(holiday, interval 10 day);

update bank_holiday SET end_time = utc_timestamp();


-- Use of alias:
select product as New_Product from bank_details;

-- use of limit :
SELECT * FROM bank_details LIMIT 1;

-- use of substr() :
SELECT substr(geo_location, 1,5) from bank_details;