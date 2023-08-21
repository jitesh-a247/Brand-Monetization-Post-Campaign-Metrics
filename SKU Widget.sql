with atc as (

  select extract(date from tsparsed) date, S9 as SKUID, CT_source, S7 as Section_Name,
  sum(case when S14 = 'Pharmacy Home' then 1 else 0 end) as ATC_direct_mob,
  sum(case when S14 = 'Pharmacy List' then 1 else 0 end) as ATC_ViewAll_mob
  from `CLEVERTAP.CT_EVENTS`
  where S7 = 'PAMPERS DIAPERING RANGE'
  and EVENTNAME = 'Pharmacy Add to Cart'
  and CT_source = 'Mobile'
  and extract(date from tsparsed) between '2023-08-15' and '2023-08-15'
  group by 1,2,3,4
  
)

,pdp as (

  select extract(date from tsparsed) date, S32 as SKUID, CT_source, S28 as Section_Name,
  sum(case when S38 = 'home page' then 1 else 0 end) as PDP_view_direct_mob,
  sum(case when S38 = 'category or listing' then 1 else 0 end) as PDP_ViewAll_mob
  from `CLEVERTAP.CT_EVENTS`
  where S28 = 'PAMPERS DIAPERING RANGE'
  and EVENTNAME = 'Pharmacy Product Page Viewed'
  and CT_source = 'Mobile'
  and extract(date from tsparsed) between '2023-08-15' and '2023-08-15'
  group by 1,2,3,4

)

select a.date, a.SKUID, a.CT_source, a.Section_Name, 
ATC_direct_mob, PDP_view_direct_mob, ATC_ViewAll_mob, PDP_ViewAll_mob
from atc a
left join pdp p on p.SKUID = a.SKUID