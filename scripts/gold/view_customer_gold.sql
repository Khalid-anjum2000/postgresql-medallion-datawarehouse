/*
===============================================================================
DDL Script: Create Gold Views
===============================================================================
Script Purpose:
    This script creates views for the Gold layer in the data warehouse. 
    The Gold layer represents the final dimension and fact tables (Star Schema).

    Each view performs transformations and combines data from the Silver layer 
    to produce a clean, enriched, and business-ready dataset.

Usage:
    - These views can be queried directly for analytics and reporting.
    - Run this script after the Silver layer is fully populated.
===============================================================================
*/

-- =============================================================================
-- Create Dimension: gold.dim_customers
-- =============================================================================

CREATE VIEW gold.dim_customers as
select
	row_number() over( order by ci.cst_id) as customer_key,
	ci.cst_id as customer_id,
	ci.cst_key as customer_number,
	ci.cst_firstname as firstname,
	ci.cst_lastname as lastname,
	la.cntry as country,
	ci.cst_marital_status as marital_status,
	case when ci.cst_gndr != 'n/a' then ci.cst_gndr
		 else coalesce(ca.gen, 'n/a')
	end as gender,
	ca.bdate as birthdate,
	ci.cst_create_date as create_date
from silver.crm_cust_info ci
left join silver.erp_cust_az12 ca
on ci.cst_key= ca.cid
left join silver.erp_loc_a101 la
on ci.cst_key = la.cid



--product Dimesnion
CREATE VIEW gold.dim_products as
select 
	row_number() over(order by prd_id) as product_key,
	pr.prd_id as product_id,
	pr.prd_key as product_number,
	pr.prd_name as product_name,
	pr.cat_id as category_id,
	pc.cat as category,
	pc.subcat as subcategory,
	pc.maintenance as maintainance,
	pr.prd_cost as cost,
	pr.prd_line as product_line,
	pr.prd_start_dt as start_date
from silver.crm_prd_info pr
left join silver.erp_px_cat_g1v2 pc
on pr.cat_id=pc.id
where pr.prd_end_dt is null


--fact sales
CREATE VIEW gold.fact_sales as
SELECT 
	sls_ord_num as order_number,
	pr.product_key,
	cu.customer_key,
	sls_order_dt as order_date,
	sls_ship_dt as shipping_date,
	sls_due_dt as due_date,
	sls_sales as sales_amount,
	sls_quantity as quantity,
	sls_price as price 
FROM silver.crm_sales_details sd
left join gold.dim_products pr
on sd.sls_prd_key = pr.product_number
left join gold.dim_customers as cu
on sd.sls_cust_id = cu.customer_id
