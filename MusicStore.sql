Use master 
Go

If DB_ID('MusicStore') is NOT Null
	Drop Database MusicStore
Go

Create Database MusicStore
Go

Use MusicStore 
Go

Create Table Employees(
	EmpID Varchar(20) Primary Key ,
	EmpFirstName Varchar(20) Not Null,
	EmpLastName Varchar(20) Not Null,
	EmpPhone# Varchar(20) Not Null,
	SalesCommission smallmoney Not Null,
	RentalCommission Money Not Null,
	LessonSignUpCommission money Not Null,
	StudentsSignedUp int,
)
Go

Alter Table Employees
Add EmployeeRate money, HoursWorked int;
Go

Create Table EmployeeArchive(    /* Use trigger to populate  */
	EmpID Varchar(20) Primary Key ,
	EmpFirstName Varchar(20) Not Null,
	EmpLastName Varchar(20) Not Null,
	EmpPhone# Varchar(20) Not Null,
)
Go

Create Table Customers(
	CustID Varchar(20) Primary Key,
	CustFirstName Varchar(20) Not Null,
	CustLastName Varchar(20) Not Null,
	CustEmail Varchar(50) Not Null,
	CustPhone# Varchar(20) Not NUll,
)
Go

Alter Table Customers
Add CustomerAddress varchar(40), CustState varchar(5), CustomerZip varchar(10)
Go 

Create Table Instructors(
	InstructorID varchar(20) Primary Key,
	InstructorFirstName Varchar(20) Not Null,
	InstructorLastName Varchar(20) Not Null,
	InstructorPhone# Varchar(20) Not Null,
	InstructorInstrument Varchar(20) Not Null,
	InstructorRate money Not Null,
	NumberOfStudents int,
)
Go

Create Table Students(
	StudentID Varchar(20) Primary Key,
	InstructorID Varchar(20) Not Null References Instructors (InstructorID),
	StudentFName Varchar(20) Not NUll,
	StudentLName Varchar(20) Not Null,
	StudentInstrument Varchar(20) Not Null,
)
Go

Create NonClustered Index Students
	On Students(InstructorID)
Go

Alter Table Students
Add LessonTime varchar(10), LessonDay varchar(10)
Go

Create Table SalesInventory(
	Item# Varchar(20) Primary Key,
	ItemDescription Varchar (50) Not Null,
	ItemCost money Not Null, 
	QuantitySold int,
)
Go

Alter Table SalesInventory Drop Column QuantitySold;

Alter Table SalesInventory 
Add Serial#Sales varchar (10), InStockSales int
Go

Create Table RentalInventory(
	RentalInstID Varchar(20) Primary Key,
	InstrumentDescription Varchar(20) Not Null,
	Make Varchar (20) Not Null,
	RentalCost money not Null,
	NewOrUsed varchar(10) Not Null,
	QuantityRented int,
)
Go

Alter Table RentalInventory 
Add Serial#Rentals varchar(10), InStockRentals int
Go

Alter Table RentalInventory Drop Column QuantityRented;

Create Table Payroll(
	CheckID Varchar(20) Primary Key,
	EmpID Varchar(20) Not Null References Employees (EmpID),
	EmployeeNetPay money,
	InstructorID varchar(20) Not Null references Instructors (InstructorID),
	InstructorNetPay money,
)
Go

Create Nonclustered Index Payroll
	On Payroll(EmpID, InstructorID)
Go

Alter Table Payroll
Add DateOfCheck date
Go

Alter Table Payroll Drop Column EmployeeNetPay, InstructorNetPay


Create Table Sales(
	SalesInvoiceID Varchar(20) Primary Key,
	EmpID Varchar(20) Not Null references Employees (EmpID),
	CustID Varchar(20) Not Null references Customers (CustID),
	Item# Varchar(20) Not Null references SalesInventory (Item#),
)
Go 

