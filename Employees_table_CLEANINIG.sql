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
FROM Employees;                            --14 rows


/** my format requirements:  (123)456-7890

1. remove all special characters
2. get the last 10, remove the excess

 **/

 --working with sample phone number
 select PHONENUMBER from Employees
 where PHONENUMBER like '03.23.46.10404';

--step1
DECLARE @dirty VARCHAR(55)= '03.23.46.10404';
SELECT REPLACE(@dirty, '.', ''), LEN(@dirty) as length;

--step2
select trim(replace('03.23.46.10404', '.', '' )), LEN(trim(replace('03.23.46.10404', '.', '' ))) as length;


--step3 Use subtring to remove extra digits over 10



-- Sampling
declare @cleaning varchar(20)   
set @cleaning = trim(replace(replace('56-6064', '.', '' ), '-', ''))     -- replacing '.' and '-'

if len(@cleaning) > 10
	begin 
		set @cleaning = reverse(SUBSTRING(reverse(@cleaning), 1, 10))    --works from inside function to outer function 
		print @cleaning
	end
else
	--print 'phone is correct length' 
if len(@cleaning) < 10
	begin
		set @cleaning = ''    -- make the value null
		print 'phone is empty or invalid'
	end
else
	begin
		set @cleaning = '(' + LEFT(@cleaning,3) + ')' + RIGHT(LEFT(@cleaning,6),3) + '-' + RIGHT(@cleaning,4)
		print @cleaning
	end

GO
/** to solve selecting only the last 10 characters, I had to Reverse @cleaning, then place it into a 
    substring that would grab the first 10 caharacters only from the starting point of 1(esentially the last digit),
    then reverse it back to the original order **/

-- A much better alternative for the issue above:  RIGHT()
declare @cleaning varchar(20)   
set @cleaning = trim(replace(replace('805-756-6064', '.', '' ), '-', '')) 
select right(@cleaning,10);

go


--testing next step in batch above
SELECT'('+LEFT('8057566064',3)+')'+RIGHT(LEFT('8057566064',6),3)+'-'+RIGHT('8057566064',4);



'%[^0-9]%'

--Creating a function to clean phone numbers-----------------------------------------------------------------------
GO

CREATE FUNCTION fn_CleanPhone (@Phone VARCHAR(40)  )   --create the function
RETURNS VARCHAR(40)   -- this is what I want returned 
AS
BEGIN

--Place declare statement here to strip strings down to just numbers
	DECLARE @keep VARCHAR(55)      --declaring the placeholder variable
	Set @keep = '%[^0-9]%'         --  remove values that are NOT(^) 0-9
	









select
SUBSTRING(PHONENUMBER, PATINDEX('%[-.]%', PHONENUMBER+'.'), len(PHONENUMBER))
from Employees;







