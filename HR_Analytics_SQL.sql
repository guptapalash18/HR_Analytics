select * from hr_2;
select * from hr_1;

desc hr_2;
update hr_2 set YOJ = str_to_date(YOJ,'%d-%m-%Y');
alter table hr_2 modify YOJ Date;


-- KPI 1 Department wise attrition
select department, count(attrition) attrition from hr_1 h1 inner join hr_2 h2 on h1.EmployeeNumber = h2.Employee_ID 
where Attrition='Yes' group by Department
order by 2 desc;

-- KPI 2  Avg Hourly Rate of Male research Scientist

/* CREATE DEFINER=`root`@`localhost` PROCEDURE `MaleRes_Emp`(G varchar(10),JR varchar(30))
BEGIN
select JobRole,avg(HourlyRate) Avg_Hourly_rate, count(Gender) Emp_Count from hr_1 where Gender = G and jobRole= JR group by JobRole; 
END
*/
call MaleRes_Emp('Male','Research Scientist') ;

-- KPI 3 Attrition rate Vs Monthly income stats

select concat(10001*floor(MonthlyIncome/10001),'-',10001*floor(MonthlyIncome/10001)+10000) as Monthly_Income_Range, 
round(count(Employee_ID)/(select count(Employee_ID) from hr_2)*100,2) as Attrition_Rate
from hr_1 h1 inner join hr_2 h2 on h1.EmployeeNumber = h2.Employee_ID
where Attrition ='Yes'
group by 1 order by 1;

-- KPI 4 Average Working Year for each Department

Select department ,count(Employee_ID) Count_Employee ,round(Avg(TotalWorkingYears),3) as Avg_Work_Hrs 
from hr_1 h1 inner join hr_2 h2 on h1.EmployeeNumber = h2.Employee_ID
group by 1;

-- KPI 5 Job_Role wise Work Life Balance
Select JobRole, case
				when WorkLifeBalance =1 then "Excellent"
                when WorkLifeBalance =2 then "Good"
                When WorkLifeBalance =3 then "Average"
                else "Poor" 
                end
 WorkLife_Balance, Count(Employee_ID) Emp_Count
from hr_1 h1 inner join hr_2 h2 on h1.EmployeeNumber = h2.Employee_ID
group by 1,2 order by 1,3 desc;

-- KPI 6 Attrition rate Vs Year since last promotion relation

Select YearsSinceLastPromotion, round(count(Employee_ID)/(select count(Employee_ID) from hr_2)*100,2) as Attrition_Rate
from hr_1 h1 inner join hr_2 h2 on h1.EmployeeNumber = h2.Employee_ID
where Attrition="Yes"
group by 1 Order by 1;

-- KPI 7 count of Empl based on Education fields
Select EducationField ,count(Employee_ID) Count_Employee , round(count(Employee_ID)/(select count(Employee_ID) from hr_2)*100,2) as Attrition_Rate
from hr_1 h1 inner join hr_2 h2 on h1.EmployeeNumber = h2.Employee_ID
Where Attrition = 'Yes'
group by 1;

-- KPI 8 Gender Based Attrition Rate
select gender as Gender, round(count(Employee_ID)/(Select count(employee_ID) from hr_2)*100,2) as attrition_Rate,count(Employee_ID) as Attrition
from hr_1 h1 inner join hr_2 h2 on h1.EmployeeNumber = h2.Employee_ID
where Attrition='Yes'
group by 1;

-- KPI 9 Monthly New Hire vs Attrition Trendline
select MonthName(YOJ) MonthName, round(count(Employee_ID)/(select count(Employee_ID) from hr_2)*100,2) as Attrition_Rate 
from hr_1 h1 inner join hr_2 h2 on h1.EmployeeNumber = h2.Employee_ID
Where Attrition = 'Yes'
group by 1, Month(YOJ)
order by Month(YOJ);

-- KPI 10 Department Role wise wise Job satisfaction

select department , JobRole , round(Avg(Jobsatisfaction),2) JobSatisfaction, count(Employee_ID) Attrition
from hr_1 h1 inner join hr_2 h2 on h1.EmployeeNumber = h2.Employee_ID
where attrition='Yes'
Group by 1,2
order by 1,3 desc;


