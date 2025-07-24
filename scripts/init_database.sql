/*
=============================================================
🧱 Create Database and Schemas – PostgreSQL Initialization
=============================================================

📌 Script Purpose:
      This script initializes the PostgreSQL environment for the Data Warehouse project. It creates a new database
      named `data_warehouse`. If a database with this name already exists, you must drop it manually before proceeding,
      as PostgreSQL does not allow `DROP DATABASE` inside a transaction block.

After switching to the new database, the script sets up the Medallion 
architecture by creating the following schemas:
  - 🔹 `bronze`: stores raw ingested data from source files (e.g., CSVs)
  - 🔸 `silver`: holds cleaned and transformed data
  - 🟡 `gold`: contains business-level **views** for reporting and analytics

This structure promotes clear separation between raw, processed, and reporting-ready data,
making your pipeline more modular and maintainable.

⚠️ NOTE:
Make sure you are connected to the `data_warehouse` database 
before executing the schema creation commands below.
*/

-- Step: Create Schemas (after switching to `data_warehouse` database)
CREATE SCHEMA bronze;
CREATE SCHEMA silver;
CREATE SCHEMA gold;
