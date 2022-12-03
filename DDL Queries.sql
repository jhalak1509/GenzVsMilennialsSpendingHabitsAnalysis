-----Tables-----

create table Consumer
(
ConsumerID Int not null,
[Name] varchar(25),
DateOfBirth date,
Gender varchar(10)
constraint Consumer_pk primary key (ConsumerID)
); 
--Consumer Table

Create table SocialMediaReviews
(
ReviewsID varchar(15) not null,
RatingForInstagram int,
RatingForFacebook int,
RatingForYoutube int,
ReferredToReviews Varchar(5),
Constraint SocialMediaReviews_pk primary key (ReviewsID),
Constraint RatingForInstagram_chk check(RatingForInstagram in (1,2,3,4,5)),
Constraint RatingForFacebook_chk check(RatingForFacebook in (1,2,3,4,5)),
Constraint RatingForYoutube_chk check(RatingForYoutube in (1,2,3,4,5)),
Constraint ReferredToReviews_chk check(ReferredToReviews in ('Yes', 'No'))
);
--SocialMediaReviews Table

Create table RefersTo
(
ConsumerID int not null,
ReviewsID Varchar(15) not null,
DateAndTime smalldatetime,
constraint ConsumerRefersTo_fk Foreign key (ConsumerID) references Consumer(ConsumerID),
constraint PlatfromRefersTo_fk Foreign key (ReviewsID) references SocialMediaReviews(ReviewsID)
);
--RefersTo Table

Create table ExpenseMedium
(
MediumID varchar(10) not null,
MemberDiscount varchar(5),
MediumType varchar(20),
Constraint MemberDiscount_chk check(MemberDiscount in ('Yes', 'No')),
Constraint MediumType_chk check(MediumType in ('Physical Store', 'Online')),
constraint ExpenseMedium_pk primary key (MediumID)
);
--ExpenseMedium Table


create table PhysicalStore
(
PhysicalMediumID varchar(10) not null,
StoreType Varchar(20),
Constraint StoreType_chk check(StoreType in ('Outlet','Distributor','Wholesale')),
constraint PhysicalMedium_fk Foreign key (PhysicalMediumID) references ExpenseMedium(MediumID)
);
--PysicalStore Table


create table [Online]
(
OnlineMediumID varchar(10) not null,
ShoppingMedium Varchar(20),
ExpressDelivery varchar(5),
Constraint ShoppingMedium_chk check(ShoppingMedium in ('Mobile Application','Website')),
Constraint ExpressDelivery_chk check(ExpressDelivery in ('Yes', 'No')),
constraint OnlineMedium_fk Foreign key (OnlineMediumID) references ExpenseMedium(MediumID)
);
--Online Table

create table Expense
(
ExpenseID varchar(10) not null,
ConsumerID Int not null,
MediumID varchar(10) not null,
ExpenseLevel varchar(10),
ExpenseSupporting varchar(20),
ApparelExpenseRating int,
FoodExpenseRating int,
TravelExpenseRating int,
ElectronicsExpenseRating int,
EntertainmentExpenseRating int,
ExpenseType varchar(20),
Constraint ExpenseType_chk check(ExpenseType in ('Apparel','Food','Travel','Electronics','Entertainment')),
Constraint ExpenseLevel_chk check(ExpenseLevel in ('Luxury', 'Comfort')),
Constraint ExpenseSupporting_chk check(ExpenseSupporting in ('Sustainable', 'Non-Sustainable')),
Constraint ApparelExpenseRating_chk check(ApparelExpenseRating in (1,2,3,4,5)),
Constraint FoodExpenseRating_chk check(FoodExpenseRating in (1,2,3,4,5)),
Constraint TravelExpenseRating_chk check(TravelExpenseRating in (1,2,3,4,5)),
Constraint ElectronicsExpenseRating_chk check(ElectronicsExpenseRating in (1,2,3,4,5)),
Constraint EntertainmentExpenseRating_chk check(EntertainmentExpenseRating in (1,2,3,4,5)),
constraint Expense_pk primary key (ExpenseID),
constraint Consumer_fk1 Foreign key (ConsumerID) references Consumer(ConsumerID),
constraint ExpenseMedium_fk2 Foreign key (MediumID) references ExpenseMedium(MediumID)
);
--Expense Table



