with events as (

    select *
    from {{ ref('fct_events') }}

),

sessions as (

    select *
    from {{ ref('fct_sessions') }}

),

products as (

    select *
    from {{ ref('dim_products') }}

),

product_sessions as (

    select distinct
        e.product_id,
        e.session_id,
        s.max_page
    from events e
    join sessions s
        on e.session_id = s.session_id

),

conversion as (

    select
        product_id,
        count(session_id) as total_sessions,
        count(case when max_page >= 3 then 1 end) as converted_sessions
    from product_sessions
    group by product_id

)

select
    p.product_id,

    -- dimension
    p.category,
    p.avg_price,
    -- 이벤트 기준
    count(e.event_id) as total_views,
    -- 세션 기준
    round(safe_divide(c.converted_sessions, c.total_sessions),2) as conversion_rate

from products p
left join events e
    on p.product_id = e.product_id
left join conversion c
    on p.product_id = c.product_id

group by
    p.product_id,
    p.category,
    p.avg_price,
    c.converted_sessions,
    c.total_sessions