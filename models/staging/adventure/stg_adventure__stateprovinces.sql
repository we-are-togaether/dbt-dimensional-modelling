with source as (

    select * from {{ source('adventure', 'stateprovince') }}

),

renamed as (

    select
        stateprovinceid as state_province_id,
        countryregioncode as country_region_code,
        name as state_province_name,
        territoryid as territory_id,
        isonlystateprovinceflag as is_only_state_province_flag,
        stateprovincecode as state_province_code,
        rowguid,
        modifieddate as modified_date

    from source

)

select * from renamed
