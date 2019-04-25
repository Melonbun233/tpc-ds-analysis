with operators as (
    SELECT
      CASE
      WHEN "Rows Removed by Filter" is not null
            or "Rows Removed by Join Filter" is not null
        THEN "Node Type" || '+filter'
      ELSE "Node Type"
      END AS op_name,
      *
    FROM nodes
)
, filtered_stats as (
select
  count (op_name) as occurrences,
  count (distinct query_id) as queries,
  sum("Actual Rows" * "Plan Width" * "Actual Loops") as bytes_returned,
  sum((
        coalesce(nullif("Rows Removed by Filter", null) :: numeric, 0)
        + coalesce(nullif("Rows Removed by Join Filter", null) :: numeric, 0)
      )
      * "Plan Width") as bytes_filtered,
  op_name,
  array_agg(distinct query_id) queries_present,
  array_remove(array_agg(distinct "Relation Name"), null) as related_table
from operators
where "Rows Removed by Join Filter" is not null
or "Rows Removed by Filter" is not null
group by op_name
)
select * from filtered_stats
;

--- distinct queries that contain filter
select count(distinct query_id),
       count(*)
       from nodes
where "Rows Removed by Filter" is not null or "Rows Removed by Join Filter" is not null;

--- sort analysis with parent/child
with sort_parents as (
    SELECT
      child.query_id     AS query_id,
      parent."Node Type" || parent."Strategy" AS parent_node_type,
      child."Node Type"  AS child_node_type,
      child."Actual Rows" as child_rows,
      child."Plan Width" as child_width
    --       , *
    FROM nodes parent
      JOIN nodes child
        ON (child.parent_id = parent.id AND child.query_id = parent.query_id)
    WHERE child."Node Type" = 'Sort'
)
  --select * from sort_parents where query_id = 0;

select
  count (distinct query_id),
  parent_node_type, child_node_type,
  sum(child_rows * child_width) as rowsXwidth,
  array_agg(query_id) as queries
from sort_parents
group by parent_node_type, child_node_type
;

/* operations per query?
lots of parallel operations
*/
SELECT
  query_id,
  count (distinct "Node Type") unique_operation_count,
  count(*) total_operation_count,
  array_agg("Node Type") as nodes
from nodes
group by query_id
;

--- filter stats for specific ops
with filter_op as (
  select "Node Type" as op_name, *
  from nodes where ("Rows Removed by Filter" is not null or "Rows Removed by Join Filter" is not null)
  and "Node Type"!='Hash Join' and "Node Type"!='Merge Join'
),
filter_stats as (
  select
    op_name,
    sum("Actual Rows" * "Plan Width" * "Actual Loops") as bytes_returned,
    sum((
          coalesce(nullif("Rows Removed by Filter", null) :: numeric, 0)
          + coalesce(nullif("Rows Removed by Join Filter", null) :: numeric, 0)
        )
        * "Plan Width") as bytes_filtered,
    array_agg(distinct query_id) queries_present,
    array_remove(array_agg(distinct "Relation Name"), null) as related_table,
    -- row width stats
    avg("Plan Width") as row_width_avg,
    max("Plan Width") as row_width_max,
    min("Plan Width") as row_width_min,
    percentile_disc(0.5) within group (order by "Plan Width" ) as row_width_median,
    -- loop stats
    avg("Actual Loops") as loop_avg,
    max("Actual Loops") as loop_max,
    min("Actual Loops") as loop_min,
    percentile_disc(0.5) within group ( order by "Actual Loops" ) as loop_median,
    -- plan row stats
    avg("Plan Rows") as row_in_avg,
    max("Plan Rows") as row_in_max,
    min("Plan Rows") as row_in_min,
    percentile_disc(0.5) within group ( order by "Plan Rows" ) as row_in_median
  from filter_op group by op_name
)
select * from filter_stats;

-- filter stats for join (both merge and hash)
with filter_op as (
  select "Node Type" as op_name, *
  from nodes where "Rows Removed by Filter" is not null or "Rows Removed by Join Filter" is not null
),
filter_stats as (
  select
    sum("Actual Rows" * "Plan Width" * "Actual Loops") as bytes_returned,
    sum((
          coalesce(nullif("Rows Removed by Filter", null) :: numeric, 0)
          + coalesce(nullif("Rows Removed by Join Filter", null) :: numeric, 0)
        )
        * "Plan Width") as bytes_filtered,
    array_agg(distinct query_id) queries_present,
    array_remove(array_agg(distinct "Relation Name"), null) as related_table,
    -- row width stats
    avg("Plan Width") as row_width_avg,
    max("Plan Width") as row_width_max,
    min("Plan Width") as row_width_min,
    percentile_disc(0.5) within group (order by "Plan Width" ) as row_width_median,
    -- loop stats
    avg("Actual Loops") as loop_avg,
    max("Actual Loops") as loop_max,
    min("Actual Loops") as loop_min,
    percentile_disc(0.5) within group ( order by "Actual Loops" ) as loop_median,
    -- plan row stats
    avg("Plan Rows") as row_in_avg,
    max("Plan Rows") as row_in_max,
    min("Plan Rows") as row_in_min,
    percentile_disc(0.5) within group ( order by "Plan Rows" ) as row_in_median
  from filter_op where op_name = 'Merge Join' or op_name = 'Hash Join'
)
select * from filter_stats;

-- filter stats for all filters
with filter_op as (
  select "Node Type" as op_name, *
  from nodes where ("Rows Removed by Filter" is not null or "Rows Removed by Join Filter" is not null)
  and "Node Type"!='Hash Join' and "Node Type"!='Merge Join'
),
filter_stats as (
  select
    sum("Actual Rows" * "Plan Width" * "Actual Loops") as bytes_returned,
    sum((
          coalesce(nullif("Rows Removed by Filter", null) :: numeric, 0)
          + coalesce(nullif("Rows Removed by Join Filter", null) :: numeric, 0)
        )
        * "Plan Width") as bytes_filtered,
    array_agg(distinct query_id) queries_present,
    array_remove(array_agg(distinct "Relation Name"), null) as related_table,
    -- row width stats
    avg("Plan Width") as row_width_avg,
    max("Plan Width") as row_width_max,
    min("Plan Width") as row_width_min,
    percentile_disc(0.5) within group (order by "Plan Width" ) as row_width_median,
    -- loop stats
    avg("Actual Loops") as loop_avg,
    max("Actual Loops") as loop_max,
    min("Actual Loops") as loop_min,
    percentile_disc(0.5) within group ( order by "Actual Loops" ) as loop_median,
    -- plan row stats
    avg("Plan Rows") as row_in_avg,
    max("Plan Rows") as row_in_max,
    min("Plan Rows") as row_in_min,
    percentile_disc(0.5) within group ( order by "Plan Rows" ) as row_in_median
  from filter_op
)
select * from filter_stats;


select "Filter"
  from nodes where ("Rows Removed by Filter" is not null or "Rows Removed by Join Filter" is not null) and ("Filter" is not null)