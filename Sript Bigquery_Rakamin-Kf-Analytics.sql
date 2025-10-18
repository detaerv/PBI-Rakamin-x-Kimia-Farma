-- ============================================================================
-- KIMIA FARMA BIG DATA ANALYTICS - COMPREHENSIVE ANALYSIS
-- Evaluasi Kinerja Bisnis 2020-2023
-- ============================================================================

-- ============================================================================
-- CLEANUP SCRIPT - Jalankan ini DULU sebelum script utama
-- ============================================================================
-- Script ini akan menghapus semua VIEW yang mungkin sudah ada
-- sehingga tidak conflict saat membuat TABLE baru

DROP VIEW IF EXISTS `rakamin-academi-data-analyst.kimia_farma.v_summary_kpi`;
DROP VIEW IF EXISTS `rakamin-academi-data-analyst.kimia_farma.v_top_branches`;
DROP VIEW IF EXISTS `rakamin-academi-data-analyst.kimia_farma.v_product_analysis`;
DROP VIEW IF EXISTS `rakamin-academi-data-analyst.kimia_farma.v_geographic_analysis`;
DROP VIEW IF EXISTS `rakamin-academi-data-analyst.kimia_farma.v_monthly_trends`;
DROP VIEW IF EXISTS `rakamin-academi-data-analyst.kimia_farma.v_customer_segmentation`;
DROP VIEW IF EXISTS `rakamin-academi-data-analyst.kimia_farma.v_discount_analysis`;
DROP VIEW IF EXISTS `rakamin-academi-data-analyst.kimia_farma.v_day_performance`;
DROP VIEW IF EXISTS `rakamin-academi-data-analyst.kimia_farma.v_rating_correlation`;
DROP VIEW IF EXISTS `rakamin-academi-data-analyst.kimia_farma.v_price_point_analysis`;
DROP VIEW IF EXISTS `rakamin-academi-data-analyst.kimia_farma.v_rating_gap_analysis`;

-- Juga hapus table lama jika ada
DROP TABLE IF EXISTS `rakamin-academi-data-analyst.kimia_farma.kf_analysis`;

-- ============================================================================
-- PART 1: IMPORT DATASET (sudah dilakukan via UI BigQuery)
-- ============================================================================
-- Dataset yang diimport:
-- 1. kf_final_transaction
-- 2. kf_inventory
-- 3. kf_kantor_cabang
-- 4. kf_product

-- ============================================================================
-- PART 2: CREATE ANALYSIS TABLE (Base Table)
-- ============================================================================

CREATE OR REPLACE TABLE `rakamin-academi-data-analyst.kimia_farma.kf_analysis` AS
WITH base_data AS (
  SELECT 
    -- Identifiers
    t.transaction_id,
    t.date,
    t.branch_id,
    c.branch_name,
    c.kota,
    c.provinsi,
    c.rating AS rating_cabang,
    
    -- Customer Info
    t.customer_name,
    
    -- Product Info
    t.product_id,
    p.product_name,
    t.price AS actual_price,
    t.discount_percentage,
    
    -- Financial Calculations
    CASE 
      WHEN t.price <= 50000 THEN 0.10
      WHEN t.price > 50000 AND t.price <= 100000 THEN 0.15
      WHEN t.price > 100000 AND t.price <= 300000 THEN 0.20
      WHEN t.price > 300000 AND t.price <= 500000 THEN 0.25
      ELSE 0.30
    END AS persentase_gross_laba,
    
    -- Rating
    t.rating AS rating_transaksi
    
  FROM 
    `rakamin-academi-data-analyst.kimia_farma.kf_final_transaction` t
  LEFT JOIN 
    `rakamin-academi-data-analyst.kimia_farma.kf_kantor_cabang` c
    ON t.branch_id = c.branch_id
  LEFT JOIN 
    `rakamin-academi-data-analyst.kimia_farma.kf_product` p
    ON t.product_id = p.product_id
)

