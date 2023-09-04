/*
Dica cada Script Recomendo Excecutar de 1 em 1
Questão por questão
*/

-- Questão 1

DELIMITER $$
create procedure list_customers_by_cityque(in cidade varchar(45))
begin 
	select 
    customerNumber as `ID`, 
    city as `Cidade`, 
    customerName as `Nome`, 
    contactLastName as `ADM Nome` from customers where 
    city like concat(cidade, '%') order by customerName asc;
end
$$
DELIMITER ;

set @c = "nyc";

call list_customers_by_cityque(@c);



-- Questão 2


DELIMITER $$
create procedure calculate_total_purchases_by_customerque (in id_cliente integer)
begin 

	select 
        o.orderNumber as `N Pedido`,
        od.productCode as `Cod Produto`,
        od.quantityOrdered as `Quantidade`,
        od.priceEach as `Preco Unitario`
        
    from customers c, orders o, orderdetails od
    where c.customerNumber = id_cliente
        and c.customerNumber = o.customerNumber
        and o.orderNumber = od.orderNumber;
        
        
	select 
	customerNumber `ID`,
	customerName as `Nome`, 
	(select
	
    sum((select sum(quantityOrdered * priceEach) 
	from orderdetails 
	where orderNumber like o.orderNumber
	group by orderNumber))
    
	from orders o 
	where customerNumber 
	like id_cliente
	group by p.customerNumber) as `Total` 
    
    from customers p 
	where customerNumber 
	like id_cliente;
    

end;
$$
DELIMITER ;

-- Pegar os Id caso queira testar
select customerNumber from customers order by customerNumber asc;

-- Só alterar o Numero para testar
set @id = 112;

call calculate_total_purchases_by_customerque(@id);


-- Questão 3


select productLine as `Modelo`, 
textDescription as `Descrição`
from productlines;

DELIMITER $$
create procedure update_discount_by_category

(in nome_modelo varchar(45), 
in novo_desconto decimal(5, 2))

begin

	select productLine as `Modelo`, 
	textDescription as `Descrição`
	from productlines where productLine like concat(nome_modelo, '%');

	select 
	productCode as `Codigo do Produto`, 
	productName as `Nome do Produto`, 
	productLine as `Modelo do Produto`,
	buyPrice as `Preco de Compra`, 
	MSRP as `Preco de Venda` from products where productLine like concat(nome_modelo, '%');

	update products
    set MSRP = MSRP * (1 - novo_desconto / 100)
    where productLine like concat(nome_modelo, '%');

	select 
	productCode as `Codigo do Produto`, 
	productName as `Nome do Produto`, 
	productLine as `Modelo do Produto`,
	buyPrice as `Preco de Compra`, 
	MSRP as `Preco de Venda` from products where productLine like concat(nome_modelo, '%');
    
end;
$$ DELIMITER ;

select 
	productCode as `Codigo do Produto`, 
	productName as `Nome do Produto`, 
	productLine as `Modelo do Produto`,
	buyPrice as `Preco de Compra`, 
	MSRP as `Preco de Venda` from products;
    
call update_discount_by_category('classic cars', 7);

select 
	productCode as `Codigo do Produto`, 
	productName as `Nome do Produto`, 
	productLine as `Modelo do Produto`,
	buyPrice as `Preco de Compra`, 
	MSRP as `Preco de Venda` from products;


-- Questão 4


select * from orders order by orderNumber asc;
select * from orderdetails order by orderNumber asc;

DELIMITER $$

create procedure delete_order_and_items (in numero_pedido int)

begin

	select * from orders where orderNumber like numero_pedido;
	
    select * from orderdetails where orderNumber like numero_pedido;
    
	delete from orderdetails where orderNumber = numero_pedido;

	select * from orderdetails where orderNumber like numero_pedido;

	delete from orders where orderNumber = numero_pedido;

	select * from orders where orderNumber like numero_pedido;
    
end $$

DELIMITER ;

call delete_order_and_items (10100);


-- Questão 5


select * from offices;

DELIMITER $$
create procedure list_employees_by_officeque(in id_oficina_pesquisar int)
begin

select

(select city from offices where officeCode like o.officeCode) as `Oficina`,
employeeNumber as `Id Funcionario`,
CONCAT(firstName, ' ', lastName) as `Nome Completo`,
email as `Email`

from employees o where officeCode like
id_oficina_pesquisar order by firstName asc;

end
$$ DELIMITER ;

call list_employees_by_officeque(1);


-- Questão 6


DELIMITER $$
create procedure generate_monthly_sales_report (in ano int, in mes int)
begin
select orderNumber,

		 (select 
		  concat(customerName, ' ' , contactLastName) from customers
          where customerNumber like o.customerNumber) as `Nome CLiente`,
          
         (select SUM(priceEach * quantityOrdered)
          from orderdetails
          where orderNumber = o.orderNumber
         ) as total, 
         
         orderDate,
         
         status
         
  from orders o
where year(orderDate) = ano and month(orderDate) = mes 
order by orderDate asc;


select 
         sum((select SUM(priceEach * quantityOrdered)
          from orderdetails
          where orderNumber = o.orderNumber
         )) as `Total de Ano e Por Mês`
         
from orders o
where year(orderDate) = ano and month(orderDate) = mes; 

end
$$ DELIMITER ;

call generate_monthly_sales_report (2003, 06);