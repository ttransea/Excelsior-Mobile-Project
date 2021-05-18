/*
Project 1: Excelsior Mobile Report
Tracy Tran
*/


USE [Project1]

/** WITH VISUALIZATION**/

--1A/ Show us the first and last names of our customers along with their
--minute usage, data usage, text usage and total bill. Order them by their full name./


SELECT CONCAT (S.FirstName, SPACE(1), S.LastName) AS [Full Name] , LMU.Minutes, LMU.DataInMB, LMU.Texts, B.Total
FROM Subscriber AS S
JOIN LastMonthUsage AS LMU
ON S.MIN=LMU.MIN
JOIN Bill AS B
ON S.MIN=B.MIN
ORDER BY S.FirstName;




--1B/ Show us the average of the minutes, data, texts and total bills by city.

SELECT S.City, AVG(LMU.Minutes) AS [Average Minutes] , AVG(LMU.DataInMB) As [Average Data], AVG(LMU.Texts) AS [Average Texts], AVG(B.Total) AS [Average Total Bill]
FROM Subscriber AS S
JOIN LastMonthUsage AS LMU
ON S.MIN=LMU.MIN
JOIN Bill AS B
ON S.MIN=B.MIN
GROUP BY S.City;

--1C/Show us the sum of the minutes, data, texts and total bills by city.

SELECT S.City, SUM(LMU.Minutes) AS [Total Minutes] , SUM(LMU.DataInMB) As [Total Data], SUM(LMU.Texts) AS [Total Texts], SUM(B.Total) AS [Total Bill]
FROM Subscriber AS S
INNER JOIN LastMonthUsage AS LMU
ON S.MIN=LMU.MIN
INNER JOIN Bill AS B
ON S.MIN=B.MIN
GROUP BY S.City;

--1D/ Show us the average of the minutes, data, texts and total bills by mobile plan.
SELECT S.PlanName, AVG(LMU.Minutes) AS [Average Minutes] , AVG(LMU.DataInMB) As [Average Data], AVG(LMU.Texts) AS [Average Texts], AVG(B.Total) AS [Average Total Bill]
FROM Subscriber AS S
JOIN LastMonthUsage AS LMU
ON S.MIN=LMU.MIN
JOIN Bill AS B
ON S.MIN=B.MIN
GROUP BY S.PlanName;

--1E/ Show us the sum of the minutes, data, texts and total bills by mobile plan.

SELECT S.PlanName, SUM(LMU.Minutes) AS [Total Minutes] , SUM(LMU.DataInMB) As [Total Data], SUM(LMU.Texts) AS [Total Texts], SUM(B.Total) AS [Total Bill]
FROM Subscriber AS S
INNER JOIN LastMonthUsage AS LMU
ON S.MIN=LMU.MIN
INNER JOIN Bill AS B
ON S.MIN=B.MIN
GROUP BY S.PlanName;

/**WITHOUT VISUALIZATION**/

--1A + B/ First though, I want to know which two cities we have the most customers in.Then show me which cities we should increase our marketing in.

SELECT City, COUNT (FirstName) AS [Number Of Customers]
FROM Subscriber 
GROUP BY City 
ORDER BY [Number Of Customers] DESC;

--1C/ Finally, show us which plans we should market the most based on the number of people who have them (independent of which city they live in).
SELECT PlanName, COUNT (FirstName) AS [Number Of Customers]  
FROM Subscriber 
GROUP BY PlanName 
ORDER BY [Number Of Customers] ASC;

--2A/ Show us the count of cell phone types among our customers. What type do most of our customers use?

SELECT D.Type, COUNT(D.Type) AS [Quantity Of Type]
FROM Device AS D, DirNums AS DN
WHERE D.IMEI=DN.IMEI 
GROUP BY Type
ORDER BY Type ASC;


--2B/Show us which customers (first and last name) use the phone type that is least used by our customers so we can send them a promotion for their friends and family



SELECT S.FirstName + SPACE(1) + S.LastName AS 'Apple Customers'
FROM Subscriber AS S
JOIN DirNums AS DN 
ON S.MDN=DN.MDN
JOIN Device AS D
ON DN.IMEI=D.IMEI
WHERE D.Type='Apple';

					 
--2C/Finally, show us our customers and the year of their phones who have phones released before 2018?


SELECT S.FirstName + SPACE(1) + S.LastName AS [Full Name] , D.YearReleased
FROM Subscriber AS S
JOIN DirNums AS DN
ON S.MDN=DN.MDN
JOIN Device AS D
ON DN.IMEI=D.IMEI
WHERE YearReleased < 2018
ORDER BY YearReleased;
				
--3A/We want to know ultimately if there is a city that uses a lot of data (within the top 3 data using cities) but none of our customers in that city are using the Unlimited Plans. If there is a city like that, which one is it?
SELECT TOP 3 SUM(LMU.DataInMB) AS [Total Data], S.City
FROM Subscriber AS S
JOIN LastMonthUsage AS LMU
ON S.MIN=LMU.MIN
GROUP BY City
ORDER BY [Total Data] DESC;


/** From A, we can assume that Olympia, Bellevue and Seattle are the cities that consume the most data. 
We are using B to filter out the city that DOESN'T involve in Unlimited Plans.**/

SELECT City,PlanName AS [Plan Name]
FROM Subscriber
WHERE PlanName IN ('UnlBasic','UnlPrime', 'UnlSuper') AND City IN ('Olympia', 'Seattle','Bellevue')
ORDER BY City;



/**The result from B let us know Bellevue is the city that has no customer using Unlimited Plans. **/

--4A/ They wish to know the first and last name of the customer who has the most expensive bill every month.

SELECT TOP 1 B.Total, CONCAT(S.FirstName, S.LastName) AS [Full Name]
FROM Subscriber AS S
JOIN Bill AS B ON S.MIN = B.MIN 
ORDER BY B.Total DESC;



--4B/ They also want to know which mobile plan brings us in the most revenue each month.

SELECT TOP 1 SUM(B.Total) AS [Total Revenue], S.PlanName
FROM Subscriber AS S
JOIN Bill AS B
ON S.MIN=B.MIN
GROUP BY S.PlanName
ORDER BY SUM(B.Total) DESC;

--5A/Please tell us which area code (only the area code) uses the most minutes.

SELECT TOP 1 S.Zipcode 
FROM Subscriber AS S
JOIN LastMonthUsage AS LMU
ON S.MIN=LMU.MIN
ORDER BY Minutes DESC;


--5B/Which cities do we see the biggest difference in terms of minutes usage? In other words, which cities have the biggest difference between the customers who use smallest amount of minutes to customers that use the largest. Use the difference of customers who use less than 200 and customers who use more than 700 minutes.


SELECT City, MAX(Minutes) - MIN(Minutes) AS [DIFF OF USAGE]
FROM Subscriber AS S
JOIN LastMonthUsage AS LMU
ON S.MIN=LMU.MIN
WHERE Minutes NOT BETWEEN 200 AND 700
GROUP BY City
ORDER BY [DIFF OF USAGE] DESC;








