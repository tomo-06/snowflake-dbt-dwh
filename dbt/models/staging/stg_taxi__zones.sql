with source as (

    select * from {{ source('taxi_raw', 'RAW_TAXI_ZONE_LOOKUP') }}

),

renamed as (

    select
        -- identifiers
        locationid      as location_id,

        -- attributes
        borough         as borough,
        zone            as zone,
        service_zone    as service_zone

    from source

)

select * from renamed