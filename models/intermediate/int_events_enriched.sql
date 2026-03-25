with events as (

    select *
    from {{ ref('stg_clickstream') }}

),

-- 기본 정제 (NULL)
cleaned as (

    select
        session_id,
        event_order,
        year,
        month,
        day,
        country,
        product_id,
        category_code,
        color_code,
        location_code,
        photography_type_code,
        price,
        price_segment_code,
        page_number

    from events

    where session_id is not null
      and event_order is not null
      and year is not null
      and month is not null
      and day is not null

),

-- 중복 제거 (이벤트 단위)
deduplicated as (

    select *
    from (
        select *,
            row_number() over (
                partition by session_id, event_order
                order by year, month, day
            ) as rn
        from cleaned
    )
    where rn = 1

),

-- country lookup
country_lookup as (

    select *
    from {{ ref('country_lookup') }}

),

-- enrichment / clean
final as (

    select
        -- surrogate key
        {{ dbt_utils.generate_surrogate_key([
            'e.session_id',
            'e.event_order'
        ]) }} as event_id,

        -- 세션 / 이벤트
        e.session_id,
        e.event_order,

        -- 날짜
        date(e.year, e.month, e.day) as event_date,

        -- 사용자
        coalesce(c.country_name, 'unknown') as country,

        -- 상품
        e.product_id,
        {{ get_category('e.category_code') }} as category,
        {{ get_color('e.color_code') }} as color,

        -- UI / UX
        {{ get_location('e.location_code') }} as location,

        case e.photography_type_code
            when 1 then 'front'
            when 2 then 'profile'
            else 'unknown'
        end as photography_type,

        -- 가격
        coalesce(e.price, 0) as price,

        case e.price_segment_code
            when 1 then 'high'
            when 2 then 'low'
            else 'unknown'
        end as price_segment,

        -- 페이지
        e.page_number

    from deduplicated e
    left join country_lookup c
        on e.country = c.country_code

)

select *
from final
order by session_id, event_order