with source as (

    select * from {{ source('adventure', 'address') }}

),

renamed as (

    select
        addressid as address_id,
        addressline1 as address_line_1,
        addressline2 as address_line_2,
        city,
        stateprovinceid as state_province_id,
        postalcode as postal_code,
        spatiallocation as spatial_location,
        rowguid,
        modifieddate as modified_date

    from source

)

select * from renamed
