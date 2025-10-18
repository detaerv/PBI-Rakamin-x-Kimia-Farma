# 📊 Tutorial Lengkap: Membuat Dashboard Kimia Farma
## Dari Script SQL hingga Dashboard Interaktif di Looker Studio

---

## 🎯 OVERVIEW

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

---

## 📋 DAFTAR ISI

1. [Persiapan BigQuery](#1-persiapan-bigquery)
2. [Koneksi ke Looker Studio](#2-koneksi-ke-looker-studio)
3. [Membuat Data Sources](#3-membuat-data-sources)
4. [Desain Dashboard - Page 1: Executive Summary](#4-page-1-executive-summary)
5. [Desain Dashboard - Page 2: Branch Performance](#5-page-2-branch-performance)
6. [Desain Dashboard - Page 3: Product Analysis](#6-page-3-product-analysis)
7. [Desain Dashboard - Page 4: Customer Insights](#7-page-4-customer-insights)
8. [Menambahkan Filters & Controls](#8-filters-controls)
9. [Styling & Branding](#9-styling-branding)
10. [Publish & Share ke GitHub](#10-publish-share)

---

## 1. PERSIAPAN BIGQUERY

### Step 1.1: Buka BigQuery Console
```
1. Kunjungi: https://console.cloud.google.com/bigquery
2. Login dengan akun Google Anda
3. Pastikan project "rakamin-academi-data-analyst" sudah dipilih
```

### Step 1.2: Jalankan Cleanup Script
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

### Step 1.3: Jalankan Script Utama
Copy semua script SQL dari dokumen yang sudah ada, lalu paste ke BigQuery editor dan RUN.

### Step 1.4: Verifikasi Tabel
Setelah script selesai, pastikan tabel-tabel ini ada di dataset `kimia_farma`:

✅ Checklist Tabel:
- [ ] kf_analysis (base table)
- [ ] v_summary_kpi
- [ ] v_top_branches
- [ ] v_product_analysis
- [ ] v_geographic_analysis
- [ ] v_monthly_trends
- [ ] v_customer_segmentation
- [ ] v_discount_analysis
- [ ] v_day_performance
- [ ] v_rating_correlation
- [ ] v_price_point_analysis
- [ ] v_rating_gap_analysis

**Cara Cek:**
Lihat di panel kiri BigQuery → Dataset kimia_farma → Expand → Lihat semua tabel

---

## 2. KONEKSI KE LOOKER STUDIO

### Step 2.1: Buka Looker Studio
```
1. Kunjungi: https://lookerstudio.google.com
2. Login dengan akun Google yang SAMA dengan BigQuery
3. Tunggu hingga halaman utama muncul
```

### Step 2.2: Buat Report Baru
```
1. Klik tombol "Create" (pojok kiri atas)
2. Pilih "Report"
3. Akan muncul "Add data to report"
```

---

## 3. MEMBUAT DATA SOURCES

**PENTING:** Anda perlu membuat **5 Data Source terpisah** untuk performa optimal.

### Data Source 1: KPI Summary

**Langkah-langkah:**
1. Di popup "Add data to report", cari dan klik **"BigQuery"**
2. Pilih **"CUSTOM QUERY"**
3. Pilih Project: `rakamin-academi-data-analyst`
4. Paste query ini:

```sql
SELECT * FROM `rakamin-academi-data-analyst.kimia_farma.v_summary_kpi`
```

5. Klik **"CONNECT"**
6. Rename data source menjadi: **"KPI Summary"**
7. Klik **"ADD TO REPORT"**

### Data Source 2: Top Branches

**Jangan close window!** Tambah data source kedua:

1. Klik **"Resource"** → **"Manage added data sources"**
2. Klik **"ADD A DATA SOURCE"** (tombol biru)
3. Pilih **BigQuery** → **CUSTOM QUERY**
4. Pilih project yang sama
5. Paste query:

```sql
SELECT * FROM `rakamin-academi-data-analyst.kimia_farma.v_top_branches`
```

6. **CONNECT** → Rename: **"Top Branches"** → **ADD TO REPORT**

### Data Source 3: Geographic Analysis

Ulangi langkah yang sama:

```sql
SELECT * FROM `rakamin-academi-data-analyst.kimia_farma.v_geographic_analysis`
```

Name: **"Geographic Analysis"**

### Data Source 4: Monthly Trends

```sql
SELECT * FROM `rakamin-academi-data-analyst.kimia_farma.v_monthly_trends`
```

Name: **"Monthly Trends"**

### Data Source 5: Rating Gap

```sql
SELECT * FROM `rakamin-academi-data-analyst.kimia_farma.v_rating_gap_analysis`
```

Name: **"Rating Gap Analysis"**

### Data Source 6: Product Analysis

```sql
SELECT * FROM `rakamin-academi-data-analyst.kimia_farma.v_product_analysis`
```

Name: **"Product Analysis"**

### Data Source 7: Discount Analysis

```sql
SELECT * FROM `rakamin-academi-data-analyst.kimia_farma.v_discount_analysis`
```

Name: **"Discount Analysis"**

### Data Source 8: Day Performance

```sql
SELECT * FROM `rakamin-academi-data-analyst.kimia_farma.v_day_performance`
```

Name: **"Day Performance"**

---

## 4. PAGE 1: EXECUTIVE SUMMARY

### Layout Overview
```
┌─────────────────────────────────────────────────┐
│  LOGO  | KIMIA FARMA DASHBOARD | [FILTERS]     │
├─────────────────────────────────────────────────┤
│  [Revenue]  [Profit]  [Trans]  [Customers] [%] │  ← KPI Cards
├─────────────────────────────────────────────────┤
│           Revenue & Profit Trend                │  ← Line Chart
│              (Time Series)                      │
├──────────────────────┬─────────────────────────┤
│  Top 5 Provinces     │   Profit Margin by Year │
│    (Bar Chart)       │     (Gauge Chart)       │
└──────────────────────┴─────────────────────────┘
```

### A. Tambahkan Header

1. **Insert Text** (toolbar atas)
   - Ketik: **"KIMIA FARMA BUSINESS DASHBOARD"**
   - Font: Roboto Bold, Size: 32
   - Warna: #0066CC (Biru)
   - Posisi: Top-left

2. **Insert Text** (untuk subtitle)
   - Ketik: "Periode 2020-2023 | Data Analytics Report"
   - Font: Roboto Regular, Size: 14
   - Warna: #666666 (Abu)

### B. Buat KPI Scorecards (5 Cards)

**KPI 1: Total Revenue**

1. Klik **"Add a chart"** → Pilih **"Scorecard"**
2. Di panel kanan (Setup):
   - Data Source: **KPI Summary**
   - Metric: **total_revenue_net**
3. Di tab **STYLE**:
   - Metric Name: "Total Revenue (Net)"
   - Number Format: Currency → Custom → IDR
   - Compact Numbers: ON
   - Font Size: 36

**KPI 2: Total Profit**
- Data Source: KPI Summary
- Metric: **total_profit**
- Label: "Total Profit"
- Format: Currency (IDR)

**KPI 3: Total Transactions**
- Metric: **total_transactions**
- Label: "Total Transaksi"
- Format: Number

**KPI 4: Total Customers**
- Metric: **total_customers**
- Label: "Total Pelanggan"
- Format: Number

**KPI 5: Profit Margin**
- Metric: **profit_margin_percentage**
- Label: "Profit Margin %"
- Format: Percent

**Layout Tips:**
- Susun 5 scorecard dalam 1 baris horizontal
- Spacing: 20px antar card
- Height: 120px semua card
- Background color: Putih dengan shadow

### C. Revenue & Profit Trend (Time Series)

1. **Add a chart** → **Time series chart**
2. Setup:
   - Data Source: **Monthly Trends**
   - Date Range Dimension: Buat kombinasi year + month
     * Klik "Create field" → Ketik formula:
     ```
     PARSE_DATE('%Y-%m', CONCAT(CAST(year AS STRING), '-', 
     LPAD(CAST(month AS STRING), 2, '0')))
     ```
     * Name: "date_field"
   - Metric 1: **total_revenue** (Line - Biru)
   - Metric 2: **total_profit** (Line - Hijau)

3. Style:
   - Show legend: Bottom
   - Show data labels: ON
   - Line width: 3px
   - Smooth line: Medium

### D. Top 5 Provinces (Bar Chart)

1. **Add a chart** → **Bar chart**
2. Setup:
   - Data Source: **Geographic Analysis**
   - Dimension: **provinsi**
   - Metric: **total_revenue**
   - Sort: total_revenue DESC
   - Row limit: 5

3. Style:
   - Bar color: Gradient (hijau muda → hijau tua)
   - Show data labels: ON
   - Axis title: "Total Revenue (IDR)"

### E. Profit Margin Gauge

1. **Add a chart** → **Gauge chart**
2. Setup:
   - Data Source: **KPI Summary**
   - Metric: **profit_margin_percentage**

3. Style:
   - Min: 0
   - Max: 100
   - Green zone: 20-30
   - Yellow zone: 15-20
   - Red zone: 0-15

---

## 5. PAGE 2: BRANCH PERFORMANCE

### Buat Page Baru

1. Klik **"Page"** → **"New page"**
2. Rename: "Branch Performance"

### Layout
```
┌─────────────────────────────────────────────────┐
│         Top 10 Branches Performance             │
│              (Detailed Table)                   │
├──────────────────────┬─────────────────────────┤
│   Geographic Map     │  Rating Gap Analysis    │
│   (Indonesia)        │   (Alert Table)         │
└──────────────────────┴─────────────────────────┘
```

### A. Top 10 Branches Table

1. **Add a chart** → **Table**
2. Setup:
   - Data Source: **Top Branches**
   - Dimensions & Metrics:
     * branch_name
     * kota
     * provinsi
     * total_revenue
     * total_profit
     * profit_margin_pct
     * avg_rating_cabang
   - Sort: total_profit DESC

3. Style:
   - Table header: Background #0066CC, Text white
   - Row numbers: Show
   - Pagination: 10 rows per page
   
4. **Conditional Formatting** (PENTING!):
   - Klik kolom **profit_margin_pct**
   - Add conditional formatting:
     * Jika > 20 → Background hijau muda
     * Jika 15-20 → Background kuning
     * Jika < 15 → Background merah muda

### B. Geographic Map

1. **Add a chart** → **Geo chart** → **Filled map**
2. Setup:
   - Data Source: **Geographic Analysis**
   - Location: **provinsi**
   - Size metric: **total_revenue**
   - Color metric: **profit_margin_pct**

3. Style:
   - Area: Indonesia
   - Color gradient: Merah (low) → Hijau (high)
   - Show legend: Right

### C. Rating Gap Analysis Table

**INI SANGAT PENTING untuk insight bisnis!**

1. **Add a chart** → **Table with bars**
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
   - Kolom **rating_gap**:
     * Jika > 0.5 → Background MERAH (Urgent!)
     * Jika 0.3-0.5 → Background ORANYE
     * Jika < 0.3 → Background HIJAU
   
   - Kolom **status_cabang**:
     * "Perlu Perhatian Urgent" → Text merah bold
     * "Perlu Improvement" → Text oranye
     * "Normal" → Text hijau

4. **Add Text Annotation:**
   - Insert → Text
   - Tulis: "⚠️ Cabang dengan rating gap tinggi memerlukan improvement service quality"
   - Posisi: Di atas tabel

---

## 6. PAGE 3: PRODUCT ANALYSIS

### Buat Page Baru
1. **Page** → **New page** → Name: "Product & Sales"

### Layout
```
┌──────────────────────┬─────────────────────────┐
│  Top 20 Products     │  Price Segment Analysis │
│   (Bar Chart)        │     (Pie Chart)         │
├──────────────────────┼─────────────────────────┤
│  Discount Impact     │  Day of Week Performance│
│  (Combo Chart)       │   (Column Chart)        │
└──────────────────────┴─────────────────────────┘
```

### A. Top 20 Products

1. **Add chart** → **Bar chart** (Horizontal)
2. Setup:
   - Data Source: **Product Analysis**
   - Dimension: **product_name**
   - Metric: **total_profit**
   - Sort: DESC
   - Limit: 20

3. Style:
   - Color: Gradient biru
   - Show values: ON

### B. Price Segment Performance

1. **Add chart** → **Pie chart**
2. Setup:
   - Data Source: Buat data source baru dari query:
   ```sql
   SELECT * FROM `rakamin-academi-data-analyst.kimia_farma.v_price_point_analysis`
   ```
   - Name: "Price Analysis"
   - Dimension: **price_segment**
   - Metric: **total_revenue**

3. Style:
   - Donut chart: ON
   - Hole size: 0.5
   - Show labels: Percentage & value
   - Colors: Custom 5 warna berbeda

### C. Discount Impact Analysis

1. **Add chart** → **Combo chart**
2. Setup:
   - Data Source: **Discount Analysis**
   - Dimension: **discount_range**
   - Left Y-axis (Bars): **total_revenue**
   - Right Y-axis (Line): **profit_margin_pct**

3. Style:
   - Bar color: Biru
   - Line color: Orange
   - Show both axes: ON

### D. Day of Week Performance

1. **Add chart** → **Column chart**
2. Setup:
   - Data Source: **Day Performance**
   - Dimension: **day_name**
   - Metric: **total_revenue**
   - Sort by: **day_number** ASC

3. Style:
   - Colors: Weekdays (biru), Weekend (orange)

---

## 7. PAGE 4: CUSTOMER INSIGHTS

### Buat Page Baru
1. **Page** → **New page** → Name: "Customer Insights"

### A. Customer Segmentation

1. **Add chart** → **Pie chart**
2. Setup:
   - Data Source: Buat dari query:
   ```sql
   SELECT * FROM `rakamin-academi-data-analyst.kimia_farma.v_customer_segmentation`
   ```
   - Name: "Customer Segmentation"
   - Dimension: **customer_segment**
   - Metric: COUNT(**customer_name**)

3. Style - Custom Colors:
   - VIP: #FFD700 (Gold)
   - Premium: #C0C0C0 (Silver)
   - Regular: #CD7F32 (Bronze)
   - Basic: #808080 (Gray)

### B. Monthly Revenue with YoY Growth

1. **Add chart** → **Time series with forecast**
2. Setup:
   - Data Source: **Monthly Trends**
   - Date: year + month (gunakan formula seperti sebelumnya)
   - Metrics:
     * total_revenue (Line 1)
     * revenue_growth_yoy (Line 2)

3. Style:
   - Enable trend line: ON
   - Show reference line: ON (at 0 for growth)

---

## 8. FILTERS & CONTROLS

### A. Date Range Filter

1. **Add a control** → **Date range control**
2. Setup:
   - Auto date range: Last 12 months
   - Apply to: All charts on all pages

### B. Province Dropdown

1. **Add a control** → **Drop-down list**
2. Setup:
   - Dimension: **provinsi** (dari Geographic Analysis)
   - Control field label: "Filter by Province"
   - Allow multiple selections: ON
   - Include "All" option: ON

### C. Year Selector

1. **Add a control** → **Fixed-size list**
2. Setup:
   - Dimension: **year** (dari KPI Summary)
   - Display horizontally
   - Single selection

---

## 9. STYLING & BRANDING

### A. Theme Setup

1. **Theme and layout** (menu atas)
2. Pilih template: **"Simple Light"**
3. Customize:
   - Primary color: **#0066CC** (Biru Kimia Farma)
   - Secondary color: **#00A651** (Hijau)
   - Background: **#F8F9FA**

### B. Consistent Styling

**Untuk semua charts:**
- Font family: Roboto
- Header font size: 16px
- Border: 1px solid #E0E0E0
- Border radius: 8px
- Shadow: ON (subtle)

### C. Add Logo (Optional)

1. **Insert** → **Image**
2. Upload logo Kimia Farma atau insert via URL
3. Posisi: Top-left di semua pages
4. Size: 120x40px

---

## 10. PUBLISH & SHARE

### A. Finalisasi Dashboard

1. Review semua pages
2. Test semua filters
3. Check responsive view (View → Device → Mobile)

### B. Publish Dashboard

1. Klik **"Share"** (kanan atas)
2. **"Get report link"**
3. Access settings:
   - **"Anyone with the link can view"**
   - Enable "Email viewers"
4. **Copy link**

### C. Setup untuk GitHub

**Buat Repository baru:**

1. Buka GitHub → New Repository
2. Name: `kimia-farma-dashboard`
3. Add README.md dengan struktur:

```markdown
# 📊 Kimia Farma Business Intelligence Dashboard

## 🔴 LIVE DASHBOARD
**[VIEW DASHBOARD HERE](paste-your-looker-link)**

## 📸 Preview
[Tambahkan screenshots]

## 🛠️ Tech Stack
- Google BigQuery
- Looker Studio
- SQL

## 📊 Dashboard Features
- 4 Interactive Pages
- 12+ Visualizations
- Real-time Filtering
- Geographic Analysis
- Customer Segmentation

## 📁 Files
- `sql/kimia_farma_analysis.sql` - Complete SQL script
- `screenshots/` - Dashboard screenshots
- `README.md` - Documentation
```

### D. Ambil Screenshots

**Untuk setiap page dashboard:**

1. Full screen mode (tekan F11)
2. Screenshot:
   - Windows: Win + Shift + S
   - Mac: Cmd + Shift + 4
3. Save sebagai:
   - `page1-executive-summary.png`
   - `page2-branch-performance.png`
   - `page3-product-analysis.png`
   - `page4-customer-insights.png`

4. Upload ke folder `screenshots/` di GitHub

### E. Upload SQL Script

1. Buat folder `sql/` di repository
2. Upload file SQL dengan nama: `kimia_farma_analysis.sql`

---

## ✅ CHECKLIST FINAL

Sebelum submit, pastikan:

**BigQuery:**
- [ ] Semua 12 tabel berhasil dibuat
- [ ] Tidak ada error saat query
- [ ] Data terlihat valid

**Looker Studio:**
- [ ] 4 pages lengkap
- [ ] Semua chart menampilkan data
- [ ] Filters berfungsi
- [ ] Mobile responsive
- [ ] Link dashboard bisa diakses public

**GitHub:**
- [ ] README.md lengkap
- [ ] Screenshots uploaded
- [ ] SQL script uploaded
- [ ] Link dashboard tercantum

---

## 🎯 TIPS SUKSES

### Untuk Portfolio:
1. ✨ **Highlight business insights** - jelaskan temuan penting
2. 📊 **Screenshot berkualitas tinggi** - full HD
3. 🎨 **Design yang clean** - hindari clutter
4. 📝 **Documentation lengkap** - technical & business
5. 🔗 **Easy access** - link yang jelas dan working

### Troubleshooting Common Issues:

**❌ Dashboard tidak loading:**
- Cek BigQuery quota
- Refresh browser
- Clear cache

**❌ Data tidak muncul di chart:**
- Cek data source connection
- Verify field mapping
- Re-run SQL query

**❌ Filter tidak bekerja:**
- Pastikan apply to correct pages
- Check dimension compatibility

---

## 📞 RESOURCES

- **BigQuery Docs:** https://cloud.google.com/bigquery/docs
- **Looker Studio Help:** https://support.google.com/datastudio
- **SQL Tutorial:** https://www.w3schools.com/sql/

---

## 🎉 SELAMAT!

Dashboard Anda siap untuk:
- ✅ Portfolio profesional
- ✅ Presentasi klien
- ✅ Showcase di LinkedIn
- ✅ Interview data analyst

**Good luck! 🚀**

---

*Tutorial ini dibuat untuk Rakamin Academy - Data Analyst Bootcamp*
*Last updated: October 2025*
