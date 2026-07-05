with trips as (
    select * from {{ ref('int_trips_enriched') }}
)

select
    -- foreign keys (surrogate keys to dimensions)
    {{ dbt_utils.generate_surrogate_key(['vendor_id']) }} as vendor_key,
    {{ dbt_utils.generate_surrogate_key(['coalesce(payment_type, -1)']) }} as payment_type_key,
    {{ dbt_utils.generate_surrogate_key(['coalesce(ratecode_id, -1)']) }} as rate_code_key,
    {{ dbt_utils.generate_surrogate_key(['pickup_location_id']) }} as pickup_location_key,
    {{ dbt_utils.generate_surrogate_key(['dropoff_location_id']) }} as dropoff_location_key,
    cast(to_char(pickup_at, 'YYYYMMDD') as integer) as pickup_date_key,

    -- degenerate dimensions
    trip_distance_category,
    pickup_time_of_day,

    -- timestamps
    pickup_at,
    dropoff_at,

    -- measures
    passenger_count,
    trip_distance,
    trip_minutes,
    fare_amount,
    tip_amount,
    total_amount
from trips
