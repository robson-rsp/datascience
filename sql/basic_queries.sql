-- Obter os nomes de todas as colunas de uma tabela.
SELECT *
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'customers';
-- ou 
SELECT * 
FROM customers 
LIMIT 1;



-- Selecionar as informações principais de todos os clientes.
SELECT * 
FROM customers;



-- Consultar o nome, cidade, estado e país de origem dos clientes.
SELECT customerName, city, state, country 
FROM customers;



-- Selecionar os cinco primeiros nomes dos clientes.
SELECT customerName 
FROM customers 
LIMIT 5;



-- Consultar o primeiro nome de todos os clientes e funcionários.
SELECT customers.customerName,  employees.firstName 
FROM customers, employees;



-- Decobrir quantos países distintos há na tabela customers.
SELECT DISTINCT country AS 'Unique countries'
FROM customers;



------------------------------ FILTROS EXATOS ------------------------------
-- Selecionar todos os dados dos clientes que moram em Londres.
SELECT customerName  
FROM customers 
WHERE city = "London";



-- Selecionar os nomes de todos os clientes de NYC. Seus nomes devem estar em ordem alfabética.
SELECT customerName  
FROM customers 
WHERE city = 'NYC'
ORDER BY customerName ASC;



-- Selecionar id, nome e país dos clientes. O resultado deve ser ordenado ascendentemente por país e descendentemente por nome.
SELECT customerNumber, customerName, country 
FROM customers 
ORDER BY country ASC, customerName DESC;



------------------------------ FILTROS APROXIMADOS ------------------------------
-- Selecionar os nomes dos clientes cujas cidades começam com a letra 'A'.
SELECT customerName, city 
FROM customers 
WHERE city LIKE 'A%';



-- Selecionar os clientes cujo país têm a segunda letra igual a 'a'.
SELECT customerName, country 
FROM customers 
WHERE country LIKE '_a%';



-- Selecionar os carros que contenham 'Ford' no seu nome.
SELECT productName 
FROM products 
WHERE productName LIKE '%ford%';



-- Consultar todos os clientes dos Estados Unidos que moram em estados cujos nomes começam com 'N'.
SELECT customerName, state, country 
FROM customers 
WHERE (country = 'USA') AND (state LIKE 'N%');



------------------------------ LISTAS ------------------------------
-- Consultar qual é o segundo preço mais alto dos automóveis.
SELECT MAX(buyPrice) AS '2th_expensive'
FROM products 
WHERE buyPrice NOT IN (SELECT MAX(buyPrice) 
                       FROM products);
-- Caso queria saber o nome do automóvel também veja a seção 'WINDOW FUNCTIONS'.



-- Consultar todos os clientes que moram na França, Russia e USA.
SELECT customerName, country 
FROM customers 
WHERE country IN ("France", "Russia", "USA") 
ORDER BY country;



-- Consultar todos os clientes que não moram na França, Russia e USA.
SELECT customerName, country 
FROM customers 
WHERE country NOT IN ("France", "Russia", "USA") 
ORDER BY country;



-- Selecione todos os automóveis com preços entre 20 e 25.
SELECT productName, buyPrice 
FROM products 
WHERE buyPrice BETWEEN 20 AND 25 
ORDER BY buyPrice;



-- Selecionar todos os veículos com preços menores que 20 e maiores que 25.
SELECT productName, buyPrice 
FROM products 
WHERE buyPrice NOT BETWEEN 20 AND 25 
ORDER BY buyPrice;



-- Selecione todos os carros com preços entre 10 e 30. Além disso, exclua aqueles cujo estoque seja menor que 3000.
SELECT productName, quantityInStock  
FROM products 
WHERE (buyPrice BETWEEN 10 AND 30) AND (quantityInStock > 3000) 
ORDER BY quantityInStock;



-- Selecionar todos os carros com nomes entre '1930 Buick Marquette Phaeton' e '1982 Lamborghini Diablo'.
SELECT productName 
FROM products
WHERE productName BETWEEN '1930 Buick Marquette Phaeton' AND '1982 Lamborghini Diablo';



