with source as (

    select * from {{ source('adventure', 'salesorderheader') }}

),

renamed as (

    select
        salesorderid as sales_order_id,
        shipmethodid as ship_method_id,
        billtoaddressid as bill_to_address_id,
        taxamt as tax_amt,
        shiptoaddressid as ship_to_address_id,
        onlineorderflag as online_order_flag,
        territoryid as territory_id,
        status as order_status_id,
        orderdate as order_date,
        creditcardapprovalcode as credit_card_approval_code,
        subtotal as sub_total,
        creditcardid as creditcard_id,
        currencyrateid as currency_rate_id,
        revisionnumber as revision_number,
        freight,
        duedate as due_date,
        totaldue as total_due,
        customerid as customer_id,
        salespersonid as sales_person_id,
        shipdate as ship_date,
        accountnumber as account_number,
        modifieddate as modified_date,
        case
            when status = 1 then 'in_process'
            when status = 2 then 'approved'
            when status = 3 then 'backordered'
            when status = 4 then 'rejected'
            when status = 5 then 'shipped'
            when status = 6 then 'cancelled'
            else 'no_status'
        end as order_status

    from source

)

select * from renamed
