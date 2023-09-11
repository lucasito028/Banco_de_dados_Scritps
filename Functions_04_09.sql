-- Questão 1
DELIMITER $$
create function calcularComprimentoString(palavra varchar(45))
returns int
begin
	declare qtd int;
    set qtd = LENGTH(palavra);
    return qtd;

 

end
$$ DELIMITER ;

SELECT calcularComprimentoString('Hello World') 
AS `Quantidade de Character encontrado`;

 
-- Questão 2
DELIMITER $$
create function converterCelsiusParaFahrenheit(c int)
returns double
begin
	declare f double;
    set f = (c * 1.8) + 32;
    return f;
end
$$ DELIMITER ;

select converterCelsiusParaFahrenheit(6)


-- Questão 3
DELIMITER $$
create function calcularIdade(datp date)
returns int
begin
	declare idade int;
    set idade = timestampdiff(year, datp, current_date);
    return idade;
end
$$ DELIMITER ;

select calcularIdade('1998-12-30')


/* Questão 4
Nessa questão o Mysql não deixa criar uma função que retorna uma tabela.
Então criar uma procedure chamada "sp_listarProdutosPorPreco" igual com mesmo 
resultado para se ter uma ideia como a function "listarProdutosPorPreco" 
trabaharia 
*/

DELIMITER $$
create function listarProdutosPorPreco(valor int)

returns table

begin
    
	return (select productCode as `Codigo do Produto`, 
	productName as `Nome do Produto`,
	productLine as `Tipo`, 
	MSRP as `Preco de Venda` 
	from products where MSRP < valor 
	or 
	MSRP = valor
	order by MSRP desc);

end

$$ DELIMITER ;

DELIMITER $$ 
create procedure sp_listarProdutosPorPreco(in valor int)
begin 
	select productCode as `Codigo do Produto`, 
	productName as `Nome do Produto`,
	productLine as `Tipo`, 
	MSRP as `Preco de Venda` 
	from products where MSRP < valor 
	or 
	MSRP = valor
	order by MSRP desc;
end
$$ DELIMITER ;

call sp_listarProdutosPorPreco(50)

