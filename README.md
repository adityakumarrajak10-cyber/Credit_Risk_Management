# Credit Risk Analysis Dashboard

## Project Overview

This project analyzes historical loan and borrower data to understand which characteristics are associated with higher loan-default rates. I used **MySQL** for data cleaning and analysis and **Power BI** to build an interactive dashboard.

The dashboard helps users explore default patterns by loan grade, income group, loan-to-income burden, previous default history, loan purpose, loan amount group, and home ownership.

> **Important:** This is a historical data-analysis project, not a machine-learning prediction model. The reported default rates describe groups in the dataset; they are not the predicted probability that a specific person will default. The dashboard supports risk assessment but does not automatically approve or reject loans.

## Business Problem

Lenders need to understand how loan outcomes differ across borrower and loan segments. Looking at raw rows alone makes these patterns harder to identify quickly.

**Business question:** How can historical borrower and loan data be used to identify factors associated with loan default and support credit-risk assessment?

## Project Objectives

- Clean and validate the loan dataset.
- Analyze historical default rates across relevant borrower and loan characteristics.
- Identify segments with higher or lower observed default rates.
- Present the results in an interactive Power BI dashboard that supports exploration and discussion.

## Tools Used

- **MySQL / MySQL Workbench** — Data checks, duplicate handling, SQL queries, and exploratory analysis.
- **Power BI Desktop** — Power Query transformations, DAX measures, KPI cards, visualizations, and slicers.

## Dataset Overview

The dataset contains borrower, loan, and credit-history information, including:

- Borrower details: age, income, home ownership, and employment length.
- Loan details: loan purpose, loan grade, loan amount, interest rate, and loan amount as a share of income.
- Credit history: previous default on file and credit-history length.
- Outcome: `loan_status`, where **1 = default** and **0 = non-default**.

## Data Cleaning and Preparation

The main preparation steps were:

1. Started with **28,638 rows** in the imported table.
2. Identified and removed **137 extra exact-duplicate rows**, leaving **28,501 rows** in the distinct-record table.
3. Found **two records with an employment length of 123 years**, which were treated as invalid and excluded from the Power BI model.
4. The final Power BI dashboard therefore uses **28,499 rows**.
5. Checked the original columns for SQL `NULL` values; none were found in that check.
6. Created analysis-friendly groups in Power BI, including age, income, loan amount, interest rate, employment length, and loan-to-income burden groups.

**Data-quality note:** The dataset does not provide a unique customer or loan identifier. Therefore, identical rows were treated as duplicates for this analysis, although identical-looking records could theoretically represent separate legitimate loans.

## Dashboard Features

The dashboard includes:

- **KPI Cards:** Total loans, total loan amount, defaulted loans, non-defaulted loans, and observed default rate.
- **Loan Grade Analysis:** Compares loan counts and observed default rates by grade.
- **Income Analysis:** Compares observed default rates across income groups.
- **Income-Burden Analysis:** Compares observed default rates across loan-to-income burden groups.
- **Previous-Default Donut Chart:** Shows the composition of defaulted loans by whether a previous default was on file. This is a share of defaulted loans, not the default rate for each previous-default category.
- **Loan-Purpose Chart:** Shows loan volume by loan intent.
- **Loan-Size Chart:** Shows portfolio composition by loan amount group.
- **Home-Ownership Treemap:** Shows loan volume by home-ownership category.
- **Interactive Slicers:** Allow users to filter by loan grade, loan intent, and default status.

## Key Findings

The SQL analysis identified several notable historical patterns.

### 1. Loan Grade

The observed default rate increased from approximately **9.6% for Grade A** to **59.2% for Grade D** and **98.3% for Grade G**.

Grade G contains only **59 loans**, so its rate should be interpreted cautiously.

### 2. Loan-to-Income Burden

The high-burden segment had an observed default rate of approximately **75.5%**, compared with approximately **13.5%** for the low-burden segment.

### 3. Income Level

Borrowers in the below-30K income group had an observed default rate of approximately **46.5%**, compared with approximately **12.1%** for borrowers in the 60K-and-above group.

### 4. Previous Default History

Borrowers with a previous default on file had an observed default rate of approximately **37.8%**, compared with approximately **18.2%** for borrowers without a previous default on file.

### 5. Loan Purpose

Debt consolidation and medical loans had higher observed default rates than venture loans in the SQL analysis.

These findings describe **associations, not causes**. Rates can also be affected by group size and by other characteristics of the borrowers and loans.

## Overall Dashboard Metrics

With all filters cleared, the final Power BI model should show approximately:

| Metric | Value |
|---|---:|
| Total Loans | 28,499 |
| Defaulted Loans | 6,187 |
| Non-Defaulted Loans | 22,312 |
| Observed Default Rate | 21.71% |

The dashboard's slicers change the KPIs and supporting charts, so clear all filters before comparing the overall figures.

## Business Value

The analysis helps a credit team see where historical default rates differ across portfolio segments and identify areas that may warrant closer review.

For example, loan grade, loan-to-income burden, income level, and previous default history are useful dimensions to investigate further.

The results should be used alongside additional information, validation, and an appropriate lending policy—not as the sole basis for an individual loan decision.

## Limitations

- The project describes historical patterns; it does not include a trained or validated machine-learning model.
- There is no date field for analyzing default trends over time.
- The dataset does not include a unique customer or loan ID, which limits duplicate verification and individual-level analysis.
- Small groups, especially Grade G, can produce unstable rates.
- Observed relationships do not prove causation.

## Conclusion

This project demonstrates a practical analytics workflow using SQL and Power BI: data-quality checks, exploratory analysis, KPI creation, interactive visualization, and business-focused interpretation.

The main outcome is an interactive view of historical default patterns that can support further credit-risk investigation.
