# 📊 Kimia Farma Business Intelligence Dashboard
## Complete Guide: Dataset, SQL Script, Dashboard Interaktif, dan Interpretasi

---

## 📑 DAFTAR ISI

### BAGIAN 1: DATASET DOCUMENTATION
1. [Dataset Overview](#dataset-overview)
2. [Dataset Contents](#dataset-contents)
3. [Download Instructions](#download-instructions)
4. [Data Quality & License](#data-quality)

### BAGIAN 2: TUTORIAL DASHBOARD
5. [Persiapan BigQuery](#persiapan-bigquery)
6. [Koneksi ke Looker Studio](#koneksi-looker-studio)
7. [Membuat Data Sources](#membuat-data-sources)
8. [Page 1: Executive Summary](#page-1-executive-summary)
9. [Page 2: Branch Performance](#page-2-branch-performance)
10. [Page 3: Product Analysis](#page-3-product-analysis)
11. [Page 4: Customer Insights](#page-4-customer-insights)
12. [Filters & Styling](#filters-styling)
13. [Publish & GitHub Setup](#publish-github)

### BAGIAN 3: INTERPRETASI DASHBOARD
14. [Ringkasan Kinerja Umum](#1-ringkasan-kinerja-umum)
15. [Pertumbuhan Penjualan Tahunan](#2-pertumbuhan-penjualan-tahunan-yoy)
16. [Kinerja Provinsi dan Cabang](#3-kinerja-provinsi-dan-cabang)
17. [Cabang Rating Tinggi - Aktivitas Rendah](#4-cabang-dengan-rating-tinggi-tapi-aktivitas-rendah)
18. [Distribusi Profit per Provinsi](#5-distribusi-profit-per-provinsi)
19. [Revenue Growth Bulanan](#6-revenue-growth-yoy-bulan-ke-bulan)
20. [Analisis Pelanggan VIP](#7-top-10-vip-customers)
21. [Analisis Diskon dan Margin](#8-analisis-diskon-dan-profit-margin)
22. [Kinerja Mingguan](#9-analisis-kinerja-mingguan)
23. [Revenue by Rating Category](#10-revenue-distribution-by-rating)
24. [Kesimpulan Umum](#kesimpulan-umum)

---

# BAGIAN 1: DATASET DOCUMENTATION

## Dataset Overview

### 🎯 Quick Info
- **Project Name:** Kimia Farma Business Analytics
- **Periode Data:** 2020-2023
- **Total Size:** ~45 MB (compressed)
- **Format:** CSV Files
- **Purpose:** Educational - Data Analytics Portfolio

### 📥 Full Dataset Access

Full dataset tersedia di Google Drive untuk analisis lengkap.

**📥 [DOWNLOAD FULL DATASET (45MB)](https://drive.google.com/drive/u/0/folders/1L318uziHRRDufX6ybwas0--bAEbISA8B)**

---

## Dataset Contents

Dataset ini berisi data transaksi Kimia Farma periode **2020-2023** yang terdiri dari **4 file utama**:

### 1. `kf_final_transaction.csv`
**Deskripsi:** Data transaksi lengkap dari seluruh cabang Kimia Farma

**Spesifikasi:**
- **Jumlah Records:** 150,000+ transactions
- **Ukuran File:** ~30 MB
- **Periode Data:** 2020-2023
- **Format:** CSV, UTF-8 encoding

**Kolom:**
| Column Name | Type | Description |
|------------|------|-------------|
| `transaction_id` | STRING | Unique transaction identifier |
| `date` | DATE | Transaction date (YYYY-MM-DD) |
| `branch_id` | STRING | Branch identifier (FK to branches) |
| `customer_name` | STRING | Customer name |
| `product_id` | STRING | Product identifier (FK to products) |
| `price` | FLOAT | Product price (IDR) |
| `discount_percentage` | FLOAT | Discount applied (0-100) |
| `rating` | FLOAT | Transaction rating (1-5) |

**Sample Data:**
```csv
transaction_id,date,branch_id,customer_name,product_id,price,discount_percentage,rating
TRX001,2023-01-15,CAB001,Ahmad Yani,PRD123,125000,10,4.5
TRX002,2023-01-15,CAB002,Siti Nurhaliza,PRD456,85000,5,4.8
```

---

### 2. `kf_product.csv`
**Deskripsi:** Master data produk yang dijual di Kimia Farma

**Spesifikasi:**
- **Jumlah Records:** 500+ products
- **Ukuran File:** ~2 MB
- **Format:** CSV, UTF-8 encoding

**Kolom:**
| Column Name | Type | Description |
|------------|------|-------------|
| `product_id` | STRING | Unique product identifier |
| `product_name` | STRING | Product name |
| `category` | STRING | Product category |
| `sub_category` | STRING | Product sub-category |

**Sample Data:**
```csv
product_id,product_name,category,sub_category
PRD123,Paracetamol 500mg,Obat,Analgesik
PRD456,Vitamin C 1000mg,Suplemen,Vitamin
```

---

### 3. `kf_kantor_cabang.csv`
**Deskripsi:** Informasi lengkap tentang cabang-cabang Kimia Farma

**Spesifikasi:**
- **Jumlah Records:** 50 branches
- **Ukuran File:** ~500 KB
- **Coverage:** Seluruh Indonesia
- **Format:** CSV, UTF-8 encoding

**Kolom:**
| Column Name | Type | Description |
|------------|------|-------------|
| `branch_id` | STRING | Unique branch identifier |
| `branch_name` | STRING | Branch name |
| `kota` | STRING | City location |
| `provinsi` | STRING | Province location |
| `rating` | FLOAT | Branch rating (1-5) |

**Sample Data:**
```csv
branch_id,branch_name,kota,provinsi,rating
CAB001,Kimia Farma Jakarta Pusat,Jakarta,DKI Jakarta,4.5
CAB002,Kimia Farma Surabaya,Surabaya,Jawa Timur,4.7
```

---

### 4. `kf_inventory.csv`
**Deskripsi:** Data inventori produk di setiap cabang

**Spesifikasi:**
- **Jumlah Records:** Varies by branch and product
- **Ukuran File:** ~12 MB
- **Format:** CSV, UTF-8 encoding

**Kolom:**
| Column Name | Type | Description |
|------------|------|-------------|
| `inventory_id` | STRING | Unique inventory record ID |
| `branch_id` | STRING | Branch identifier |
| `product_id` | STRING | Product identifier |
| `stock_quantity` | INTEGER | Available stock |
| `opname_date` | DATE | Stock opname date |

**Sample Data:**
```csv
inventory_id,branch_id,product_id,stock_quantity,opname_date
INV001,CAB001,PRD123,150,2023-01-31
INV002,CAB001,PRD456,200,2023-01-31
```

---

## Download Instructions

### Method 1: Direct Download (Recommended)
1. Click the download link above
2. Click "Download" button in Google Drive
3. Wait for download to complete
4. Extract ZIP file if compressed

### Method 2: Using gdown (Python)
```bash
pip install gdown

# Download using file ID
gdown --id YOUR_FILE_ID -O kimia_farma_dataset.zip

# Extract
unzip kimia_farma_dataset.zip -d data/
```

### Method 3: Using wget
```bash
wget --no-check-certificate 'https://drive.google.com/uc?export=download&id=YOUR_FILE_ID' -O dataset.zip
```

### 🗂️ File Structure After Download

```
kimia-farma-dataset/
├── kf_final_transaction.csv    (30 MB)
├── kf_product.csv               (2 MB)
├── kf_kantor_cabang.csv         (500 KB)
├── kf_inventory.csv             (12 MB)
└── README.txt
```

---

## Data Quality

### Completeness:
- ✅ No missing transaction IDs
- ✅ All transactions have valid dates
- ✅ All foreign keys validated
- ⚠️ Some optional fields may be null (e.g., discount_percentage)

### Data Ranges:
- **Dates:** 2020-01-01 to 2023-12-31
- **Prices:** Rp 5,000 - Rp 1,500,000
- **Discounts:** 0% - 50%
- **Ratings:** 1.0 - 5.0

### Known Issues:
- None reported. Data has been cleaned and validated.

---

## 🔒 Data License & Usage

### License:
This dataset is provided for **educational purposes only** as part of Rakamin Academy Data Analyst Bootcamp.

### Terms of Use:
✅ **Allowed:**
- Educational projects
- Portfolio development
- Learning and practice
- Non-commercial analysis

❌ **Not Allowed:**
- Commercial use
- Redistribution without permission
- Claiming as original work

### Attribution:
```
Dataset: Kimia Farma Business Analytics
Source: Rakamin Academy - Data Analyst Bootcamp
Year: 2024-2025
```

---

## 🛠️ Tools Compatibility

This dataset is compatible with:

- ✅ **Google BigQuery** (Recommended)
- ✅ **PostgreSQL / MySQL**
- ✅ **Python Pandas**
- ✅ **R**
- ✅ **Excel** (for smaller subsets)
- ✅ **Tableau / Power BI**
- ✅ **Looker Studio**

---

# BAGIAN 2: TUTORIAL DASHBOARD

## 🎯 Overview Tutorial

### Yang Akan Dibuat:
- Dashboard interaktif dengan 12+ komponen
- Menggunakan 12 tabel dari BigQuery
- Visualisasi: Charts, Tables, Geo Map
- Filter interaktif untuk analisis dinamis

### Waktu Estimasi: 3-4 jam

### Tools yang Dibutuhkan:
- Google Cloud Platform (BigQuery)
- Looker Studio (Google Data Studio)
- Akun Google
- Dataset yang sudah didownload

---

## Persiapan BigQuery

### Step 1: Buka BigQuery Console
```
1. Kunjungi: https://console.cloud.google.com/bigquery
2. Login dengan akun Google Anda
3. Pastikan project "rakamin-academi-data-analyst" sudah dipilih
```

### Step 2: Create Dataset
```sql
CREATE SCHEMA IF NOT EXISTS `rakamin-academi-data-analyst.kimia_farma`;
```

### Step 3: Upload CSV Files

**Upload setiap file CSV:**
1. Go to BigQuery Console
2. Select dataset `kimia_farma`
3. Click **"Create Table"**
4. Source: Upload → Browse file
5. File format: CSV
6. Table name:
   - `kf_final_transaction`
   - `kf_product`
   - `kf_kantor_cabang`
   - `kf_inventory`
7. **Schema:** Auto-detect ✅
8. Click **"Create Table"**

### Step 4: Jalankan Cleanup Script

**PENTING: Jalankan ini TERLEBIH DAHULU!**

```sql
-- Copy dan paste script ini ke BigQuery Editor
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
DROP TABLE IF EXISTS `rakamin-academi-data-analyst.kimia_farma.kf_analysis`;
```

Klik **RUN** ▶️

### Step 5: Jalankan Script Utama

Copy semua script SQL dari file `kimia_farma_analysis.sql`, paste ke BigQuery editor dan **RUN**.

### Step 6: Verifikasi Tabel

Setelah script selesai, pastikan tabel-tabel ini ada di dataset `kimia_farma`:

✅ **Checklist Tabel:**
- [ ] `kf_analysis` (Base table)
- [ ] `v_summary_kpi`
- [ ] `v_top_branches`
- [ ] `v_product_analysis`
- [ ] `v_geographic_analysis`
- [ ] `v_monthly_trends`
- [ ] `v_customer_segmentation`
- [ ] `v_discount_analysis`
- [ ] `v_day_performance`
- [ ] `v_rating_correlation`
- [ ] `v_price_point_analysis`
- [ ] `v_rating_gap_analysis`

---

## Koneksi Looker Studio

### Step 1: Buka Looker Studio
```
1. Kunjungi: https://lookerstudio.google.com/
2. Login dengan akun Google yang sama dengan BigQuery
```

### Step 2: Create Report
1. **Create** → **Report**
2. **Add data to report**
3. **BigQuery** connector
4. **CUSTOM QUERY**

---

## Membuat Data Sources

Buat 12 data sources dengan query berikut:

### 1. KPI Summary
```sql
SELECT * FROM `rakamin-academi-data-analyst.kimia_farma.v_summary_kpi`
```

### 2. Top Branches
```sql
SELECT * FROM `rakamin-academi-data-analyst.kimia_farma.v_top_branches`
```

### 3. Product Analysis
```sql
SELECT * FROM `rakamin-academi-data-analyst.kimia_farma.v_product_analysis`
```

### 4. Geographic Analysis
```sql
SELECT * FROM `rakamin-academi-data-analyst.kimia_farma.v_geographic_analysis`
```

### 5. Monthly Trends
```sql
SELECT * FROM `rakamin-academi-data-analyst.kimia_farma.v_monthly_trends`
```

### 6. Customer Segmentation
```sql
SELECT * FROM `rakamin-academi-data-analyst.kimia_farma.v_customer_segmentation`
```

### 7. Discount Analysis
```sql
SELECT * FROM `rakamin-academi-data-analyst.kimia_farma.v_discount_analysis`
```

### 8. Day Performance
```sql
SELECT * FROM `rakamin-academi-data-analyst.kimia_farma.v_day_performance`
```

### 9. Rating Correlation
```sql
SELECT * FROM `rakamin-academi-data-analyst.kimia_farma.v_rating_correlation`
```

### 10. Price Point Analysis
```sql
SELECT * FROM `rakamin-academi-data-analyst.kimia_farma.v_price_point_analysis`
```

### 11. Rating Gap Analysis
```sql
SELECT * FROM `rakamin-academi-data-analyst.kimia_farma.v_rating_gap_analysis`
```

### 12. Base Analysis
```sql
SELECT * FROM `rakamin-academi-data-analyst.kimia_farma.kf_analysis`
```

---

## Page 1: Executive Summary

### Layout Suggestion
```
┌─────────────────────────────────────────────────┐
│         KPI Cards (4 cards)                     │
├──────────────────────┬─────────────────────────┤
│   Revenue Trend      │  Top 5 Provinces        │
├──────────────────────┴─────────────────────────┤
│           Profit Margin Gauge                   │
└─────────────────────────────────────────────────┘
```

### A. Header Title

1. **Add text** → Header
2. Text: "Kimia Farma Performance Dashboard 2020-2023"
3. Style:
   - Font: Roboto Bold
   - Size: 28px
   - Color: #0066CC
   - Align: Center

### B. KPI Cards (Scorecard)

Create 4 scorecards dengan layout horizontal:

**Card 1: Total Revenue**
1. **Add a chart** → **Scorecard**
2. Setup:
   - Data Source: **KPI Summary**
   - Metric: **total_sales**
   - Label: "Total Revenue"
3. Style:
   - Prefix: "Rp "
   - Compact numbers: ON
   - Background: Light blue (#E3F2FD)

**Card 2: Total Profit**
1. Metric: **total_profit**
2. Background: Light green (#E8F5E9)

**Card 3: Total Transactions**
1. Metric: **total_transactions**
2. Background: Light orange (#FFF3E0)

**Card 4: Average Rating**
1. Metric: **avg_rating**
2. Suffix: " / 5.0"
3. Background: Light purple (#F3E5F5)

**Layout:**
- Width: 25% each
- Spacing: 20px antar card
- Height: 120px semua card

### C. Revenue & Profit Trend (Time Series)

1. **Add a chart** → **Time series chart**
2. Setup:
   - Data Source: **Monthly Trends**
   - Date Range: Create field
     ```
     PARSE_DATE('%Y-%m', CONCAT(CAST(year AS STRING), '-', 
     LPAD(CAST(month AS STRING), 2, '0')))
     ```
     Name: "date_field"
   - Metric 1: **total_revenue** (Biru)
   - Metric 2: **total_profit** (Hijau)

3. Style:
   - Show legend: Bottom
   - Show data labels: ON
   - Line width: 3px

### D. Top 5 Provinces (Bar Chart)

1. **Add a chart** → **Bar chart**
2. Setup:
   - Data Source: **Geographic Analysis**
   - Dimension: **provinsi**
   - Metric: **total_revenue**
   - Sort: DESC
   - Limit: 5

3. Style:
   - Gradient color (hijau)
   - Show data labels: ON

### E. Profit Margin Gauge

1. **Add a chart** → **Gauge chart**
2. Setup:
   - Data Source: **KPI Summary**
   - Metric: **profit_margin_percentage**

3. Style:
   - Green zone: 20-30
   - Yellow: 15-20
   - Red: 0-15

---

## Page 2: Branch Performance

### Buat Page Baru

1. **Page** → **New page**
2. Rename: "Branch Performance"

### Layout
```
┌─────────────────────────────────────────────────┐
│         Top 10 Branches Performance             │
├──────────────────────┬─────────────────────────┤
│   Geographic Map     │  Rating Gap Analysis    │
└──────────────────────┴─────────────────────────┘
```

### A. Top 10 Branches Table

1. **Add a chart** → **Table**
2. Setup:
   - Data Source: **Top Branches**
   - Columns:
     * branch_name
     * kota
     * provinsi
     * total_revenue
     * total_profit
     * profit_margin_pct
     * avg_rating_cabang
   - Sort: total_profit DESC

3. **Conditional Formatting:**
   - **profit_margin_pct**:
     * > 20 → Hijau
     * 15-20 → Kuning
     * < 15 → Merah

### B. Geographic Map

1. **Add a chart** → **Geo chart**
2. Setup:
   - Data Source: **Geographic Analysis**
   - Location: **provinsi**
   - Size: **total_revenue**
   - Color: **profit_margin_pct**

3. Style:
   - Area: Indonesia
   - Gradient: Merah → Hijau

### C. Rating Gap Analysis Table

**PENTING untuk business insights!**

1. **Add a chart** → **Table**
2. Setup:
   - Data Source: **Rating Gap Analysis**
   - Columns:
     * branch_name
     * kota
     * avg_rating_cabang
     * avg_rating_transaksi
     * rating_gap
     * status_cabang

3. **Conditional Formatting:**
   - **rating_gap**:
     * > 0.5 → MERAH
     * 0.3-0.5 → ORANYE
     * < 0.3 → HIJAU

---

## Page 3: Product Analysis

### Buat Page Baru
**Page** → **New page** → "Product & Sales"

### A. Top 20 Products

1. **Bar chart** (Horizontal)
2. Setup:
   - Data Source: **Product Analysis**
   - Dimension: **product_name**
   - Metric: **total_profit**
   - Limit: 20

### B. Price Segment Performance

1. **Pie chart**
2. Setup:
   - Data Source: Create new:
   ```sql
   SELECT * FROM `rakamin-academi-data-analyst.kimia_farma.v_price_point_analysis`
   ```
   - Name: "Price Analysis"
   - Dimension: **price_segment**
   - Metric: **total_revenue**

3. Style: Donut chart

### C. Discount Impact Analysis

1. **Combo chart**
2. Setup:
   - Data Source: **Discount Analysis**
   - Dimension: **discount_range**
   - Left Y-axis: **total_revenue**
   - Right Y-axis: **profit_margin_pct**

### D. Day of Week Performance

1. **Column chart**
2. Setup:
   - Data Source: **Day Performance**
   - Dimension: **day_name**
   - Metric: **total_revenue**
   - Sort by: **day_number**

---

## Page 4: Customer Insights

### A. Customer Segmentation

1. **Pie chart**
2. Setup:
   - Data Source: Create:
   ```sql
   SELECT * FROM `rakamin-academi-data-analyst.kimia_farma.v_customer_segmentation`
   ```
   - Dimension: **customer_segment**
   - Metric: COUNT(**customer_name**)

3. Custom Colors:
   - VIP: #FFD700
   - Premium: #C0C0C0
   - Regular: #CD7F32
   - Basic: #808080

### B. Monthly Revenue with YoY

1. **Time series**
2. Setup:
   - Data Source: **Monthly Trends**
   - Date: Use date_field
   - Metrics: total_revenue, revenue_growth_yoy

---

## Filters & Styling

### A. Add Filters

**Date Range Filter:**
1. **Add a control** → **Date range**
2. Auto: Last 12 months
3. Apply to: All pages

**Province Dropdown:**
1. **Drop-down list**
2. Dimension: **provinsi**
3. Multiple selections: ON

**Year Selector:**
1. **Fixed-size list**
2. Dimension: **year**
3. Single selection

### B. Theme Setup

1. **Theme and layout**
2. Template: **Simple Light**
3. Colors:
   - Primary: **#0066CC**
   - Secondary: **#00A651**
   - Background: **#F8F9FA**

### C. Consistent Styling

All charts:
- Font: Roboto
- Border: 1px solid #E0E0E0
- Border radius: 8px
- Shadow: ON

---

## Publish GitHub

### A. Publish Dashboard

1. **Share** (kanan atas)
2. **Get report link**
3. Settings: **Anyone with link can view**
4. **Copy link**

### B. Screenshot Dashboard

**Untuk setiap page:**
1. Full screen (F11)
2. Screenshot:
   - Windows: Win + Shift + S
   - Mac: Cmd + Shift + 4
3. Save as:
   - `page1-executive-summary.png`
   - `page2-branch-performance.png`
   - `page3-product-analysis.png`
   - `page4-customer-insights.png`

### C. GitHub Repository Structure

```
kimia-farma-dashboard/
├── data/
│   ├── sample/
│   │   └── (sample CSV files)
│   └── DATASET.md              # This documentation
├── sql/
│   └── kimia_farma_analysis.sql
├── screenshots/
│   ├── page1-executive-summary.png
│   ├── page2-branch-performance.png
│   ├── page3-product-analysis.png
│   └── page4-customer-insights.png
├── README.md
└── TUTORIAL.md
```

---

# BAGIAN 3: INTERPRETASI DASHBOARD

## 1. Ringkasan Kinerja Umum

<img width="956" height="475" alt="image" src="https://github.com/user-attachments/assets/0d2551bb-57ba-402f-90e5-b967909b0253" />



**Isi:**

- 💰 **Total Sales:** Rp 347 Miliar
- 📈 **Total Profit:** Rp 98,5 Miliar
- 🛒 **Total Transactions:** 672,5 ribu
- 💵 **Rata-rata Transaksi:** Rp 516,3 ribu
- 🏪 **Total Branches:** 1.700 cabang
- ⭐ **Average Rating:** 4,0

**Interpretasi:**

Secara keseluruhan, performa bisnis Kimia Farma dalam periode 2020–2023 menunjukkan stabilitas tinggi. Volume transaksi yang besar dan jumlah cabang yang luas menandakan jaringan distribusi dan layanan yang kuat di seluruh Indonesia.

Rata-rata nilai transaksi (Rp 516 ribu) serta rating pelanggan 4,0 mencerminkan konsistensi kepuasan pelanggan.

Namun, selisih antara total sales dan profit (±28%) menunjukkan masih ada ruang untuk efisiensi biaya operasional.

---

## 2. Pertumbuhan Penjualan Tahunan (YoY)

<img width="948" height="308" alt="image" src="https://github.com/user-attachments/assets/4e2f8838-90f5-4df1-a7df-982bc4070052" />




**Interpretasi:**

Tren penjualan tahunan Kimia Farma relatif stabil dengan nilai penjualan di kisaran Rp 86–87 miliar per tahun.

Peningkatan tertinggi terjadi pada tahun 2022, namun penurunan tipis terlihat pada 2023 — kemungkinan dipengaruhi oleh fluktuasi permintaan pascapandemi dan perubahan pola pembelian pelanggan.

Secara umum, performa tahunan yang konsisten ini menunjukkan ketahanan bisnis jangka panjang, namun strategi pertumbuhan baru masih dibutuhkan untuk mendorong ekspansi di tahun-tahun berikutnya.

---

## 3. Kinerja Provinsi dan Cabang

<img width="944" height="412" alt="image" src="https://github.com/user-attachments/assets/9dfd8380-363a-4930-83d6-9073f87751fc" />



**Interpretasi:**

Provinsi dengan kontribusi tertinggi adalah:
- **Maluku** – Rp 238,8 juta
- **Jawa Tengah** – Rp 237,8 juta
- **Sumatera Utara** – Rp 236,2 juta

Sementara dari sisi jumlah transaksi, Sumatera Utara dan Sulawesi Utara menempati posisi teratas.

Artinya, walau wilayah barat Indonesia masih mendominasi pendapatan, aktivitas pelanggan di wilayah timur seperti Maluku mulai meningkat signifikan.

📌 **Insight penting:** Kimia Farma perlu memperkuat distribusi logistik dan strategi pemasaran di wilayah tengah-timur karena kontribusinya terus tumbuh.

---

## 4. Cabang dengan Rating Tinggi tapi Aktivitas Rendah

<img width="950" height="225" alt="image" src="https://github.com/user-attachments/assets/2d064b4b-dd5c-499b-84c3-a25e3c30e739" />



**Interpretasi:**

Beberapa cabang seperti Kepulauan Riau, Kalimantan Utara, dan Bangka Belitung mendapat rating sempurna (5,0) tetapi memiliki aktivitas transaksi rendah.

Fenomena ini menunjukkan bahwa pelayanan pelanggan sangat baik, tetapi volume penjualan belum optimal — kemungkinan karena minim promosi lokal atau daya beli wilayah lebih rendah.

💡 **Rekomendasi:** lakukan targeted marketing dan product bundling di cabang ber-rating tinggi agar potensi customer retention bisa dimaksimalkan.

---

## 5. Distribusi Profit per Provinsi

<img width="973" height="442" alt="image" src="https://github.com/user-attachments/assets/b2612a91-6de7-48f9-a816-27af5051302b" />



**Interpretasi:**

Profit tertinggi terkonsentrasi di Jawa Barat, Jawa Tengah, Kalimantan Timur, dan Sumatera Utara, masing-masing menghasilkan puluhan miliar rupiah.

Sedangkan wilayah timur seperti Nusa Tenggara dan Maluku menghasilkan margin lebih kecil, menunjukkan adanya disparitas geografis dalam kontribusi keuntungan.

Hal ini bisa menjadi dasar untuk meninjau kembali alokasi stok, strategi harga, dan kebutuhan ekspansi cabang di wilayah timur.

---

## 6. Revenue Growth YoY (Bulan ke Bulan)

<img width="501" height="335" alt="image" src="https://github.com/user-attachments/assets/9ae66b65-b71b-4192-a25c-9e4fc7323015" />



**Interpretasi:**

Perubahan pendapatan bulanan memperlihatkan fluktuasi yang cukup signifikan, dengan beberapa bulan mengalami penurunan besar (misal -226 juta pada Februari).

Peningkatan positif paling konsisten terlihat pada kuartal ketiga (Juli–September).

📈 Hal ini menunjukkan bahwa puncak aktivitas penjualan terjadi pertengahan tahun, kemungkinan dipengaruhi oleh peningkatan permintaan obat dan produk kesehatan di musim tertentu.

---

## 7. Top 10 VIP Customers

<img width="419" height="378" alt="image" src="https://github.com/user-attachments/assets/175ae846-1078-4fa9-ab8b-18eb0561f4fc" />




**Interpretasi:**

Seluruh pelanggan dengan total transaksi terbanyak termasuk kategori VIP Loyal, dengan nama-nama seperti Michael Smith dan Jennifer Smith (fiktif data anonim).

Ini menunjukkan sistem loyalitas Kimia Farma berjalan efektif — pelanggan dengan volume tinggi tetap aktif bertransaksi secara konsisten.

💡 **Insight:** strategi loyalty rewards dan personalisasi promosi dapat dipertahankan bahkan diperluas ke segmen non-VIP untuk meningkatkan engagement.

---

## 8. Analisis Diskon dan Profit Margin

<img width="494" height="346" alt="image" src="https://github.com/user-attachments/assets/b189de59-357d-4c5b-a7e8-a5eeb1c2dab0" />



**Interpretasi:**

Cabang dengan diskon 1–5% menghasilkan revenue tertinggi (Rp 335,5 miliar) dan margin optimal (±11,5%).

Sementara diskon lebih besar (>10%) justru menurunkan profit margin.

📊 Artinya, strategi potongan harga moderat lebih efektif daripada agresif — karena tetap mendorong pembelian tanpa mengorbankan margin keuntungan.

---

## 9. Analisis Kinerja Mingguan

<img width="435" height="349" alt="image" src="https://github.com/user-attachments/assets/459eb92a-67df-4a7e-b5ee-cc3a886a58ca" />



**Interpretasi:**

Penjualan tertinggi terjadi pada hari Senin dan Jumat, sedangkan paling rendah pada akhir pekan.

Pola ini konsisten dengan perilaku konsumen apotek dan klinik — di mana pembelian biasanya meningkat di awal minggu (resep baru) dan menjelang akhir minggu (persiapan akhir pekan).

💡 **Insight operasional:** cabang bisa meningkatkan stok atau promosi pada dua hari tersebut untuk memaksimalkan pendapatan.

---

## 10. Revenue Distribution by Rating

<img width="938" height="410" alt="image" src="https://github.com/user-attachments/assets/e1df9320-b119-4d97-bee8-0397e144d7d7" />



**Interpretasi:**

Kategori dengan rating "Excellent (4.5–5.0)" menyumbang pendapatan tertinggi (sekitar Rp 160 miliar).

Menunjukkan adanya hubungan positif antara kepuasan pelanggan dan pendapatan — semakin tinggi rating, semakin besar revenue cabang tersebut.

📈 Hal ini memperkuat bukti bahwa layanan pelanggan berkualitas langsung berdampak pada performa finansial.

---

## Kesimpulan Umum

✅ Performa bisnis stabil dan merata di seluruh cabang besar, namun masih ada potensi peningkatan di wilayah timur.

✅ Strategi diskon moderat (1–5%) terbukti paling menguntungkan.

✅ Kualitas layanan pelanggan tinggi menjadi kekuatan utama Kimia Farma.

✅ Diperlukan strategi optimasi cabang ber-rating tinggi namun low sales agar potensi pertumbuhan lebih merata.

Dashboard ini memberikan dasar kuat bagi pengambilan keputusan berbasis data (data-driven strategy).

---


## 🧠 Tech Stack
- **Google BigQuery**
- **Looker Studio**
- **SQL Analytics**

---

## 📚 Features
- 🔹 4 Interactive Pages  
- 🔹 12+ Visualizations  
- 🔹 Real-time Filtering  
- 🔹 Geographic Analysis  

---

## 📁 Repository Structure
```
kimia-farma-dashboard/
├── sql/               → SQL analysis scripts  
├── data/              → Raw & processed datasets  
├── screenshots/       → Dashboard visualizations
├── docs/              → Documentation
└── README.md          → Complete project guide
```

---

## 📞 Support & Resources

### 📘 Documentation
- **BigQuery:** [Console Link](https://console.cloud.google.com/bigquery?ws=!1m7!1m6!12m5!1m3!1sRAKAMIN-ACADEMI-DATA-ANALYST!2sUS-CENTRAL1!3s84D236)  
- **Looker Studio:** [Dashboard Link](https://lookerstudio.google.com/reporting/816e6a7a-8532-45cf-9b4d-b7a96065bb83)

### 👤 Contact
- **Email:** [detaerviana9@gmail.com](mailto:detaerviana9@gmail.com)  
- **GitHub:** [@detaerv](https://github.com/detaerv)  
- **LinkedIn:** [Deta Erviana](https://www.linkedin.com/in/detaerviana)

---

## 🙏 Acknowledgments
**Data Provider:** Kimia Farma (educational purposes)  
**Program:** Rakamin Academy – Data Analyst Bootcamp  
**Version:** 2.0  
**Last Updated:** January 18, 2025  

*Complete Guide: Dataset + Tutorial + Interpretation by Rakamin Academy*
