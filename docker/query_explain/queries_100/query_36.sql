SET max_parallel_workers_per_gather TO 0;
\o /var/lib/postgresql/data/explain/sf_100/explain_36.json
EXPLAIN (FORMAT JSON)
-- start query 1 in stream 36 using template query37.tpl
select  i_item_id
       ,i_item_desc
       ,i_current_price
 from item, inventory, date_dim, catalog_sales
 where i_current_price between 63 and 63 + 30
 and inv_item_sk = i_item_sk
 and d_date_sk=inv_date_sk
 and d_date between cast('2002-03-23' as date) and (cast('2002-03-23' as date) +  60)
 and i_manufact_id in (841,952,810,984)
 and inv_quantity_on_hand between 100 and 500
 and cs_item_sk = i_item_sk
 group by i_item_id,i_item_desc,i_current_price
 order by i_item_id
 limit 100;

-- end query 1 in stream 36 using template query37.tpl
\echo query_36 processed