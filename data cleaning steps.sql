select * from weekly_sales;

/*
In a single query, perform the following operations and generate a new table 
in the data_mart schema named clean_weekly_sales:

    Convert the week_date to a DATE format

    Add a week_number as the second column for each week_date value, for example 
    any value from the 1st of January to 7th of January will be 1, 8th to 14th will be 2 etc
    

    Add a month_number with the calendar month for each week_date value as the 3rd column

    Add a calendar_year column as the 4th column containing either 2018, 2019 or 2020 values

    Add a new column called age_band after the original segment column using the 
    following mapping on the number inside the segment value
*/
# Convert the week_date to a DATE format
create table new_clean_weekly_sales as
select str_to_date(week_date,'%d/%m/%y') as week_date, region, platform, segment, customer_type, transactions, sales
from weekly_sales;
select * from new_clean_weekly_sales;


/*Add a week_number as the second column for each week_date value, for example 
    any value from the 1st of January to 7th of January will be 1, 8th to 14th will be 2 etc */
    
alter table new_clean_weekly_sales add column week_number integer ;
SET SQL_SAFE_UPDATES = 0;
update new_clean_weekly_sales set week_number = ceil(day(week_date)/7);


# Add a month_number with the calendar month for each week_date value as the 3rd column
alter table new_clean_weekly_sales add column month_number integer;
update new_clean_weekly_sales set month_number = month(week_date);

#  Add a calendar_year column as the 4th column containing either 2018, 2019 or 2020 values
alter table new_clean_weekly_sales add column calendar_year integer;
update new_clean_weekly_sales set calendar_year = year(week_date);

/* Add a new column called age_band after the original segment column using the 
    following mapping on the number inside the segment value */
    alter table new_clean_weekly_sales add column segment_number integer;
   UPDATE new_clean_weekly_sales
SET segment_number = CASE
    WHEN segment LIKE 'C%' THEN CAST(SUBSTRING(segment, 2) AS UNSIGNED)
    WHEN segment LIKE 'F%' THEN CAST(SUBSTRING(segment, 2) AS UNSIGNED)
    ELSE NULL
END;
    alter table new_clean_weekly_sales add column age_band varchar(20);
update new_clean_weekly_sales set age_band = 
case when segment_number = 1 then 'Yung Adults' when segment_number = 2 then 'Middle Aged' 
when segment_number =3 or segment_number = 4 then 'Retirees' else 'Unknown' end;

select * from new_clean_weekly_sales;


#    Add a new demographic column using the following mapping for the first letter in the segment values:
alter table new_clean_weekly_sales add column demographic varchar(15);
update new_clean_weekly_sales set demographic = case when segment like'C%' then 'Cuples' 
when segment like 'F%' then 'Families' else 'Unkown' end;

#    Generate a new avg_transaction column as the sales value divided by transactions rounded to 2 decimal places for each record
alter table new_clean_weekly_sales add column avg_transaction integer;
alter table new_clean_weekly_sales modify avg_transaction decimal(10,2);
update new_clean_weekly_sales set avg_transaction = round(sales/transactions,2);


create table clean_weekly_sales as select week_number,month_number,calendar_year,
age_band,demographic,avg_transaction from new_clean_weekly_sales;

select *from clean_weekly_sales;





 

