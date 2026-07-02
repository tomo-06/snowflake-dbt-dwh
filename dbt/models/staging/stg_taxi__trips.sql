with source as (

    select * from {{ source('taxi_raw', 'RAW_YELLOW_TRIPDATA') }}

),

renamed as (

    select
        -- identifiers
        "VendorID"                                              as vendor_id,
        "RatecodeID"                                            as ratecode_id,
        "PULocationID"                                          as pickup_location_id,
        "DOLocationID"                                          as dropoff_location_id,
        "payment_type"                                          as payment_type,

        -- timestamps (epoch microseconds -> TIMESTAMP_NTZ)
        to_timestamp_ntz("tpep_pickup_datetime"  / 1000000)    as pickup_at,
        to_timestamp_ntz("tpep_dropoff_datetime" / 1000000)    as dropoff_at,

        -- derived: trip duration in minutes
        datediff(
            'minute',
            to_timestamp_ntz("tpep_pickup_datetime"  / 1000000),
            to_timestamp_ntz("tpep_dropoff_datetime" / 1000000)
        )                                                       as trip_minutes,

        -- trip measures
        "passenger_count"                                      as passenger_count,
        "trip_distance"                                        as trip_distance,
        "store_and_fwd_flag"                                   as store_and_fwd_flag,

        -- fare breakdown
        "fare_amount"                                          as fare_amount,
        "extra"                                                as extra,
        "mta_tax"                                              as mta_tax,
        "tip_amount"                                           as tip_amount,
        "tolls_amount"                                         as tolls_amount,
        "improvement_surcharge"                                as improvement_surcharge,
        "total_amount"                                         as total_amount,
        "congestion_surcharge"                                 as congestion_surcharge,
        "Airport_fee"                                          as airport_fee

    from source

)

select * from renamed
