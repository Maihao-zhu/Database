
# 579. Find Cumulative Salary of an Employee
USE test;
DROP TABLE Employee;
Create table If Not Exists Employee (
id int, 
month int, 
salary int,
Primary key (id));
Truncate table Employee;
insert into Employee (id, month, salary) values ('1', '1', '20');
insert into Employee (id, month, salary) values ('2', '1', '20');
insert into Employee (id, month, salary) values ('1', '2', '30');
insert into Employee (id, month, salary) values ('2', '2', '30');
insert into Employee (id, month, salary) values ('3', '2', '40');
insert into Employee (id, month, salary) values ('1', '3', '40');
insert into Employee (id, month, salary) values ('3', '3', '60');
insert into Employee (id, month, salary) values ('1', '4', '60');
insert into Employee (id, month, salary) values ('3', '4', '70');
insert into Employee (id, month, salary) values ('1', '7', '90');
insert into Employee (id, month, salary) values ('1', '8', '90');
DESC Employee
SELECT * 
FROM Employee


SELECT e1.id,e1.month,Coalesce(e1.salary,0)+Coalesce(e2.salary,0)+Coalesce(e3.salary,0) AS Total_amount
FROM 
(SELECT id,max(month) as max_month
from employee
group by id
having count(*)>1) exl
left join Employee e1 ON exl.id=e1.id and exl.max_month> e1.month
LEFT JOIN Employee e2 ON e1.id=e2.id and e1.month=e2.month+1
LEFT JOIN Employee e3 ON e2.id=e3.id and e2.month=e3.month+1
ORDER BY e1.id,e1.month asc


#601. Human Traffic of Stadium
Create table If Not Exists Stadium (id int NOT NULL,
 visit_date DATE NOT NULL,
 people int NOT NULL,
 PRIMARY KEY (id));
Truncate table Stadium;
insert into Stadium (id, visit_date, people) values ('1', '2017-01-01', '10');
insert into Stadium (id, visit_date, people) values ('2', '2017-01-02', '109');
insert into Stadium (id, visit_date, people) values ('3', '2017-01-03', '150');
insert into Stadium (id, visit_date, people) values ('4', '2017-01-04', '99');
insert into Stadium (id, visit_date, people) values ('5', '2017-01-05', '145');
insert into Stadium (id, visit_date, people) values ('6', '2017-01-06', '1455');
insert into Stadium (id, visit_date, people) values ('7', '2017-01-07', '199');
insert into Stadium (id, visit_date, people) values ('8', '2017-01-09', '188');

select *
from stadium 

SELECT DISTINCT S1.*
FROM Stadium s1 JOIN stadium s2 JOIN stadium s3
ON (S1.id = S2.id-1 AND S1.id= S3.id-2)
OR (S1.id = S2.id+1 AND S1.id= S3.id+2)
OR (S1.id = S2.id+1 AND S1.id= S3.id-1)
-- OR (S1.id = S2.id-1 AND S1.id= S3.id+1)
WHERE S1.people>=100 and S2.people>=100 and S3. people>=100
ORDER BY visit_date ASC

SELECT ID
        , visit_date
        , people
        , LEAD(people, 1) OVER (ORDER BY id) nxt
        , LEAD(people, 2) OVER (ORDER BY id) nxt2
        , LAG(people, 1) OVER (ORDER BY id) pre
        , LAG(people, 2) OVER (ORDER BY id) pre2
    FROM Stadium


#613. Shortest Distance in a Line
USE test;
Create Table If Not Exists Point (x int not null);
Truncate table Point;
insert into Point (x) values ('-1');
insert into Point (x) values ('0');
insert into Point (x) values ('2');

DESC Point

SELECT *
FROM Point;

#615. Average Salary: Departments VS Company
DROP table Salary;
DROP table Employee;
Create table If Not Exists Salary (id int, employee_id int, amount int, pay_date date);
Create table If Not Exists Employee (employee_id int, department_id int);
Truncate table Salary;
insert into Salary (id, employee_id, amount, pay_date) values ('1', '1', '9000', '2017/03/31');
insert into Salary (id, employee_id, amount, pay_date) values ('2', '2', '6000', '2017/03/31');
insert into Salary (id, employee_id, amount, pay_date) values ('3', '3', '10000', '2017/03/31');
insert into Salary (id, employee_id, amount, pay_date) values ('4', '1', '7000', '2017/02/28');
insert into Salary (id, employee_id, amount, pay_date) values ('5', '2', '6000', '2017/02/28');
insert into Salary (id, employee_id, amount, pay_date) values ('6', '3', '8000', '2017/02/28');
Truncate table Employee;
insert into Employee (employee_id, department_id) values ('1', '1');
insert into Employee (employee_id, department_id) values ('2', '2');
insert into Employee (employee_id, department_id) values ('3', '2');

select * from salary
select * from employee

