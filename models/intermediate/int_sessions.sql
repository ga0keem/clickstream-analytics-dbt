with events as (

    select *
    from {{ ref('int_events_enriched') }}

),

aggregated as (

    select
        session_id,

        -- 시간
        min(event_date) as session_start_time,
        max(event_date) as session_end_time,

        -- duration
        timestamp_diff(
            timestamp(max(event_date)),
            timestamp(min(event_date)),
            second
        ) as session_duration,

        -- 행동
        count(event_id) as event_count,
        count(distinct product_id) as unique_products,
        max(page_number) as max_page

    from events
    group by session_id

)

select *
from aggregated