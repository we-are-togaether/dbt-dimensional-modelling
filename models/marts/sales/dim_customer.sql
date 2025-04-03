with stg_customer as (

    select *
    from {{ ref('stg_adventure__customers') }}

),

stg_person as (

    select *
    from {{ ref('stg_adventure__persons') }}

),

stg_store as (

    select *
    from {{ ref('stg_adventure__stores') }}

)

select


    {{ dbt_utils.generate_surrogate_key(['stg_customer.customer_id']) }}
        as customer_key,
    stg_customer.customer_id,
    coalesce(stg_person.business_entity_id, stg_store.business_entity_id)
        as business_entity_id,
    coalesce(stg_person.fullname, stg_store.store_name) as customer_name,
    coalesce(stg_person.person_type, '_N/A') as person_type

from stg_customer
left join stg_person
    on stg_customer.person_id = stg_person.business_entity_id
left join stg_store
    on stg_customer.store_id = stg_store.business_entity_id