-- pay_month|department_id|comparison level
#for each month, avg salary across all departments
WITH COMP AS(
SELECT avg(s.amount) as avg_comp_salary, month(s.pay_date) AS pay_month 
FROM salary s
JOIN employee e 
ON s.employee_id=e.employee_id
GROUP BY month(s.pay_date)),

#for each month, avg salary for each departments
DEP AS (
SELECT avg(s.amount) as avg_dep_salary,month(s.pay_date) as pay_month, e.department_id as dep_id
FROM salary s
JOIN employee e 
ON s.employee_id=e.employee_id
GROUP BY month(s.pay_date),dep)
#comparison

SELECT dep.pay_month,dep.dep_id as department_id,
CASE 
WHEN comp.avg_comp_salary=dep.avg_dep_salary THEN "same"
WHEN comp.avg_comp_salary>dep.avg_dep_salary THEN "lower"
WHEN comp.avg_comp_salary<dep.avg_dep_salary THEN "higher"
END AS comparison
FROM comp
RIGHT JOIN dep
ON comp.pay_month=dep.pay_month


618. Students Report By Geography
Create table If Not Exists Student (name varchar(50), continent varchar(7));
Truncate table Student;
insert into Student (name, continent) values ('Jane', 'America');
insert into Student (name, continent) values ('Pascal', 'Europe');
insert into Student (name, continent) values ('Xi', 'Asia');
insert into Student (name, continent) values ('Jack', 'America');

America|Asia|Europe

SELECT am.America, `as`.Asia,eu.Europe
FROM
(SELECT row_number()over(order by name) as as_id,name as Asia
FROM student 
WHERE continent="Asia") `as`
RIGHT JOIN 
(SELECT row_number()over(order by name) as am_id,name as America
FROM student 
WHERE continent="America") am
ON `as`.as_id=am.am_id
LEFT JOIN 
(SELECT row_number()over(order by name) as eu_id,name as Europe
FROM student 
WHERE continent="Europe") eu
ON eu.eu_id=am.am_id



1070. Product Sales Analysis III
Create table If Not Exists Sales (sale_id int, product_id int, year int, quantity int, price int);
Create table If Not Exists Product (product_id int, product_name varchar(10));
Truncate table Sales;
insert into Sales (sale_id, product_id, year, quantity, price) values ('1', '100', '2008', '10', '5000');
insert into Sales (sale_id, product_id, year, quantity, price) values ('2', '100', '2009', '12', '5000');
insert into Sales (sale_id, product_id, year, quantity, price) values ('7', '200', '2011', '15', '9000');
Truncate table Product;
insert into Product (product_id, product_name) values ('100', 'Nokia');
insert into Product (product_id, product_name) values ('200', 'Apple');
insert into Product (product_id, product_name) values ('300', 'Samsung');

SELECT distinct product_id, year as first_year, quantity, price
FROM(
SELECT product_id, quantity, price, year, rank()over(partition by product_id order by year asc) as year_rank
FROM Sales) as t
WHERE year_rank= 1

SELECT product_id, year AS first_year, quantity, price
FROM Sales
WHERE (product_id, year) IN (
SELECT product_id, MIN(year) as year
FROM Sales
GROUP BY product_id) ;

SELECT product_id, year AS first_year, quantity, price
FROM sales
WHERE (product_id, year) in (
SELECT product_id, MIN(year) as year
FROM Sales
GROUP BY product_id)

1082. Sales Analysis I
Create table If Not Exists Product (product_id int, product_name varchar(10), unit_price int)
Create table If Not Exists Sales (seller_id int, product_id int, buyer_id int, sale_date date, quantity int, price int)
Truncate table Product
insert into Product (product_id, product_name, unit_price) values ('1', 'S8', '1000')
insert into Product (product_id, product_name, unit_price) values ('2', 'G4', '800')
insert into Product (product_id, product_name, unit_price) values ('3', 'iPhone', '1400')
Truncate table Sales
insert into Sales (seller_id, product_id, buyer_id, sale_date, quantity, price) values ('1', '1', '1', '2019-01-21', '2', '2000')
insert into Sales (seller_id, product_id, buyer_id, sale_date, quantity, price) values ('1', '2', '2', '2019-02-17', '1', '800')
insert into Sales (seller_id, product_id, buyer_id, sale_date, quantity, price) values ('2', '2', '3', '2019-06-02', '1', '800')
insert into Sales (seller_id, product_id, buyer_id, sale_date, quantity, price) values ('3', '3', '4', '2019-05-13', '2', '2800')


SELECT seller_id
FROM (
SELECT seller_id, rank() over (order by sum(price) DESC) as sales_rank
FROM sales 
GROUP BY seller_id) t
WHERE sales_rank = 1

