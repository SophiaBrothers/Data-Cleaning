/***********************   CLEANING EMPLOYEES TABLE  *************************************/
USE CleaningDB

BEGIN TRANSACTION
ALTER TABLE Employees
DROP COLUMN [NAME_INITIALS], column14, column15, column16, column17, column18, column19

ROLLBACK
-- or
commit


select * from Employees



--Problem columns are:  NAME_FIRST,   NAME_LAST,   PHONENUMBER,   VALIDITY_STARTDATE,   VALIDITY_ENDATE

------------------------------------------------------------------------------------------------


--CLEANING NAME_FIRST & NAME_LAST 

--A diamond (or square) with a question mark in the middle. This is a "replacement character."
--It is displayed whenever a character is not recognized in a document or webpage                        



--replace special character

--REPLACE(string, old_string, new_string)

select NAME_FIRST, REPLACE(NAME_FIRST COLLATE Latin1_General_BIN, N'�','e') as CLEAN_NAME from Employees;
select NAME_LAST, REPLACE(NAME_LAST COLLATE Latin1_General_BIN, N'�','e') as CLEAN_NAME from Employees;

--COLLATE is used to cast the string or column collation into a specified collation; In this case, Latin1_General_BIN 
--The N means that the following string is in Unicode


--to update in table
begin transaction
update Employees 
set NAME_FIRST = REPLACE(NAME_FIRST COLLATE Latin1_General_BIN,N'�','e')

update Employees 
set NAME_LAST = REPLACE(NAME_LAST COLLATE Latin1_General_BIN,N'�','e')

update Employees 
set LOGINNAME = REPLACE(LOGINNAME COLLATE Latin1_General_BIN,N'�','e')

rollback
--or 
commit;






----------------------------------------------------------------------------------------------
use CleaningDB

SELECT EMPLOYEE_ID as EmployeeID,
        len(EMPLOYEE_ID) as field_length
FROM Employees;


GO


-------------------REMOVING ZERO'S FROM EMPLOYEE_ID------------------------------------------

--basic understanding
SELECT SUBSTRING('0000000011', 1, 8) AS ExtractString;    -- Extract 8 characters from a string, starting in position 1:
-- returns 00000000


--option 1
select
SUBSTRING(EMPLOYEE_ID, PATINDEX('%[^0]%', EMPLOYEE_ID+'.'), len(EMPLOYEE_ID))
from Employees


--option 2
begin transaction
UPDATE Employees
SET EMPLOYEE_ID = RIGHT(EMPLOYEE_ID, LEN(EMPLOYEE_ID) - 8)

rollback
--or 
commit;
go

-------------------------------  CONVERT INT TO DATE  ------------------------------------------------

-- must first cast as a character of length 8. then convert to date.

select
CONVERT(date, CAST(VALIDITY_STARTDATE AS char(8)))
from Employees


--wont work. try in design. design failed.

--this works
ALTER TABLE Employees
alter COLUMN VALIDITY_ENDDATE char(8);

ALTER TABLE Employees
alter COLUMN VALIDITY_ENDDATE date;


ALTER TABLE Employees
alter COLUMN VALIDITY_STARTDATE char(8);

ALTER TABLE Employees
alter COLUMN VALIDITY_STARTDATE date;




-------------------------------- PHONE NUMBER ---------------------------------------------------------

-- Since the countries are not available for the phone number column, I am going to use the last 10 digits 
-- to create a standard US phone format

SELECT PHONENUMBER as PHONENUMBER,
        len(PHONENUMBER) as field_length
FROM Employees;



select
SUBSTRING(PHONENUMBER, PATINDEX('%[-.]%', PHONENUMBER+'.'), len(PHONENUMBER))
from Employees

--trying this code. Doesnt yeild exactly what I want.
SET NOCOUNT ON
DECLARE @Phone table (PhoneNo varchar(50))
INSERT INTO @Phone VALUES ('630-374-0306')
INSERT INTO @Phone VALUES ('09603 61 24 64')
INSERT INTO @Phone VALUES ('070 8691 2288')
INSERT INTO @Phone VALUES ('026734 4556')
INSERT INTO @Phone VALUES ('02224135120')
INSERT INTO @Phone VALUES ('2288340')
INSERT INTO @Phone VALUES ('306-598-7404')
INSERT INTO @Phone VALUES ('03.23.46.10404')
INSERT INTO @Phone VALUES ('805-756-6064')
INSERT INTO @Phone VALUES ('201-849-2465')
INSERT INTO @Phone VALUES ('916-223-7055')
INSERT INTO @Phone VALUES ('416-794-6633')
INSERT INTO @Phone VALUES ('780-682-9921')
INSERT INTO @Phone VALUES ('416-609-5608')
SET NOCOUNT OFF

;WITH StripedNumber AS
(
SELECT
    PhoneNo,
    REPLACE(
    REPLACE(
    REPLACE(
    REPLACE(
    REPLACE(
    REPLACE(PhoneNo
           ,'(','')
           ,')','')
           ,'.','')
           ,' ','')
           ,'-','')
           ,'+','') AS StripedNumber
    FROM @Phone
)
SELECT
    CASE
        WHEN ISNUMERIC(StripedNumber)=1 THEN +CONVERT(varchar(50),CONVERT(bigint,StripedNumber))
        ELSE PhoneNo  --make this ELSE NULL if you don't want to see invalid non numeric phone numbers
    END AS PhoneNumber
    FROM StripedNumber

