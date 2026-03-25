with events as (

    select *
    from {{ ref('int_events_enriched') }}

),

product_perf as (

    select
        product_id,

        -- 성과
        count(event_id) as total_views,
        avg(price) as avg_price,

        -- category
        any_value(category) as category

    from events
    group by product_id

)

select *
from product_perf