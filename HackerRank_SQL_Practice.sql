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

/**
Aggregation - Top Earners
**/
-- Solution:
-- SQL Server
select  a.total, count(rk)
from    (
        select  (salary * months) as total, rank() over(order by (salary * months) desc) as rk
        from    Employee
        ) a
where   a.rk = 1
group by a.total;

-- MySQL
SELECT salary * months AS total, COUNT(*)
FROM Employee
GROUP BY total
ORDER BY total DESC
LIMIT 1;

/**
Aggregation - Weather Observation Station 2
**/
-- Solution:
-- SQL Server
-- use format(float number, '0.######') to remove tailing zeros in SQL Server
select  format(Round(sum(LAT_N), 2), '0.######'), format(Round(sum(LONG_W), 2), '0.######')
from    station;

-- MySQL
SELECT  ROUND(SUM(LAT_N), 2), ROUND(SUM(LONG_W), 2) 
FROM    STATION;

/**
Aggregation - Weather Observation Station 13
**/
-- Solution:
-- SQL Server
select  format(Round(sum(LAT_N), 4), '0.######')
from    station
where   LAT_N > 38.7880 and LAT_N < 137.2345;

/**
Aggregation - Weather Observation Station 14
**/
-- Solution:
-- SQL Server
select  format(Round(Max(LAT_N), 4), '0.######')
from    station
where   LAT_N < 137.2345;

/**
Aggregation - Weather Observation Station 15
**/
-- Solution:
-- SQL Server
select  format(Round(s.LONG_W, 4), '0.######')
from    (
        select  Max(LAT_N) as maxN
        from    station
        where   LAT_N < 137.2345
        ) a,
        Station s
where   s.LAT_N = a.maxN;

/**
Revising Aggregation - The Count Function
**/
-- Solution:
-- SQL Server
select  count(1)
from    city
where   population > 100000;

/**
Revising Aggregation - The Sum Function
**/
-- Solution:
-- SQL Server
select  sum(population)  
from    city
where   district = 'California';

/**
Revising Aggregation - Averages
**/
-- Solution:
-- SQL Server
select  avg(population)  
from    city
where   district = 'California';

/**
Aggregation - Averages Population - rounded down to the nearest integer.
**/
-- Solution:
-- SQL Server
select  cast(avg(population) as int)
from    city;

/**
Aggregation - Population Density Difference - difference between the maximum and minimum
**/
-- Solution:
-- SQL Server
select  max(population) - min(population)
from    city;

/**
Aggregation - The Blunder - use replace()
**/
-- Solution:
-- MySQL
select  ceil(avg(salary) - avg(replace(salary, '0', '')))
from    EMPLOYEES;

-- SQL Server - solution 1 - not correct
-- this result is differnet from MySQL
-- because avg() returns int
select  CEILING(avg(salary) - avg(cast(replace(salary, '0', '') as float)))
from    EMPLOYEES;

-- SQL Server - solution 2 - this one is correct, meets the requirement
-- cast salary from int to float
select  cast(ceiling(avg(cast(salary as float)) - avg(cast(replace(salary, '0', '') as float))) as int)
from    EMPLOYEES;

/**
Aggregation - Weather Observation Station 17
**/
-- Solution:
-- SQL Server
select  format(round(s.LONG_W, 4), '0.######')
from    (
        select  min(LAT_N) as minN
        from    station
        where   LAT_N > 38.7780
        ) a
        , station s
where   a.minN = s.LAT_N;

/**
Aggregation - Weather Observation Station 18 - Manhattan Distance between two points
**/
-- Solution:
-- SQL Server
select  format(round(abs(max(LAT_N)-min(LAT_N)) + abs(max(LONG_W)-min(LONG_W)), 4), '0.######')
from    station;

/**
Aggregation - Weather Observation Station 19 - Euclidean Distance between two points
**/
-- Solution:
-- SQL Server
select  format(round(sqrt(square(max(LAT_N)-min(LAT_N)) + square(max(LONG_W)-min(LONG_W))), 4), '0.######')
from    station;

/**
Aggregation - Weather Observation Station 20 find median
**/
-- Solution:
-- SQL Server
-- find median using PERCENTILE_CONT() WITHIN GROUP(ORDER BY...) OVER()
select  distinct format(round(PERCENTILE_CONT(0.5) WITHIN GROUP (order by LAT_N) OVER(), 4), '0.######')
from    station;

-- Oracle
SELECT  ROUND(MEDIAN(Lat_N), 4)
FROM    Station;

/**
Basic Join - Asian Population
**/
-- Solution:
-- SQL Server
select  sum(c.population)
from    city c
        inner join
        country cty
        on c.CountryCode = cty.Code
where   cty.CONTINENT = 'Asia';

/**
Basic Join - The Report
**/
-- Solution:
-- SQL Server
select  case when g.grade < 8 then NULL
        else s.name
        end
        , g.grade
        , s.marks
from    students s
        inner join
        grades g
        on s.Marks between g.Min_Mark and g.Max_Mark
order by    g.grade desc, s.name, s.marks;

/**
Basic Join - Top Competitors
**/
-- Solution:
-- SQL Server
select  h.hacker_id, h.name
from    Submissions s
        inner join
        Hackers h
        on s.hacker_id = h.hacker_id
        inner join
        Challenges c
        on s.challenge_id = c.challenge_id
        inner join
        Difficulty d
        on c.difficulty_level = d.difficulty_level