1083. Sales Analysis II
DROP TABLE Product;
DROP TABLE Sales;
Create table If Not Exists Product (product_id int, product_name varchar(10), unit_price int);
Create table If Not Exists Sales (seller_id int, product_id int, buyer_id int, sale_date date, quantity int, price int);
Truncate table Product;
insert into Product (product_id, product_name, unit_price) values ('1', 'S8', '1000');
insert into Product (product_id, product_name, unit_price) values ('2', 'G4', '800');
insert into Product (product_id, product_name, unit_price) values ('3', 'iPhone', '1400');
Truncate table Sales;
insert into Sales (seller_id, product_id, buyer_id, sale_date, quantity, price) values ('1', '1', '1', '2019-01-21', '2', '2000');
insert into Sales (seller_id, product_id, buyer_id, sale_date, quantity, price) values ('1', '2', '2', '2019-02-17', '1', '800');
insert into Sales (seller_id, product_id, buyer_id, sale_date, quantity, price) values ('2', '1', '3', '2019-06-02', '1', '800');
insert into Sales (seller_id, product_id, buyer_id, sale_date, quantity, price) values ('3', '3', '3', '2019-05-13', '2', '2800');

# users who have bought S8
SELECT t1.buyer_id FROM (
SELECT buyer_id
FROM sales sa
LEFT JOIN product pr
ON sa.product_id= pr.product_id
WHERE pr.product_name = 'S8') t1
WHERE t1.buyer_id not in (
# users who have bought ip
SELECT buyer_id
FROM sales sa
LEFT JOIN product pr
ON sa.product_id= pr.product_id
WHERE pr.product_name = 'iPhone')
# 1084. Sales Analysis III
SELECT distinct s.product_id,p.product_name
FROM sales s
JOIN product p
ON s.product_id=p.product_id
WHERE s.sale_date between '2019-01-01' and '2019-03-31' 
AND s.product_id not in(
#produts that sold not in  Q1 2019
SELECT s.product_id
FROM sales s
WHERE s.sale_date not between '2019-01-01' and '2019-03-31')

# 1112. Highest Grade For Each Student

-- grade|course|student
SELECT student_id,course_id,grade 
FROM (
SELECT *,
row_number()over(partition by student_id order by grade DESC,course_id ASC) as rank_grade
FROM enrollments 
) as t_rank
WHERE rank_grade=1

-- 1149. Article Views II
Create table If Not Exists Views 
(article_id int, 
author_id int, 
viewer_id int, 
view_date date);
Truncate table Views;
insert into Views (article_id, author_id, viewer_id, view_date) values ('1', '3', '5', '2019-08-01');
insert into Views (article_id, author_id, viewer_id, view_date) values ('3', '4', '5', '2019-08-01');
insert into Views (article_id, author_id, viewer_id, view_date) values ('1', '3', '6', '2019-08-02');
insert into Views (article_id, author_id, viewer_id, view_date) values ('2', '7', '7', '2019-08-01');
insert into Views (article_id, author_id, viewer_id, view_date) values ('2', '7', '6', '2019-08-02');
insert into Views (article_id, author_id, viewer_id, view_date) values ('4', '7', '1', '2019-07-22');
insert into Views (article_id, author_id, viewer_id, view_date) values ('3', '4', '4', '2019-07-21');
insert into Views (article_id, author_id, viewer_id, view_date) values ('3', '4', '4', '2019-07-21');

SELECT DISTINCT viewer_id AS id
FROM Views
GROUP BY viewer_id,view_date
HAVING count(DISTINCT article_id)>1
ORDER BY viewer_id ASC


SELECT DISTINCT v1.viewer_id AS id
FROM views v1
JOIN views v2
ON v1.viewer_id = v2.viewer_id
AND v1.view_date = v2.view_date
AND v1.article_id != v2.article_id
ORDER BY 1;

-- 1164. Product Price at a Given Date
Create table If Not Exists Products (product_id int, new_price int, change_date date);
Truncate table Products;
insert into Products (product_id, new_price, change_date) values ('1', '20', '2019-08-14');
insert into Products (product_id, new_price, change_date) values ('2', '50', '2019-08-14');
insert into Products (product_id, new_price, change_date) values ('1', '30', '2019-08-15');
insert into Products (product_id, new_price, change_date) values ('1', '35', '2019-08-16');
insert into Products (product_id, new_price, change_date) values ('2', '65', '2019-08-17');
insert into Products (product_id, new_price, change_date) values ('3', '20', '2019-08-18');


SELECT product_id, 10 as price 
FROM Products
group by product_id
having min(change_date) > "2019-08-16"

union all

SELECT distinct product_id,new_price as price 
FROM Products
where (product_id,change_date)in (
SELECT product_id, max(change_date)
    FROM products
    where change_date<="2019-08-16"
    group by product_id)

SELECT distinct a.product_id,coalesce(temp.new_price,10) as price 
FROM products as a
LEFT JOIN
(SELECT * 
FROM products 
WHERE (product_id, change_date) in (select product_id,max(change_date) from products where change_date<="2019-08-16" group by product_id)) as temp
on a.product_id = temp.product_id;