-- Selecionar todos os veículos comprados entre  '2003-12-22' e '2004-12-04'.
SELECT * 
FROM payments 
WHERE paymentDate BETWEEN "2003-12-22" AND "2004-12-04"
ORDER BY paymentDate;



------------------------------ FUNÇÕES DE AGREGAÇÃO ------------------------------
-- Descobrir quantos clientes estão registrados.
SELECT COUNT(*) AS total_lines
FROM customers;



-- Informar quantos clientes de NYC existem no banco de dados.
SELECT COUNT(customerNumber) AS 'NYC customers' 
FROM customers 
WHERE city = "NYC";
-- Caso queira mostrar o nome da cidade também veja o exercício ## da seção "AGRUPAMENTO COM GROUP BY".



-- Calcular a média de preços dos automóveis.
SELECT AVG(buyPrice) AS 'average price' 
FROM products;



-- Obter o menor e maior preço dos automóveis.
SELECT MIN(buyPrice) AS 'lowest price', MAX(buyPrice) AS 'highest price' 
FROM products;



------------------------------ AGRUPAMENTO COM GROUP BY ------------------------------
-- Informar quantos clientes de NYC existem no banco de dados. O resulado deve mostrar o nome da cidade também.
SELECT city, COUNT(customerNumber) AS 'n_customers' 
FROM customers 
WHERE city = "NYC" 
GROUP BY city;



-- Informar quantos clientes de cada cidade existem no banco de dados.
SELECT city, COUNT(customerNumber) AS 'n_customers' 
FROM customers 
GROUP BY city;



-- Consultar a quantidade de clientes de cada país. 
-- Os nomes dos países devem estar em ordem crescente as quantidades em ordem decrescente.
SELECT country, COUNT(customerName) AS 'n_clients' 
FROM customers 
GROUP BY country 
ORDER BY country, COUNT(customerName) DESC;



-- Pesquisar a quantidade média de compras de cada veículo.
SELECT productName, AVG(buyPrice) AS 'average_price' 
FROM products 
GROUP BY productName;



------------------------------ SUB QUERIES ------------------------------
-- Consultar qual é o automóvel mais barato.
SELECT productName, buyPrice 
FROM products 
WHERE buyPrice = (SELECT MIN(buyPrice) AS min_price 
                  FROM products);



-- Consultar qual é o automóvel mais caro.
SELECT productName, buyPrice 
FROM products 
WHERE buyPrice = (SELECT MAX(buyPrice) AS max_price 
                  FROM products);



-- Descobrir qual a cidade com o maior número de clientes.
WITH tbl_ncustomers AS (SELECT city, COUNT(customerNumber) AS 'n_customers' 
                        FROM customers 
                        GROUP BY city) 
SELECT city, n_customers 
FROM tbl_ncustomers 
ORDER BY n_customers DESC 
LIMIT 1;



-- Selecione todos os clientes cujas cidades onde moram possuem um escritório da empresa.
SELECT customerName, city 
FROM customers  
WHERE customers.city IN (SELECT DISTINCT city
                            FROM offices);
-- Versão alternativa com a tabela temporária na cláusula FROM.
SELECT customerName, customers.city 
FROM customers, 
     (SELECT DISTINCT city
      FROM offices) AS tbl_cities 
WHERE customers.city IN (tbl_cities.city);

-- Versão alternativa com a tabela temporária na cláusula WITH.
WITH tbl_cities AS (SELECT DISTINCT city
                    FROM offices)
SELECT customers.customerName, customers.city 
FROM customers, tbl_cities 
WHERE customers.city IN (tbl_cities.city);



-- Consultar todos os veículos que possuem preços acima da média.
WITH tbl_avg_price AS (SELECT AVG(buyPrice) AS 'avg_price' 
                       FROM products)
SELECT products.productName, 
       products.buyPrice, 
       tbl_avg_price.avg_price 
FROM products, tbl_avg_price 
WHERE products.buyPrice > tbl_avg_price.avg_price 
ORDER BY products.productName;



-- Consulte todos os funcionários cujos nomes começam com 'A e 'J'. Use UNION na consulta.
WITH tbl_names_a AS (SELECT * FROM employees WHERE firstName LIKE "A%"),
     tbl_names_p AS (SELECT * FROM employees WHERE firstName LIKE "P%")
