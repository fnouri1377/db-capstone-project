drop database little_lemon_db;
show databases;
use little_lemon_db;

show tables;

-- Create View
create view OrdersView as
select order_id,
		quantity,
        total_cost
from Orders
where quantity > 2;
select * from OrdersView;

-- Join
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

-- Join
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
set @id = 1;
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