-- 1225. Report Contiguous Dates
Create table If Not Exists Failed (fail_date date);
Create table If Not Exists Succeeded (success_date date);
Truncate table Failed;
insert into Failed (fail_date) values ('2018-12-28');
insert into Failed (fail_date) values ('2018-12-29');
insert into Failed (fail_date) values ('2019-01-04');
insert into Failed (fail_date) values ('2019-01-05');
Truncate table Succeeded;
insert into Succeeded (success_date) values ('2018-12-30');
insert into Succeeded (success_date) values ('2018-12-31');
insert into Succeeded (success_date) values ('2019-01-01');
insert into Succeeded (success_date) values ('2019-01-02');
insert into Succeeded (success_date) values ('2019-01-03');
insert into Succeeded (success_date) values ('2019-01-06');

with data as(
SELECT date,period_state as ps,rank()over(order by date) as rk2,period_state,rank()over(order by date)-rk as intv
from(
SELECT fail_date as date,'failed' as period_state,RANK()OVER(order by fail_date) as rk
FROM Failed
 WHERE fail_date BETWEEN '2019-01-01' AND '2019-12-31'
UNION ALL 
SELECT success_date as date, 'success' as period_state,rank()over(order by success_date) as rk
FROM Succeeded
 WHERE success_date BETWEEN '2019-01-01' AND '2019-12-31'
) t
)
SELECT d.ps,min(date) as start_date,max(date) as end_date
FROM data d
group by d.ps,d.intv


SELECT stats AS period_state, MIN(day) AS start_date, MAX(day) AS end_date
FROM (
    SELECT 
        day, 
        RANK() OVER (ORDER BY day) AS overall_ranking, 
        stats, 
        rk, 
        (RANK() OVER (ORDER BY day) - rk) AS inv
    FROM (
        SELECT fail_date AS day, 'failed' AS stats, RANK() OVER (ORDER BY fail_date) AS rk
        FROM Failed
        WHERE fail_date BETWEEN '2019-01-01' AND '2019-12-31'
        UNION 
        SELECT success_date AS day, 'succeeded' AS stats, RANK() OVER (ORDER BY success_date) AS rk
        FROM Succeeded
        WHERE success_date BETWEEN '2019-01-01' AND '2019-12-31') t
    ) c
GROUP BY inv, stats
ORDER BY start_date

-- 1251. Average Selling Price
Drop table Prices;
Drop table UnitsSold;
Create table If Not Exists Prices (product_id int, start_date date, end_date date, price int);
Create table If Not Exists UnitsSold (product_id int, purchase_date date, units int);
Truncate table Prices;
insert into Prices (product_id, start_date, end_date, price) values ('1', '2019-02-17', '2019-02-28', '5');
insert into Prices (product_id, start_date, end_date, price) values ('1', '2019-03-01', '2019-03-22', '20');
insert into Prices (product_id, start_date, end_date, price) values ('2', '2019-02-01', '2019-02-20', '15');
insert into Prices (product_id, start_date, end_date, price) values ('2', '2019-02-21', '2019-03-31', '30');
Truncate table UnitsSold;
insert into UnitsSold (product_id, purchase_date, units) values ('1', '2019-02-25', '100');
insert into UnitsSold (product_id, purchase_date, units) values ('1', '2019-03-01', '15');
insert into UnitsSold (product_id, purchase_date, units) values ('2', '2019-02-10', '200');
insert into UnitsSold (product_id, purchase_date, units) values ('2', '2019-03-22', '30');

SELECT *
FROM Prices p
JOIN UnitsSold u
ON p.product_id=u.product_id
WHERE u.purchase_date Between p.start_date and p.end_date


-- 1270. All People Report to the Given Manager
Create table If Not Exists Employees (employee_id int, employee_name varchar(30), manager_id int);
Truncate table Employees;
insert into Employees (employee_id, employee_name, manager_id) values ('1', 'Boss', '1');
insert into Employees (employee_id, employee_name, manager_id) values ('3', 'Alice', '3');
insert into Employees (employee_id, employee_name, manager_id) values ('2', 'Bob', '1');
insert into Employees (employee_id, employee_name, manager_id) values ('4', 'Daniel', '2');
insert into Employees (employee_id, employee_name, manager_id) values ('7', 'Luis', '4');
insert into Employees (employee_id, employee_name, manager_id) values ('8', 'John', '3');
insert into Employees (employee_id, employee_name, manager_id) values ('9', 'Angela', '8');
insert into Employees (employee_id, employee_name, manager_id) values ('77', 'Robert', '1');

select *
from employees a
join employees b
join employees c
on a.manager_id=b.employee_id and b.manager_id=c.employee_id
where c.manager_id=1 and a.employee_id!=1

-- 1285. Find the Start and End Number of Continuous Ranges
select min(log_id) as start_id,max(log_id) as end_id
FROM
(SELECT log_id, row_number()over(order by log_id asc) as rk
FROM Logs)t
group by log_id-rk
-- 1303. Find the Team Size
SELECT e.employee_id,t.team_size
FROM employee e
Left JOIN (
select team_id,count(*) as team_size
FROM employee
group by team_id) t
ON e.team_id=t.team_id


