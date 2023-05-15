-- Databricks notebook source
DROP TABLE IF EXISTS clinicaltrial_2021;
DROP TABLE IF EXISTS pharma;


-- COMMAND ----------

--CREATE TABLE 
CREATE TEMPORARY TABLE clinicaltrial_2021
USING csv 
OPTIONS (
  path '/FileStore/tables/clinicaltrial_2021',
  header true,
  sep '|'
);
CREATE TEMPORARY TABLE pharma
USING csv 
OPTIONS (
  path '/FileStore/tables/pharma',
  header true
);
 


-- COMMAND ----------

-- MAGIC %md
-- MAGIC ##Question 1
-- MAGIC 1. The number of studies in the dataset. You must ensure that you explicitly check 
-- MAGIC distinct studies.

-- COMMAND ----------

-- calculate the total distinct studies
select count(distinct Id) as Total_Studies from clinicaltrial_2021

-- COMMAND ----------

-- MAGIC %md
-- MAGIC ##Question 2
-- MAGIC You should list all the types (as contained in the Type column) of studies in the 
-- MAGIC dataset along with the frequencies of each type. These should be ordered from 
-- MAGIC most frequent to least frequent

-- COMMAND ----------

-- group the table by types
select Type, count(*) Frequency
from clinicaltrial_2021
group by Type
Order by Frequency desc

-- COMMAND ----------

-- MAGIC %md
-- MAGIC ##Question 3
-- MAGIC The top 5 conditions (from Conditions) with their frequencies.

-- COMMAND ----------

select col as Conditions, count(*) as Frequency 
from
 
(SELECT explode(split(Conditions, ',')) from clinicaltrial_2021)
 
group by Conditions
 
order by Frequency desc
limit 5

-- COMMAND ----------

-- MAGIC %md
-- MAGIC ##Question 4
-- MAGIC Find the 10 most common sponsors that are not pharmaceutical companies, along 
-- MAGIC with the number of clinical trials they have sponsored.

-- COMMAND ----------

select Sponsor, count(*) Total_Studies
from 
(select * from clinicaltrial_2021 c
left join pharma p
on c.Sponsor = p.Parent_Company
where Parent_Company is null)
 
group by Sponsor
order by Total_Studies desc
limit 10

-- COMMAND ----------

-- MAGIC %md
-- MAGIC ##Question 5
-- MAGIC  Plot number of completed studies each month in a given year – for the submission 
-- MAGIC dataset, the year is 2021. You need to include your visualization as well as a table 
-- MAGIC of all the values you have plotted for each month.

-- COMMAND ----------

select Completion, count(*) as TotalCompleted
from clinicaltrial_2021
where Status = 'Completed' and Completion like '%2021'
group by Completion
order by to_date(Completion, "MMM yyyy") 

-- COMMAND ----------


