use sal;
SELECT * FROM sal.mmm;

-- 1
select industry,gender,avg(`Annual_salary(INR)`) as average_salary
from mmm
group by industry, gender
order by industry, gender;

-- 2
select job_title, sum(`Annual_salary(INR)` + `Additional_Monetary_Compensation(INR)`) as total_compensation
from mmm
group by job_title
order by total_compensation desc;

-- 3 
select Highest_Level_of_Education_Completed,
    avg(`annual_salary(inr)`) as avg_salary,
    min(`annual_salary(inr)`) as min_salary,
    max(`annual_salary(inr)`) as max_salary
from mmm
group by education_level
order by avg_salary desc;

-- 4
select 
    industry,
    Years_of_Professional_Experience_Overall,
    count(*) as employee_count
from 
    mmm
group by 
    industry, Years_of_Professional_Experience_Overall
order by 
    industry, Years_of_Professional_Experience_Overall;
    
-- 5
-- select 
--     age_range,
--     gender,
--     (min(`annual_salary(inr)`) + max(`annual_salary(inr)`)) / 2 as approx_median_salary
-- from 
--     mmm
-- group by 
--     age_range, gender
-- order by 
--     age_range, gender;

select 
    age_range,
    gender,
    avg(`annual_salary(inr)`) as median_salary
from (
    select 
        age_range,
        gender,
        `annual_salary(inr)`,
        row_number() over (partition by age_range, gender order by `annual_salary(inr)`) as r,
        count(*) over (partition by age_range, gender) as c
    from mmm
) x
where r in (floor((c + 1)/2), floor((c + 2)/2))
group by age_range, gender;



-- 6
-- select country,job_title,`annual_salary(inr)`
-- from mmm
-- where (`country`, `annual_salary(inr)`) in (
-- select country,max(`annual_salary(inr)`)
-- from mmm
-- group by country
-- );
select country,job_title,`annual_salary(inr)`
from (select country,job_title,`annual_salary(inr)`,
rank() over (partition by country order by `annual_salary(inr)` desc) as rnk
from mmm
) x
where rnk = 1
order by country;

-- 7

select city,industry,avg(`annual_salary(inr)`) as average_salary
from mmm
group by 
    city, industry
order by 
    city, industry;

-- 8
select gender,round(100 * sum(case when `additional_monetary_compensation(inr)` > 0 then 1 else 0 end) / count(*), 2) 
as percentage_with_compensation
from mmm
group by 
    gender;
    
-- 9
select job_title,Years_of_Professional_Experience_Overall,
    sum(`annual_salary(inr)` + `additional_monetary_compensation(inr)`) as total_compensation
from mmm
group by 
    job_title, Years_of_Professional_Experience_Overall
order by 
    job_title, Years_of_Professional_Experience_Overall;

-- 10
select industry,gender,Highest_Level_of_Education_Completed,
    avg(`annual_salary(inr)`) as average_salary
from mmm
group by 
    industry, gender, Highest_Level_of_Education_Completed
order by 
    industry, gender, Highest_Level_of_Education_Completed;