Create Nonclustered Index Sales
	On Sales(EmpID, CustID, Item#)
Go

Alter Table Sales
Add QuantitySold int, SaleDate Date;
Go

Create Table Rentals(
	RentalInvoiceID Varchar(20) Primary Key,
	RentalInstID Varchar(20) Not Null references RentalInventory (RentalInstID),
	CustID Varchar(20) Not Null references Customers (CustID),
	EmpID Varchar(20) Not Null references Employees (EmpID),
)
Go

Alter Table Rentals
Add QuantityRented int, RentalDate date;
Go

Create Nonclustered Index Rentals
	On Rentals (RentalInstID, CustID, EmpID)
Go

Insert Employees(EmpID, EmpFirstName, EmpLastName, EmpPhone#, SalesCommission, RentalCommission,
	   LessonSignUpCommission, StudentsSignedUp, EmployeeRate, HoursWorked )
	   Values ('1', 'Miles', 'Davis', '123-4567', .1, 5, 10, 4, 15, 35),
			  ('2', 'Charlie', 'Parker', '234-5678', .1, 5, 10, 6, 14, 30),
			  ('3', 'Dizzy', 'Gillespie', '345-6789', .12, 5, 10, 3, 14, 32),
			  ('4', 'Thelonious', 'Monk', '456-7890', .15, 5, 10, 8, 13, 25),
			  ('5', 'Max', 'Roach', '567-8901', .1, 5, 10, 5, 14, 40),
			  ('6','Stanley','Clark','678-9012',.1,5,10,9,15,38 ),
			  ('7','Joe','Smith','789-0123',.1,5,10,3,12,32 ),
			  ('8','Jane','Doe','890-1234',.1,5,10,5,12, 34),
			  ('9','Pablo','Escobar','901-2345',.12,5,10,2,14,34),
			  ('10','Charlie','Christian','012-3456',.1,5,10,6,15,37)
Go

/*  Trigger to update CustState to uppercase.  Triggered when 
    data is inserted into table, and when table is updated  */
Create Trigger UpdateCustState
	On Customers
	After Insert, UPDATE
As 
	Update Customers
	Set CustState = UPPER(CustState)
	Where CustID In (Select CustID From Inserted)
Go

Insert Customers(CustID, CustFirstName, CustLastName, CustEmail, CustPhone#, CustomerAddress,
				 CustState, CustomerZip)
	   Values ('1', 'Charles', 'Mingus', 'jazzbass@gmail.com', '123-4556', '123 Jazz Rd.', 'nc', '11101'),
		      ('2', 'Philly', 'Jones', 'swingdrum@yahoo.com', '234-4567', '234 Swing St.','nc', '11101'),
			  ('3', 'Elvin', 'Jones', 'iheartjazz@gmail.com', '345-6789', '345 Improv Ave.','nc', '11101'),
			  ('4', 'Jack', 'DeJohnette', 'sabianguy@bellsouth.net', '456-7890', '456 Melody Ct.','nc','11102'),
			  ('5', 'Chick', 'Corea', 'keysplease@gmail.com', '567-8901', '567 Spain Blvd.','nc','11102' )
Go

Insert Instructors(InstructorID, InstructorFirstName, InstructorLastName, InstructorPhone#,/*City,Staet, Zip?*/
	   InstructorInstrument,InstructorRate, NumberOfStudents)
	   Values ('1', 'Bill', 'Evans', '123-4567', 'Piano', 25, 10),
			  ('2', 'Chris', 'Potter', '234-5678', 'Saxophone', 30, 8),
			  ('3', 'Bill', 'Stewart', '345-6789', 'Drum Set', 30, 12),
			  ('4', 'Roy', 'Haynes', '456-7890', 'Drum Set', 40, 5),
			  ('5', 'Wes', 'Montgomery', '567-8901', 'Guitar', 25, 15),
			  ('6', 'Avishai', 'Cohen', '123-4567', 'Bass', 25, 10),
			  ('7', 'Dan', 'Smith', '234-5678', 'Drums', 30, 15),
			  ('8', 'Will', 'Chacon', '345-6778', 'Drums', 25, 8),
			  ('9', 'Jason', 'Moore', '456-7890', 'Bass', 25, 5),
			  ('10', 'Bob', 'Russell', '567-8901', 'Guitar', 30, 12)
Go

Insert Students(StudentID, InstructorID, StudentFName, StudentLName, StudentInstrument, LessonDay, LessonTime)
	   Values ('1', '3', 'Brian', 'Mason', 'Drum Set','Monday' ,'3:00' ),
			  ('2', '5','Brett', 'Johnson', 'Guitar','Monday' ,'4:00' ),
			  ('3', '4', 'Some', 'Guy', 'Drum Set','Monday' ,'5:00' ),
			  ('4', '2', 'Joe', 'Smith', 'Saxophone','Tuesday' ,'3:00' ),
			  ('5', '1', 'This', 'Dude', 'Piano','Tuesday' ,'4:00' ),
			  ('6', '3', 'Drum', 'Person', 'Drum Set','Tuesday' ,'5:00' )
Go

Insert SalesInventory (Item#, ItemDescription, ItemCost, InStockSales, Serial#Sales)
	   Values ('1', 'Drum Set', 799.99, 10,'A1B2C3' ),                       
			  ('2', 'Electric Guitar', 499.99, 10,'D4E5F6' ),
			  ('3', 'Guitar Amp', 399.99, 10, 'G7H8I9' ),
			  ('4', 'Keyboard', 699.99, 10, 'J0K1L2' ),
			  ('5', 'Electric Bass', 599.99, 10, 'M3N4O5')
Go

/*  Trigger to set U = Used*/
Create Trigger ChangeUsed
	On RentalInventory
	After Insert, Update
As
	Update RentalInventory 
	Set NewOrUsed = 'Used'
	Where RentalInstID In (Select RentalInstID From Inserted)
Go 	

Insert RentalInventory (RentalInstID, InstrumentDescription,Make,RentalCost, InStockRentals, NewOrUsed, Serial#Rentals) 
	   Values ('1', 'Clarinet', 'Jupiter', 25, 10, 'U','12345'),
			  ('2', 'Trumpet', 'Bach', 25, 10, 'U', '23456'),
			  ('3', 'Clarinet', 'Jupiter', 28, 10, 'U', '34567'),
			  ('4', 'Saxophone', 'Selmer', 40, 10,'U', '45678'),
			  ('5', 'PercussionKit', 'Pearl', 30, 10, 'U', '56789'),
			  ('6', 'Euphonium', 'Jupiter', 45, 3, 'U','12345')
Go

Insert Payroll(CheckID, EmpID, InstructorID, DateOfCheck) 
	   Values ('100', '1', '1', '2016-09-15'),
			  ('101', '2',  '2','2016-09-15'),
			  ('102', '3', '3','2016-09-15'),
			  ('103', '4',  '4','2016-09-15'),
			  ('104', '5',  '5','2016-09-15' ),
			  ('105', '6','6','2016-09-15'),
			  ('106', '7','7','2016-09-15'),
			  ('107', '8','8','2016-9-15'),
			  ('108', '9','9', '2016-09-15'),
			  ('109','10','10', '2016-09-15')

Go

Insert Sales (SalesInvoiceID, EmpID, CustID, Item#, QuantitySold, SaleDate)
	   Values ('200', '1', '2', '2', 2, '2016-02-12'),
		      ('201', '2', '3', '4', 1, '2016-03-13'),
			  ('202', '3', '1', '3', 3,'2016-02-15'),
			  ('203', '4', '4', '1', 2, '2016-03-12'),
			  ('204', '5', '5', '5', 4, '2016-04-22')
Go

Insert Rentals (RentalInvoiceID, RentalInstID, CustID, EmpID, QuantityRented, RentalDate)
	   Values ('301', '1', '2', '3', 2,'2016-08-21'),
			  ('302', '2', '4', '2', 1,'2016-08-24'),
			  ('303', '5', '3', '1', 1,'2016-08-22'),
			  ('304', '3', '5', '4', 1,'2016-08-29'),
			  ('305', '4', '1', '5', 1,'2016-09-02')
			  
Go

/*       Stored Procedures     */
/*  Calculates Instructor pay.  User inputs instructor number, and total pay 
	is calculated.  */
Create Proc spInstructorPay
		@Instructor varchar(10),
		@InstructorPay money OUTPUT
As
Select @InstructorPay = InstructorRate * NumberOfStudents
From Instructors
Where @Instructor = InstructorID 
Go

/*Calculates employee pay.  User inputs employee number, and total pay is calculated  */
Create Proc spEmployeePay
	@Employee varchar (20),
	@EmployeePay money OUTPUT
As
Select @EmployeePay = (HoursWorked * EmployeeRate) +
	                  ((ItemCost * SalesCommission) * Sales.QuantitySold) +
					  (RentalCommission * QuantityRented) +
					  (LessonSignUpCommission * StudentsSignedUp)
From Employees Join Sales On Employees.EmpID = Sales.EmpID
			   Join SalesInventory On Sales.Item# = SalesInventory.Item#
			   Join Rentals On Employees.EmpID = Rentals.EmpID
Where @Employee = Employees.EmpID
Go

/*  User inputs zip code to find customers in that area.  */
Create Proc spCustomerFinder
	@CustomerZip varchar (10)
As 
Select CustFirstName, CustLastName, ItemDescription
From Customers join Sales On Customers.CustID = Sales.CustID
			   join SalesInventory On Sales.Item# = SalesInventory.Item#
Where @CustomerZip = CustomerZip
Go

/* User inputs a date, and the procedure calculates the sales
   from that point on.   */
Create Proc spSalesSince
	@SaleDate date,
	@TotalSales money OUTPUT
As
Select Serial#Sales, ItemDescription, SaleDate, EmpFirstName, EmpLastName, CustFirstName, 
	   CustLastName,ItemCost,QuantitySold 
From Sales join Employees On Sales.EmpID = Employees.EmpID
		   join Customers On Sales.CustID = Customers.CustID
		   join  SalesInventory On SalesInventory.Item# = Sales.Item#
Select @TotalSales = SUM(ItemCost * QuantitySold)
From Sales join SalesInventory On Sales.Item# = SalesInventory.Item#
Where SaleDate >= @SaleDate
Go

/*  The user inputs a date, and the procedure calculates the rentals from that 
    from that point on.  */
Create Proc spRentalsSince 
	@RentalDate date,
	@TotalRentals money OUTPUT
As 
Select EmpFirstName, EmpLastName, CustFirstName, CustLastName, InstrumentDescription, Make, 
	   RentalCost, NewOrUsed, QuantityRented 
From RentalInventory Join Rentals On Rentals.RentalInstID = RentalInventory.RentalInstID 
					 Join Employees on Employees.EmpID = Rentals.EmpID
					 Join Customers On Customers.CustID = Rentals.CustID
Select @TotalRentals = SUM(RentalCost * QuantityRented)
From Rentals Join RentalInventory On Rentals.RentalInstID = RentalInventory.RentalInstID 
Where RentalDate >= @RentalDate
Go

/*    Trigger populates the 'EmployeeArchive' table after an employee
	  is deleted from the 'Employees' table,  */
Create Trigger EmployeeDelete
	On Employees
	After Delete
AS 
	Insert Into EmployeeArchive 
			   ( EmpFirstName, EmpLastName, EmpPhone#)
			   Select 
			    EmpFirstName, EmpLastName, EmpPhone#
			   From Deleted
Go

/*  Displays relevent customer info  */
Create View CustomerRecords 
As 
Select Customers.CustID, CustFirstName, CustLastName, CustEmail, ItemDescription, SaleDate , 
	   InstrumentDescription, RentalDate
From Customers join Sales On Customers.CustID = Sales.CustID
			   join SalesInventory On Sales.Item# = SalesInventory.Item#
			   join Rentals On Rentals.CustID = Customers.CustID
			   join RentalInventory On Rentals.RentalInstID = RentalInventory.RentalInstID
Go

/*  Displays student info:  Time, instructor, instrument, etc. */
Create View LessonFinder 
As
Select StudentFName, StudentLName, StudentInstrument, InstructorFirstName,
	   InstructorLastName, LessonDay, LessonTime
From Instructors Left Join Students On Students.InstructorID = Instructors.InstructorID
Go

/*  Displays Employee paycheck info  */
Create View EmployeePaycheck
As 
Select CheckID, Employees.EmpID, EmpFirstName, EmpLastName, DateOfCheck
From Payroll join Employees On Payroll.EmpID = Employees.EmpID
Go

/*  Displays Instructor paycheck info  */
Create View InstructorPaycheck
As 
Select CheckID, Instructors.InstructorID, InstructorFirstName, InstructorLastName, DateOfCheck
From Payroll join Instructors on Payroll.InstructorID = Instructors.InstructorID
Go

/*  Displays the top-selling Employees  */
Create View TopSales
As 
Select Top 3 Employees.EmpID, EmpFirstName, EmpLastName, ItemDescription, ItemCost
From Employees join Sales On Employees.EmpID = Sales.EmpID
			   join SalesInventory On SalesInventory.Item# = Sales.Item#
Order By ItemCost Desc
Go

