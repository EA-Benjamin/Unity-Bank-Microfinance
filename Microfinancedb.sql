create database Unity_microfinance;
use Unity_microfinance;
show tables;   -- No tables in the database, hence we import 

select * from microfinance_loan_prediction_dataset;

-- Now we rename the table to loan

rename table microfinance_loan_prediction_dataset to loan;

select count(*) from loan;   -- 10000 rows

describe loan;

-- Let's check for duplicates
select 
Customer_ID, Age, Gender, Occupation, Monthly_Income, Loan_Amount, Repayment_Term_Months, 
Past_Defaults, Existing_Loans, Loan_Paid, Days_to_Repay, count(*) as duplicates
from loan
group by Customer_ID, Age, Gender, Occupation, Monthly_Income, Loan_Amount, Repayment_Term_Months, 
Past_Defaults, Existing_Loans, Loan_Paid, Days_to_Repay
having duplicates>1;                                               -- No duplicates

-- Now we assign a primary key to the table
alter table loan
add constraint primary key(Customer_ID);  -- Won't work because I have to remove the datatype from text first

alter table loan
modify column Customer_ID varchar(100);   -- Changing the datatype so the above statement can work


-- DQD Begins
-- Now we check for blanks in the data
select * from loan where Customer_ID ='';
select * from loan where Age ='';
select * from loan where Gender ='';
select * from loan where Occupation ='';
select * from loan where Monthly_Income ='';
select * from loan where Loan_Amount ='';
select * from loan where Repayment_Term_Months ='';
select * from loan where Past_Defaults ='';
select * from loan where Existing_Loans ='';
select * from loan where Loan_Paid ='';
select * from loan where Days_to_Repay ='';      #Everything is intact apart from days to repay column

-- Checking for unique values per column
select distinct Customer_ID from loan;
select distinct Age from loan;
select distinct Gender from loan;
select distinct Occupation from loan;
select distinct Monthly_Income from loan;
select distinct Loan_Amount from loan;
select distinct Repayment_Term_Months from loan;
select distinct Past_Defaults from loan;
select distinct Existing_Loans from loan;
select distinct Loan_Paid from loan;
select distinct Days_to_Repay from loan;

-- Now we replace the empties in days to repay with 0 so we can change the datatype
start transaction;
update loan
set Days_to_Repay = 0
where Days_to_Repay = '';
commit;

select * from loan where Days_to_Repay = 0; -- Done

-- Changing it's datatype
alter table loan
modify column Days_to_Repay int;

Describe loan;
select * from loan;

-- Checking the min and max age to determine the values for age range
select max(age) as highest, min(age) as lowest from loan;   -- max=59, min=21

-- Checking the min and max repayment term to determines values for repayment range
select max(Repayment_Term_Months) as highest, min(Repayment_Term_Months) as lowest from loan;  -- max= 12, min = 3

-- Checking the min and max monthly income for range values
select max(Monthly_Income) as highest, min(Monthly_Income) as lowest from loan;  -- max= 349,966, min = 30,043

-- Checking the min and max loan amount for range values
select max(Loan_Amount) as highest, min(Loan_Amount) as lowest from loan;  -- max= 499,977, min = 20,047

-- We create an age range column and populate it with the case statement
alter table loan
add column age_range text after age;

start transaction;
update loan
set age_range = case
					when age between 21 and 30 then '21-30 yrs'
                    when age between 31 and 40 then '31-40 yrs'
                    when age between 41 and 50 then '41-50 yrs'
                    when age between 51 and 60 then '51-60 yrs'
                    end;
commit;
select * from loan;

-- Now we create a repayment range column and populate with case
alter table loan
add column Repayment_range text after Repayment_Term_Months;

start transaction;
update loan
set Repayment_range = case
					   when Repayment_Term_Months between 3 and 6 then '3-6 mths'
                       when Repayment_Term_Months between 7 and 9 then '7-9 mths'
                       when Repayment_Term_Months between 10 and 12 then '10-12 mths'
                       end;
commit;
select * from loan;

-- Now we create a range column for the month income and update with case
alter table loan
add column Income_range text after Monthly_Income;

start transaction;
update loan
set Income_range = case
					   when Monthly_Income between 30000 and 99999 then '30000 - 99999'
                       when Monthly_Income between 10000 and 169999 then '100000 - 169999'
                       when Monthly_Income between 170000 and 239999 then '170000 - 239999'
                       when Monthly_Income between 240000 and 309999 then '240000 - 309999'
                       else '310000 - 380000'
                       end;
commit;                       
select * from loan;

-- creating a loan amount range column and populating
alter table loan
add column loan_range text after loan_amount;

start transaction;
update loan
set loan_range = case
					   when loan_amount between 20000 and 99999 then '20000 - 99999'
                       when loan_amount between 10000 and 179999 then '100000 - 179999'
                       when loan_amount between 180000 and 259999 then '180000 - 259999'
                       when loan_amount between 260000 and 339999 then '260000 - 339999'
                       when loan_amount between 340000 and 419999 then '340000 - 419999'
                       else '420000 - 500000'
                       end; 
commit;                       
select * from loan;                       

-- Adding a column for defaults(i.e clients who have defaulted before)
alter table loan
add column Defaulted int after Past_Defaults;



start transaction;
update loan
set Defaulted = case
					when Past_Defaults = 0 then 0
                    else 1
                    end;
commit;                    
select * from loan;

-- Now we create a column for risk category
alter table loan
add column Risk text;

start transaction;
update loan
set Risk = case
			 when Defaulted = 0 and Loan_Paid = 'Yes' then 'No-risk'
             when Defaulted != 0 and Loan_Paid = 'Yes' then 'Medium-risk'
             when Defaulted != 0 and Loan_Paid = 'No' then 'High-risk'
             when Defaulted = 0 and Loan_Paid = 'No' then 'low-risk'
             end;
commit;             
select * from loan;

select * from loan where Risk = '';

