with source as (

    select * from {{ source('adventure', 'customer') }}

),

renamed as (

    select
        customerid as customer_id,
        personid as person_id,
        storeid as store_id,
        territoryid as territory_id,
        cast(case
            when personid is not null then 1
            else 0
        end as boolean) as is_individual,
        cast(case
            when storeid is not null then 1
            else 0
        end as boolean) as is_store,
        case
            when personid is not null then 'b2c'
            when storeid is not null then 'b2b'
            else 'Unknown'
        end as customer_category

    from source

)

select * from renamed
