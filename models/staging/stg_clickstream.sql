with source_data as (

    select *
    from {{ source('clickstream', 'raw_clickstream') }}

),

renamed as (

    select
        -- 날짜
        year,
        month,
        day,

        -- 세션 / 이벤트
        `session ID` as session_id,
        `order` as event_order,

        -- 사용자
        country,

        -- 상품
        product_id,
        page_main_category as category_code,
        colour as color_code,

        -- UI / UX
        location as location_code,
        `model photography` as photography_type_code,

        -- 가격
        price,
        `price 2` as price_segment_code,

        -- 페이지
        page as page_number

    from source_data

)

select * 
from renamed