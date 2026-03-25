with events as (

    select *
    from {{ ref('int_events_enriched') }}

)

select distinct
    country
from events