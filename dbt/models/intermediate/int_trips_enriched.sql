{{
    config(
        materialized='view'
    )
}}

with trips as (

    select * from {{ ref('stg_taxi__trips') }}

),

zones as (

    select * from {{ ref('stg_taxi__zones') }}

),

enriched as (

    select
        trips.*,

        -- pickup zone の解決
        pickup_zones.borough      as pickup_borough,
        pickup_zones.zone         as pickup_zone,
        pickup_zones.service_zone as pickup_service_zone,

        -- dropoff zone の解決
        dropoff_zones.borough      as dropoff_borough,
        dropoff_zones.zone         as dropoff_zone,
        dropoff_zones.service_zone as dropoff_service_zone,

        -- 距離区分（マイルベース、下側包含）
        case
            when trips.trip_distance < 2 then 'short'
            when trips.trip_distance < 5 then 'medium'
            else 'long'
        end as trip_distance_category,

        -- 時間帯区分（pickup の hour ベース）
        case
            when hour(trips.pickup_at) between 5 and 11  then 'morning'
            when hour(trips.pickup_at) between 12 and 16 then 'afternoon'
            when hour(trips.pickup_at) between 17 and 21 then 'evening'
            else 'night'
        end as pickup_time_of_day

    from trips

    left join zones as pickup_zones
        on trips.pickup_location_id = pickup_zones.location_id

    left join zones as dropoff_zones
        on trips.dropoff_location_id = dropoff_zones.location_id

)

select * from enriched