-- 1350. Students With Invalid Departments
Create table If Not Exists Departments (id int, name varchar(30));
Create table If Not Exists Students (id int, name varchar(30), department_id int);
Truncate table Departments;
insert into Departments (id, name) values ('1', 'Electrical Engineering');
insert into Departments (id, name) values ('7', 'Computer Engineering');
insert into Departments (id, name) values ('13', 'Bussiness Administration');
Truncate table Students;
insert into Students (id, name, department_id) values ('23', 'Alice', '1');
insert into Students (id, name, department_id) values ('1', 'Bob', '7');
insert into Students (id, name, department_id) values ('5', 'Jennifer', '13');
insert into Students (id, name, department_id) values ('2', 'John', '14');
insert into Students (id, name, department_id) values ('4', 'Jasmine', '77');
insert into Students (id, name, department_id) values ('3', 'Steve', '74');
insert into Students (id, name, department_id) values ('6', 'Luis', '1');
insert into Students (id, name, department_id) values ('8', 'Jonathan', '7');
insert into Students (id, name, department_id) values ('7', 'Daiana', '33');
insert into Students (id, name, department_id) values ('11', 'Madelynn', '1');

SELECT s.id,s.name
FROM students s 
LEFT JOIN departments d 
ON s.department_id=d.id 
WHERE d.id is null


-- 1421. NPV Queries
SELECT q.id,q.year,ifnull(npv,0) as npv
FROM NPV n
Right JOIN queries q
ON n.id=q.id
and n.year=q.year


-- 1398. Customers Who Bought Products A and B but Not C
Create table If Not Exists Customers (customer_id int, customer_name varchar(30));
Create table If Not Exists Orders (order_id int, customer_id int, product_name varchar(30));
Truncate table Customers;
insert into Customers (customer_id, customer_name) values ('1', 'Daniel');
insert into Customers (customer_id, customer_name) values ('2', 'Diana');
insert into Customers (customer_id, customer_name) values ('3', 'Elizabeth');
insert into Customers (customer_id, customer_name) values ('4', 'Jhon');
Truncate table Orders;
insert into Orders (order_id, customer_id, product_name) values ('10', '1', 'A');
insert into Orders (order_id, customer_id, product_name) values ('20', '1', 'B');
insert into Orders (order_id, customer_id, product_name) values ('30', '1', 'D');
insert into Orders (order_id, customer_id, product_name) values ('40', '1', 'C');
insert into Orders (order_id, customer_id, product_name) values ('50', '2', 'A');
insert into Orders (order_id, customer_id, product_name) values ('60', '3', 'A');
insert into Orders (order_id, customer_id, product_name) values ('70', '3', 'B');
insert into Orders (order_id, customer_id, product_name) values ('80', '3', 'D');
insert into Orders (order_id, customer_id, product_name) values ('90', '4', 'C');
SELECT t.customer_id,t.customer_name
FROM (
select c.customer_id,c.customer_name,sum(o.product_name="A") as a,sum(o.product_name="B") as b,sum(o.product_name="C") as c
from  Customers c 
join Orders o 
on c.customer_id=o.customer_id
group by c.customer_id,c.customer_name
having (a>0 and b>0 and C=0)
)t

-- 1445. Apples & Oranges
DROP Table sales;
Create table If Not Exists Sales (sale_date date, fruit ENUM('apples', 'oranges'), sold_num int);
Truncate table Sales;
insert into Sales (sale_date, fruit, sold_num) values ('2020-05-01', 'apples', '10');
insert into Sales (sale_date, fruit, sold_num) values ('2020-05-01', 'oranges', '8');
insert into Sales (sale_date, fruit, sold_num) values ('2020-05-02', 'apples', '15');
insert into Sales (sale_date, fruit, sold_num) values ('2020-05-02', 'oranges', '15');
insert into Sales (sale_date, fruit, sold_num) values ('2020-05-03', 'apples', '20');
insert into Sales (sale_date, fruit, sold_num) values ('2020-05-03', 'oranges', '0');
insert into Sales (sale_date, fruit, sold_num) values ('2020-05-04', 'apples', '15');
insert into Sales (sale_date, fruit, sold_num) values ('2020-05-04', 'oranges', '16');
Select *
FROM sales


