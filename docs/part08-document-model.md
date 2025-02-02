## Part 6: Document the dimensional model relationships


### Step 1: Create ERD
Let’s make it easier for consumers of our dimensional model to understand the relationships between tables by creating an [Entity Relationship Diagram (ERD)](https://www.visual-paradigm.com/guide/data-modeling/what-is-entity-relationship-diagram/). 

![](img/target-schema.png)

*Final dimensional model ERD*

The ERD will enable consumers of our dimensional model to quickly identify the keys and relationship type (one-to-one, one-to-many) that need to be used to join tables. 

### Step 2: Explore the documentation in your dbt project.
One big advantage of dbt is that the documentation is living next to the code, within the same version control.

Explore the documentation of your project by running:

```
dbt docs generate
```

Followed by:

```
dbt docs serve
```

This will allow you to visualize the documentation, browse the tables and columns, tests that are being carried out on the data, etc...
Please explore and have fun with it!

**I want to stress the importance of the lineage**. 
You can open the lineage by clicking on the `Lineage` at the bottom right hand corner in the dbt documentation.

This is a very powerful feature of dbt that allows you to track the data from the source to the final model. 
All we needed to do to create this lineage was use the `source` and `ref` macros in our SQL models.

This is a great way to do impact analysis on new changes. It allows you to easily catch downstream impacts.



[&laquo; Previous](part07-create-fact.md) [Next &raquo;](part09-next-steps.md)
