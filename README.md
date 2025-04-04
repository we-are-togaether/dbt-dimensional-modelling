<img src="docs/img/dbt-duckdb.png" align="right" />

# dbt dimensional modelling tutorial

Welcome to the tutorial on building a dimensional model with dbt and DuckDB.
The purpose of this tutorial is to let you experience DuckDB and dbt (Core).
Both of them are extremely powerful and open source.

Using the combination of both tools, allows you the experiment with dbt without the need for
compute resources in the cloud. You can simply create your models on your own local machine
and it won't cost you anything.

*Note: The **daredevils** among us, can delete all the models and start to rebuild them from scratch.*

You can find more information on [DuckDB here](https://duckdb.org/).\
And if you want to know more about dbt, start by looking [here](https://docs.getdbt.com/docs/introduction)

This tutorial is forked from a [github repository](https://github.com/Data-Engineer-Camp/dbt-dimensional-modelling.git), but adjusted according to preferences matching more closely with my own perspective on data modelling.

The original tutorial is also featured on the [dbt developer blog](https://docs.getdbt.com/blog/kimball-dimensional-model).

## Table of Contents

- [Part 0: Understand dimensional modelling concepts](#dimensional-modelling)
- [Part 1: Set up a mock dbt project and database](docs/part01-setup-dbt-project.md)
- [Part 2: Running our first dbt commands](docs/part02-our-first-dbt-commands.md)
- [Part 3: Identify the business process to model](docs/part03-identify-business-process.md)
- [Part 4: Identify the fact and dimension tables](docs/part04-identify-fact-dimension.md)
- [Part 5: Create the staging tables](docs/part05-create-staging.md)
- [Part 6: Create the dimension tables](docs/part06-create-dimension.md)
- [Part 7: Create the fact table](docs/part07-create-fact.md)
- [Part 8: Document the dimensional model relationships](docs/part08-document-model.md)
- [Part 9: Next steps](docs/part09-next-steps.md)

## Introduction

Dimensional modelling is one of many data modelling techniques that are used by data practitioners to organize and present data for analytics. Other data modelling techniques include Data Vault (DV), Third Normal Form (3NF), and One Big Table (OBT) to name a few.

![](docs/img/data-modelling.png)
*Data modelling techniques on a normalization vs denormalization scale*

While the relevancy of dimensional modelling [has been debated by data practitioners](https://discourse.getdbt.com/t/is-kimball-dimensional-modeling-still-relevant-in-a-modern-data-warehouse/225/6), it is still one of the most widely adopted data modelling technique for analytics.

Despite its popularity, resources on how to create dimensional models using dbt remain scarce and lack detail. This tutorial aims to solve this by providing the definitive guide to dimensional modelling with dbt.

## Dimensional modelling

Dimensional modelling is a technique introduced by Ralph Kimball in 1996 with his book, [The Data Warehouse Toolkit](https://www.kimballgroup.com/data-warehouse-business-intelligence-resources/books/data-warehouse-dw-toolkit/).

The goal of dimensional modelling is to take raw data and transform it into Fact and Dimension tables that represent the business.

![](docs/img/3nf-to-dimensional-model.png)

*Raw 3NF data to dimensional model*

The benefits of dimensional modelling are:

- **Simpler data model for analytics**: Users of dimensional models do not need to perform complex joins when consuming a dimensional model for analytics. Performing joins between fact and dimension tables are made simple through the use of surrogate keys.
- [**Don’t repeat yourself**](https://docs.getdbt.com/terms/dry): Dimensions can be easily re-used with other fact tables to avoid duplication of effort and code logic. Reusable dimensions are referred to as conformed dimensions.
- **Faster data retrieval**: Analytical queries executed against a dimensional model are significantly faster than a 3NF model since data transformations like joins and aggregations have been already applied.
- **Close alignment with actual business processes**: Business processes and metrics are modelled and calculated as part of dimensional modelling. This helps ensure that the modelled data is easily usable.

Now that we understand the broad concepts and benefits of dimensional modelling, let’s get hands-on and create our first dimensional model using dbt.

[Next &raquo;](docs/part01-setup-dbt-project.md)
