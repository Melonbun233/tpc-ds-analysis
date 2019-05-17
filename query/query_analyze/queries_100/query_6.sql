SET max_parallel_workers_per_gather TO 0;
\o /var/lib/postgresql/data/analyze/sf_100/analyze_6.json
EXPLAIN (FORMAT JSON, ANALYZE)
-- start query 1 in stream 6 using template query7.tpl
select  i_item_id, 
        avg(ss_quantity) agg1,
        avg(ss_list_price) agg2,
        avg(ss_coupon_amt) agg3,
        avg(ss_sales_price) agg4 
 from store_sales, customer_demographics, date_dim, item, promotion
 where ss_sold_date_sk = d_date_sk and
       ss_item_sk = i_item_sk and
       ss_cdemo_sk = cd_demo_sk and
       ss_promo_sk = p_promo_sk and
       cd_gender = 'M' and 
       cd_marital_status = 'W' and
       cd_education_status = 'Secondary' and
       (p_channel_email = 'N' or p_channel_event = 'N') and
       d_year = 2001 
 group by i_item_id
 order by i_item_id
 limit 100;

-- end query 1 in stream 6 using template query7.tpl
\echo query_6 processed