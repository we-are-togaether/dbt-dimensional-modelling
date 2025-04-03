with source as (

    select * from {{ source('adventure', 'store') }}

),

renamed as (

    select
        businessentityid as business_entity_id,
        storename as store_name,
        salespersonid as sales_person_id,
        modifieddate as modified_date
    from source

)

select * from renamed
