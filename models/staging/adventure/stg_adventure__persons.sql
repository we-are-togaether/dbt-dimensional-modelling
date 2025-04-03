with source as (

    select * from {{ source('adventure', 'person') }}

),

renamed as (

    select
        businessentityid as business_entity_id,
        title,
        firstname,
        middlename,
        lastname,
        persontype as person_type_id,
        namestyle,
        suffix,
        emailpromotion,
        rowguid,
        modifieddate as modified_date,
        trim(
            concat(
                coalesce(firstname, ''),
                ' ',
                coalesce(middlename, ''),
                ' ',
                coalesce(lastname, '')
            )
        ) as fullname,
        case persontype
            when 'EM' then 'Employee'
            when 'IN' then 'Individual retail customer'
            when 'SP' then 'Sales Person'
            when 'VC' then 'Vendor Contact'
            when 'GC' then 'General Contact'
            when 'SC' then 'Store Contact'
            else 'Unknown'
        end as person_type

    from source

)

select * from renamed
