/*
Foundation Recap Exercise
 
Use the table PatientStay.  

This lists 44 patients admitted to London hospitals over 5 days between Feb 26th and March 2nd 2024

*/
 
 
/*

1. Filter the list the patients to show only those  -

a) in the Oxleas hospital,

b) and also in the PRUH hospital,

c) admitted in February 2024

d) only the surgical wards (i.e. wards ending with the word Surgery)
 
 
2. Show the PatientId, AdmittedDate, DischargeDate, Hospital and Ward columns only, not all the columns.

3. Order results by AdmittedDate (latest first) then PatientID column (high to low)

4. Add a new column LengthOfStay which calculates the number of days that the patient stayed in hospital, inclusive of both admitted and discharge date.

*/
 
-- Write the SQL statement here
 
SELECT 
ps.PatientId
,ps.AdmittedDate
,ps.Hospital
,ps.Ward
,DATEDIFF(DAY,ps.AdmittedDate, ps.dischargedate) +1 AS 'Length Of Stay'
,DATEADD(WEEK, -2, ps.AdmittedDate) AS 'Reminder Date'
FROM PatientStay ps 
WHERE ps.Hospital IN ('Oxleas','PRUH')
--AND ps.hospital >= '2024-03-01'
AND ps.AdmittedDate BETWEEN '2024-02-01' AND '2024-02-29'
AND ps.Ward like '%Surgery%'
ORDER BY ps.AdmittedDate desc, ps.PatientID asc

-- sub query
SELECT SUM(topPatients.Tariff) From ( 
    SELECT top 10
    PS.PatientID
    ,ps.Tariff
    from 
    patient ps 
ORDER BY ps.Tariff desc) topPatients

-- CTE
;
WITH topPatients AS
 (
SELECT
    TOP 10
    ps.PatientId
    ,ps.Tariff
FROM
    PatientStay ps
ORDER BY ps.Tariff DESC )
select SUM(topPatients.Tariff) from topPatients
 


/*
5. How many patients has each hospital admitted? 

6. How much is the total tarriff for each hospital?

7. List only those hospitals that have admitted over 10 patients

8. Order by the hospital with most admissions first
*/
 
-- Write the SQL statement here
 
SELECT 
ps.Hospital, 
COUNT(ps.PatientId) AS 'Total Admissions'
FROM PatientStay ps
WHERE ps.AdmittedDate BETWEEN '2024-02-01' AND '2024-02-29'
GROUP BY ps.Hospital
ORDER BY [Total Admissions] desc

SELECT
COUNT (*) AS [Total Admissions] from PatientStay

SELECT
ps.Hospital
,count(*) as 'Number Of Patients'
,avg(ps.Tariff) as 'Average Tariff'
,SUM(ps.Tariff) as 'Total Tariff'
FROM PatientStay ps
GROUP BY ps.Hospital
HAVING COUNT (ps.PatientId) > '10'

SELECT
ps.Hospital
,count(*) as NumPatients
,sum(ps.Tariff) AS TotalTariff
,avg(ps.Tariff) AS AverageTariff
from PatientStay ps
GROUP BY ps.Hospital
having count(*) > 10
ORDER BY NumPatients desc
 
 DROP TABLE IF EXISTS #EDD
 
 
IF OBJECT_ID('tempdb..#EDD') IS NOT NULL DROP TABLE #EDD
 