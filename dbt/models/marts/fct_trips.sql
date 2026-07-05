{{
    config(
        materialized='incremental',
        unique_key='trip_key',
        incremental_strategy='merge',
        on_schema_change='sync_all_columns'
    )
}}

with trips as (
    select * from {{ ref('int_trips_enriched') }}
)

select
    -- surrogate key for this fact (unique per trip)
    {{ dbt_utils.generate_surrogate_key([
        'pickup_at',
        'dropoff_at',
        'pickup_location_id',
        'dropoff_location_id',
        'vendor_id',
        'total_amount'
    ]) }} as trip_key,

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

{% if is_incremental() %}

    -- 差分ロード: 既存テーブルにある最大 pickup_at より新しい行だけ取り込む
    where pickup_at > (select max(pickup_at) from {{ this }})

{% endif %}

{% if var('max_pickup_month', none) is not none %}

    -- A方式（段階投入）: 取り込み対象の上限月を var で制御
    {% if is_incremental() %}and{% else %}where{% endif %}
        pickup_at < '{{ var("max_pickup_month") }}'

{% endif %}
