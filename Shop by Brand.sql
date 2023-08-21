with hpv as (

  select extract(date from tsparsed) date, CT_source, 
  sum(case when S3 = 'Medicine' then 1 else 0 end) as home_page_events
  from `CLEVERTAP.CT_EVENTS`
  where EVENTNAME = 'Pharmacy Home page viewed' 
  and extract(date from tsparsed) between '2023-08-15' and '2023-08-15'
  and CT_source = 'Mobile'
  group by 1,2

)

, bpv as (

  select extract(date from tsparsed) date, CT_source, S10 as brand_name,
  sum(case when S7 = 'Home' then 1 else 0 end) as brand_name_clicks
  from `CLEVERTAP.CT_EVENTS`
  where EVENTNAME = 'Brand page viewed'
  and S10 = 'Pampers'
  and extract(date from tsparsed) between '2023-08-15' and '2023-08-15'
  and CT_source = 'Mobile'
  group by 1,2,3

)

select hpv.date, hpv.CT_source, brand_name, home_page_events, brand_name_clicks
from hpv
left join bpv on bpv.date = hpv.date
