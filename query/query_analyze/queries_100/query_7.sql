SET max_parallel_workers_per_gather TO 0;
\o /var/lib/postgresql/data/analyze/sf_100/analyze_7.json
EXPLAIN (FORMAT JSON, ANALYZE)
-- start query 1 in stream 7 using template query8.tpl
select  s_store_name
      ,sum(ss_net_profit)
 from store_sales
     ,date_dim
     ,store,
     (select ca_zip
     from (
      SELECT substr(ca_zip,1,5) ca_zip
      FROM customer_address
      WHERE substr(ca_zip,1,5) IN (
                          '77465','97995','72537','21900','42499','52330',
                          '83610','73167','15686','85030','46804',
                          '88233','65158','12472','53269','80508',
                          '24560','52813','81622','16418','58991',
                          '50537','27152','54999','16785','82675',
                          '76889','81395','55130','38896','14208',
                          '98598','66935','52476','64233','90009',
                          '18332','49832','30797','45499','79663',
                          '43550','36279','99439','70375','30001',
                          '54009','69517','69740','59166','39009',
                          '96191','87649','39365','38379','45582',
                          '97450','45053','43288','46058','45113',
                          '47915','91376','89267','18138','72838',
                          '51397','38489','30740','73330','30795',
                          '16409','40256','53770','95419','51779',
                          '35561','83054','75117','24060','98388',
                          '42093','87121','82328','11033','57947',
                          '17917','74350','99900','61796','33493',
                          '99641','37504','66987','68014','65720',
                          '73105','26199','91335','17785','47313',
                          '62391','70292','15180','29492','65259',
                          '81625','69908','48239','70434','77483',
                          '24399','57375','25135','45747','11531',
                          '42789','78192','18654','86653','90239',
                          '77981','56007','26458','93115','75238',
                          '53312','12453','13404','35264','94144',
                          '90302','17422','18112','52238','89482',
                          '50734','44227','47560','28406','42543',
                          '41638','76496','87800','45526','41726',
                          '89427','11366','63993','58761','23561',
                          '82202','77510','90870','65019','99090',
                          '37461','21030','20086','36115','72203',
                          '46791','51062','22342','16184','24835',
                          '63840','33770','18818','32561','41117',
                          '16725','93309','57913','77395','41849',
                          '69152','75768','50195','92692','74443',
                          '14704','51107','43524','79407','71004',
                          '20227','40386','66426','74289','96908',
                          '49399','62680','82289','14104','82830',
                          '90876','34874','74969','77895','68353',
                          '83811','30134','63490','49806','73141',
                          '77733','46489','89660','10935','27003',
                          '79364','77982','12882','33558','23370',
                          '60564','14983','24939','33447','63759',
                          '16462','70273','15189','63406','42185',
                          '32505','63108','48305','83529','31536',
                          '76094','19184','83590','33560','93962',
                          '32510','98269','12912','80541','99138',
                          '51278','27848','90747','14890','91593',
                          '74080','54731','15976','12289','45422',
                          '55999','22900','17535','28293','48231',
                          '50488','80367','24273','67884','69225',
                          '80496','22359','47461','12915','45218',
                          '91034','84049','11455','15766','97588',
                          '24927','49694','31029','60639','32025',
                          '30265','71497','60326','44707','90330',
                          '39539','84911','73782','43783','65204',
                          '42466','37845','70726','36584','98658',
                          '23536','31272','76587','36960','98215',
                          '66851','51442','13313','57121','90226',
                          '98625','91584','55432','51860','97515',
                          '50220','91855','70844','81729','94215',
                          '27426','77085','41373','91641','91399',
                          '41262','87202','32971','28564','80190',
                          '32532','78675','26993','72447','52550',
                          '93469','94488','34282','66268','69331',
                          '25830','51007','91581','29966','83846',
                          '70752','79546','42087','82460','52786',
                          '66746','20182','17010','55861','51876',
                          '23805','40636','51267','37212','81557',
                          '27311','33246','38973','80038','12735',
                          '20676','23267','36439','71060','74201',
                          '18946','37237','48913','79605','33851',
                          '99932','49974','34725','13531','13242',
                          '63267','51214','14542','57525','50551',
                          '34631','32594','27557','14478','11548',
                          '66318','88581','38329','86517','99349',
                          '29495','94651','51906','48404','92612',
                          '61791','81485','86188','45253','88898',
                          '56706','45106','88875','78579')
     intersect
      select ca_zip
      from (SELECT substr(ca_zip,1,5) ca_zip,count(*) cnt
            FROM customer_address, customer
            WHERE ca_address_sk = c_current_addr_sk and
                  c_preferred_cust_flag='Y'
            group by ca_zip
            having count(*) > 10)A1)A2) V1
 where ss_store_sk = s_store_sk
  and ss_sold_date_sk = d_date_sk
  and d_qoy = 1 and d_year = 2000
  and (substr(s_zip,1,2) = substr(V1.ca_zip,1,2))
 group by s_store_name
 order by s_store_name
 limit 100;

-- end query 1 in stream 7 using template query8.tpl
\echo query_7 processed