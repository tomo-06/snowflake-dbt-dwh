with source as (
    select * from {{ ref('seed_rate_code') }}
)

select
    {{ dbt_utils.generate_surrogate_key(['rate_code_id']) }} as rate_code_key,
    rate_code_id,
    rate_code_name
from source
