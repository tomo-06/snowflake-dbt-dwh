with date_spine as (
    {{ dbt_utils.date_spine(
        datepart="day",
        start_date="to_date('2024-01-01')",
        end_date="to_date('2025-01-01')"
    ) }}
),

dates as (
    select
        cast(date_day as date) as date_day
    from date_spine
)

select
    cast(to_char(date_day, 'YYYYMMDD') as integer) as date_key,
    date_day,
    year(date_day)                as year,
    quarter(date_day)             as quarter,
    month(date_day)               as month,
    day(date_day)                 as day,
    dayofweek(date_day)           as day_of_week,
    dayname(date_day)             as day_name,
    monthname(date_day)           as month_name,
    case when dayofweek(date_day) in (0, 6) then true else false end as is_weekend
from dates
