with events as (

    select *
    from {{ ref('int_events_enriched') }}

)

select
    -- PK
    event_id,

    -- session / event
    session_id,
    event_order,

    -- 날짜
    event_date,

    -- 상품
    product_id,
    category,

    -- 사용자
    country,

    -- 페이지
    page_number,

    -- 가격
    price,
    price_segment,

    -- UI / UX
    location,
    photography_type

from events