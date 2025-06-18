/*
This technique is usually used when we inspect an important event and 
want to inspect the impact before and after a certain point in time.

Taking the week_date value of 2020-06-15 as the baseline week where 
the Data Mart sustainable packaging changes came into effect.

We would include all week_date values for 2020-06-15 as the start of 
the period after the change and the previous week_date values would be before

Using this analysis approach - answer the following questions:
    What is the total sales for the 4 weeks before and after 2020-06-15? 
    What is the growth or reduction rate in actual values and percentage of sales?
    
    What about the entire 12 weeks before and after?
    
    How do the sale metrics for these 2 periods before and after 
    compare with the previous years in 2018 and 2019?
    */
    
    /* Q1.  What is the total sales for the 4 weeks before and after 2020-06-15? 
    What is the growth or reduction rate in actual values and percentage of sales? */
#befor
with sales_summery as(select 'Before' as period,sum(sales) total_sales from new_clean_weekly_sales 
where week_date < '2020-06-15' and week_date >=date_sub('2020-06-15' ,interval 28 day)
union all
#afte
select 'After' as period,sum(sales) total_sales from new_clean_weekly_sales 
where week_date >= '2020-06-15' and week_date < date_add('2020-06-15', interval 28 day)),

# convert columns data into  row data
calculations as(select max(case when period = 'Before' then total_sales end) before_total_sales,
max(case when period = 'After' then total_sales end) after_total_sales from sales_summery)
select before_total_sales, after_total_sales,(after_total_sales-before_total_sales) difference,
round(((after_total_sales-before_total_sales)/before_total_sales)*100,2) percentage from calculations;

# What about the entire 12 weeks before and after?
# before
with sales_summery as(select 'before' as period, sum(sales) total_sales from new_clean_weekly_sales 
where week_date >= date_sub('2020-06-15',interval 84 day) and week_date < '2020-06-15' 
union all
# after
select 'after' as period, sum(sales) total_sales from new_clean_weekly_sales 
where week_date >= '2020-06-15' and week_date < date_add('2020-06-15',interval 84 day)),

# Row data change into columns
calculation as(select max(case when period = 'before' then total_sales end) before_sales,
max(case when period ='after' then total_sales end) after_sales from sales_summery)
select before_sales,after_sales,(after_sales - before_sales) difference, 
round(((after_sales-before_sales)/before_sales)*100,2) percentage from calculation;

# Q3. How do the sale metrics for these 2 periods before and after compare with the previous years in 2018 and 2019?

with sales_summery_1 as(select 'Before' as period,sum(sales) total_sales from new_clean_weekly_sales 
where week_date < '2020-06-15' and week_date >=date_sub('2020-06-15' ,interval 28 day)
union all
#afte
select 'After' as period,sum(sales) total_sales from new_clean_weekly_sales 
where week_date >= '2020-06-15' and week_date < date_add('2020-06-15', interval 28 day)),

# convert columns data into  row data
calculations_1 as(select max(case when period = 'Before' then total_sales end) before_total_sales,
max(case when period = 'After' then total_sales end) after_total_sales from sales_summery_1),

 sales_summery_2 as(select 'Before' as period,sum(sales) total_sales from new_clean_weekly_sales 
where week_date < '2019-06-15' and week_date >=date_sub('2019-06-15' ,interval 28 day)
union all
#afte
select 'After' as period,sum(sales) total_sales from new_clean_weekly_sales 
where week_date >= '2019-06-15' and week_date < date_add('2019-06-15', interval 28 day)),

# convert columns data into  row data
calculations_2 as(select max(case when period = 'Before' then total_sales end) before_total_sales,
max(case when period = 'After' then total_sales end) after_total_sales from sales_summery_2),

 sales_summery_3 as(select 'Before' as period,sum(sales) total_sales from new_clean_weekly_sales 
where week_date < '2018-06-15' and week_date >=date_sub('2018-06-15' ,interval 28 day)
union all
#afte
select 'After' as period,sum(sales) total_sales from new_clean_weekly_sales 
where week_date >= '2018-06-15' and week_date < date_add('2018-06-15', interval 28 day)),

