SET max_parallel_workers_per_gather TO 0;
\o /var/lib/postgresql/data/explain/sf_1000/explain_15.json
EXPLAIN (FORMAT JSON)
-- start query 1 in stream 15 using template query16.tpl
select  
   count(distinct cs_order_number) as "order count"
  ,sum(cs_ext_ship_cost) as "total shipping cost"
  ,sum(cs_net_profit) as "total net profit"
from
   catalog_sales cs1
  ,date_dim
  ,customer_address
  ,call_center
where
    d_date between '1999-5-01' and 
           (cast('1999-5-01' as date) + integer '60')
and cs1.cs_ship_date_sk = d_date_sk
and cs1.cs_ship_addr_sk = ca_address_sk
and ca_state = 'DE'
and cs1.cs_call_center_sk = cc_call_center_sk
and cc_county in ('Daviess County','Wadena County','Richland County','Bronx County',
                  'Franklin Parish'
)
and exists (select *
            from catalog_sales cs2
            where cs1.cs_order_number = cs2.cs_order_number
              and cs1.cs_warehouse_sk <> cs2.cs_warehouse_sk)
and not exists(select *
               from catalog_returns cr1
               where cs1.cs_order_number = cr1.cr_order_number)
order by count(distinct cs_order_number)
limit 100;

-- end query 1 in stream 15 using template query16.tpl
\echo query_15 processed