-- 1479. Sales by Day of the Week
Drop table Orders;
Drop table Items;
Create table If Not Exists Orders (order_id int, customer_id int, order_date date, item_id varchar(30), quantity int);
Create table If Not Exists Items (item_id varchar(30), item_name varchar(30), item_category varchar(30));
Truncate table Orders;
insert into Orders (order_id, customer_id, order_date, item_id, quantity) values ('1', '1', '2020-06-01', '1', '10');
insert into Orders (order_id, customer_id, order_date, item_id, quantity) values ('2', '1', '2020-06-08', '2', '10');
insert into Orders (order_id, customer_id, order_date, item_id, quantity) values ('3', '2', '2020-06-02', '1', '5');
insert into Orders (order_id, customer_id, order_date, item_id, quantity) values ('4', '3', '2020-06-03', '3', '5');
insert into Orders (order_id, customer_id, order_date, item_id, quantity) values ('5', '4', '2020-06-04', '4', '1');
insert into Orders (order_id, customer_id, order_date, item_id, quantity) values ('6', '4', '2020-06-05', '5', '5');
insert into Orders (order_id, customer_id, order_date, item_id, quantity) values ('7', '5', '2020-06-05', '1', '10');
insert into Orders (order_id, customer_id, order_date, item_id, quantity) values ('8', '5', '2020-06-14', '4', '5');
insert into Orders (order_id, customer_id, order_date, item_id, quantity) values ('9', '5', '2020-06-21', '3', '5');
Truncate table Items;
insert into Items (item_id, item_name, item_category) values ('1', 'LC Alg. Book', 'Book');
insert into Items (item_id, item_name, item_category) values ('2', 'LC DB. Book', 'Book');
insert into Items (item_id, item_name, item_category) values ('3', 'LC SmarthPhone', 'Phone');
insert into Items (item_id, item_name, item_category) values ('4', 'LC Phone 2020', 'Phone');
insert into Items (item_id, item_name, item_category) values ('5', 'LC SmartGlass', 'Glasses');
insert into Items (item_id, item_name, item_category) values ('6', 'LC T-Shirt XL', 'T-shirt');
with t1 as (
SELECT item_category,order_date,quantity,dayofweek(order_date) as wk
FROM orders o
right JOIN items i
ON o.item_id=i.item_id)

select t1.item_category as category, 
sum(case 
when t1.wk=2 
THEN t1.quantity
else 0
end ) as 'Monday',
sum(
case 
when t1.wk=3 THEN t1.quantity
else 0
end) as 'Tuesday',
sum(
case
when t1.wk=4 THEN t1.quantity
else 0
end )
as 'Wednesday',
sum(
case
when t1.wk=5 THEN t1.quantity
else 0 
end) as 'Thursday',
sum(
case 
when t1.wk=6 THEN t1.quantity
else 0
end) as 'Friday',
sum(
case
when t1.wk=7 THEN t1.quantity
else 0
end 
)as 'Saturday',
sum(
case
when t1.wk=1 THEN t1.quantity
else 0
end) as 'Sunday'
from t1
group by t1.item_category

-- 1596. The Most Frequently Ordered Products for Each Customer
use test;
DROP table Customers;
DROP table Orders;
DROP table Products;
Create table If Not Exists Customers (customer_id int, name varchar(10));
Create table If Not Exists Orders (order_id int, order_date date, customer_id int, product_id int);
Create table If Not Exists Products (product_id int, product_name varchar(20), price int);
Truncate table Customers;
insert into Customers (customer_id, name) values ('1', 'Alice');
insert into Customers (customer_id, name) values ('2', 'Bob');
insert into Customers (customer_id, name) values ('3', 'Tom');
insert into Customers (customer_id, name) values ('4', 'Jerry');
insert into Customers (customer_id, name) values ('5', 'John');
Truncate table Orders;
insert into Orders (order_id, order_date, customer_id, product_id) values ('1', '2020-07-31', '1', '1');
insert into Orders (order_id, order_date, customer_id, product_id) values ('2', '2020-7-30', '2', '2');
insert into Orders (order_id, order_date, customer_id, product_id) values ('3', '2020-08-29', '3', '3');
insert into Orders (order_id, order_date, customer_id, product_id) values ('4', '2020-07-29', '4', '1');
insert into Orders (order_id, order_date, customer_id, product_id) values ('5', '2020-06-10', '1', '2');
insert into Orders (order_id, order_date, customer_id, product_id) values ('6', '2020-08-01', '2', '1');
insert into Orders (order_id, order_date, customer_id, product_id) values ('7', '2020-08-01', '3', '3');
insert into Orders (order_id, order_date, customer_id, product_id) values ('8', '2020-08-03', '1', '2');
insert into Orders (order_id, order_date, customer_id, product_id) values ('9', '2020-08-07', '2', '3');
insert into Orders (order_id, order_date, customer_id, product_id) values ('10', '2020-07-15', '1', '2');
Truncate table Products;
insert into Products (product_id, product_name, price) values ('1', 'keyboard', '120');
insert into Products (product_id, product_name, price) values ('2', 'mouse', '80');
insert into Products (product_id, product_name, price) values ('3', 'screen', '600');
insert into Products (product_id, product_name, price) values ('4', 'hard disk', '450');


select c.customer_id,p.product_id,p.product_name,rank() over (partition by customer_id order by count(p.product_id) desc) as counts
from customers c
join orders o on c.customer_id=o.customer_id
join products p on o.product_id=p.product_id
group by c.customer_id,p.product_id,p.product_name

