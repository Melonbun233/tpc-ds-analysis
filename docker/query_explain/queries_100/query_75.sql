SET max_parallel_workers_per_gather TO 0;
\o /var/lib/postgresql/data/explain/sf_100/explain_75.json
EXPLAIN (FORMAT JSON)
-- start query 1 in stream 75 using template query76.tpl
select  channel, col_name, d_year, d_qoy, i_category, COUNT(*) sales_cnt, SUM(ext_sales_price) sales_amt FROM (
        SELECT 'store' as channel, 'ss_hdemo_sk' col_name, d_year, d_qoy, i_category, ss_ext_sales_price ext_sales_price
         FROM store_sales, item, date_dim
         WHERE ss_hdemo_sk IS NULL
           AND ss_sold_date_sk=d_date_sk
           AND ss_item_sk=i_item_sk
        UNION ALL
        SELECT 'web' as channel, 'ws_bill_hdemo_sk' col_name, d_year, d_qoy, i_category, ws_ext_sales_price ext_sales_price
         FROM web_sales, item, date_dim
         WHERE ws_bill_hdemo_sk IS NULL
           AND ws_sold_date_sk=d_date_sk
           AND ws_item_sk=i_item_sk
        UNION ALL
        SELECT 'catalog' as channel, 'cs_ship_mode_sk' col_name, d_year, d_qoy, i_category, cs_ext_sales_price ext_sales_price
         FROM catalog_sales, item, date_dim
         WHERE cs_ship_mode_sk IS NULL
           AND cs_sold_date_sk=d_date_sk
           AND cs_item_sk=i_item_sk) foo
GROUP BY channel, col_name, d_year, d_qoy, i_category
ORDER BY channel, col_name, d_year, d_qoy, i_category
limit 100;

-- end query 1 in stream 75 using template query76.tpl
\echo query_75 processed