/***********************   CLEANING EMPLOYEES TABLE  *************************************/
USE CleaningDB

BEGIN TRANSACTION
ALTER TABLE Employees
DROP COLUMN [NAME_INITIALS], column14, column15, column16, column17, column18, column19

ROLLBACK
-- or
commit



Select * from [dbo].[Employees]

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


-------------------------------- PHONE NUMBER ---------------------------------------------------------

