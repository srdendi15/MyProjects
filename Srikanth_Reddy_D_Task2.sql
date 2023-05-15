CREATE DATABASE PrescriptionsDB;
go 
Use PrescriptionsDB;
go 

--Q1 Adding Foriegn Keys to represent the database diagram

ALTER TABLE Prescriptions ADD FOREIGN KEY (BNF_CODE) REFERENCES DRUGS(BNF_CODE);

Alter Table Prescriptions add foreign key (PRACTICE_CODE) REFERENCES Medical_Practice(PRACTICE_CODE); 

  /* Q2  Write a query that returns details of all drugs which are in the form of tablets or 
capsules. You can assume that all drugs in this form will have one of these words in the 
BNF_DESCRIPTION column.*/
SELECT * FROM Drugs WHERE BNF_DESCRIPTION LIKE '%TABLETS%' OR BNF_DESCRIPTION LIKE '%CAPSULES%'; 

/*Q3  Write a query that returns the total quantity for each of prescriptions – this is given by 
the number of items multiplied by the quantity. Some of the quantities are not integer 
values and your client has asked you to round the result to the nearest integer value. */

SELECT PRESCRIPTION_CODE, PRACTICE_CODE, BNF_CODE, ROUND((QUANTITY*ITEMS),1) AS OVERALL_QUANTITY FROM Prescriptions;

/*Q4  Write a query that returns a list of the distinct chemical substances which appear in 
the Drugs table (the chemical substance is listed in the 
CHEMICAL_SUBSTANCE_BNF_DESCR column) */

SELECT DISTINCT CHEMICAL_SUBSTANCE_BNF_DESCR FROM Drugs;

/*Q5  Write a query that returns the number of prescriptions for each 
BNF_CHAPTER_PLUS_CODE, along with the average cost for that chapter code, and the 
minimum and maximum prescription costs for that chapter code. */

SELECT D.BNF_CHAPTER_PLUS_CODE AS CHAPTER_PLUS_CODE,
	COUNT(P.BNF_CODE) AS TOTAL_PRESCRIPTIONS,
	AVG(P.ACTUAL_COST) AS AVG_COST,
	MIN(P.ACTUAL_COST) AS MIN_COST,
	MAX(P.ACTUAL_COST) AS MAX_COST FROM Prescriptions AS P 
INNER JOIN Drugs AS D 
ON P.BNF_CODE = D.BNF_CODE
GROUP BY (D.BNF_CHAPTER_PLUS_CODE);

/*Q6 Write a query that returns the most expensive prescription prescribed by each 
practice, sorted in descending order by prescription cost (the ACTUAL_COST column in 
the prescription table.) Return only those rows where the most expensive prescription 
is more than £4000. You should include the practice name in your result.*/

SELECT MP.PRACTICE_NAME, MP.PRACTICE_CODE,P.ACTUAL_COST FROM Prescriptions AS P
INNER JOIN Medical_Practice AS MP
ON P.PRACTICE_CODE = MP.PRACTICE_CODE 
WHERE ACTUAL_COST > 4000 
ORDER BY (P.ACTUAL_COST) DESC;

/*Q7 Write any five quries */

--A) WRITE A SELECT STATEMENT TO RETRIEVE THE MEDICAL PRACTICE DETAILS IN 3 DIFFERENT POSTCODES?

SELECT * FROM Medical_Practice WHERE POSTCODE IN ('BL2 6NT','BL1 3RG', 'BL7 9RG');

--B)WRITE A QUERY IF ANY OF THE MEDICAL_PRACTICE ADDRESS_2 IS NULL THEN REPLACE WITH NOT AVAIALBLE

--SELECT * FROM Medical_Practice;

SELECT PRACTICE_NAME, ADDRESS_1, ADDRESS_2, ISNULL(ADDRESS_2, 'Not Provided') as Address from Medical_Practice;

--C) write a query to retreive unique chemical substance which have more than 200 items?

SELECT Distinct D.CHEMICAL_SUBSTANCE_BNF_DESCR FROM Drugs D 
INNER JOIN Prescriptions P ON D.BNF_CODE=P.BNF_CODE WHERE ITEMS > 200;

--D) DISPLAY THE DRUGS DETAILS BY THEIR ACTUAL COSTS ARE MORE THAN 10000?

SELECT  BNF_CODE, BNF_CHAPTER_PLUS_CODE, CHEMICAL_SUBSTANCE_BNF_DESCR FROM Drugs 
WHERE BNF_CODE 
IN (SELECT BNF_CODE FROM Prescriptions 
GROUP BY BNF_CODE 
HAVING MAX(ACTUAL_COST) >= 10000);

--select * from drugs;

--E) Write a query to print all the columns of the tables where the prescriptions code is 2

SELECT *
FROM Prescriptions
JOIN Drugs ON (Drugs.BNF_CODE = Prescriptions.BNF_CODE)
JOIN Medical_Practice ON (Medical_Practice.Practice_code = Prescriptions.Practice_code) where Prescription_code = 2;