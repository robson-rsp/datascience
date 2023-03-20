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
SELECT DISTINCT country AS "Unique countries"
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



------------------------------ FUNÇÕES DE AGREGAÇÃO ------------------------------
-- Descobrir quantos clientes estão registrados.
SELECT COUNT(*) AS total_lines
FROM customers;



-- Informar quantos clientes de NYC existem no banco de dados.
SELECT COUNT(customerNumber) AS "NYC customers"
FROM customers 
WHERE city = "NYC";
-- Caso queira mostrar o nome da cidade também veja o exercício ## da seção "AGRUPAMENTO COM GROUP BY".



-- Calcular a média de preços dos automóveis.
SELECT AVG(buyPrice) AS "average price"
FROM products;



-- Obter o menor e maior preço dos automóveis.
SELECT MIN(buyPrice) AS "lowest price", MAX(buyPrice) AS "highest price" 
FROM products;



------------------------------ AGRUPAMENTO COM GROUP BY ------------------------------
-- Informar quantos clientes de NYC existem no banco de dados. O resulado deve mostrar o nome da cidade também.
SELECT city, COUNT(customerNumber) AS "n_customers" 
FROM customers 
WHERE city = "NYC" 
GROUP BY city;



-- Informar quantos clientes de cada cidade existem no banco de dados.
SELECT city, COUNT(customerNumber) AS "n_customers" 
FROM customers 
GROUP BY city;



-- Consultar a quantidade de clientes de cada país. Os nomes dos países devem estar em ordem crescente as quantidades em ordem decrescente.
SELECT country, COUNT(customerName) AS 'n_clients'
FROM customers 
GROUP BY country 
ORDER BY country, COUNT(customerName) DESC;



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



------------------------------ WINDOW FUNCTIONS ------------------------------
Consultar o nome do automóvel que tem o segundo preço mais elevado bem com o seu preço.
WITH tbl_ranking_price AS (SELECT productName, buyPrice, ROW_NUMBER() OVER() AS "ranking_price" 
                           FROM products 
                           ORDER BY buyPrice DESC)
SELECT productName, buyPrice 
FROM tbl_ranking_price 
WHERE ranking_price = 2;