SELECT 
  *,
  -- Calculated Fields
  actual_price * (discount_percentage / 100) AS discount_amount,
  actual_price - (actual_price * discount_percentage / 100) AS nett_sales,
  (actual_price - (actual_price * discount_percentage / 100)) * persentase_gross_laba AS nett_profit,
  
  -- Date Components untuk analisis temporal
  EXTRACT(YEAR FROM date) AS year,
  EXTRACT(MONTH FROM date) AS month,
  EXTRACT(QUARTER FROM date) AS quarter,
  FORMAT_DATE('%B', date) AS month_name,
  FORMAT_DATE('%A', date) AS day_name
FROM 
  base_data;


-- ============================================================================
-- PART 3: ANALYTICAL TABLES - KPI DASHBOARD
-- ============================================================================

-- ----------------------------------------------------------------------------
-- TABLE 1: Summary KPI per Tahun
-- ----------------------------------------------------------------------------
CREATE OR REPLACE TABLE `rakamin-academi-data-analyst.kimia_farma.v_summary_kpi` AS
SELECT 
  year,
  COUNT(DISTINCT transaction_id) AS total_transactions,
  COUNT(DISTINCT customer_name) AS total_customers,
  COUNT(DISTINCT branch_id) AS total_branches,
  COUNT(DISTINCT product_id) AS total_products_sold,
  
  ROUND(SUM(actual_price), 2) AS total_revenue_gross,
  ROUND(SUM(nett_sales), 2) AS total_revenue_net,
  ROUND(SUM(nett_profit), 2) AS total_profit,
  ROUND(SUM(discount_amount), 2) AS total_discount_given,
  
  ROUND(AVG(nett_sales), 2) AS avg_transaction_value,
  ROUND(AVG(rating_transaksi), 2) AS avg_rating_transaction,
  ROUND(AVG(discount_percentage), 2) AS avg_discount_percentage,
  
  ROUND((SUM(nett_profit) / SUM(nett_sales)) * 100, 2) AS profit_margin_percentage
FROM 
  `rakamin-academi-data-analyst.kimia_farma.kf_analysis`
GROUP BY 
  year
ORDER BY 
  year;


-- ----------------------------------------------------------------------------
-- TABLE 2: Top 10 Cabang dengan Profit Tertinggi
-- ----------------------------------------------------------------------------
CREATE OR REPLACE TABLE `rakamin-academi-data-analyst.kimia_farma.v_top_branches` AS
SELECT 
  branch_id,
  branch_name,
  kota,
  provinsi,
  ROUND(AVG(rating_cabang), 2) AS avg_rating_cabang,
  
  COUNT(DISTINCT transaction_id) AS total_transactions,
  COUNT(DISTINCT customer_name) AS total_customers,
  
  ROUND(SUM(nett_sales), 2) AS total_revenue,
  ROUND(SUM(nett_profit), 2) AS total_profit,
  ROUND(AVG(nett_sales), 2) AS avg_transaction_value,
  
  ROUND((SUM(nett_profit) / SUM(nett_sales)) * 100, 2) AS profit_margin_pct
FROM 
  `rakamin-academi-data-analyst.kimia_farma.kf_analysis`
GROUP BY 
  branch_id, branch_name, kota, provinsi
ORDER BY 
  total_profit DESC
LIMIT 10;


-- ----------------------------------------------------------------------------
-- TABLE 3: Analisis Produk Terlaris dan Paling Menguntungkan
-- ----------------------------------------------------------------------------
CREATE OR REPLACE TABLE `rakamin-academi-data-analyst.kimia_farma.v_product_analysis` AS
SELECT 
  product_id,
  product_name,
  
  COUNT(DISTINCT transaction_id) AS total_sold,
  COUNT(DISTINCT branch_id) AS available_in_branches,
  
  ROUND(SUM(nett_sales), 2) AS total_revenue,
  ROUND(SUM(nett_profit), 2) AS total_profit,
  ROUND(AVG(actual_price), 2) AS avg_price,
  ROUND(AVG(discount_percentage), 2) AS avg_discount_pct,
  ROUND(AVG(rating_transaksi), 2) AS avg_rating,
  
  ROUND((SUM(nett_profit) / SUM(nett_sales)) * 100, 2) AS profit_margin_pct
FROM 
  `rakamin-academi-data-analyst.kimia_farma.kf_analysis`
GROUP BY 
  product_id, product_name
ORDER BY 
  total_profit DESC
LIMIT 20;


