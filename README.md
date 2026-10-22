# Credit Card Fraud Risk Dashboard

End-to-end fraud analysis of **42,308 credit card transactions (December 2019)** using **Excel, MySQL and Power BI**. The project finds where, when and against whom fraud happens, and turns the findings into a four-page interactive dashboard with recommendations for a fraud risk team.


## Business Problem

Fraud is less than 0.5% of all transactions, so it is almost impossible to spot by reading raw data. A fraud risk team needs one clear view of the size of the problem, the highest-risk segments, and the times when fraud is most likely, so it can prioritise controls and reduce losses.

## Objectives

- Measure the size of the fraud problem (count, value and rate)
- Identify the highest-risk merchant categories, states and customer segments
- Find when fraud happens (time of day and day of week)
- Build an interactive Power BI dashboard
- Recommend actions backed by the data

## Tools and Skills

| Tool | Used for |
|---|---|
| Excel | Data cleaning, descriptive statistics, histogram, fraud by category and gender, top 10 states, charts |
| MySQL Workbench | Table design, data loading, KPI and segmentation queries |
| Power BI | Data modelling, DAX measures and columns, slicers, page navigation, dashboard design |
| Business analysis | Business Requirements Document (BRD), KPIs, insights and recommendations |

## Dataset

| Item | Detail |
|---|---|
| Records | 42,308 transactions |
| Period | December 2019 |
| Columns | 21 (transaction date and time, merchant, category, amount, customer details, location, city population, `is_fraud` flag) |
| Fraud transactions | 180 (0.43%) |
| Legitimate transactions | 42,128 (99.57%) |

### Data cleaning

| Issue | Fix |
|---|---|
| Dates in `dd/mm/yyyy` and times in 12-hour format, which MySQL rejects | Converted to `yyyy-mm-dd` and 24-hour time |
| Header typo (`tans_time`) | Renamed to `trans_time` |
| Reserved words used as column names (`index`, `long`) | Renamed to `txn_index` and `lng` |
| BOM and Windows line endings in the CSV | Saved as UTF-8 with LF line endings |
| `cc_num` in scientific notation (for example `3.5469E+15`) | Kept as text; the original digits cannot be recovered, so the column is not used for card-level or unique-customer analysis |

Transactions are identified by `trans_num`.

## Key Findings

- **Fraud is rare but costly.** 180 of 42,308 transactions (0.43%) were fraud, but they made up 3.29% of spend (97,540.81 of 2,966,148.83). The average fraud amount is about 542, against about 68 for legitimate transactions.
- **Large transactions carry the most risk.** The fraud rate is 17.86% for amounts of 500 and above and 3.01% for 200-499, against 0.18% for under 50. About 75% of fraud sits in transactions of 200 or more.
- **Online and grocery point-of-sale categories are the riskiest.** `shopping_net` (1.30%), `grocery_pos` (0.94%) and `misc_net` (0.91%) have the highest fraud rates. The top 4 categories hold about 67% of all fraud.
- **Fraud peaks in the evening and at night.** Evening (6 PM-12 AM) has a fraud rate of 0.88% and night (12-6 AM) 0.54%, against 0.12% in the afternoon.
- **Age and gender are weaker signals.** Customers aged 65+ (0.56%) and under 26 (0.53%) are slightly above the 0.43% average. Gender is almost even.
- **Some states have high rates on small bases.** WV (1.50%) and OK (1.12%) have high rates. PA, TX and OH have the most fraud cases.

## Recommendations

1. Add step-up verification (one-time password or 3-D Secure) for transactions of 200 or more, especially 500 or more.
2. Apply stricter checks on `shopping_net`, `misc_net` and `grocery_pos` transactions.
3. Raise monitoring and alert thresholds between 6 PM and 6 AM.
4. Consider targeted customer alerts for cardholders aged 65+ and under 26, whose fraud rates are slightly above average.
5. Review high-rate states and merchants monthly, using counts together with rates.
6. Keep full card numbers in future data extracts so card-level analysis is possible.

## Dashboard Pages

| Page | Content |
|---|---|
| 1. Executive Overview | KPI cards (Total Transactions, Fraud Transactions, Fraud Rate %, Fraud Amount), daily fraud trend, fraud vs legitimate split |
| 2. Where is the Fraud? | Fraud rate by category, top 10 states, top 10 merchants by fraud count |
| 3. Who and When? | Fraud by age group, gender, time of day and day of week |
| 4. Insights and Recommendations | Key findings and recommended actions |

## Power BI Model Highlights

**Columns created (examples):** Fraud Flag, Age (at transaction date), Age Group, Time Band.

**Core measures (examples):**

```DAX
Total Transactions = COUNTROWS ( cc_data )
Fraud Transactions = SUM ( cc_data[Fraud Flag] )
Fraud Rate % = DIVIDE ( [Fraud Transactions], [Total Transactions], 0 )
Fraud Amount = CALCULATE ( SUM ( cc_data[amt] ), cc_data[Fraud Flag] = 1 )
Fraud Amount % = DIVIDE ( [Fraud Amount], SUM ( cc_data[amt] ), 0 )
```

## SQL Highlights

```sql
-- Overall fraud rate
SELECT COUNT(*) AS total_transactions,
       SUM(is_fraud) AS fraud_transactions,
       ROUND(SUM(is_fraud) * 100.0 / COUNT(*), 2) AS fraud_rate_pct
FROM cc_data;

-- Fraud rate by category
SELECT category,
       COUNT(*) AS transactions,
       SUM(is_fraud) AS fraud_transactions,
       ROUND(SUM(is_fraud) * 100.0 / COUNT(*), 2) AS fraud_rate_pct
FROM cc_data
GROUP BY category
ORDER BY fraud_rate_pct DESC;
```

All scripts are in the `03_SQL` folder.
```

## How to Reproduce

1. Create the table using the script in `03_SQL`.
2. Load `data/cc_data_clean.csv` into MySQL (`LOAD DATA LOCAL INFILE`, or the Table Data Import Wizard into the existing table).
3. Confirm the row count is 42,308 and the fraud count is 180.
4. Open the `.pbix` file in Power BI Desktop and refresh the data.
5. Check that the Fraud Rate % card shows 0.43%.

## Limitations

- Only one month of data, so seasonality cannot be assessed.
- Fraud is rare, so rates for small groups (states, merchants, jobs) can be unstable. Counts are shown next to rates.
- `cc_num` could not be recovered, so card-level analysis is not possible.

## Author

**Anamya Upadhyay**