Create table Apparel
(
ApparelExpenseID varchar(10) not null,
RatingForClothing int,
RatingForFootwear int,
RatingForAccessories int,
Constraint RatingForClothing_chk check(RatingForClothing in (1,2,3,4,5)),
Constraint RatingForFootwear_chk check(RatingForFootwear in (1,2,3,4,5)),
Constraint RatingForAccessories_chk check(RatingForAccessories in (1,2,3,4,5)),
constraint ApparelExpense_fk Foreign key (ApparelExpenseID) references Expense(ExpenseID),
);
--Apparel Table


Create table Food(
FoodExpenseID varchar(10) not null,
EatingOutFrequency Varchar(50),
constraint FoodExpense_fk Foreign key (FoodExpenseID) references Expense(ExpenseID),
);
--Food Table


Create table Travel
(
TravelExpenseID varchar(10) not null,
Airways int,
Roadways int,
Waterways int,
Railways int,
Constraint AirwaysTravel_chk check(Airways in (1,2,3,4,5)),
Constraint RoadwaysTravel_chk check(Roadways in (1,2,3,4,5)),
Constraint WaterwaysTravel_chk check(Waterways in (1,2,3,4,5)),
Constraint RailwaysTravel_chk check(Railways in (1,2,3,4,5)),
Constraint TravelExpense_fk Foreign key (TravelExpenseID) references Expense(ExpenseID),
);
--Travel Table


Create table Electronics
(
ElectronicsExpenseID varchar(10) not null,
GadgetType varchar(50),
constraint ElectronicsExpense_fk Foreign key (ElectronicsExpenseID) references Expense(ExpenseID),
);
--Electronics Table


Create table Entertainment
(
EntertainmentExpenseID varchar(10) not null,
RatingForMusic int,
RatingForMovies int,
Constraint RatingForMusic_chk check(RatingForMusic in (1,2,3,4,5)),
Constraint RatingForMovies_chk check(RatingForMovies in (1,2,3,4,5)),
constraint EntertainmentExpense_fk Foreign key (EntertainmentExpenseID) references Expense(ExpenseID),
);
-- Entertainment Table




-----Views-----

create view View_Apparel As 
Select DATEDIFF(YYYY,c.DateofBirth,GETDATE()) AS Age, e.ExpenseType, a.RatingForClothing, a.RatingForFootwear, a.RatingForAccessories
from consumer c 
inner join Expense e on c.ConsumerID = e.ConsumerID 
inner join Apparel a on a.ApparelExpenseID = e.ExpenseID
where ExpenseType like 'Apparel'

create view View_Food As 
Select DATEDIFF(YYYY,c.DateofBirth,GETDATE()) AS Age, e.ExpenseType, f.EatingOutFrequency
from consumer c 
inner join Expense e on c.ConsumerID = e.ConsumerID 
inner join Food f on f.FoodExpenseID = e.ExpenseID
where ExpenseType like 'Food'

create view View_Travel As 
Select DATEDIFF(YYYY,c.DateofBirth,GETDATE()) AS Age, e.ExpenseType, t.Airways, t.Roadways, t.Waterways, t.Railways
from consumer c 
inner join Expense e on c.ConsumerID = e.ConsumerID 
inner join Travel t on t.TravelExpenseID = e.ExpenseID
where ExpenseType like 'Travel'

create view View_Electronics As 
Select DATEDIFF(YYYY,c.DateofBirth,GETDATE()) AS Age, e.ExpenseType, el.GadgetType
from consumer c 
inner join Expense e on c.ConsumerID = e.ConsumerID 
inner join Electronics el on el.ElectronicsExpenseID = e.ExpenseID
where ExpenseType like 'Electronics'

