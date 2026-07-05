with source as (
    select * from {{ ref('seed_vendor') }}
)

select
    {{ dbt_utils.generate_surrogate_key(['vendor_id']) }} as vendor_key,
    vendor_id,
    vendor_name
from source
