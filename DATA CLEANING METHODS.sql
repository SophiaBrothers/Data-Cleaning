/***********************   DATA CLEANING  *************************************/
USE CleaningDB


SELECT EMPLOYEE_ID as EmployeeID,
        len(EMPLOYEE_ID) as field_length
FROM Employees;


GO


-------------------REMOVING ZERO'S FROM EMPLOYEE_ID------------------------------------------

--basic understanding
SELECT SUBSTRING('0000000011', 1, 8) AS ExtractString;    -- Extract 8 characters from a string, starting in position 1:
-- returns 00000000




--------------------------------------------------------------------------------------------------------

--REMOVE UNNECESSARY SPACES

SELECT  NAME_FIRST as real_FirstName,
		len(NAME_FIRST) as field_length,
        trim(NAME_FIRST) as trimmed_FirstName,
		len(NAME_FIRST) as new_field_length
FROM Employees;


SELECT SEX, count(*) as COUNT
FROM  Employees
GROUP BY SEX;


-- to get rid of the unwanted characters (extra spaces) and eliminate the capitalization mistakes(LOWER).
SELECT lower(trim(NAME_FIRST)), count(*)
FROM  Employees
GROUP BY lower(trim(NAME_FIRST))







----------------------------------Various cleaning functions -----------------------------------
DECLARE @MyString VARCHAR(100)
SET @MyString = 'abcdef&&&&ybyds'
                                                        -- [^a-zA-Z0-9] means any letter (regardless of case) or digit. ^ means not
IF (@MyString LIKE '%[^a-zA-Z0-9]%')                    -- basically if the string has any charaters that are not normal (A-Z, a-z, 0-9)
    BEGIN
       SET @MyString = Replace(@MyString,'&',' ')		--replace & with a blank space
       PRINT 'Contains "special" characters'
       PRINT @MyString
  END
ELSE
    BEGIN
       PRINT 'Does not contain "special" characters'
       PRINT @MyString
    END;



	GO
---------------------------------------------------------------------------------------
Create function [dbo].[RemoveCharSpecialSymbolValue](@str varchar(500))     --create function
returns varchar(500)                                                        --to return this
begin                                                                       -- begin by
declare @startingIndex int													-- declaring the name and data type of variable
set @startingIndex=0                                                        -- assigning value to variable
while 1=1																	-- set condition for loop			
begin																		-- begin this action
set @startingIndex= patindex('%[^0-9.]%',@str)                           -- the position of patterns to search for in an expression
if @startingIndex <> 0                                                    -- 	Not equal to
begin  
set @str = replace(@str,substring(@str,@startingIndex,1),'')  
end  
else break;  
end  
return @str  
end;


go
/** In this function, set @startingIndex for the first time to 0 after which, use while loop
and get the index where numeric values are available, if it finds any characters and symbols,
then it replaces only the greater numeric values. 

finally it returns numeric values. 
 
Suppose you have a string, as shown below.  **/
 
DECLARE @Spcialtext nvarchar(100)='YVVV5V4'

 --Now, use the function given below.

select dbo.RemoveCharSpecialSymbolValue(@Spcialtext) 
 
 go
--Output - 23356


/********************************************************************************************************/

--to remove all non-alphanumeric characters you could use a regular expresion:


Create Function [dbo].[RemoveNonAlphaCharacters](@Temp VarChar(1000))
Returns VarChar(1000)
AS
Begin

    Declare @KeepValues as varchar(50)
    Set @KeepValues = '%[^a-z]%'                --characters that are not a-z
    While PatIndex(@KeepValues, @Temp) > 0
        Set @Temp = Stuff(@Temp, PatIndex(@KeepValues, @Temp), 1, '')   --The STUFF() function deletes a part of a string and then inserts another part into it

    Return @Temp
End;

go 

Select dbo.RemoveNonAlphaCharacters('abc1234def5678ghi90jkl')

go



--to run this funtion on a specific column, use UPDATE
BEGIN TRANSACTION

UPDATE Employees
SET NAME_FIRST = dbo.RemoveNonAlphaCharacters(NAME_FIRST)

ROLLBACK

go

---------------------------------------------------------------------------------