create view View_Entertainment As 
Select DATEDIFF(YYYY,c.DateofBirth,GETDATE()) AS Age, e.ExpenseType, en.RatingForMovies, en.RatingForMusic
from consumer c 
inner join Expense e on c.ConsumerID = e.ConsumerID 
inner join Entertainment en on en.EntertainmentExpenseID = e.ExpenseID
where ExpenseType like 'Entertainment'


-----Triggers-----

Create TRIGGER TR_ExpenseDelete ON Expense
INSTEAD OF DELETE
AS
BEGIN
  Select 'Cannot delete data from Expense Table' as [Message]
END

CREATE TRIGGER TR_ExpenseInsert ON Expense
INSTEAD OF INSERT
AS
BEGIN
  Select 'Cannot insert data into Expense Table' as [Message]
END

CREATE TRIGGER TR_ExpenseUpdate ON Expense
INSTEAD OF UPDATE
AS
BEGIN
  Select 'Cannot update data in Expense Table' as [Message]
END


-----Stored Procedures-----

create proc sp_Genz as
begin 
select DATEDIFF(YYYY,c.DateofBirth,GETDATE()) AS Age, e.ExpenseType, e.ExpenseLevel, e.ExpenseSupporting, a.RatingForClothing, a.RatingForFootwear, 
a.RatingForAccessories, f.EatingOutFrequency, t.Airways, t.Roadways, t.Waterways, t.Railways, el.GadgetType, en.RatingForMovies, en.RatingForMusic,em.MemberDiscount, p.StoreType, o.ShoppingMedium, o.ExpressDelivery
from Consumer c 
inner join Expense e on c.ConsumerID = e.ConsumerID
inner join Apparel a on a.ApparelExpenseID = e.ExpenseID
inner join Food f on f.FoodExpenseID = e.ExpenseID
inner join Travel t on t.TravelExpenseID = e.ExpenseID
inner join Electronics el on el.ElectronicsExpenseID = e.ExpenseID
inner join Entertainment en on en.EntertainmentExpenseID = e.ExpenseID
inner join ExpenseMedium em on em.MediumID = e.MediumID
inner join PhysicalStore p on p.PhysicalMediumID = em.MediumID
inner join [Online] o on o.OnlineMediumID = em.MediumID

where DATEDIFF(YYYY,c.DateofBirth,GETDATE()) between 10 and 25
end


create proc sp_Millennial as
begin 
select DATEDIFF(YYYY,c.DateofBirth,GETDATE()) AS Age, e.ExpenseType, e.ExpenseLevel, e.ExpenseSupporting, a.RatingForClothing, a.RatingForFootwear, 
a.RatingForAccessories, f.EatingOutFrequency, t.Airways, t.Roadways, t.Waterways, t.Railways, el.GadgetType, en.RatingForMovies, en.RatingForMusic,em.MemberDiscount, p.StoreType, o.ShoppingMedium, o.ExpressDelivery
from Consumer c 
inner join Expense e on c.ConsumerID = e.ConsumerID
inner join Apparel a on a.ApparelExpenseID = e.ExpenseID
inner join Food f on f.FoodExpenseID = e.ExpenseID
inner join Travel t on t.TravelExpenseID = e.ExpenseID
inner join Electronics el on el.ElectronicsExpenseID = e.ExpenseID
inner join Entertainment en on en.EntertainmentExpenseID = e.ExpenseID
inner join ExpenseMedium em on em.MediumID = e.MediumID
inner join PhysicalStore p on p.PhysicalMediumID = em.MediumID
inner join [Online] o on o.OnlineMediumID = em.MediumID

where DATEDIFF(YYYY,c.DateofBirth,GETDATE()) between 26 and 41
end


create proc sp_ReferredToReviews @answer varchar(5)
As
Begin 
select RatingForFacebook, RatingForInstagram, RatingForYoutube
from SocialMediaReviews where ReferredToReviews = @answer
end

