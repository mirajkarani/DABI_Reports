/*Question 1: Total Sales via Invoice*/

SELECT CONCAT(SUM(Total),' USD') AS 'Total Sales via Invoice' FROM Invoice;

/*Question 2: Total Sales via InvoiceLine*/

SELECT CONCAT(SUM(UnitPrice),' USD') AS 'Total Sales via InvoiceLine' FROM InvoiceLine;


/*Question 3: Total tracks sold*/

SELECT COUNT(TrackId) AS 'No. of Tracks sold' FROM InvoiceLine;

/*Question 4: Total Sales by Country*/

SELECT Country, CONCAT(SUM(Total),' USD') AS 'Total Sales'  
FROM Invoice i JOIN Customer c ON i.CustomerId = c.CustomerId 
GROUP BY Country
ORDER BY SUM(Total) DESC; 

/*Question 5: Total Sales by Geo - Country, State, City*/

SELECT Country, 
	CASE WHEN State IS NULL THEN 'N/A' ELSE State 
	END AS 'State', 
City, CONCAT(SUM(Total),' USD') AS 'Total Sales'
FROM Invoice i JOIN Customer c ON i.CustomerId = c.CustomerId 
GROUP BY Country, State, City
ORDER BY SUM(Total) DESC; 

/*Question 6: Total Sales by Customer*/

SELECT CONCAT(LastName, CONCAT(' ',FirstName)) AS 'Customer', CONCAT(SUM(Total),' USD')  AS 'Total Sales'
FROM Customer c JOIN Invoice i ON c.CustomerId = i.CustomerId
GROUP BY FirstName, LastName
ORDER BY SUM(Total) DESC;

/*Question 7: *Total Sales by Company Name*/

SELECT CASE WHEN Company IS NULL THEN 'N/A' ELSE Company 
END AS 'Company',
CONCAT(SUM(Total),' USD') AS 'Total Sales'
FROM Customer c JOIN Invoice i 
ON c.CustomerId = i.CustomerId 
GROUP BY Company
ORDER BY SUM(Total) DESC;

/*Question 8: Total Sales by Artist*/

SELECT a.Name, CONCAT(SUM(il.UnitPrice),' USD') AS 'Total Sales'
FROM Artist a JOIN Album a2
ON a.ArtistId = a2.ArtistId 
JOIN Track t on t.AlbumId = a2.AlbumId 
JOIN InvoiceLine il ON t.TrackId = il.TrackId 
GROUP BY a.Name
ORDER BY SUM(il.UnitPrice) DESC, a.Name; 

/*Top 20 Artists by Sales*/

SELECT TOP(20) a.Name, CONCAT(SUM(il.UnitPrice),' USD') AS 'Total Sales'
FROM Artist a JOIN Album a2
ON a.ArtistId = a2.ArtistId 
JOIN Track t on t.AlbumId = a2.AlbumId 
JOIN InvoiceLine il ON t.TrackId = il.TrackId 
GROUP BY a.Name
ORDER BY SUM(il.UnitPrice) DESC; 

/*Question 9: Total Sales by Album*/

SELECT Title, CONCAT(SUM(il.UnitPrice),' USD') AS 'Total Sales'
FROM Album a2 JOIN Track t on t.AlbumId = a2.AlbumId 
JOIN InvoiceLine il ON t.TrackId = il.TrackId 
GROUP BY a2.Title
ORDER BY SUM(il.UnitPrice) DESC, a2.Title; 

/*Question 10: Total Sales by Employee*/

SELECT CONCAT(e.LastName,CONCAT(' ',e.FirstName)) AS 'Employee Name', CONCAT(SUM(Total),' USD') AS 'Total Sales'
FROM Employee e JOIN Customer c 
ON e.EmployeeId = c.SupportRepId JOIN Invoice i 
ON c.CustomerId  = i.CustomerId 
GROUP BY e.FirstName, e.LastName 
ORDER BY SUM(Total) DESC;

/*Question 11: Total Sales by MediaType*/

SELECT mt.Name AS 'Media Type', CONCAT(SUM(il.UnitPrice),' USD') AS 'Total Sales'
FROM MediaType mt JOIN Track t 
ON mt.MediaTypeId = t.MediaTypeId 
JOIN InvoiceLine il ON t.TrackId = il.TrackId 
GROUP BY mt.Name 
ORDER BY SUM(il.UnitPrice) DESC;

/*Question 12: Total Sales by Genre*/

SELECT g.Name as 'Genre', CONCAT(SUM(il.UnitPrice),' USD') AS 'Total Sales'
FROM Genre g JOIN Track t ON g.GenreId = t.GenreId 
JOIN InvoiceLine il ON il.TrackId = t.TrackId 
GROUP BY g.Name 
ORDER BY SUM(il.UnitPrice) DESC;

