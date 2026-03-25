with sessions as (

    select *
    from {{ ref('int_sessions') }}

),

events as (

    select *
    from {{ ref('int_events_enriched') }}

),

session_country as (

    select
        session_id,
        any_value(country) as country
    from events
    group by session_id

)

select
    s.session_id,

    -- metrics
    s.session_duration,
    s.event_count,
    s.unique_products,
    s.max_page,

    -- dimension
    sc.country

from sessions s
left join session_country sc
    on s.session_id = sc.session_id