-----Indexes-----

If exists (Select name from sys.indexes
			Where name = 'IX_Consumer_DOB')
Drop index IX_Consumer_DOB on Consumer;

Go

Create nonclustered index IX_Consumer_DOB 
on Consumer(DateofBirth);
Go

If exists (Select name from sys.indexes
			Where name = 'IX_Expense_ExpenseType')
Drop index IX_Expense_ExpenseType on Expense;

Go

Create nonclustered index IX_Expense_ExpenseType 
on Expense (ExpenseType);
Go



If exists (Select name from sys.indexes
			Where name = 'IX_ExpenseMedium_MediumType')
Drop index IX_ExpenseMedium_MediumType on ExpenseMedium;

Go

Create nonclustered index IX_ExpenseMedium_MediumType 
on ExpenseMedium (MediumType);
Go

-----Functions-----

create function fn_Apparel(@rating int) 
Returns Table  
As 
Return 
Select DATEDIFF(YYYY,c.DateofBirth,GETDATE()) AS Age, e.ExpenseType, a.RatingForClothing, a.RatingForFootwear, a.RatingForAccessories 
from consumer c  
inner join Expense e on c.ConsumerID = e.ConsumerID  
inner join Apparel a on a.ApparelExpenseID = e.ExpenseID 
where ExpenseType like 'Apparel'  
And a.RatingForClothing > @rating And a.RatingForFootwear > @rating And a.RatingForAccessories > @rating


create function fn_Travel(@rating int) 
Returns Table  
As 
Return 
Select DATEDIFF(YYYY,c.DateofBirth,GETDATE()) AS Age, e.ExpenseType, t.airways, t.roadways, t.waterways, t.railways
from consumer c  
inner join Expense e on c.ConsumerID = e.ConsumerID  
inner join Travel t on t.TravelExpenseID = e.ExpenseID 
where ExpenseType like 'Travel'
and t.airways > @rating and t.roadways > @rating and t.waterways > @rating and t.railways > @rating


create function fn_Entertainment(@rating int) 
Returns Table  
As 
Return 
Select DATEDIFF(YYYY,c.DateofBirth,GETDATE()) AS Age, e.ExpenseType, en.RatingForMovies, en.RatingForMusic
from consumer c  
inner join Expense e on c.ConsumerID = e.ConsumerID  
inner join Entertainment en on en.EntertainmentExpenseID = e.ExpenseID 
where ExpenseType like 'Entertainment'
and en.RatingForMovies > @rating and en.RatingForMusic > @rating

-----Ecryption-----

CREATE MASTER KEY ENCRYPTION BY PASSWORD = 'Group20';

CREATE CERTIFICATE Certificate_test WITH SUBJECT = 'Protect my data';


CREATE SYMMETRIC KEY SymKey_test WITH ALGORITHM = AES_256 ENCRYPTION BY CERTIFICATE
Certificate_test;

ALTER TABLE Consumer
ADD Name_encrypt varbinary(MAX);

OPEN SYMMETRIC KEY SymKey_test
 DECRYPTION BY CERTIFICATE Certificate_test;

UPDATE Consumer
 SET Name_encrypt = EncryptByKey (Key_GUID('SymKey_test'), [Name])
 FROM Consumer;
 

CLOSE SYMMETRIC KEY SymKey_test;

ALTER TABLE Consumer DROP COLUMN [Name];

-----ComputedColumnsBasedonUDF-----

create function Age(@ConsumerID int)
returns int 
As 
Begin
	Declare @Age as int;
	Select @Age = DATEDIFF(YYYY,DateofBirth,GETDATE()) 
	From Consumer 
	Where ConsumerID = @ConsumerID;
	Return @Age;
END

Alter table Consumer
ADD Age as dbo.Age(ConsumerID)


--------------------------------------------------------------------------------------------------------------------------------------------------------------