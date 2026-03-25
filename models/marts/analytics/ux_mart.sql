with events as (

    select *
    from {{ ref('fct_events') }}

),

sessions as (

    select *
    from {{ ref('fct_sessions') }}

),

ux_sessions as (

    select distinct
        e.location,
        e.photography_type,
        e.session_id,
        s.max_page
    from events e
    join sessions s
        on e.session_id = s.session_id

),

session_agg as (

    select
        location,
        photography_type,
        count(session_id) as total_sessions,
        count(case when max_page >= 3 then 1 end) as converted_sessions
    from ux_sessions
    group by location, photography_type

),

event_agg as (

    select
        location,
        photography_type,
        count(event_id) as click_count
    from events
    group by location, photography_type

)

select
    e.location,
    e.photography_type,

    -- 이벤트 기준
    e.click_count,
    -- 세션 기준
    round(safe_divide(s.converted_sessions, s.total_sessions), 2) as conversion_rate

from event_agg e
left join session_agg s
    on e.location = s.location
    and e.photography_type = s.photography_type