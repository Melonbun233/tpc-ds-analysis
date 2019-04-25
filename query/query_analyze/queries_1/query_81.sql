SET max_parallel_workers_per_gather TO 0;
\o /var/lib/postgresql/data/analyze/sf_1/analyze_81.json
EXPLAIN (FORMAT JSON, ANALYZE)
-- start query 1 in stream 81 using template query82.tpl
select  i_item_id
       ,i_item_desc
       ,i_current_price
 from item, inventory, date_dim, store_sales
 where i_current_price between 89 and 89+30
 and inv_item_sk = i_item_sk
 and d_date_sk=inv_date_sk
 and d_date between cast('1998-02-11' as date) and (cast('1998-02-11' as date) +  integer '60')
 and i_manufact_id in (262,464,3,768)
 and inv_quantity_on_hand between 100 and 500
 and ss_item_sk = i_item_sk
 group by i_item_id,i_item_desc,i_current_price
 order by i_item_id
 limit 100;

-- end query 1 in stream 81 using template query82.tpl
\echo query_81 processed