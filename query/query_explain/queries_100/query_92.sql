SET max_parallel_workers_per_gather TO 0;
\o /var/lib/postgresql/data/explain/sf_100/explain_92.json
EXPLAIN (FORMAT JSON)
-- start query 1 in stream 92 using template query93.tpl
select  ss_customer_sk
            ,sum(act_sales) sumsales
      from (select ss_item_sk
                  ,ss_ticket_number
                  ,ss_customer_sk
                  ,case when sr_return_quantity is not null then (ss_quantity-sr_return_quantity)*ss_sales_price
                                                            else (ss_quantity*ss_sales_price) end act_sales
            from store_sales left outer join store_returns on (sr_item_sk = ss_item_sk
                                                               and sr_ticket_number = ss_ticket_number)
                ,reason
            where sr_reason_sk = r_reason_sk
              and r_reason_desc = 'Not the product that was ordred') t
      group by ss_customer_sk
      order by sumsales, ss_customer_sk
limit 100;

-- end query 1 in stream 92 using template query93.tpl
\echo query_92 processed