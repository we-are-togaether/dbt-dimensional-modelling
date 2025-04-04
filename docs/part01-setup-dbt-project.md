## Part 1: Setup dbt project and database

### Step 1: Before you get started / Prerequisites

Before you can get started:

- You must have Python 3.8 or above installed
- You should have a basic understanding of SQL
- It's a benefit if you have a basic understanding of [dbt](https://docs.getdbt.com/docs/quickstarts/overview)
- It might be handy to have [DBeaver](https://dbeaver.io/) installed to query your DuckDB database. It's also possible to query directly via the command line with DuckDB.\
  For more information on how to set up DBeaver with DuckDB, see later in the documentation: [Use DBeaver to connect to DuckDB](./part02-our-first-dbt-commands#step-4-use-dbeaver-to-connect-to-duckdb)


### Step 2: Clone the repository and set up virtual env

1. Navigate to a location on your local machine where you want to clone the repository.
2. Clone the [github repository](https://github.com/we-are-togaether/dbt-dimensional-modelling.git) by running this command in your terminal:

```
git clone https://github.com/we-are-togaether/dbt-dimensional-modelling.git
```
3. Change into the local repository
```
cd dbt-dimensional-modelling/
```
4. Create a virtual environment for your python project dependencies. This will create a .venv folder in your project.

```
python -m venv .venv
```
5. Activate the virtual environment

**Windows**
```bash
.venv/scripts/activate
```
**Mac**
```bash
source .venv/bin/activate
```

### Step 3: Install python dependencies

Install the requirements for the project at once.
```bash
pip install -r "requirements.txt"
```

### Step 4: Install pre-commit locally in order to deliver clean code

In this repository, we are working with `pre-commit`.  
More information on [the official website](https://pre-commit.com/).  
Pre-commit hooks make sure that checks are executed when you want to locally commit your code.  
This will improve code quality and make everyone in the project follow the same standards.

To make sure you can make use of pre-commit, run:

```bash
pre-commit install
```

[&laquo; Previous](../README.md) [Next &raquo;](part02-our-first-dbt-commands.md)
