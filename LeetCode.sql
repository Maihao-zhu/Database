/*
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
*/
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



























