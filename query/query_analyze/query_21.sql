SET max_parallel_workers_per_gather TO 0;
\o ../../analyze/analyze_21.json
EXPLAIN (FORMAT JSON, ANALYZE)
-- start query 1 in stream 21 using template query22.tpl
select  i_product_name
             ,i_brand
             ,i_class
             ,i_category
             ,avg(inv_quantity_on_hand) qoh
       from inventory
           ,date_dim
           ,item
       where inv_date_sk=d_date_sk
              and inv_item_sk=i_item_sk
              and d_month_seq between 1214 and 1214 + 11
       group by rollup(i_product_name
                       ,i_brand
                       ,i_class
                       ,i_category)
order by qoh, i_product_name, i_brand, i_class, i_category
limit 100;

-- end query 1 in stream 21 using template query22.tpl
\echo query_21 processed