-- ----------------------------------------------------------------------------
-- TABLE 4: Analisis Geografis (Provinsi)
-- ----------------------------------------------------------------------------
CREATE OR REPLACE TABLE `rakamin-academi-data-analyst.kimia_farma.v_geographic_analysis` AS
SELECT 
  provinsi,
  COUNT(DISTINCT branch_id) AS total_branches,
  COUNT(DISTINCT transaction_id) AS total_transactions,
  COUNT(DISTINCT customer_name) AS total_customers,
  
  ROUND(SUM(nett_sales), 2) AS total_revenue,
  ROUND(SUM(nett_profit), 2) AS total_profit,
  ROUND(AVG(nett_sales), 2) AS avg_transaction_value,
  ROUND(AVG(rating_cabang), 2) AS avg_branch_rating,
  ROUND(AVG(rating_transaksi), 2) AS avg_transaction_rating,
  
  ROUND((SUM(nett_profit) / SUM(nett_sales)) * 100, 2) AS profit_margin_pct
FROM 
  `rakamin-academi-data-analyst.kimia_farma.kf_analysis`
GROUP BY 
  provinsi
ORDER BY 
  total_profit DESC;


-- ----------------------------------------------------------------------------
-- TABLE 5: Analisis Tren Bulanan (Time Series)
-- ----------------------------------------------------------------------------
CREATE OR REPLACE TABLE `rakamin-academi-data-analyst.kimia_farma.v_monthly_trends` AS
SELECT 
  year,
  month,
  month_name,
  quarter,
  
  COUNT(DISTINCT transaction_id) AS total_transactions,
  COUNT(DISTINCT customer_name) AS total_customers,
  
  ROUND(SUM(nett_sales), 2) AS total_revenue,
  ROUND(SUM(nett_profit), 2) AS total_profit,
  ROUND(AVG(nett_sales), 2) AS avg_transaction_value,
  ROUND(AVG(rating_transaksi), 2) AS avg_rating,
  
  -- YoY Growth (untuk tahun yang sama)
  ROUND(SUM(nett_sales) - LAG(SUM(nett_sales)) OVER (PARTITION BY month ORDER BY year), 2) AS revenue_growth_yoy,
  ROUND(((SUM(nett_sales) - LAG(SUM(nett_sales)) OVER (PARTITION BY month ORDER BY year)) / 
         LAG(SUM(nett_sales)) OVER (PARTITION BY month ORDER BY year)) * 100, 2) AS revenue_growth_pct_yoy
FROM 
  `rakamin-academi-data-analyst.kimia_farma.kf_analysis`
GROUP BY 
  year, month, month_name, quarter
ORDER BY 
  year, month;


-- ----------------------------------------------------------------------------
-- TABLE 6: Customer Segmentation berdasarkan Nilai Transaksi
-- ----------------------------------------------------------------------------
CREATE OR REPLACE TABLE `rakamin-academi-data-analyst.kimia_farma.v_customer_segmentation` AS
WITH customer_metrics AS (
  SELECT 
    customer_name,
    COUNT(DISTINCT transaction_id) AS total_transactions,
    ROUND(SUM(nett_sales), 2) AS total_spent,
    ROUND(AVG(nett_sales), 2) AS avg_transaction_value,
    ROUND(AVG(rating_transaksi), 2) AS avg_rating,
    MAX(date) AS last_transaction_date,
    MIN(date) AS first_transaction_date
  FROM 
    `rakamin-academi-data-analyst.kimia_farma.kf_analysis`
  GROUP BY 
    customer_name
)

SELECT 
  customer_name,
  total_transactions,
  total_spent,
  avg_transaction_value,
  avg_rating,
  first_transaction_date,
  last_transaction_date,
  DATE_DIFF(last_transaction_date, first_transaction_date, DAY) AS customer_lifetime_days,
  
  -- Customer Segmentation
  CASE 
    WHEN total_spent >= 1000000 THEN 'VIP'
    WHEN total_spent >= 500000 THEN 'Premium'
    WHEN total_spent >= 200000 THEN 'Regular'
    ELSE 'Basic'
  END AS customer_segment,
  
  CASE 
    WHEN total_transactions >= 10 THEN 'Loyal'
    WHEN total_transactions >= 5 THEN 'Frequent'
    WHEN total_transactions >= 2 THEN 'Occasional'
    ELSE 'One-time'
  END AS loyalty_status
