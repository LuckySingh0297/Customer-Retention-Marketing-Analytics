# Customer Retention & Marketing Analytics

**An end-to-end Data Analyst project using Excel, MySQL, Python and Power BI**

## 1. Project Overview

Customer retention is an important part of business growth. Understanding how customers purchase, how frequently they return, and how much value they contribute can help businesses make better decisions.

In this project, I analysed the **UCI Online Retail II dataset** to understand historical sales performance, customer purchasing behaviour, repeat purchases and customer value.

The objective was to transform raw retail transaction data into meaningful business insights and identify customer groups that may need attention from the business.

This project follows an end-to-end data analysis workflow, from data understanding and preparation to SQL analysis, Python exploration and Power BI reporting.

## 2. Business Problem

An online retailer generates thousands of transactions, but raw transaction records alone do not explain customer behaviour.

The business needs answers to questions such as:

- Which countries and product categories contribute the most sales?
- How does sales performance change over time?
- How many customers make repeat purchases?
- Which customers contribute the most revenue?
- Which customers may need attention from a retention perspective?
- How can customer purchasing behaviour be grouped into meaningful segments?

### Project Objectives

1. Understand and assess the quality of retail transaction data.
2. Analyse sales performance across time, countries and products.
3. Measure customer purchasing frequency and repeat purchases.
4. Perform customer segmentation using RFM analysis.
5. Build an interactive Power BI dashboard.
6. Translate analytical results into practical business recommendations.

## 3. Dataset

**Dataset:** UCI Online Retail II

