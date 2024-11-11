-- drop database little_lemon_db;
show databases;
use little_lemon_db;

show tables;

-- Insert example data
-- Insert example data into Customers
INSERT INTO Customers (name, contact_details) VALUES
('John Doe', 'john.doe@example.com'),
('Jane Smith', 'jane.smith@example.com'),
('Alice Johnson', 'alice.johnson@example.com'),
('Bob Brown', 'bob.brown@example.com');

select * from Customers;

-- Insert example data into Menu
INSERT INTO Menu (cuisine, menu_name) VALUES
('Italian', 'Pasta Special'),
('Mexican', 'Taco Fiesta'),
('Indian', 'Curry Delight');

select * from Menu;

-- Insert example data into Orders
INSERT INTO Orders (order_date, quantity, total_cost, customer_id) VALUES
('2023-10-01 18:30:00', 2, 29.99, 12),
('2023-10-01 19:00:00', 1, 15.50, 13),
('2023-10-01 19:30:00', 3, 45.00, 14),
('2023-10-01 20:00:00', 1, 20.00, 15);

select * from Orders;

-- Insert example data into MenuItems
INSERT INTO MenuItems (CourseName, StarterName, DessertName, menu_id, order_id) VALUES
('Main Course', 'Garlic Bread', 'Tiramisu', 1, 1),
('Main Course', 'Nachos', 'Churros', 2, 2),
('Main Course', 'Butter Chicken', 'Gulab Jamun', 3, 3),
('Main Course', 'Spaghetti', 'Panna Cotta', 1, 4);

select * from MenuItems;

-- Insert example data into Bookings
INSERT INTO Bookings (date, table_number, customer_id) VALUES
('2023-10-01 18:00:00', 1, 12),
('2023-10-01 19:00:00', 2, 13),
('2023-10-01 19:30:00', 3, 14),
('2023-10-01 20:00:00', 4, 15);

select * from Bookings;

-- Insert example data into Order_Delivery_Status
INSERT INTO Order_Delivery_Status (delivary_date, status, order_id) VALUES
('2023-10-01 19:00:00', 'Delivered', 1),
('2023-10-01 19:30:00', 'Pending', 2),
('2023-10-01 20:00:00', 'Delivered', 3),
('2023-10-01 20:30:00', 'Pending', 4);

select * from Order_Delivery_Status;

-- Insert example data into Staff_Information
INSERT INTO Staff_Information (role, salary) VALUES
('Chef', 50),
('Waiter', 30),
('Manager', 60);

select * from Staff_Information;

-- Create View
create view OrdersView as
select order_id,
		quantity,
        total_cost
from Orders
where quantity > 2;

select * from OrdersView;

-- Join 1
select
	c.customer_id,
	c.name,
    o.order_id,
    o.total_cost,
    m.menu_name,
    mi.CourseName,
    mi.StarterName
from
	Customers as c
join
	Orders as o
join
	MenuItems as mi
join
	Menu as m
on
	c.customer_id = o.customer_id and
    mi.order_id = o.order_id and
    m.menu_id = mi.menu_id
where
	o.total_cost > 150
order by
	o.total_cost asc;

-- Join 2
select menu_name
from Menu
where menu_id in (
	select mi.menu_id
    from MenuItems as mi
    join Orders as o
    on o.order_id = mi.order_id
    group by mi.menu_id
    having count(o.order_id) > 2
);

-- Procedure
delimiter //
create procedure GetMaxQuantity()
begin
	select max(quantity) as MaxOrderedQuantity from Orders;
end//

delimiter ;

call GetMaxQuantity();

-- Prepared Statement
set @sql = 'select order_id, quantity, total_cost from Orders where customer_id = ?';
prepare GetOrderDetail from @sql;
set @id = 12;
execute GetOrderDetail using @id;
deallocate prepare GetOrderDetail;

-- Procedure
delimiter //

create procedure CancelOrder(in OrderID int)
begin
	delete from Orders where order_id = OrderID;
end //

delimiter ;

call CancelOrder(1);

-- Populate Bookings Table
insert into Customers (customer_id, name, contact_details) values
(1, 'Isla Nou', '12345678'),
(2, 'Neo Cham', '23456789'),
(3, 'Maggie Dan', '34567890');

select * from Customers;

insert into Bookings (booking_id, date, table_number, customer_id) values
(1, '2022-10-10', 5, 1),
(2, '2022-11-12', 3, 3),
(3, '2022-10-11', 2, 2),
(4, '2022-10-13', 2, 1);

select * from Bookings;

-- Check Booking Procedure
delimiter //

create procedure CheckBooking(in bookingDate date, in tableNumber int)
begin
	declare tableBooked int;
    
    select count(*) into tableBooked from Bookings where date = bookingDate and table_number = tableNumber;
    
    if tableBooked > 0 then
		select 'Table is already booked.' as BookingStatus;
	else
		select 'Table is available.' as BookingStatus;
	end if;
end//

delimiter ;

call CheckBooking('2022-10-11', 2);
call CheckBooking('2022-11-12', 5);

-- Booking Procedure and Transaction
delimiter //

create procedure AddValidBooking(in bookingDate date, in tableNumber int, in customerID varchar(255))
begin
	declare tableBooked int;
    
    start transaction;
    
    select count(*) into tableBooked from Bookings where date = bookingDate and table_number = tableNumber;
    
    if tableBooked > 0 then
		rollback;
        select 'Booking declined: Table is already booked.' as StatusMessage;
	else
		insert into Bookings (booking_id, date, table_number, customer_id) values (100, bookingDate, tableNumber, customerID);
        commit;
        select 'Booking confirmed.' as StatusMessage;
	end if;
end //

delimiter ;

call AddValidBooking('2022-12-17', 6, 1);
call AddValidBooking('2022-10-10', 5, 1);

-- Add Booking Procedure
delimiter //

create procedure AddBooking(in bookingID int, in customerID int, in bookingDate date, in tableNumber int)
begin
	insert into Bookings (booking_id, date, table_number, customer_id) values
    (bookingID, bookingDate, tableNumber, customerID);
end //

delimiter ;

call AddBooking(9, 3, '2022-12-30', 4);

select * from Bookings;

-- Update Booking Procedure
delimiter //

create procedure UpdateBooking(in bookingID int, in bookingDate date)
begin
	update Bookings
    set date = bookingDate
    where booking_id = bookingID;
end //

delimiter ;

call UpdateBooking(9, '2022-12-15');

select * from Bookings;

-- Cancel Booking Procedure
delimiter //

create procedure CancelBooking(in bookingID int)
begin
	delete from Bookings
    where booking_id = bookingID;
end //

delimiter ;

call CancelBooking(100);

select * from Bookings;