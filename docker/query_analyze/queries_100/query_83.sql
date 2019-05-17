SET max_parallel_workers_per_gather TO 0;
\o /var/lib/postgresql/data/analyze/sf_100/analyze_83.json
EXPLAIN (FORMAT JSON, ANALYZE)
-- start query 1 in stream 83 using template query84.tpl
select  c_customer_id as customer_id
       , coalesce(c_last_name,'') || ', ' || coalesce(c_first_name,'') as customername
 from customer
     ,customer_address
     ,customer_demographics
     ,household_demographics
     ,income_band
     ,store_returns
 where ca_city	        =  'Crossroads'
   and c_current_addr_sk = ca_address_sk
   and ib_lower_bound   >=  875
   and ib_upper_bound   <=  875 + 50000
   and ib_income_band_sk = hd_income_band_sk
   and cd_demo_sk = c_current_cdemo_sk
   and hd_demo_sk = c_current_hdemo_sk
   and sr_cdemo_sk = cd_demo_sk
 order by c_customer_id
 limit 100;

-- end query 1 in stream 83 using template query84.tpl
\echo query_83 processed