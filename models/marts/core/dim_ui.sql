with events as (

    select *
    from {{ ref('int_events_enriched') }}

)

select distinct
    location,
    photography_type

from events