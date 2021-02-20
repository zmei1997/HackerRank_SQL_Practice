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