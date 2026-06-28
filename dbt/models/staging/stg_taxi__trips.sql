with source as (
    select * from {{ source('taxi_raw', 'RAW_YELLOW_TRIPDATA') }}
)

select * from source
limit 100
