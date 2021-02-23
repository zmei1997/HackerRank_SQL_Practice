create table #Projects (
	Task_ID	int,
	Start_Date Date,
	End_Date Date
);

insert into #Projects values(1, '2015-10-01', '2015-10-02');
insert into #Projects values(2, '2015-10-02', '2015-10-03');
insert into #Projects values(3, '2015-10-03', '2015-10-04');
insert into #Projects values(4, '2015-10-13', '2015-10-14');
insert into #Projects values(5, '2015-10-14', '2015-10-15');
insert into #Projects values(6, '2015-10-28', '2015-10-29');
insert into #Projects values(7, '2015-10-30', '2015-10-31');

/**
You are given a table, Projects, containing three columns: Task_ID, Start_Date and End_Date. 
It is guaranteed that the difference between the End_Date and the Start_Date is equal to 1 day for each row in the table.
If the End_Date of the tasks are consecutive, then they are part of the same project. 
Samantha is interested in finding the total number of different projects completed.

Write a query to output the start and end dates of projects listed by the number of days it took to 
complete the project in ascending order. If there is more than one project that have the same number of completion days, 
then order by the start date of the project.
**/
select *
from #Projects;

SELECT Start_Date,ROW_NUMBER() OVER (ORDER BY Start_Date) RN 
FROM #Projects 
WHERE Start_Date NOT IN (SELECT END_Date FROM #Projects)

SELECT End_Date,ROW_NUMBER() OVER (ORDER BY End_Date) RN 
FROM #Projects 
WHERE End_Date NOT IN (SELECT Start_Date FROM #Projects)

/**
solution 1
**/
SELECT T1.Start_Date,T2.End_Date 
FROM ( 
    SELECT Start_Date,ROW_NUMBER() OVER (ORDER BY Start_Date) RN 
    FROM #Projects 
    WHERE Start_Date NOT IN (SELECT END_Date FROM #Projects)) AS T1 
    INNER JOIN (
                SELECT End_Date,ROW_NUMBER() OVER (ORDER BY End_Date) RN 
                FROM #Projects 
                WHERE End_Date NOT IN (SELECT Start_Date FROM #Projects)) AS T2 
    ON T1.RN = T2.RN
ORDER BY DATEDIFF(Day,T1.Start_Date,T2.End_Date),T1.Start_Date;

/**
solution2
**/
with StartD as (
    select  a.start_date
    from    #projects A
            left join 
            #projects t
            on a.start_date = t.end_date
            where t.end_date is null
), endD as (
    select  a.end_date
    from    #projects A
            left join 
            #projects t
            on a.end_date = t.start_date
            where t.start_date is null
)
select  sd.start_date, min(ed.end_date)
from    StartD sd
        inner join
        endD ed
        on sd.start_date < ed.end_date
group by sd.start_date
order by datediff(day, sd.start_date, min(ed.end_date)), sd.start_date;