where   s.score = d.score
group by        h.hacker_id, h.name
having          count(*) > 1 
order by        count(*) desc, h.hacker_id;

/**
Basic Join - Ollivander's Inventory
**/
-- Solution:
-- SQL Server
with a as (
        select  code, power, MIN(coins_needed) as coins_needed 
        from    Wands 
        group by    code, power
)
select  w.id, wp.age, w.coins_needed, w.power
from    a
        inner join
        Wands w
        on a.code = w.code and a.power = w.power and a.coins_needed = w.coins_needed
        inner join
        Wands_Property wp
        on  a.code = wp.code
where   wp.is_evil = 0
order by    a.power desc, wp.age desc;

/**
Basic Join - Challenges
**/
-- Solution:
-- SQL Server
select  h.hacker_id, h.name, count(c.challenge_id)
from    hackers h
        inner join
        Challenges c
        on h.hacker_id = c.hacker_id
group by    h.hacker_id, h.name
having  count(c.hacker_id) = (
                                select max(cnts.cnt) 
                                from (
                                        select count(hacker_id) as cnt 
                                        from Challenges 
                                        group by hacker_id) as cnts
                                )
        or count(c.hacker_id) in (
                                    select cnts.cnt 
                                    from (
                                            select count(hacker_id) as cnt
                                            from Challenges
                                            group by hacker_id) as cnts
                                    group by cnts.cnt
                                    having  count(cnts.cnt) = 1
                                 )
order by count(c.hacker_id) desc, hacker_id;

-- cleaner solution using WITH
with totalChallenges as (
    select count(hacker_id) as cnt 
    from Challenges 
    group by hacker_id
)
select  h.hacker_id, h.name, count(c.challenge_id)
from    hackers h
        inner join
        Challenges c
        on h.hacker_id = c.hacker_id
group by    h.hacker_id, h.name
having  count(c.hacker_id) = (
                                select max(totalChallenges.cnt) 
                                from totalChallenges
                                )
        or count(c.hacker_id) in (
                                    select totalChallenges.cnt 
                                    from totalChallenges
                                    group by totalChallenges.cnt
                                    having  count(totalChallenges.cnt) = 1
                                 )
order by count(c.hacker_id) desc, hacker_id;

/**
Basic Join - Contest Leaderboard
**/
-- Solution:
-- SQL Server
with max_score as (
            select  hacker_id, challenge_id, max(score) as maxScore
            from    Submissions
            group by    hacker_id, challenge_id
)
select  ms.hacker_id, h.name, sum(ms.maxScore)
from    max_score ms
        inner join
        hackers h
        on ms.hacker_id = h.hacker_id
group by    ms.hacker_id, h.name
having      sum(ms.maxScore) <> 0
order by    sum(ms.maxScore) desc, ms.hacker_id;

/**
Advanced Join - SQL Project Planning - using LEFT JOIN
**/
-- Solution:
-- SQL Server
select  s.start_date, min(e.end_date)
from (
        select a.start_date
        from projects A
        left join 
        projects t
        on a.start_date = t.end_date
        where t.end_date is null
    )s 
    join (
        select a.end_date
        from projects A
        left join 
        projects t
        on a.end_date = t.start_date
        where t.start_date is null
    )e
on s.start_date < e.end_date
group by s.start_date
order by datediff(dd, s.start_date, min(e.end_date)), s.start_date;

-- use WITH
with StartD as (
    select  a.start_date
    from    projects A
            left join 
            projects t
            on a.start_date = t.end_date
            where t.end_date is null
), endD as (
    select  a.end_date
    from    projects A
            left join 
            projects t
            on a.end_date = t.start_date
            where t.start_date is null
)
select  sd.start_date, min(ed.end_date)
from    StartD sd
        inner join
        endD ed
        on sd.start_date < ed.end_date
group by sd.start_date
order by datediff(dd, sd.start_date, min(ed.end_date)), sd.start_date;

-- do not use JOIN
WITH CTE_Projects AS 
(
  SELECT Start_Date, End_Date, ROW_NUMBER() OVER (ORDER BY Start_Date) AS RowNumber
  FROM Projects
)
SELECT MIN(Start_Date), MAX(End_Date) 
FROM CTE_Projects
GROUP BY DATEDIFF(DAY, RowNumber, Start_Date)
ORDER BY DATEDIFF(DAY, MIN(Start_Date), MAX(End_Date)), MIN(Start_Date);

-- use rownumber 2
SELECT T1.Start_Date,T2.End_Date 
FROM ( 
    SELECT Start_Date,ROW_NUMBER() OVER (ORDER BY Start_Date) RN 
    FROM Projects 
    WHERE Start_Date NOT IN (SELECT END_Date FROM Projects)) AS T1 
    INNER JOIN (
                SELECT End_Date,ROW_NUMBER() OVER (ORDER BY End_Date) RN 
                FROM Projects 
                WHERE End_Date NOT IN (SELECT Start_Date FROM Projects)) AS T2 
    ON T1.RN = T2.RN 
ORDER BY DATEDIFF(Day,T1.Start_Date,T2.End_Date),T1.Start_Date;