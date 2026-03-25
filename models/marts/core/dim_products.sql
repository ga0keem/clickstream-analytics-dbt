with product_perf as (

    select *
    from {{ ref('int_product_performance') }}

)

select
    product_id,
    category,
    avg_price,
    case
        when avg_price >= 50 then 'high'
        else 'low'
    end as price_segment

from product_perf