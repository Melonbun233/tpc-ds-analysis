SET max_parallel_workers_per_gather TO 0;
\o /var/lib/postgresql/data/explain/sf_100/explain_31.json
EXPLAIN (FORMAT JSON)
-- start query 1 in stream 31 using template query32.tpl
select  sum(cs_ext_discount_amt)  as "excess discount amount" 
from 
   catalog_sales 
   ,item 
   ,date_dim
where
i_manufact_id = 434
and i_item_sk = cs_item_sk 
and d_date between '1998-02-25' and 
        (cast('1998-02-25' as date) + 90)
and d_date_sk = cs_sold_date_sk 
and cs_ext_discount_amt  
     > ( 
         select 
            1.3 * avg(cs_ext_discount_amt) 
         from 
            catalog_sales 
           ,date_dim
         where 
              cs_item_sk = i_item_sk 
          and d_date between '1998-02-25' and
                             (cast('1998-02-25' as date) + 90)
          and d_date_sk = cs_sold_date_sk 
      ) 
limit 100;

-- end query 1 in stream 31 using template query32.tpl
\echo query_31 processed