**Source:** [UCI Machine Learning Repository – Online Retail II](https://archive.ics.uci.edu/dataset/502/online+retail+ii)

The dataset contains historical online retail transactions from a UK-based online retailer.

The retained-source workflow in the Excel analysis workbook contains **1,067,371 transaction rows**.

Important fields include:

| Column | Description |
|---|---|
| Invoice | Invoice number |
| StockCode | Product code |
| Description | Product description |
| Quantity | Number of units purchased |
| InvoiceDate | Transaction date |
| Price | Unit price |
| Customer ID | Customer identifier |
| Country | Customer's country |

Additional analytical fields were created, including line total and invoice type.

**Important:** The source contains returns, cancellations, missing customer identifiers and other records that require careful treatment before customer-level analysis.

## 4. Tools & Technologies

| Tool | Purpose |
|---|---|
| Microsoft Excel | Data inspection, data quality checks, analysis and summaries |
| Power Query | Data preparation and transformation |
| MySQL | Data querying, filtering, grouping and customer analysis |
| Python | Data analysis, customer-level calculations and visualisation |
| Pandas & NumPy | Data manipulation and numerical analysis |
| Matplotlib & Seaborn | Data visualisation |
| Power BI | Interactive dashboard and business reporting |

## 5. Project Workflow

### Step 1 – Data Understanding and Data Quality

I started by understanding the dataset structure, columns, data types and transaction-level details.

I checked:

- Missing customer identifiers.
- Missing product descriptions.
- Negative quantities.
- Cancellation invoices.
- Unusual transaction values.
- Duplicate transaction candidates.

**Why?**

Before calculating business metrics, an analyst needs to understand the quality and limitations of the data. Incorrectly treating returns or cancellations as normal purchases can produce misleading results.

The raw source was retained so that data-quality decisions could be reviewed.

### Step 2 – Data Preparation

I prepared the transaction data for analysis and created additional fields, including:

- Line Total = Quantity × Unit Price
- Invoice Type = Sale, Cancellation or Return Adjustment

For customer retention and RFM analysis, I used a defined positive-sales population:

- Known Customer ID.
- Valid invoice.
- Valid invoice date.
- Positive quantity.
- Positive unit price.
- Sale transactions only.

The recorded clean customer-sales population contains **805,531 transaction rows**.

**Why?**

Customer retention analysis requires identifiable customers and valid purchase activity. Returns and cancellation transactions should not automatically be treated as positive purchases.

### Step 3 – Excel Analysis

I used Excel and Power Query to inspect, prepare and analyse the dataset.

Analysis included:

- Data quality assessment.
- Monthly sales analysis.
- Country-wise sales analysis.
- Product category analysis.
- Customer analysis.
- Cohort retention analysis.
- RFM segment summaries.

**Why?**

Excel provides a practical way to inspect data, validate calculations and create summaries before moving into deeper analysis.

### Step 4 – SQL Analysis Using MySQL

I used MySQL to query the transaction data and perform structured analysis.

The analysis focused on:

- Sales performance.
- Distinct invoice counts.
- Customer-level purchase frequency.
- Repeat customer identification.
- Customer retention.
- Cohort analysis.
- RFM metrics and segmentation.

**Why?**

SQL helps analyse large datasets efficiently. It also allows business questions to be translated into repeatable queries.

An important analytical decision was to count distinct invoices rather than transaction rows when measuring orders, because one invoice can contain multiple product lines.

### Step 5 – Python Analysis

I used Python, mainly Pandas and NumPy, to perform customer-level analysis and visual exploration.

The workflow included:

- Loading and inspecting the dataset.
- Checking missing values and duplicate candidates.
- Preparing the clean-sales population.
- Calculating customer-level metrics.
- Measuring repeat purchasing.
- Performing RFM analysis.
- Creating visualisations.

**Why?**

Python makes the analytical process repeatable and provides flexibility for data manipulation, customer segmentation and visualisation.

### Step 6 – RFM Customer Segmentation

I used RFM analysis to understand customer behaviour through three measures:

| Metric | Meaning |
|---|---|
| Recency | How recently did the customer purchase? |
| Frequency | How many distinct qualifying invoices did the customer place? |
| Monetary | How much positive purchase value did the customer generate? |

Customers were assigned relative scores from 1 to 5.

The analysis used the following segments:

- Champions
- Loyal Customers
- New / Promising
- At Risk
- Needs Attention

**Why?**

RFM analysis helps distinguish customers based on their observed purchasing behaviour and provides a practical starting point for retention-focused business discussions.

The scores are relative to this dataset and the selected customer population.

### Step 7 – Power BI Dashboard

I used Power BI to communicate the analytical results through an interactive dashboard.

The documented dashboard design includes:

- Total Sales Revenue.
- Total Customers.
- Total Orders.
- Repeat Customers.
- Repeat Purchase Rate.
- Monthly Revenue Trend.
- Top 10 Countries by Revenue.
- Customer Segmentation.
- Repeat vs One-Time Customers.
- Country, Date and Customer Segment slicers.

**Why?**

A dashboard helps business users understand key performance indicators and explore sales and customer patterns without having to read raw data or SQL queries.

## 6. Key Analytical Results

The following are recorded results from the current project documentation. They should be treated as provisional until all tools have been reconciled.

| Metric | Recorded Result |
|---|---:|
| Source transaction rows | 1,067,371 |
| Clean customer-sales rows | 805,531 |
| Qualifying customers | 5,878 |
| Qualifying distinct invoices | 36,969 |
| Repeat customers | 4,255 |
| Repeat purchase rate | 72.39% |
| Positive purchase value | Approximately 17.74 million |

**Validation note:** A later Power BI report records 4,225 repeat customers and a 71.88% repeat purchase rate. This difference is being investigated. The repeat-purchase KPI should not be treated as final until the same customer population and calculation are verified across Excel, SQL, Python and Power BI.

### Recorded RFM Segment Summary

| Customer Segment | Customers | Share |
|---|---:|---:|
| Needs Attention | 2,615 | 44.49% |
| Champions | 1,292 | 21.98% |
| At Risk | 825 | 14.04% |
| Loyal Customers | 705 | 11.99% |
| New / Promising | 441 | 7.50% |

These are recorded Python analysis results. Exact agreement with the Power BI segmentation still requires validation.

## 7. Business Insights

Based on the recorded analysis:

**1. Customer value is concentrated among Champions**

The Champions segment contributes the largest recorded revenue among the RFM groups. Understanding this group's purchasing behaviour may help the business identify ways to maintain valuable customer relationships.

**2. Needs Attention is the largest customer segment**

Approximately 44.49% of the recorded RFM customer population falls into Needs Attention. This group could be investigated further to understand its purchase history and identify potential retention opportunities.

**3. Repeat purchasing is an important metric**

Measuring distinct invoices per customer provides a clearer picture of repeat purchasing than counting transaction rows.

**4. Geographic analysis helps identify sales concentration**

Country-wise revenue analysis helps identify the markets contributing most to historical sales. The recorded Power BI analysis identifies the United Kingdom as the highest-revenue country.

## 8. Business Recommendations

Based on the analysis, I would recommend:

- Study Champions to understand their purchase frequency and product preferences.
- Investigate the Needs Attention segment to identify customers who may benefit from further retention analysis.
- Review At Risk customers based on their last purchase date and historical order frequency.
- Monitor monthly sales trends and country-wise performance.
- Collect campaign cost, channel and customer exposure data in future so that marketing campaign performance and ROI can be measured.

These are recommendations for further investigation, not proven campaign outcomes.

## 9. Project Limitations

- The dataset represents historical transactions, not current customer behaviour.
- Some transactions have missing customer identifiers.
- Returns and cancellations require separate treatment from positive sales.
- RFM scores depend on the selected population, snapshot date and scoring method.
- The dataset does not provide campaign expenditure or campaign exposure data.
- Campaign ROI cannot be calculated from the available information.
- The analysis cannot prove why a customer stopped purchasing.

## 10. Repository Structure

```text
Project-2-Customer-Retention-Marketing-Analytics/
│
├── README.md
│
├── Excel/
│   ├── Project_2_Excel_Analysis.xlsx
│   └── Project_2_Excel_Handoff.xlsx
│
├── SQL/
│   └── Project_2_Customer_Retention_Analytics.sql
│
├── Python/
│   ├── Customer_Retention_Analysis.ipynb
│   └── requirements.txt
│
├── PowerBI/
│   ├── Customer_Retention_Analytics.pbix
│   └── Dashboard_Screenshots/
│
├── Documentation/
│   ├── Project_2_Final_Data_Analyst_Report.docx
│   ├── Project_Guide.docx
│   ├── Excel_Report.docx
│   ├── SQL_Report.docx
│   ├── Python_Report.docx
│   └── PowerBI_Report.docx
│
└── Data/
    └── README.md
```

*The folder and filenames above are the proposed repository structure. Use the actual final filenames when organising the repository.*

## 11. Conclusion

This project helped me understand how raw retail transaction data can be transformed into meaningful business information.

I followed an analytical workflow that included data understanding, data quality assessment, data preparation, SQL querying, Python analysis, customer segmentation and Power BI reporting.

The main objective was not simply to create charts or write queries, but to understand the business questions behind the data, choose appropriate analytical methods and communicate findings in a way that supports business decisions.

**The project demonstrates my practical learning and application of Excel, SQL, Python and Power BI for Data Analyst responsibilities.**

---

**Project Category:** Data Analytics | Customer Analytics | Retail Analytics

**Tools:** Excel | MySQL | Python | Power BI

**Dataset:** UCI Online Retail II
