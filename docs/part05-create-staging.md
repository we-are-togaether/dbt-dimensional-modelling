## Part 4: Create staging or silver tables 

In this part, we create the staging or silver tables in our project.
This is where we rename the columns from our source system to a more readable format and convert to the correct data types.\
Additionally, we add any additional columns that we want to be available in our downstream tables that re-use the staging tables.

For more on the best practices of creating staging tables, [refer to the dbt documentation](https://docs.getdbt.com/best-practices/how-we-structure/2-staging)

### Step 1: Create model folder structure 

Let's first start by creating the folder structure nested under the `models` folder according to the [dbt best practices](https://docs.getdbt.com/best-practices/how-we-structure/1-guide-overview).
For increased focus and readability, we leave out the other folders and files and focus on the `models` folder.

```text
adventureworks
├── models
    ├── intermediate
    ├── marts
    └── staging
```

According to best practices, we create a subfolder per different source system that we require data from.\
In this case, this is only the `adventure` source system.

```text
adventureworks
├── models
    ├── intermediate
    ├── marts
    └── staging
        └── adventure
```

Under this folder, we nest the staging tables that we want to create, together with three important files:

```text
adventureworks
├── models
    ├── intermediate
    ├── marts
    └── staging
        └── adventure
            ├── _adventure__docs.md
            ├── _adventure__models.yml
            └── _adventure__sources.yml
```
We distinguish between the following files:

- `_adventure__docs.md` : This markdown file will contain documentation blocks for the staging tables that we create from adventure source.
- `_adventure__models.yml` : This yaml file will contain the documentation and tests for the staging tables that we create from the adventure source.
- `_adventure__sources.yml` : This yaml file will contain the sources that we use to create the staging tables.

*Note: Naming convention is to prefix these three files with an underscore `_` and separate source name and following part with a double underscore `__`.*

### Step 2: Create the staging models 

We will work out the staging model for the addresses table in the AdventureWorks database.

```text
adventureworks
├── models
    ├── intermediate
    ├── marts
    └── staging
        └── adventure
            ├── _adventure__docs.md
            ├── _adventure__models.yml
            ├── _adventure__sources.yml
            └── stg_adventure__addresses.sql
```

**File names:**
Creating a consistent pattern of file naming is crucial in dbt. 
File names must be unique and correspond to the name of the model when selected and created in the warehouse. 
We recommend putting as much clear information into the file name as possible, including a prefix for the layer the model exists in, important grouping information, and specific information about the entity or transformation in the model.
- ✅ `stg_[source]__[entity]s.sql` - the double underscore between source system and entity helps visually distinguish the separate parts in the case of a source name having multiple words. 
For instance, `google_analytics__campaigns` is always understandable, whereas to somebody unfamiliar `google_analytics_campaigns` could be `analytics_campaigns` from the `google` source system as easily as `campaigns` from the `google_analytics` source system. 
Think of it like an oxford comma, the extra clarity is very much worth the extra punctuation.
- ✅ Plural. SQL, and particularly SQL in dbt, should read as much like prose as we can achieve. 
We want to lean into the broad clarity and declarative nature of SQL when possible. 
As such, unless there’s a single order in your `orders` table, plural is the correct way to describe what is in a table with multiple rows.
- ❌ `stg_[entity].sql` - might be specific enough at first, but will break down in time. 
Adding the source system into the file name aids in discoverability, 
and allows understanding where a component model came from even if you aren't looking at the file tree.


Inside of the `stg_adventure__addresses.sql` file, we can see the structure of a `staging` or `silver` table:

```sql
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

```
We’ve organized our model into two CTEs: one pulling in a source table via the [source macro](https://docs.getdbt.com/docs/build/sources#selecting-from-a-source) and the other applying our transformations.
I want to stress the importance of this `source macro`.\
This will start to build our DAG (Directed Acyclic Graph) of dependencies, which is crucial for dbt to know the order in which to run our models.

While our later layers of transformation will vary greatly from model to model, every one of our staging models will follow this exact same pattern. 
As such, we need to make sure the pattern we’ve established is rock solid and consistent.

```sql
with source as (

    select * from {{ source('xxxx', 'xxxx') }}

),

renamed as (

    select
        ...
    from source

)

select * from renamed

```

We follow a similar approach to create all other remaining staging tables.\
In the end, we want to end up with a structure similar to this one:

```text
adventureworks
├── models
    ├── intermediate
    ├── marts
    └── staging
        └── adventure
            ├── _adventure__docs.md
            ├── _adventure__models.yml
            ├── _adventure__sources.yml
            ├── stg_adventure__addresses.sql
            ├── stg_adventure__countryregions.sql
            ├── stg_adventure__creditcards.sql
            ├── stg_adventure__customers.sql
            ├── stg_adventure__date.sql
            ├── stg_adventure__persons.sql
            ├── stg_adventure__productcategories.sql
            ├── stg_adventure__products.sql
            ├── stg_adventure__productsubcategories.sql
            ├── stg_adventure__salesorderdetails.sql
            ├── stg_adventure__salesorderheaders.sql
            ├── stg_adventure__salesorderheadersalesreasons.sql
            ├── stg_adventure__salesreasons.sql
            ├── stg_adventure__stateprovinces.sql
            └── stg_adventure__stores.sql
```

### Step 3: Create model documentation and tests

We will now document and test the staging models we have created in the accompanying `_adventure__models.yml` file.

```yaml
version: 2

models:
  - name: stg_adventure__persons
    description: "This table contains information about people."
    columns:
      - name: business_entity_id
        data_type: integer
        description: "Primary key of the table"
        data_tests:
          - unique
          - not_null

      - name: person_type_id
        data_type: varchar
        description: > 
          Primary type of person 
          SC = Store Contact, 
          IN = Individual (retail) customer, 
          SP = Sales person, 
          EM = Employee (non-sales), 
          VC = Vendor contact, 
          GC = General contact
        data_tests:
          - accepted_values: 
              values: ["SC", "IN", "SP", "EM", "VC", "GC"]
```

I hope you can immediately see some benefits of having this documentation and testing in the same repository as the code.\
In addition, the `yaml` file format makes this easily human readable and maintainable.

dbt has [four out of the box data tests](https://docs.getdbt.com/docs/build/data-tests#generic-data-tests) available:
- unique
- not_null
- accepted_values
- relationships

These are pretty self explanatory. But please [refer to the docs] if you want more clarifications on how to use them.

By installing extra packages, you can get many many many more data tests available.
Examples of dbt packages that contain more testing functionalities are:
- [dbt_utils](https://hub.getdbt.com/dbt-labs/dbt_utils/latest/)
- [dbt_expectations](https://hub.getdbt.com/calogica/dbt_expectations/latest/): as in great-expectations

[&laquo; Previous](part04-identify-fact-dimension.md) [Next &raquo;](part06-create-dimension.md)