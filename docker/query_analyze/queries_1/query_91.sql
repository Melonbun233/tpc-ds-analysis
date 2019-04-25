SET max_parallel_workers_per_gather TO 0;
\o /var/lib/postgresql/data/analyze/sf_1/analyze_91.json
EXPLAIN (FORMAT JSON, ANALYZE)
-- start query 1 in stream 91 using template query92.tpl
select  
   sum(ws_ext_discount_amt)  as "Excess Discount Amount" 
from 
    web_sales 
   ,item 
   ,date_dim
where
i_manufact_id = 410
and i_item_sk = ws_item_sk 
and d_date between '1999-02-18' and 
        (cast('1999-02-18' as date) + integer '90')
and d_date_sk = ws_sold_date_sk 
and ws_ext_discount_amt  
     > ( 
         SELECT 
            1.3 * avg(ws_ext_discount_amt) 
         FROM 
            web_sales 
           ,date_dim
         WHERE 
              ws_item_sk = i_item_sk 
          and d_date between '1999-02-18' and
                             (cast('1999-02-18' as date) + integer '90')
          and d_date_sk = ws_sold_date_sk 
      ) 
order by sum(ws_ext_discount_amt)
limit 100;

-- end query 1 in stream 91 using template query92.tpl
\echo query_91 processed