# convert columns data into  row data
calculations_3 as(select max(case when period = 'Before' then total_sales end) before_total_sales,
max(case when period = 'After' then total_sales end) after_total_sales from sales_summery_3)

select '2020' as years,before_total_sales, after_total_sales from calculations_1
union all
select '2019'as years, before_total_sales, after_total_sales from calculations_2
union all
select '2018' as years, before_total_sales, after_total_sales from calculations_3;


/* Q4.  Which areas of the business have the highest negative impact in sales metrics 
performance in 2020 for the 12 week before and after period?

    region
    platform
    age_band
    demographic
    customer_type

Do you have any further recommendations for Danny’s team at Data Mart or any interesting insights based off this analysis?
*/

# before
with filter_data_before as(select * from new_clean_weekly_sales 
where week_date < '2020-06-15' and week_date >= date_sub('2020-06-15',interval 84 day)),

region_data_before as(select region,sum(sales) total_sales_region  from filter_data_before group by region ),

platform_data_before as(select platform,sum(sales) total_sales_platform  from filter_data_before group by platform ),

age_band_data_before as(select age_band,sum(sales) total_sales_age_band from filter_data_before group by age_band),

demographic_data_before as(select demographic,sum(sales) total_sales_demographic from filter_data_before group by demographic),

customer_type_data_before as(select customer_type, sum(sales) total_sales_customer_type from filter_data_before group by customer_type),

# After 
filter_data_after as(select * from  new_clean_weekly_sales 
where week_date >= '2020-06-15' and week_date <date_add('2020-06-15',interval 84 day)),

region_data_after as(select region,sum(sales) total_sales_region  from filter_data_after group by region ),

platform_data_after as(select platform,sum(sales) total_sales_platform  from filter_data_after group by platform ),

age_band_data_after as(select age_band,sum(sales) total_sales_age_band from filter_data_after group by age_band),

demographic_data_after as(select demographic,sum(sales) total_sales_demographic from filter_data_after group by demographic),

customer_type_data_after as(select customer_type, sum(sales) total_sales_customer_type from filter_data_after group by customer_type)

select 'region' as category,b.region as sub_cateogry,b.total_sales_region befores,a.total_sales_region afters,
(a.total_sales_region - b.total_sales_region) difference,
round(((a.total_sales_region - b.total_sales_region)/b.total_sales_region)*100,2) percentage
from region_data_before b join region_data_after a on b.region = a.region
  
union all

select 'platform' as category,b.platform as sub_cateogry,b.total_sales_platform befores,a.total_sales_platform afters,
(a.total_sales_platform - b.total_sales_platform) difference,
round(((a.total_sales_platform - b.total_sales_platform)/b.total_sales_platform)*100,2) percentage
from platform_data_before b join platform_data_after a on b.platform = a.platform 
union all
select 'age_band'as category,b.age_band as sub_cateogry,b.total_sales_age_band befores,a.total_sales_age_band afters,
(a.total_sales_age_band - b.total_sales_age_band) difference,
round(((a.total_sales_age_band - b.total_sales_age_band)/b.total_sales_age_band)*100,2) percentage
from age_band_data_before b join age_band_data_after a on b.age_band = a.age_band
union all

select 'demographic' as category,b.demographic as sub_cateogry,b.total_sales_demographic befores,
a.total_sales_demographic afters,(a.total_sales_demographic - b.total_sales_demographic) difference,
round(((a.total_sales_demographic - b.total_sales_demographic)/b.total_sales_demographic)*100,2) percentage
from demographic_data_before b join demographic_data_after a on b.demographic = a.demographic
union all
select 'customer_type' as category,b.customer_type as sub_cateogry,b.total_sales_customer_type befores,a.total_sales_customer_type afters,
(a.total_sales_customer_type - b.total_sales_customer_type) difference,
round(((a.total_sales_customer_type - b.total_sales_customer_type)/b.total_sales_customer_type)*100,2) percentage
from customer_type_data_before b join customer_type_data_after a on b.customer_type = a.customer_type;



  

