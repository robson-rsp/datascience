-- Obter os nomes de todas as colunas de uma tabela.
-- Não funcionou no w3schools
SELECT *
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'Customers';
-- ou
SELECT TOP 1 * 
FROM Customers;



-- Selecionar os cinco primeiros nomes dos clientes.
SELECT TOP 5 CustomerName  
FROM Customers;



-- Descobrir quantas linhas há na tabela de clientes.
SELECT COUNT(*)
FROM Customers;



-- Selecionar todas as colunas de duas tabelas
SELECT * 
FROM Customers, Categories;



-- Selecionar todos os clientes da tabela 'Customers'
SELECT *
FROM Customers;



-- Selecionar os nomes dos clientes e dos funcionários.
SELECT Customers.CustomerName, EmployeeID 
FROM Customers, Orders



-- Selecionar na tabela Costumers a id, nome e pais de todos os clientes.
SELECT CustomerID, CustomerName, Country
FROM Customers;



-- Selecionar todos os dados dos clientes que estão em São Paulo.
SELECT * 
FROM Customers 
WHERE City = 'São Paulo';



-- Selecionar todos os clientes que estão sem São Paulo, mas seus nomes devem estar em ordem alfabética.
SELECT * 
FROM Customers 
WHERE City = 'São Paulo' 
ORDER BY CustomerName;



-- Selecionar id, nome e país dos clientes, o resultado deve ser ordenado ascendentemente por país e nome.
SELECT CustomerID, CustomerName, Country 
FROM Customers 
ORDER BY Country, CustomerName;



-- Selecionar id, nome e país dos clientes, o resultado deve ser ordenado descendentemente por país e ascendentemente  por nome.
SELECT CustomerID, CustomerName, Country 
FROM Customers 
ORDER BY Country DESC, CustomerName;



-- Informar quantos clientes da cidade de São Paulo existem no banco de dados.
SELECT COUNT(CustomerID) AS "Customers from São Paulo" 
FROM Customers
WHERE City = "São Paulo";
-- ou 
SELECT  City, COUNT(CustomerID) as 'Quantidade'
FROM Customers
WHERE City = 'São Paulo'
GROUP BY City



-- Informar quantos clientes de cada cidade existem no banco de dados.
SELECT City, COUNT(CustomerID) as 'Quantidade' 
FROM Customers 
GROUP BY City



-- Selecionar os nomes dos clientes cujo país começam com a letra 'A'.
SELECT CustomerName, Country
FROM Customers
WHERE Country LIKE 'A%';



-- Selecionar os clientes cujo país têm a segunda letra igual a 'a'.
SELECT CustomerName, Country
FROM Customers
WHERE Country LIKE '_A%';



-- Selecionar os produtos que contenham 'guaraná' no seu nome.
SELECT * 
FROM Products 
WHERE ProductName LIKE '%guaraná%';



-- Consultar todos os clientes de São Paulo que tenham contato com alguém chamado 'Pedro'
SELECT *
FROM Customers
WHERE city = 'São Paulo' AND ContactName LIKE '%Pedro%';



-- Decobrir quantos países distintos há na tabela Customers.
SELECT COUNT(DISTINCT Customers.Country) AS 'Unique countries'
FROM Customers;



-- Calcular a média de preços dos produtos.
SELECT AVG(Products.Price) AS 'Agerage prices'
FROM Products;



-- Obter o maior e o menor preço dos produtos.
SELECT MAX(Price) AS 'Max price', MIN(Price) AS 'Min price'
FROM Products



-- Consultar a quantidade de clientes de cada país. O resultado deverá ter o nome do país e a quantidade em ordem decrescente de quantidade, mas em orde crescente por nome do país.
SELECT Country, COUNT(CustomerID) AS 'Amount of clients'
FROM Customers 
GROUP BY Country
ORDER BY COUNT(CustomerID) DESC, Country;



-- Consultar o nome de todos os produtos e as quantidades em todas as compras registradas.
SELECT Products.ProductName, OrderDetails.Quantity  
FROM OrderDetails JOIN Products ON OrderDetails.ProductID = Products.ProductID;



-- Pesquisar a quantidade média de compras de cada produto.
SELECT Products.ProductName, AVG(OrderDetails.Quantity) AS 'Average sells' 
FROM OrderDetails JOIN Products ON OrderDetails.ProductID = Products.ProductID
GROUP BY Products.ProductName;
-- ou
SELECT ProductID, AVG(Quantity) as 'Quantity' 
FROM OrderDetails
GROUP BY ProductID;



-- Selecionar quais produtos têm uma média de compra acima de 40 unidades.
SELECT Products.ProductName, AVG(OrderDetails.Quantity) 
FROM OrderDetails JOIN Products ON OrderDetails.ProductID = Products.ProductID
GROUP BY Products.ProductName 
HAVING AVG(OrderDetails.Quantity) > 40;



-- Consultar todos os clientes que moram na Brasil, Canada e Dinamarca.
SELECT * 
FROM Customers 
WHERE Country IN ('Brazil', 'Canada', 'Denmark ');



