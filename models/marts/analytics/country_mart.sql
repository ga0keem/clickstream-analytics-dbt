with sessions as (

    select *
    from {{ ref('fct_sessions') }}

),

aggregated as (

    select
        country,
        count(session_id) as session_count,
        round(avg(max_page),2) as avg_page_depth,
        count(case when max_page >= 3 then 1 end) as converted_sessions

    from sessions
    group by country

)

select
    country,
    session_count,
    avg_page_depth,
    round(safe_divide(converted_sessions, session_count), 2) as conversion_rate

from aggregated