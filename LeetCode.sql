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
*/


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


