-- Exibir o nome do cliente, do produto e a quantidade que cada cliente comprou.
SELECT Customers.CustomerName, Products.ProductName, OrderDetails.Quantity
FROM OrderDetails JOIN Orders    ON Orders.OrderID = OrderDetails.OrderID
                  JOIN Products  ON Products.ProductID = OrderDetails.ProductID
                  JOIN Customers ON Customers.CustomerID = Orders.CustomerID;



-- Consultar os nomes dos produtos e as quantidades compradas por um cliente cujo nome começa com 'Berglunds'.
SELECT Customers.CustomerName AS 'Name', Products.ProductName AS 'Product', OrderDetails.Quantity AS 'Quantity' 
FROM OrderDetails JOIN Products  ON OrderDetails.ProductID = Products.ProductID 
                  JOIN Orders    ON OrderDetails.OrderID   = Orders.OrderID 
                  JOIN Customers ON Orders.CustomerID      = Customers.CustomerID 
WHERE Customers.CustomerName LIKE 'Berglunds%';



-- Obter os nomes dos produtos fornecidos pela empresa 'Exotic Liquid' juntamente com o seu preço. A consulta não pode ser feita utilizando JOINS.
SELECT ProductName, Price
FROM Products 
WHERE SupplierID = (SELECT Suppliers.SupplierID 
                    FROM Suppliers 
                    WHERE SupplierName = 'Exotic Liquid');



-- Consultar o nome e a quantidade de todos os produtos que tenham a quantidade de vendas acima da média
SELECT Products.ProductName, SUM(OrderDetails.Quantity) 
FROM OrderDetails JOIN Products ON OrderDetails.ProductID = Products.ProductID
GROUP BY Products.ProductName
HAVING SUM(OrderDetails.Quantity) > (SELECT AVG(OrderDetails.Quantity) 
                                     FROM OrderDetails);



-- Consultar todos os produtos que possuem preços acima da média.
SELECT ProductName, Price  
FROM Products 
WHERE Price > (SELECT AVG(Price)  
               FROM Products)



-- Consultar os nomes de todos os funcionários que fizeram vendas entre as datas '1996-09-09' e '1996-12-27'.
WITH temp_tbl AS (SELECT * 
                  FROM Orders 
                  WHERE OrderDate BETWEEN '1996-09-09' AND '1996-12-27')
SELECT Employees.FirstName, temp_tbl.OrderDate
FROM Employees JOIN temp_tbl ON Employees.EmployeeID = temp_tbl.EmployeeID



-- Consultar as ids das vendas e os nomes dos funcionários que comecem com a letra 'A' .
SELECT Orders.OrderID, temp_table.FirstName
FROM Orders JOIN (SELECT EmployeeID, FirstName
                  FROM Employees 
                  WHERE FirstName LIKE 'A%') as temp_table ON Orders.EmployeeID = temp_table.EmployeeID



-- Obter os nomes dos produtos fornecidos pela empresa 'Exotic Liquid' juntamente com o seu preço. A consulta não pode ser feita utilizando JOINS.
WITH temp_table AS (SELECT SupplierID 
                    FROM Suppliers 
                    WHERE SupplierName = 'Exotic Liquid')

SELECT ProductName, Price  
FROM Products, temp_table 
WHERE Products.SupplierID = temp_table.SupplierID;



-- Consultar o nome e a quantidade de todos os produtos que tenham a quantidade de vendas acima da média.
WITH tmp_table AS (SELECT AVG(Quantity) AS 'Average'
FROM OrderDetails)

SELECT Products.ProductName, SUM(OrderDetails.Quantity) 
FROM OrderDetails JOIN Products ON OrderDetails.ProductID = Products.ProductID, tmp_table 
GROUP BY Products.ProductName
HAVING SUM(OrderDetails.Quantity) > tmp_table.Average



-- Consulte todos os fornecedores cujos nomes começam com 'S' e 'P'. Use UNION na consulta.
WITH tmp_s AS (SELECT * FROM Suppliers WHERE Suppliers.SupplierName LIKE 'S%'),
     tmp_p AS (SELECT * FROM Suppliers WHERE Suppliers.SupplierName LIKE 'P%')
SELECT * FROM tmp_s
UNION
SELECT * FROM tmp_p



-- O w3scools não permite o uso de window functions, então tive que usar outro.
-- As consultas abaixo foram feitas no website https://www.programiz.com/sql/online-compiler/
-- Não pude fazer consutas mais elaboradas pois o banco de dados é muito pequeno.



-- Atribuir a cada linha da tabela Shippings um número
SELECT *, 
       ROW_NUMBER() OVER() AS 'Linha'
FROM Shippings



-- Criar um ranking de idades dos clientes crescentemente usando OVER.
SELECT first_name, last_name, age, 
       DENSE_RANK() OVER(ORDER BY age) AS 'AGE_RANKING' 
FROM Customers



-- Criar uma coluna do tipo 'lag' com a idade do cliente registrado uma linha acima.
SELECT first_name, last_name, age, 
       LAG(age, 1, 0) OVER() AS 'previous_age'
FROM Customers;



-- Criar uma coluna do tipo 'lead' com a idade do cliente registrado uma linha abaixo.
SELECT first_name, last_name, age, 
       LEAD(age, 1, 0) OVER() AS 'next_age'
FROM Customers;
