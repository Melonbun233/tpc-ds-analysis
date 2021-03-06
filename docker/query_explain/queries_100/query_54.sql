SET max_parallel_workers_per_gather TO 0;
\o /var/lib/postgresql/data/explain/sf_100/explain_54.json
EXPLAIN (FORMAT JSON)
-- start query 1 in stream 54 using template query55.tpl
select  i_brand_id brand_id, i_brand brand,
 	sum(ss_ext_sales_price) ext_price
 from date_dim, store_sales, item
 where d_date_sk = ss_sold_date_sk
 	and ss_item_sk = i_item_sk
 	and i_manager_id=54
 	and d_moy=12
 	and d_year=2000
 group by i_brand, i_brand_id
 order by ext_price desc, i_brand_id
limit 100 ;

-- end query 1 in stream 54 using template query55.tpl
\echo query_54 processed