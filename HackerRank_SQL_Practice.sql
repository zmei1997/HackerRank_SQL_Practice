/**
Advanced Select - Type of Triangle
**/
-- Solution:
-- SQL Server
select  case 
            when A + B > C AND A + C > B AND B + C > A THEN
                CASE when A = B and B = C THEN 'Equilateral'
                     when A = B or A = C or B = C then 'Isosceles'
                else 'Scalene'
                end
        else 'Not A Triangle'
        end
from TRIANGLES;

/**
Advanced Select - The PADS
**/
-- Solution:
-- SQL Server
select  name + '(' + left(occupation, 1) + ')'
from    OCCUPATIONS
order by    name asc;

select  'There are a total of ' + cast(count(occupation) as varchar(10)) + ' ' + lower(occupation) + 's.'
from    OCCUPATIONS
group by    occupation
order by    count(occupation), occupation asc;

/**
Advanced Select - Occupations - Pivot
**/
-- Solution:
-- SQL Server
SELECT
    [Doctor], [Professor], [Singer], [Actor]
FROM
(
    SELECT *, ROW_NUMBER() OVER (PARTITION BY Occupation ORDER BY NAME) [RowNumber] FROM OCCUPATIONS
) AS sourceTable
PIVOT
(
    MAX(NAME) FOR Occupation IN ([Doctor], [Professor], [Singer], [Actor])
) AS pivotTable

/**
Advanced Select - Binary Tree Nodes
**/
-- Solution:
-- SQL Server
select N,
        case when P is null then 'Root'
             when N in (select P from BST) then 'Inner'
        else 'Leaf'
        end
from BST
order by N;

/**
Advanced Select - New Companies
**/
-- Solution:
-- SQL Server
-- use WHERE clouse
select  c.company_code, c.founder, count(distinct l.lead_manager_code), 
        count(distinct s.senior_manager_code), count(distinct m.manager_code), count(distinct e.employee_code)
from    Company c, Lead_Manager l, Senior_Manager s, Manager m, Employee e
where   c.company_code = l.company_code and
        l.lead_manager_code = s.lead_manager_code and
        s.senior_manager_code = m.senior_manager_code and
        m.manager_code = e.manager_code
group by    c.company_code, c.founder
order by    c.company_code asc;

-- use JOIN
select  c.company_code, c.founder, count(distinct l.lead_manager_code), 
        count(distinct s.senior_manager_code), count(distinct m.manager_code), count(distinct e.employee_code)
from    Company c
        inner join
        Lead_Manager l
        on c.company_code = l.company_code
        inner join
        Senior_Manager s
        on l.lead_manager_code = s.lead_manager_code
        inner join
        Manager m
        on s.senior_manager_code = m.senior_manager_code
        inner join
        Employee e
        on m.manager_code = e.manager_code
group by    c.company_code, c.founder
order by    c.company_code asc;