FROM 
  customer_metrics
ORDER BY 
  total_spent DESC;


-- ----------------------------------------------------------------------------
-- TABLE 7: Analisis Diskon dan Dampaknya
-- ----------------------------------------------------------------------------
CREATE OR REPLACE TABLE `rakamin-academi-data-analyst.kimia_farma.v_discount_analysis` AS
SELECT 
  CASE 
    WHEN discount_percentage = 0 THEN 'No Discount'
    WHEN discount_percentage <= 5 THEN '1-5%'
    WHEN discount_percentage <= 10 THEN '6-10%'
    WHEN discount_percentage <= 20 THEN '11-20%'
    ELSE '>20%'
  END AS discount_range,
  
  COUNT(DISTINCT transaction_id) AS total_transactions,
  ROUND(AVG(discount_percentage), 2) AS avg_discount_pct,
  ROUND(SUM(discount_amount), 2) AS total_discount_given,
  ROUND(SUM(nett_sales), 2) AS total_revenue,
  ROUND(SUM(nett_profit), 2) AS total_profit,
  ROUND(AVG(nett_sales), 2) AS avg_transaction_value,
  ROUND(AVG(rating_transaksi), 2) AS avg_rating,
  ROUND((SUM(nett_profit) / SUM(nett_sales)) * 100, 2) AS profit_margin_pct
FROM 
  `rakamin-academi-data-analyst.kimia_farma.kf_analysis`
GROUP BY 
  discount_range
ORDER BY 
  avg_discount_pct;


-- ============================================================================
-- PART 4: ADVANCED ANALYTICS - BUSINESS INSIGHTS
-- ============================================================================

-- ----------------------------------------------------------------------------
-- Analisis 1: Performa Hari dalam Seminggu
-- ----------------------------------------------------------------------------
CREATE OR REPLACE TABLE `rakamin-academi-data-analyst.kimia_farma.v_day_performance` AS
SELECT 
  day_name,
  EXTRACT(DAYOFWEEK FROM date) AS day_number,
  
  COUNT(DISTINCT transaction_id) AS total_transactions,
  ROUND(SUM(nett_sales), 2) AS total_revenue,
  ROUND(SUM(nett_profit), 2) AS total_profit,
  ROUND(AVG(nett_sales), 2) AS avg_transaction_value,
  ROUND(AVG(rating_transaksi), 2) AS avg_rating
FROM 
  `rakamin-academi-data-analyst.kimia_farma.kf_analysis`
GROUP BY 
  day_name, day_number
ORDER BY 
  day_number;


-- ----------------------------------------------------------------------------
-- Analisis 2: Korelasi Rating Cabang dengan Performa
-- ----------------------------------------------------------------------------
CREATE OR REPLACE TABLE `rakamin-academi-data-analyst.kimia_farma.v_rating_correlation` AS
SELECT 
  CASE 
    WHEN rating_cabang >= 4.5 THEN 'Excellent (4.5-5.0)'
    WHEN rating_cabang >= 4.0 THEN 'Good (4.0-4.4)'
    WHEN rating_cabang >= 3.5 THEN 'Average (3.5-3.9)'
    ELSE 'Below Average (<3.5)'
  END AS rating_category,
  
  COUNT(DISTINCT branch_id) AS total_branches,
  COUNT(DISTINCT transaction_id) AS total_transactions,
  
  ROUND(AVG(rating_cabang), 2) AS avg_branch_rating,
  ROUND(AVG(rating_transaksi), 2) AS avg_transaction_rating,
  ROUND(SUM(nett_sales), 2) AS total_revenue,
  ROUND(AVG(nett_sales), 2) AS avg_transaction_value,
  ROUND((SUM(nett_profit) / SUM(nett_sales)) * 100, 2) AS profit_margin_pct
FROM 
  `rakamin-academi-data-analyst.kimia_farma.kf_analysis`
GROUP BY 
  rating_category
ORDER BY 
  avg_branch_rating DESC;


