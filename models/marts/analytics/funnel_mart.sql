with funnel as (

    select *
    from {{ ref('int_session_funnel') }}

),

aggregated as (

    select
        count(*) as total_sessions,
        sum(step_1) as step_1_sessions,
        sum(step_2) as step_2_sessions,
        sum(step_3) as step_3_sessions,
        sum(step_4) as step_4_sessions,
        sum(step_5) as step_5_sessions

    from funnel

),

final as (

    select 'step_1' as step, step_1_sessions as session_count, 1.0 as conversion_rate from aggregated
    union all
    select 'step_2', step_2_sessions, round(step_2_sessions / step_1_sessions,2) from aggregated
    union all
    select 'step_3', step_3_sessions, round(step_3_sessions / step_1_sessions,2) from aggregated
    union all
    select 'step_4', step_4_sessions, round(step_4_sessions / step_1_sessions,2) from aggregated
    union all
    select 'step_5', step_5_sessions, round(step_5_sessions / step_1_sessions,2) from aggregated

)

select *
from final