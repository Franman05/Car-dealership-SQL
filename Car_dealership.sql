create table customer(
	customer_id SERIAL primary key,
	first_name VARCHAR(100),
	last_name VARCHAR(100),
	vin_num VARCHAR(100),
	phone_number VARCHAR(50)
);

create table mechanic(
	mechanic_id SERIAL primary key,
	first_name VARCHAR(100),
	last_name VARCHAR(100)
);


create table saleperson(
	sales_id SERIAL primary key,
	first_name VARCHAR(100),
	last_name VARCHAR(100)
);

create table car_inventory(
	vin_num SERIAL primary key,
	car_year INTEGER,
	car_make VARCHAR(100),
	car_model VARCHAR(100),
	car_used_or_new VARCHAR(50),
	price_amount NUMERIC(8,2)
);

create table parts(
	part_id SERIAL primary key,
	part_name VARCHAR(100),
	price NUMERIC(4,2)
);

create table invoices(
	invoice_id SERIAL primary key,
	vin_num VARCHAR(100),
	sales_id INTEGER,
	customer_id INTEGER,
	foreign key (sales_id) references saleperson(sales_id),
	foreign key (customer_id) references customer(customer_id)
);

create table car_service(
	ticket_num SERIAL primary key,
	vin_number VARCHAR(100),
	customer_id INTEGER,
	payment_amount NUMERIC(8,2)
);

alter table car_service
add mechanic_id INTEGER,
add	part_id INTEGER,
add	foreign key (mechanic_id) references mechanic(mechanic_id),
add	foreign key (part_id) references parts(part_id);

insert into customer(customer_id, first_name, last_name, vin_num, phone_number)
values 
(1, 'Steve', 'Ross', 'VH890808', '333-567-889'),
(2, 'Ray', 'Smith', 'VH767753', '222-498-0014'),
(3, 'Rose', 'Espenza', 'VH57373', '555-034-3456');

select * from customer

insert into mechanic(mechanic_id, first_name, last_name)
values 
('101', 'Lewis', 'Jones'),
('102', 'Ellie', 'Swin'),
('103', 'Robert', 'Hancock');

select * from mechanic

insert into saleperson(sales_id, first_name, last_name)
values 
('201', 'Tim', 'Caldwell'),
('202', 'Shay', 'Robertson'),
('203', 'Hannah', 'Wright');

select * from saleperson

create or replace function add_customers(_vin_num int, _car_year int, _car_make VARCHAR, _car_model VARCHAR, _car_used_or_new VARCHAR, _price_amount NUMERIC)
returns void as 
$BODY$
	begin
		insert into car_inventory(vin_num, car_year, car_make, car_model, car_used_or_new, price_amount)
		values (_vin_num, _car_year, _car_make, _car_model, _car_used_or_new, _price_amount);
	end;
$BODY$
language 'plpgsql' volatile;

--select * from add_customers('87993', '2015', 'Nissa', 'Pathfinder','Used', 15000)
--select * from add_customers('85934', '2020', 'Jeep', 'Cherokee', 'New', 25000)
--select * from add_customers('65959', '2018', 'Dodge', 'Ram', 'Used', 10000)

select * from car_inventory

create or replace function add_customers(_part_id int, _part_name VARCHAR(100), _price numeric)
returns void as
$BODY$
	begin
		insert into parts(part_id, part_name, price)
		values (_part_id, _part_name, _price);
	end;
$BODY$
language 'plpgsql' volatile;

--select * from add_customers('1002', 'Transmisson', 40.00)  -- Should of made numeric value higher
--select * from add_customers('1003', 'Tie Rod', 40.20)
--select * from add_customers('1004', 'Oil change', 25.00)

select * from parts

create or replace function add_customers(_invoice_id int, _sales_id int, _customer_id int, _vin_num VARCHAR)
returns void as
$BODY$
	begin
		insert into invoices(invoice_id, sales_id, customer_id, vin_num)
		values (_invoice_id, _sales_id, _customer_id, _vin_num);
	end;
$BODY$
language 'plpgsql' volatile;

--select * from add_customers('1', '201', '1', 'WC748442')
--select * from add_customers('2', '202', '2', 'WC345453')
--select * from add_customers('3', '203', '3', 'WC97095')

select * from invoices

create or replace function add_customers(_ticket_num int, _vin_number VARCHAR(100), _customer_id int, _payment_amount numeric,  _mechanic_id int, _part_id int)
returns void as
$BODY$
	begin
		insert into car_service(ticket_num, vin_number, customer_id, payment_amount, mechanic_id, part_id)
		values (_ticket_num, _vin_number, _customer_id, _payment_amount, _mechanic_id, _part_id);
	end;
	$BODY$
language 'plpgsql' volatile;

select * from add_customers('1', 'WC97095', '1', 750.00, '101', '1002')
select * from add_customers('2', 'WC345453', '2', 450.00, '102', '1003')
select * from add_customers('3', 'WC748442', '3', 25.00, '103', '1004')

select * from car_service