-- ----------------------------------------------------------------------------
-- Analisis 3: Price Point Analysis
-- ----------------------------------------------------------------------------
CREATE OR REPLACE TABLE `rakamin-academi-data-analyst.kimia_farma.v_price_point_analysis` AS
SELECT 
  CASE 
    WHEN actual_price <= 50000 THEN '< Rp 50K (Margin 10%)'
    WHEN actual_price <= 100000 THEN 'Rp 50K-100K (Margin 15%)'
    WHEN actual_price <= 300000 THEN 'Rp 100K-300K (Margin 20%)'
    WHEN actual_price <= 500000 THEN 'Rp 300K-500K (Margin 25%)'
    ELSE '> Rp 500K (Margin 30%)'
  END AS price_segment,
  
  COUNT(DISTINCT transaction_id) AS total_transactions,
  ROUND(AVG(actual_price), 2) AS avg_price,
  ROUND(SUM(nett_sales), 2) AS total_revenue,
  ROUND(SUM(nett_profit), 2) AS total_profit,
  ROUND(AVG(persentase_gross_laba) * 100, 2) AS avg_margin_pct,
  ROUND(AVG(discount_percentage), 2) AS avg_discount_pct,
  ROUND(AVG(rating_transaksi), 2) AS avg_rating
FROM 
  `rakamin-academi-data-analyst.kimia_farma.kf_analysis`
GROUP BY 
  price_segment
ORDER BY 
  avg_price;


-- ----------------------------------------------------------------------------
-- Analisis 4: Rating Gap Analysis (UNTUK DASHBOARD - IMPORTANT!)
-- Top 5 Cabang dengan Rating Cabang Tertinggi tapi Rating Transaksi Rendah
-- ----------------------------------------------------------------------------
CREATE OR REPLACE TABLE `rakamin-academi-data-analyst.kimia_farma.v_rating_gap_analysis` AS
SELECT 
  branch_id,
  branch_name,
  kota,
  provinsi,
  ROUND(AVG(rating_cabang), 2) AS avg_rating_cabang,
  ROUND(AVG(rating_transaksi), 2) AS avg_rating_transaksi,
  
  -- Gap antara rating cabang vs transaksi (negatif = masalah service)
  ROUND(AVG(rating_cabang) - AVG(rating_transaksi), 2) AS rating_gap,
  
  COUNT(DISTINCT transaction_id) AS total_transactions,
  ROUND(SUM(nett_sales), 0) AS total_penjualan,
  
  -- Status analysis untuk action plan
  CASE 
    WHEN AVG(rating_cabang) >= 4.5 AND AVG(rating_transaksi) < 4.0 THEN 'Perlu Perhatian Urgent'
    WHEN AVG(rating_cabang) >= 4.0 AND AVG(rating_transaksi) < 3.8 THEN 'Perlu Improvement'
    WHEN AVG(rating_cabang) - AVG(rating_transaksi) > 0.5 THEN 'Ada Gap'
    ELSE 'Normal'
  END AS status_cabang
  
FROM 
  `rakamin-academi-data-analyst.kimia_farma.kf_analysis`
GROUP BY 
  branch_id, branch_name, kota, provinsi
HAVING 
  COUNT(DISTINCT transaction_id) >= 10  -- Min 10 transaksi untuk valid
ORDER BY 
  avg_rating_cabang DESC,
  avg_rating_transaksi ASC
LIMIT 5;


-- ============================================================================
-- VERIFICATION QUERIES
-- ============================================================================

-- Check total records in main analysis table
SELECT 
  'Total Records' AS metric,
  COUNT(*) AS value 
FROM 
  `rakamin-academi-data-analyst.kimia_farma.kf_analysis`;

-- Check data quality - null values
SELECT 
  'Records with Null Branch' AS metric,
  COUNT(*) AS value 
FROM 
  `rakamin-academi-data-analyst.kimia_farma.kf_analysis` 
WHERE 
  branch_name IS NULL;

-- Verify Rating Gap Analysis
SELECT 
  'Rating Gap Analysis' AS metric,
  COUNT(*) AS total_branches
FROM 
  `rakamin-academi-data-analyst.kimia_farma.v_rating_gap_analysis`;

-- ============================================================================
-- END OF SCRIPT
-- ============================================================================