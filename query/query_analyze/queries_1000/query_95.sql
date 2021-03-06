SET max_parallel_workers_per_gather TO 0;
\o /var/lib/postgresql/data/analyze/sf_1000/analyze_95.json
EXPLAIN (FORMAT JSON, ANALYZE)
-- start query 1 in stream 95 using template query96.tpl
select  count(*) 
from store_sales
    ,household_demographics 
    ,time_dim, store
where ss_sold_time_sk = time_dim.t_time_sk   
    and ss_hdemo_sk = household_demographics.hd_demo_sk 
    and ss_store_sk = s_store_sk
    and time_dim.t_hour = 15
    and time_dim.t_minute >= 30
    and household_demographics.hd_dep_count = 7
    and store.s_store_name = 'ese'
order by count(*)
limit 100;

-- end query 1 in stream 95 using template query96.tpl
\echo query_95 processed