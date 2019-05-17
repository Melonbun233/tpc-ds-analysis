SET max_parallel_workers_per_gather TO 0;
\o /var/lib/postgresql/data/analyze/sf_100/analyze_88.json
EXPLAIN (FORMAT JSON, ANALYZE)
-- start query 1 in stream 88 using template query89.tpl
select  *
from(
select i_category, i_class, i_brand,
       s_store_name, s_company_name,
       d_moy,
       sum(ss_sales_price) sum_sales,
       avg(sum(ss_sales_price)) over
         (partition by i_category, i_brand, s_store_name, s_company_name)
         avg_monthly_sales
from item, store_sales, date_dim, store
where ss_item_sk = i_item_sk and
      ss_sold_date_sk = d_date_sk and
      ss_store_sk = s_store_sk and
      d_year in (2002) and
        ((i_category in ('Men','Books','Home') and
          i_class in ('accessories','entertainments','bedding')
         )
      or (i_category in ('Women','Children','Music') and
          i_class in ('maternity','toddlers','classical') 
        ))
group by i_category, i_class, i_brand,
         s_store_name, s_company_name, d_moy) tmp1
where case when (avg_monthly_sales <> 0) then (abs(sum_sales - avg_monthly_sales) / avg_monthly_sales) else null end > 0.1
order by sum_sales - avg_monthly_sales, s_store_name
limit 100;

-- end query 1 in stream 88 using template query89.tpl
\echo query_88 processed