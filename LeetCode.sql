# 579. Find Cumulative Salary of an Employee
USE test;
Create table If Not Exists Employee (id int, month int, salary int);
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



