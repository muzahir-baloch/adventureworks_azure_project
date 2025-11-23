# CI CD plan for AdventureWorks Azure

## Scope for Phase 1

Database: Azure SQL `adw_dev_db`  
Environment: Dev only (Test and Prod later)

SQL scripts:
- 001_create_adventureworks_schema.sql
- 002_seed_sample_data.sql

## Deployment model

Source control: GitHub repo `adventureworks_azure_project`  
Pipeline engine: Azure DevOps Pipelines (YAML)

Stages (target):

1. Dev
   - Trigger on push to `main` for `sql/*.sql`
   - Run 001, then 002 against Dev

2. Test
   - Later: run same scripts against `adw_test_db`
   - Manual approval before running

3. Prod
   - Later: run same scripts against `adw_prod_db`
   - Manual approval and protected variables

## Execution approach

- Use Azure DevOps service connection to the Azure subscription
- Use SQLCMD or `Azure SQL Database deployment` task to execute:
  - `sql/001_create_adventureworks_schema.sql`
  - `sql/002_seed_sample_data.sql`

## Naming

Azure DevOps project: `AdventureWorks-Azure`  
Default pipeline YAML: `pipelines/db-deploy.yml`