-- 1613. Find the Missing IDs
DROP table Customers;
Create table If Not Exists Customers (customer_id int, customer_name varchar(20));
Truncate table Customers;
insert into Customers (customer_id, customer_name) values ('1', 'Alice');
insert into Customers (customer_id, customer_name) values ('4', 'Bob');
insert into Customers (customer_id, customer_name) values ('5', 'Charlie');

WITH RECURSIVE nums AS (
    SELECT 1 AS value
    UNION ALL
    SELECT value + 1 AS value
    FROM nums
    WHERE nums.value < (select max(customer_id) from Customers)
)
select value as ids from nums
with recursive cte1 as(
select 1 as num
union all 
select num+1 as value 
from cte1
where cte1.num<10)
select * from cte1

-- 1623. All Valid Triplets That Can Represent a Country
Create table If Not Exists SchoolA (student_id int, student_name varchar(20));
Create table If Not Exists SchoolB (student_id int, student_name varchar(20));
Create table If Not Exists SchoolC (student_id int, student_name varchar(20));
Truncate table SchoolA;
insert into SchoolA (student_id, student_name) values ('1', 'Alice');
insert into SchoolA (student_id, student_name) values ('2', 'Bob');
Truncate table SchoolB;
insert into SchoolB (student_id, student_name) values ('3', 'Tom');
Truncate table SchoolC;
insert into SchoolC (student_id, student_name) values ('3', 'Tom');
insert into SchoolC (student_id, student_name) values ('2', 'Jerry');
insert into SchoolC (student_id, student_name) values ('10', 'Alice');

select a.student_name as member_A,b.student_name as member_B,c.student_name as member_C
from SchoolA a
join SchoolB b
join SchoolC c
on (a.student_id != b.student_id and a.student_id != c.student_id and b.student_id != c.student_id
and a.student_name != b.student_name and a.student_name != c.student_name and b.student_name != c.student_name)


-- 1777. Product's Price for Each Store
DROP table products;

Create table If Not Exists Products (product_id int, store ENUM('store1', 'store2', 'store3'), price int);
Truncate table Products;
insert into Products (product_id, store, price) values ('0', 'store1', '95');
insert into Products (product_id, store, price) values ('0', 'store3', '105');
insert into Products (product_id, store, price) values ('0', 'store2', '100');
insert into Products (product_id, store, price) values ('1', 'store1', '70');
insert into Products (product_id, store, price) values ('1', 'store3', '80');

select product_id,
sum(case when store='store1' then price

end) as 'store1',
sum(case when store='store2' then price

end) as 'store2',
sum(case when store='store3' then price

end) as 'store3'
from Products
group by product_id

-- 1972. First and Last Call On the Same Day
Create table If Not Exists Calls (caller_id int, recipient_id int, call_time datetime);
Truncate table Calls;
insert into Calls (caller_id, recipient_id, call_time) values ('8', '4', '2021-08-24 17:46:07');
insert into Calls (caller_id, recipient_id, call_time) values ('4', '8', '2021-08-24 19:57:13');
insert into Calls (caller_id, recipient_id, call_time) values ('5', '1', '2021-08-11 05:28:44');
insert into Calls (caller_id, recipient_id, call_time) values ('8', '3', '2021-08-17 04:04:15');
insert into Calls (caller_id, recipient_id, call_time) values ('11', '3', '2021-08-17 13:07:00');
insert into Calls (caller_id, recipient_id, call_time) values ('8', '11', '2021-08-17 22:22:22');

WITH CTE AS (
                SELECT caller_id AS user_id, call_time, recipient_id FROM Calls
                UNION 
                SELECT recipient_id AS user_id, call_time, caller_id AS recipient_id FROM Calls
            ),
CTE1 AS (
        SELECT 
        user_id,
        recipient_id,
        DATE(call_time) AS DAY,
        DENSE_RANK() OVER(PARTITION BY user_id, DATE(call_time) ORDER BY call_time ASC) AS RN,
        DENSE_RANK() OVER(PARTITION BY user_id, DATE(call_time) ORDER BY call_time DESC) AS RK
        FROM CTE
        )
        
SELECT user_id,DAY
FROM CTE1
WHERE RN = 1 OR RK = 1
GROUP BY user_id, DAY
HAVING COUNT(DISTINCT recipient_id) = 1

-- 2329. Product Sales Analysis V
select s.user_id,sum(s.quantity*p.price) as spending
from Sales s
join Product p 
on s.product_id=p.product_id
group by s.user_id 

-- 2394. Employees With Deductions

select t.employee_id
from(
select e.employee_id,e.needed_hours,
(SUM(CEIL(IFNULL(TIMESTAMPDIFF(SECOND, L.in_time, L.out_time),0) / 60)) / 60) as time

from Logs l 
right join Employees e
on l.employee_id=e.employee_id
group by l.employee_id
having time<e.needed_hours) t

order by t.employee_id

