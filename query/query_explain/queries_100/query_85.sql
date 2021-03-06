SET max_parallel_workers_per_gather TO 0;
\o /var/lib/postgresql/data/explain/sf_100/explain_85.json
EXPLAIN (FORMAT JSON)
-- start query 1 in stream 85 using template query86.tpl
select   
    sum(ws_net_paid) as total_sum
   ,i_category
   ,i_class
   ,grouping(i_category)+grouping(i_class) as lochierarchy
   ,rank() over (
 	partition by grouping(i_category)+grouping(i_class),
 	case when grouping(i_class) = 0 then i_category end 
 	order by sum(ws_net_paid) desc) as rank_within_parent
 from
    web_sales
   ,date_dim       d1
   ,item
 where
    d1.d_month_seq between 1186 and 1186+11
 and d1.d_date_sk = ws_sold_date_sk
 and i_item_sk  = ws_item_sk
 group by rollup(i_category,i_class)
 order by
   lochierarchy desc,
   case when grouping(i_category)+grouping(i_class) = 0 then i_category end,
   rank_within_parent
 limit 100;

-- end query 1 in stream 85 using template query86.tpl
\echo query_85 processed