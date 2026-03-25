with events as (

    select *
    from {{ ref('int_events_enriched') }}

),

funnel as (

    select
        session_id,

        -- funnel step
        max(case when page_number = 1 then 1 else 0 end) as step_1,
        max(case when page_number = 2 then 1 else 0 end) as step_2,
        max(case when page_number = 3 then 1 else 0 end) as step_3,
        max(case when page_number = 4 then 1 else 0 end) as step_4,
        max(case when page_number = 5 then 1 else 0 end) as step_5,

        -- 최종 도달 단계
        max(page_number) as max_page_reached

    from events
    group by session_id

)

select *
from funnel