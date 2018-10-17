-- update and insert new data into fact table
update sales_old set orderdate=date_add(orderdate, interval 900 day);


insert into sales(ordernumber,
orderlinenumber,
quantityordered,
priceeach,
sales,
orderdate,
status_code,
product_id,
customer_id,
dealsize,
created_at,
modified_at)
select ordernumber, orderlinenumber,
quantityordered,
priceeach,
sales,
orderdate,
status_code,
product_id,
customer_id,
dealsize,
now(),
now() from sales_old;

-- udf split_string function
CREATE FUNCTION `SPLIT_STRING`(
	str VARCHAR(255) ,
	delim VARCHAR(12) ,
	pos INT
) RETURNS VARCHAR(255) CHARSET utf8 RETURN REPLACE(
	SUBSTRING(
		SUBSTRING_INDEX(str , delim , pos) ,
		CHAR_LENGTH(
			SUBSTRING_INDEX(str , delim , pos - 1)
		) + 1
	) ,
	delim ,
	''
);

-- date transformation by using split_string()

update sales set orderdate=CONCAT(concat('20', split_string(orderdate, '/', 3)),'-',split_string(orderdate, '/', 1),'-',split_string(orderdate, '/', 2));
update sales set orderdate = replace(orderdate, ' 0:00','');
select orderdate from sales limit 5;
alter table sales modify column orderdate date;

-- testing data with date partition
select count(id) from sales where orderdate BETWEEN '2003-01-01' and '2004-01-01';