/*Question 13: Total Sales by Year*/

SELECT DATEPART(yyyy, InvoiceDate) as 'Year', CONCAT(SUM(Total),' USD') AS 'Total Sales'
FROM Invoice i 
GROUP BY DATEPART(yyyy, InvoiceDate)
ORDER BY SUM(Total) DESC;

/*Question 14: Total Sales by Year-Month*/

SELECT 	DATEPART(yyyy, InvoiceDate) as 'Year', 
		DATENAME(month, InvoiceDate) as 'Month', 
		CONCAT(SUM(Total),' USD') 
FROM Invoice i 
GROUP BY 	DATEPART(yyyy, InvoiceDate), 
			DATENAME(month, InvoiceDate)
ORDER BY  DATEPART(yyyy, InvoiceDate) ASC;

/*Question 15: Employees’ name, birthday, hire date, years of working with company, address, 
 * city, state, country, title, manager and manager’s title*/

SELECT 	CONCAT(FirstName, CONCAT(' ',LastName)) AS 'Employee Name',
		FORMAT(BirthDate,'yyyy-MM-dd') AS 'Birth Date',
		FORMAT(HireDate,'yyyy-MM-dd') AS 'Hire Date',
		DATEDIFF(YEAR,HireDate,'2013-12-31') AS 'Yrs of Exp',
		Address, City, State, Country,
		Title,	
		(SELECT CONCAT(FirstName, CONCAT(' ',LastName)) FROM Employee e2 WHERE e.ReportsTo=e2.EmployeeId) AS 'Manager Name',
        (SELECT Title FROM Employee e2 WHERE e.ReportsTo=e2.EmployeeId) AS 'Manager Title'
FROM Employee e;

/*Question 16: Total sales $ by employee age at the time of the invoice d*/

SELECT 	CONCAT(e.FirstName, CONCAT(' ',e.LastName)) AS 'Employee Name', 
		FORMAT(InvoiceDate,'yyyy-MM-dd') AS 'InvoiceDate',
		DATEDIFF(YEAR,e.BirthDate,i.InvoiceDate) AS 'Age',
		CONCAT(SUM(Total), 'USD')  
FROM Employee e JOIN Customer c ON e.EmployeeId = c.SupportRepId 
JOIN Invoice i ON i.CustomerId = c.CustomerId
GROUP BY CONCAT(e.FirstName, CONCAT(' ',e.LastName)), 
		 DATEDIFF(YEAR,e.BirthDate,i.InvoiceDate),
		 InvoiceDate
ORDER BY CONCAT(e.FirstName, CONCAT(' ',e.LastName)) ASC, InvoiceDate ASC;	

/*Question 17: Total sales $ by employees who are in their 30s, 40s, 50s and 60s */

SELECT 	CONCAT(e.FirstName, CONCAT(' ',e.LastName)) AS 'Employee Name', 
CASE 
		WHEN DATEDIFF(YEAR,e.BirthDate,i.InvoiceDate) BETWEEN 30 AND 39 THEN '30-39'
		WHEN DATEDIFF(YEAR,e.BirthDate,i.InvoiceDate) BETWEEN 40 AND 49 THEN '40-49'
		WHEN DATEDIFF(YEAR,e.BirthDate,i.InvoiceDate) BETWEEN 50 AND 59 THEN '50-59'
		WHEN DATEDIFF(YEAR,e.BirthDate,i.InvoiceDate) BETWEEN 60 AND 69 THEN '60-69'
		END AS 'Age_range',
		CONCAT(SUM(Total), ' USD')  
FROM Employee e JOIN Customer c ON e.EmployeeId = c.SupportRepId 
JOIN Invoice i ON i.CustomerId = c.CustomerId
GROUP BY CONCAT(e.FirstName, CONCAT(' ',e.LastName)), 
CASE 
		WHEN DATEDIFF(YEAR,e.BirthDate,i.InvoiceDate) BETWEEN 30 AND 39 THEN '30-39'
		WHEN DATEDIFF(YEAR,e.BirthDate,i.InvoiceDate) BETWEEN 40 AND 49 THEN '40-49'
		WHEN DATEDIFF(YEAR,e.BirthDate,i.InvoiceDate) BETWEEN 50 AND 59 THEN '50-59'
		WHEN DATEDIFF(YEAR,e.BirthDate,i.InvoiceDate) BETWEEN 60 AND 69 THEN '60-69'
END
ORDER BY SUM(Total) DESC;




