EXPLAIN (FORMAT JSON)
-- start query 1 in stream 35 using template query36.tpl

SELECT sum(ss_net_profit)/sum(ss_ext_sales_price) AS gross_margin ,
       i_category ,
       i_class ,
       grouping(i_category)+grouping(i_class) AS lochierarchy ,
       rank() over ( partition BY grouping(i_category)+grouping(i_class), CASE
                                                                              WHEN grouping(i_class) = 0 THEN i_category
                                                                          END
                    ORDER BY sum(ss_net_profit)/sum(ss_ext_sales_price) ASC) AS rank_within_parent
FROM store_sales ,
     date_dim d1 ,
     item ,
     store
WHERE d1.d_year = 1998
    AND d1.d_date_sk = ss_sold_date_sk
    AND i_item_sk = ss_item_sk
    AND s_store_sk = ss_store_sk
    AND s_state IN ('TN',
                    'TN',
                    'TN',
                    'TN',
                    'TN',
                    'TN',
                    'TN',
                    'TN')
GROUP BY rollup(i_category,i_class)
ORDER BY lochierarchy DESC ,
         CASE
             WHEN grouping(i_category)+grouping(i_class) = 0 THEN i_category --alias not working here, modified
         END ,
         rank_within_parent
LIMIT 100;

-- end query 1 in stream 35 using template query36.tpl
