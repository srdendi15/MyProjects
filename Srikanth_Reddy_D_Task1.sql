Create Database LibararyManagement;

Use LibararyManagement;

-- Creating Members table
CREATE TABLE Members (
MemberID INT PRIMARY KEY,
FullName VARCHAR(50) NOT NULL,
Address1 VARCHAR(100) NOT NULL,
DateOfBirth DATE NOT NULL,
UserName VARCHAR(50) NOT NULL,
Password VARCHAR(50) NOT NULL,
Email VARCHAR(50),
PhoneNumber VARCHAR(20),
MembershipEndDate DATE DEFAULT NULL
);


-- Creating Overdue_Fines table
CREATE TABLE Overdues (
FineID INT PRIMARY KEY,
MemberID INT NOT NULL,
OverdueFines DECIMAL(8,2) NOT NULL,
Amountrepaid DECIMAL(8,2) NOT NULL,
OustandingBalance DECIMAL(8,2) NOT NULL,
RepaymentDate DATETIME NOT NULL,
RepaymentMethod VARCHAR(10) NOT NULL,
CONSTRAINT Fk_Overdue_Fines_Members FOREIGN KEY (MemberID)
REFERENCES Members(MemberID)
);

-- Creating Item Types table

CREATE TABLE ItemTypes (
ItemTypeID INT PRIMARY KEY,
ItemTypeName VARCHAR(20) NOT NULL
);


-- Creating Status table
CREATE TABLE Status (
StatusID INT PRIMARY KEY,
StatusNAME VARCHAR(20) NOT NULL
);

-- Creating Items table
CREATE TABLE ITEMS (
ItemID INT PRIMARY KEY,
ItemTitle VARCHAR(50) NOT NULL,
ItemTypeID INT NOT NULL,
Author VARCHAR(50) NOT NULL,
YearOfPublication INT NOT NULL,
AddedDate DATE NOT NULL,
CurrentStatusID INT NOT NULL,
date_identified_lost_removed DATE DEFAULT NULL,
ISBN VARCHAR(20),
CONSTRAINT FK_Items_Types FOREIGN KEY (ItemTypeID)
REFERENCES ItemTypes(ItemTypeID),
CONSTRAINT FK__Status FOREIGN KEY (CurrentStatusID)
REFERENCES Status(StatusID)
);

CREATE TABLE Loan (
LoanID INT PRIMARY KEY,
MemberID INT NOT NULL,
ItemID INT NOT NULL,
DateTakenOut DATE NOT NULL,
DueDate DATE NOT NULL,
Returneddate DATE DEFAULT NULL,
OverdueFine DECIMAL(10,2) DEFAULT NULL,
CONSTRAINT FK_Loan_Members FOREIGN KEY (MemberID)
REFERENCES Members(MemberID),
CONSTRAINT FK_Loan_Item FOREIGN KEY (ItemID)
REFERENCES ITEMS(ItemID)
);

/* Q6) So that you can demonstrate the database to the client you should insert some records 
into each of the tables (you only need to add a small number of rows to each, 
however, you should also ensure the data you input allows you to adequately test that 
all SELECT queries, user-defined functions, stored procedures, and triggers are working 
as you expect).
*/

INSERT INTO Members (MemberID, FullName, Address1, DateOfBirth, UserName, Password, Email, PhoneNumber)
VALUES (1, 'Srikanth reddy', '1 Picadillyy', '2000-01-01', 'srikanth1', 'srikanth2', 'srikanth@email.com', '783-333-4343'),
(2, 'Ehthu Like', '3 salford Street', '1995-03-04', 'ethu1', 'ethu2', NULL, NULL),
(3, 'siva mamm', '34 child Street', '1990-04-08', 'siva1', 'siva2', 'siva@email.com', '345-345-5555'),
(4, 'jamm pik', '12 hela Street', '1994-03-02', 'jam1', 'jam2', NULL, NULL);

INSERT INTO Overdues (FineID, MemberID, OverdueFines, Amountrepaid, OustandingBalance, RepaymentDate, RepaymentMethod)
VALUES (1, 1, 10.50, 5.50, 5.00, '2023-03-01 10:30:00', 'CASH'),
(2, 2, 8.50, 3.50, 5.00, '2023-05-02 11:20:00', 'CARD'),
(3, 3, 15.00, 0.00,0.00, '2023-03-15 14:45:00', 'CARD');

--Inserting tables for ItemTypes
INSERT INTO ItemTypes(ItemTypeID, ItemTypeName)
VALUES (1, 'Book'),
(2, 'DVD'),
(3, 'Journal'),
(4, 'Other Media');

--Inserting tables for status

INSERT INTO Status (StatusID, StatusNAME)
VALUES (1, 'On Loan'),
(2, 'Overdue'),
(3, 'Available'),
(4, 'Lost/Removed');

--Inserting values for Items

INSERT INTO ITEMS(ItemID, ItemTitle, ItemTypeID, Author, YearOfPublication, AddedDate, CurrentStatusID, date_identified_lost_removed , ISBN)
VALUES (1, 'The Jimmy', 2, 'Gapil', 1925, '2023-03-02', 3, NULL, '978-3-16-147440-0'),
(2, 'Halla', 1, 'Sarri', 1836, '2023-03-09', 1, NULL, NULL),
(3, 'Therapy', 1, 'Peter Godse', 1994, '2023-03-16', 3, NULL, NULL),
(4, 'The Fire War', 3, 'habbi Tab', 1912, '2023-03-21', 1, NULL, '978-3-16-148411-0');

