## Part 5: Create the fact table (Gold layer)

After we have created all required dimension tables, we can now create the fact table for `fct_sales`. 

### Step 1: Create model files

Let’s create the new dbt model files that will contain our transformation code. Under [adventureworks/models/marts](../adventureworks/models/marts), create two files: 

- `fct_sales.sql` : This file will contain our SQL transformation code.

```
adventureworks/models/
└── marts
    ├──sales
        ├── _sales_models.yml
        ├── dim_product.sql
        └── fct_sales.sql
```

### Step 2: Fetch data from the upstream tables

To answer the business questions, we need columns from both `salesorderheader` and `salesorderdetail`. Let’s reflect that in `fct_sales.sql` : 

```sql
with stg_salesorderheader as (

    select *
    from {{ ref('stg_adventure__salesorderheaders') }}

),

stg_salesorderdetail as (

    select *
    from {{ ref('stg_adventure__salesorderdetails') }}

)

... 
```

### Step 3: Perform joins

The grain of the `fct_sales` table is one record in the SalesOrderDetail table, which describes the quantity of a product within a SalesOrderHeader. So we perform a join between `salesorderheader` and `salesorderdetail` to achieve that grain. 

```sql
... 

select
  ... 
from stg_salesorderdetail as sod
inner join stg_salesorderheader as soh
    on sod.sales_order_id = soh.sales_order_id
```

### Step 4: Create the surrogate key

Next, we create the surrogate key to uniquely identify each row in the fact table. Each row in the `fct_sales` table can be uniquely identified by the `salesorderid` and the `salesorderdetailid` which is why we use both columns in the `generate_surrogate_key()` macro. 

```sql
... 

select
  {{ dbt_utils.generate_surrogate_key(['stg_salesorderdetail.salesorderid', 'salesorderdetailid']) }} as sales_key,
  ... 
from stg_salesorderdetail as sod
inner join stg_salesorderheader as soh
    on sod.sales_order_id = soh.sales_order_id
```

### Step 5:  Select fact table columns

You can now select the fact table columns that will help us answer the business questions identified earlier. We want to be able to calculate the amount of revenue, and therefore we include a column revenue per sales order detail which is calculated by `unitprice * orderqty as revenue` . 

```sql
...

select
    {{ dbt_utils.generate_surrogate_key(['sod.sales_order_id', 'salesorderdetailid']) }} as sales_key,
    sod.sales_order_id,
    sod.sales_order_detail_id,
    sod.unit_price,
    sod.order_qty,
    sod.revenue
from stg_salesorderdetail as sod
inner join stg_salesorderheader as soh
    on sod.sales_order_id = soh.sales_order_id
```

### Step 6:  Create foreign surrogate keys

We want to be able to slice and dice our fact table against the dimension tables we have created in the earlier step. So we need to create the foreign surrogate keys that will be used to join the fact table back to the dimension tables. 

We achieve this by applying the `generate_surrogate_key()` macro to the same unique id columns that we had previously used when generating the surrogate keys in the dimension tables. 

```sql
...

select
    {{ dbt_utils.generate_surrogate_key(['sod.sales_order_id', 'sod.sales_order_detail_id']) }} as sales_key,
    {{ dbt_utils.generate_surrogate_key(['sod.product_id']) }} as product_key,
    {{ dbt_utils.generate_surrogate_key(['soh.customer_id']) }} as customer_key,
    {{ dbt_utils.generate_surrogate_key(['soh.ship_to_address_id']) }} as ship_to_address_key,
    {{ dbt_utils.generate_surrogate_key(['soh.bill_to_address_id']) }} as bill_to_address_key,
    sod.sales_order_id,
    sod.sales_order_detail_id,
    soh.customer_id,
    soh.ship_to_address_id,
    soh.bill_to_address_id,
    sod.product_id,
    soh.order_date,
    soh.order_status,
    sod.unit_price,
    sod.order_qty,
    sod.revenue,
    soh.due_date,
    soh.ship_date,
    soh.online_order_flag

from stg_salesorderdetail as sod
inner join stg_salesorderheader as soh
    on sod.sales_order_id = soh.sales_order_id
```

### Step 7: Choose a materialization type

You may choose from one of the following materialization types supported by dbt: 

- View
- Table
- Incremental

It is common for fact tables to be materialized as `incremental` or `table` depending on the data volume size.\
[As a rule of thumb](https://docs.getdbt.com/docs/build/incremental-models#when-should-i-use-an-incremental-model), if you are transforming millions or billions of rows, then you should start using the `incremental` materialization. In this example, we have chosen to go with `table` for simplicity. 

### Step 8: Create model documentation and tests

Alongside our `fct_sales.sql` model, we can document and test our model in the `_sales__models.yml` file. 

```yaml
version: 2

models:
  - name: fct_sales
    columns:

      - name: sales_key
        description: The surrogate key of the fct sales
        tests:
          - not_null
          - unique

      - name: sales_order_id
        description: The natural key of the saleorderheader
        tests:
          - not_null

      - name: sales_order_detail_id
        description: The natural key of the salesorderdetail
        tests:
          - not_null
      
      - name: product_key
        description: The foreign key of the product
        tests:
          - not_null

      - name: customer_key
        description: The foreign key of the customer
        tests:
          - not_null 
      
      - name: ship_to_address_key
        description: The foreign key of the shipping address
        tests:
          - not_null

      - name: revenue
        description: The revenue obtained by multiplying unitprice and orderqty 
```

### Step 9: Build dbt models

Execute the [dbt run](https://docs.getdbt.com/reference/commands/run) and [dbt test](https://docs.getdbt.com/reference/commands/run) commands to run and test your dbt models: 

```bash
dbt run  
```

followed by 

```bash
dbt test
```

Great work, you have successfully created your very first fact and dimension tables! Our dimensional model is now complete!! 🎉

[&laquo; Previous](part06-create-dimension.md) [Next &raquo;](part08-document-model.md)