SELECT * FROM tbl_names_a
UNION
SELECT * FROM tbl_names_p;



------------------------------ JOINS ------------------------------
-- Consultar o nome de todos os automóveis e as quantidades médias de cada pedido.
SELECT products.productName, AVG(orderdetails.quantityOrdered) AS 'average_quantity' 
FROM products INNER JOIN orderdetails ON products.productCode = orderdetails.productCode 
GROUP BY products.productName;



-- Selecionar quais automóveis têm uma média de compra acima da média total.
SELECT products.productName, 
       AVG(orderdetails.quantityOrdered) 
FROM products INNER JOIN orderdetails ON products.productCode = orderdetails.productCode 
GROUP BY products.productName 
HAVING AVG(orderdetails.quantityOrdered) > (SELECT AVG(quantityOrdered)  
                                            FROM orderdetails);
-- Obs. Por algum motivo o MySQL não reconhece tabelas temporárias criadas com WITH em cláusulas HAVING.



-- Exibir o nome dos clientes, dos veículos comprados e a quantidade que cada cliente comprou.
SELECT customers.customerName, 
       products.productName, 
       orderdetails.quantityOrdered 
FROM customers INNER JOIN orders ON customers.customerNumber = orders.customerNumber 
               INNER JOIN orderdetails ON orders.orderNumber = orderdetails.orderNumber 
               INNER JOIN products ON orderdetails.productCode = products.productCode;



-- Consultar os nomes dos automóveis e as quantidades compradas por um cliente cujo nome começa com 'West Coast'.
SELECT customers.customerName, 
       products.productName, 
       orderdetails.quantityOrdered 
FROM customers INNER JOIN orders ON customers.customerNumber = orders.customerNumber 
               INNER JOIN orderdetails ON orders.orderNumber = orderdetails.orderNumber 
               INNER JOIN products ON orderdetails.productCode = products.productCode 
WHERE customers.customerName LIKE "West Coast%";



-- Consultar os nomes de todos os funcionários que fizeram vendas entre '2003-12-22' e '2004-12-04'.
SELECT employees.firstName, 
       employees.lastName, 
       orders.orderDate 
FROM employees JOIN customers ON employees.employeeNumber = customers.salesRepEmployeeNumber
               JOIN orders ON customers.customerNumber = orders.customerNumber
WHERE orders.orderDate BETWEEN '2003-12-22' AND '2004-12-04';



-- Consultar as ids das vendas e os nomes dos funcionários que começam com a letra 'A' .
SELECT employees.firstName, 
       employees.lastName, 
       orders.orderNumber 
FROM employees INNER JOIN customers ON employees.employeeNumber = customers.salesRepEmployeeNumber 
               INNER JOIN orders ON customers.customerNumber = orders.customerNumber 
WHERE employees.firstName LIKE "A%";



------------------------------ WINDOW FUNCTIONS ------------------------------
-- Atribuir a cada linha da tabela 'employees' um número.
SELECT *, 
       ROW_NUMBER() OVER() AS 'line'
FROM employees;



-- Criar um ranking decrescente dos clientes que mais gastaram.
SELECT customers.customerName, 
       payments.amount, 
       DENSE_RANK() OVER(ORDER BY payments.amount DESC) AS 'amount_ranking'
FROM customers INNER JOIN payments ON customers.customerNumber = payments.customerNumber;



-- Criar uma coluna do tipo 'lag' com o número da ordem do dia anterior.
SELECT orderNumber, 
       orderDate, 
       LAG(orderDate, 1) OVER() AS 'previous_date_order'
FROM orders 
ORDER BY orderDate;
-- Obs. Não há necessidade de se ordenar as datas.



-- Consultar o nome e o preço do automóvel que tem o segundo preço mais elevado.
WITH tbl_ranking_price AS (SELECT productName, buyPrice, ROW_NUMBER() OVER() AS 'ranking_price' 
                           FROM products 
                           ORDER BY buyPrice DESC)
SELECT productName, buyPrice 
FROM tbl_ranking_price 
WHERE ranking_price = 2;
