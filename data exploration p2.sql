select * from new_clean_weekly_sales;
#Q1. What day of the week is used for each week_date value?
select dayname(week_date) week_day  from new_clean_weekly_sales;

# Q2.  What range of week numbers are missing from the dataset?
with week_no as(select ceil(day(week_date)/7) week_number from new_clean_weekly_sales ),

all_weeks_number as(select 1 as week_number
union
select 2
union
select 3
union
select 4
union
select 5)

select awn.week_number from all_weeks_number awn 
left join(select distinct week_number from week_no) wn on awn.week_number = wn.week_number 
where wn.week_number is null; 

# Q3.  How many total transactions were there for each year in the dataset?
select year(week_date) years, sum(transactions) total_transactions 
from new_clean_weekly_sales group by years;

# Q4. What is the total sales for each region for each month?
select region,date_format(week_date,'%y-%m') months_wise,sum(sales) total_sales 
from new_clean_weekly_sales group by region,months;

# Q5.  What is the total count of transactions for each platform
select platform,count(*) count_transaction from new_clean_weekly_sales group by platform;

# Q6. What is the percentage of sales for Retail vs Shopify for each month?
with monthly_sales as(select date_format(week_date,'%y-%m') month_wise,platform,sum(sales) sales 
from new_clean_weekly_sales group by month_wise,platform),

total_monthly_sales as(select month_wise,sum(sales) total_sales
from monthly_sales  group by month_wise)

select ms.month_wise,ms.platform,ms.sales,round((ms.sales/tms.total_sales)*100,2) percentage
 from monthly_sales ms join total_monthly_sales  tms on ms.month_wise = tms.month_wise order by ms.month_wise,ms.platform;
 
# Q7.  What is the percentage of sales by demographic for each year in the dataset? 
with total_sales as(select year(week_date) years,sum(sales) sales from new_clean_weekly_sales group by years),

demographic_wise as(select year(week_date) years,demographic,sum(sales) sales_demographic_wise 
from new_clean_weekly_sales group by years,demographic)

select dw.years,dw.demographic,dw.sales_demographic_wise,round((dw.sales_demographic_wise/ts.sales)*100,2) percentage
from demographic_wise dw join total_sales ts on dw.years = ts.years order by dw.years,dw.demographic ;
 

# Q8. Which age_band and demographic values contribute the most to Retail sales?
with filter_data as(select * from new_clean_weekly_sales where platform = 'Retail')
select demographic,age_band,sum(sales) total_sales from filter_data 
group by age_band,demographic order by total_sales desc;

/* Q9. Can we use the avg_transaction column to find the average transaction size 
for each year for Retail vs Shopify? If not - how would you calculate it instead? */

select year(week_date) years,platform,round(sum(sales)/sum(transactions),2) average 
from new_clean_weekly_sales group by years,platform order by years;







