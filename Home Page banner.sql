with hpv as (

  select extract(date from tsparsed) date, CT_source, 
  sum(case when S3 = 'Medicine' then 1 else 0 end) as home_page_events
  from `CLEVERTAP.CT_EVENTS`
  where EVENTNAME = 'Pharmacy Home page viewed' 
  and extract(date from tsparsed) between '2023-08-15' and '2023-08-15'
  and CT_source = 'Mobile'
  group by 1,2

)

, bc as (

  select extract(date from tsparsed) date, CT_source, S5 as banner_name, S2 as banner_position,
  sum(case when S3 = 'Special Offers' then 1 else 0 end) as click_events
  from `CLEVERTAP.CT_EVENTS`
  where EVENTNAME = 'Pharmacy Home Page Banner'
  and S5 = 'Huggies'
  and extract(date from tsparsed) between '2023-08-15' and '2023-08-15'
  and CT_source = 'Mobile'
  group by 1,2,3,4

)

select hpv.date, hpv.CT_source, banner_name, banner_position, home_page_events, click_events
from hpv
left join bc on bc.date = hpv.date