-- Inserting data into Loans table
INSERT INTO Loan(LoanID, MemberID, ItemID, DateTakenOut, DueDate, Returneddate, OverdueFine)
VALUES (1, 1, 1, '2023-03-10', '2023-03-24', NULL, NULL),
(2, 2, 2, '2023-03-05', '2023-03-15', NULL, NULL),
(3, 1, 3, '2023-03-10', '2023-03-24', NULL, NULL),
(4, 2, 4, '2023-03-15', '2023-03-29', NULL, NULL);

/*--Q2 a)  Search the catalogue for matching character strings by title. Results should be 
sorted with most recent publication date first. This will allow them to query the 
catalogue looking for a specific item.*/

CREATE PROCEDURE ItemSearch
@title VARCHAR(50)
AS
SELECT ItemTitle, ItemTypeID, Author, YearOfPublication, CurrentStatusID, ISBN
FROM ITEMS
WHERE ItemTitle LIKE '%' + @title + '%'
ORDER BY YearOfPublication DESC

Exec ItemSearch @title = 'The Jimmy'

/*Q2 b) Return a full list of all items currently on loan which have a due date of less 
than five days from the current date (i.e., the system date when the query is 
run)
*/
 
 CREATE PROCEDURE ItemsOnLoan
AS
SELECT ITEMS.ItemTitle, Members.FullName, Loan.DueDate
FROM Loan
INNER JOIN Members ON Loan.MemberID = Members.MemberID
INNER JOIN ITEMS ON Loan.ItemID = ITEMS.ItemID
WHERE Loan.Returneddate IS NULL AND DATEDIFF(day, GETDATE(), Loan.DueDate) <= 5

Exec ItemsOnLoan;

/* Q2 c) Insert a new member into the database */

CREATE PROCEDURE InsertMember
@FullName VARCHAR(50),
@Address1 VARCHAR(100),
@DateOfBirth DATE,
@UserName VARCHAR(20),
@Password VARCHAR(20),
@Email VARCHAR(50) = NULL,
@PhoneNumber VARCHAR(20) = NULL
AS
INSERT INTO Members (FullName, Address1, DateOfBirth, UserName, Password, Email, PhoneNumber)
VALUES (@FullName, @Address1, @DateOfBirth, @UserName, @Password, @Email, @PhoneNumber)

EXEC InsertMember 'Honey', '44 chirag St', '1992-01-04', 'chirag1', 'chirag2','chirah@email.com','983-444-43439'

/* Q2 d) Update the details for an existing member*/

CREATE PROCEDURE UpdateMember
@MemberID INT,
@FullName VARCHAR(50),
@Address1 VARCHAR(100),
@DateOfBirth DATE,
@UserName VARCHAR(20),
@Password VARCHAR(20),
@Email VARCHAR(50) = NULL,
@PhoneNumber VARCHAR(20) = NULL,
@MembershipEndDate DATE = NULL
AS
UPDATE Members
SET FullName = @FullName,
Address1 = @Address1,
DateOfBirth = @DateOfBirth,
UserName = @UserName,
password = @Password,
Email = @Email,
PhoneNumber = @PhoneNumber,
MembershipEndDate = @MembershipEndDate
WHERE MemberID = @MemberID

EXEC UpdateMember @MemberID = 3, @FullName = 'Paultly', @Address1 = 'Oxford3 St', 
@DateOfBirth = '1998-03-01', @UserName = 'paul1ty', @Password = 'pault2', @Email = 'paultt@email.com', @PhoneNumber = '6260-777-9999'

select * from Members;

/* Q3
 The library wants be able to view the loan history, showing all previous and current 
loans, and including details of the item borrowed, borrowed date, due date and any 
associated fines for each loan. You should create a view containing all the required 
information.*/CREATE VIEW LoanHistory AS
SELECT Loan.LoanID, Members.FullName, ITEMS.ItemTitle, Loan.DateTakenOut, Loan.DueDate, Loan.Returneddate, Loan.OverdueFine
FROM Loan
INNER JOIN Members ON Loan.MemberID = Members.MemberID
INNER JOIN ITEMS ON Loan.ItemID = ITEMS.ItemID

/* Q4 Create a trigger so that the current status of an item automatically updates to 
Available when the book is returned.*/

CREATE TRIGGER UpdateStatusReturn
ON Loan
AFTER UPDATE
AS
IF UPDATE(Returneddate)
BEGIN
UPDATE ITEMS
SET CurrentStatusID = 3 -- 3 means it represents "Available"
FROM ITEMS
INNER JOIN deleted ON ITEMS.ItemID = deleted.ItemID
WHERE ITEMS.CurrentStatusID = 1 -- 1 means it represents "On Loan"
AND deleted.Returneddate IS NOT NULL
END

/* Q5 You should provide a function, view, or SELECT query which allows the library to 
identify the total number of loans made on a specified date.*/
SELECT COUNT(*) AS total_loans
FROM Loan
WHERE DateTakenOut = '2023-03-10' ;

/*Q7 If there are any other database objects such as views, stored procedures, user-defined 
functions, or triggers which you think would be relevant to the library given the brief 
above, you will obtain higher marks for providing these along with an explanation of 
their functionality.
*/

--FUNCTION PRINTS TO THE TOTAL NUMBER OF OVERDUE LOANS
 
 CREATE FUNCTION TotalOverdueLoan
()
RETURNS INT
AS
BEGIN
DECLARE @total_loans INT
SELECT @total_loans = COUNT(*)
FROM Loan
WHERE DueDate < GETDATE() AND Returneddate IS NULL
RETURN @total_loans
END

