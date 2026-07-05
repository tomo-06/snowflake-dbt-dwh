with source as (
    select * from {{ ref('seed_payment_type') }}
)

select
    {{ dbt_utils.generate_surrogate_key(['payment_type_id']) }} as payment_type_key,
    payment_type_id,
    payment_type_name
from source