-- 2292. Products With Three or More Orders in Two Consecutive Years
drop TABLE ORDERS;
Create table If Not Exists Orders (order_id int, product_id int, quantity int, purchase_date date);
Truncate table Orders;
insert into Orders (order_id, product_id, quantity, purchase_date) values ('1', '1', '7', '2020-03-16');
insert into Orders (order_id, product_id, quantity, purchase_date) values ('2', '1', '4', '2020-12-02');
insert into Orders (order_id, product_id, quantity, purchase_date) values ('3', '1', '7', '2020-05-10');
insert into Orders (order_id, product_id, quantity, purchase_date) values ('4', '1', '6', '2021-12-23');
insert into Orders (order_id, product_id, quantity, purchase_date) values ('5', '1', '5', '2021-05-21');
insert into Orders (order_id, product_id, quantity, purchase_date) values ('6', '1', '6', '2021-10-11');
insert into Orders (order_id, product_id, quantity, purchase_date) values ('7', '2', '6', '2022-10-11');

SELECT *
FROM Orders O1
JOIN Orders O2
ON O1.product_id=O2.product_id and 
YEAR(O1.purchase_date)=YEAR(O2.purchase_date)+1 



SELECT O1.product_id,year(O1.purchase_date) AS Year1
FROM Orders O1 JOIN Orders O2
ON (O1.product_id=O2.product_id and YEAR(O1.purchase_date)=YEAR(O2.purchase_date)+1 )
GROUP BY O1.product_id, Year1
HAVING COUNT(O1.order_id)>=3

-- 2238. Number of Times a Driver Was a Passenger

Create table If Not Exists Rides (ride_id int, driver_id int, passenger_id int);
Truncate table Rides;
insert into Rides (ride_id, driver_id, passenger_id) values ('1', '7', '1');
insert into Rides (ride_id, driver_id, passenger_id) values ('2', '7', '2');
insert into Rides (ride_id, driver_id, passenger_id) values ('3', '11', '1');
insert into Rides (ride_id, driver_id, passenger_id) values ('4', '11', '7');
insert into Rides (ride_id, driver_id, passenger_id) values ('5', '11', '7');
insert into Rides (ride_id, driver_id, passenger_id) values ('6', '11', '3');

 
select r.driver_id,count(t.passenger_id)
from 
(select distinct driver_id
from Rides) r

left join Rides t

on r.driver_id=t.passenger_id

group by r.driver_id

-- 2228. Users With Two Purchases Within Seven Days
Create table If Not Exists Purchases (purchase_id int, user_id int, purchase_date date);
Truncate table Purchases;
insert into Purchases (purchase_id, user_id, purchase_date) values ('4', '2', '2022-03-13');
insert into Purchases (purchase_id, user_id, purchase_date) values ('1', '5', '2022-02-11');
insert into Purchases (purchase_id, user_id, purchase_date) values ('3', '7', '2022-06-19');
insert into Purchases (purchase_id, user_id, purchase_date) values ('6', '2', '2022-03-20');
insert into Purchases (purchase_id, user_id, purchase_date) values ('5', '7', '2022-06-19');
insert into Purchases (purchase_id, user_id, purchase_date) values ('2', '2', '2022-06-08');

SELECT P1.user_id
FROM Purchases P1
JOIN Purchases P2
ON P1.user_id=P2.user_id AND 
P1.purchase_date BETWEEN p2.purchase_date AND p2.purchase_date+7
AND p1.purchase_id!=p2.purchase_id
GROUP BY P1.user_id 
ORDER BY P1.user_id 

-- 2173. Longest Winning Streak
Create table If Not Exists Matches (player_id int, match_day date, result ENUM('Win', 'Draw', 'Lose'));
Truncate table Matches;
insert into Matches (player_id, match_day, result) values ('1', '2022-01-17', 'Win');
insert into Matches (player_id, match_day, result) values ('1', '2022-01-18', 'Win');
insert into Matches (player_id, match_day, result) values ('1', '2022-01-25', 'Win');
insert into Matches (player_id, match_day, result) values ('1', '2022-01-31', 'Draw');
insert into Matches (player_id, match_day, result) values ('1', '2022-02-08', 'Win');
insert into Matches (player_id, match_day, result) values ('2', '2022-02-06', 'Lose');
insert into Matches (player_id, match_day, result) values ('2', '2022-02-08', 'Lose');
insert into Matches (player_id, match_day, result) values ('3', '2022-03-30', 'Win');

SELECT player_id, IFNULL(MAX(cnt), 0) AS longest_streak
FROM Matches m
LEFT JOIN (
	SELECT player_id, p_rnk - rnk AS diff, COUNT(p_rnk - rnk) AS cnt
	FROM (
		SELECT *, 	
			CAST(RANK () OVER (PARTITION BY player_id, result ORDER BY match_day) AS SIGNED) AS rnk,
			CAST(RANK () OVER (PARTITION BY player_id ORDER BY match_day) AS SIGNED) AS p_rnk
		FROM Matches
	) t
	WHERE result = 'Win'
	GROUP BY player_id, diff
) t2
	USING (player_id)
GROUP BY player_id










