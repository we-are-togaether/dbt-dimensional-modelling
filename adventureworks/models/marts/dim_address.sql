with stg_address as (

    select *
    from {{ ref('stg_adventure__addresses') }}

),

stg_stateprovince as (

    select *
    from {{ ref('stg_adventure__stateprovinces') }}

),

stg_countryregion as (

    select *
    from {{ ref('stg_adventure__countryregions') }}

),

final as (

    select
        {{ dbt_utils.generate_surrogate_key(['stg_address.address_id']) }} as address_key,
        stg_address.address_id,
        stg_address.city,
        stg_stateprovince.state_province_code,
        stg_stateprovince.state_province_name,
        stg_countryregion.country_region_name,
        stg_countryregion.country_region_code
    from stg_address
    left join stg_stateprovince 
        on stg_address.state_province_id = stg_stateprovince.state_province_id
    left join stg_countryregion 
        on stg_stateprovince.country_region_code = stg_countryregion.country_region_code

)

select * from final
