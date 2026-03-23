with source_data as (

    select *
    from {{ source('clickstream', 'raw_clickstream') }}

),

renamed as (

    select
        -- 날짜
        date(year, month, day) as event_date,

        -- 세션 / 이벤트
        `session ID` as session_id,
        `order` as event_order,

        -- 사용자
        country,

        -- 상품
        product_id,

        case page_main_category
            when 1 then 'trousers'
            when 2 then 'skirts'
            when 3 then 'blouses'
            when 4 then 'sale'
        end as category,

        case colour
            when 1 then 'beige'
            when 2 then 'black'
            when 3 then 'blue'
            when 4 then 'brown'
            when 5 then 'burgundy'
            when 6 then 'gray'
            when 7 then 'green'
            when 8 then 'navy blue'
            when 9 then 'multicolor'
            when 10 then 'olive'
            when 11 then 'pink'
            when 12 then 'red'
            when 13 then 'violet'
            when 14 then 'white'
        end as color,

        -- UI / UX
        location,

        case `model photography`
            when 1 then 'front'
            when 2 then 'profile'
        end as photography_type,

        -- 가격
        price,

        case `price 2`
            when 1 then 'high'
            else 'low'
        end as price_segment,

        -- 페이지
        page as page_number

    from source_data

)

select * 
from renamed