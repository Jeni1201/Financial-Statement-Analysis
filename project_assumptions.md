# Data Dictionary

## Dataset Overview

Financial statement data for 5 Indian listed companies across FY2022–FY2026.

**Source :**  Screener.in (Consolidated Financial Statements)

**Unit of Measurement :**  All values are reported in ₹ Crores exactly as presented on Screener.
 
**Reporting Period :**  FY 2022 – FY 2026

---

# Column Definitions

| Column           | Description                                                                           |
| ---------------- | ------------------------------------------------------------------------------------- |
| Company          | Company name                                                                          |
| Year             | Financial year                                                                        |
| Revenue          | Sales reported in the Profit & Loss Statement                                         |
| EBITDA           | Operating Profit used as an EBITDA proxy                                              |
| NetProfit        | Net Profit reported in the Profit & Loss Statement                                    |
| Assets           | Total Assets reported in the Balance Sheet                                            |
| Borrowings       | Interest-bearing debt reported under Borrowings                                       |
| Deposits         | Deposits reported by banking institutions                                             |
| OtherLiabilities | Non-debt liabilities such as payables, deferred tax liabilities, and accrued expenses |
| EquityCapital    | Share Capital reported in the Balance Sheet                                           |
| Reserves         | Reserves & Surplus reported in the Balance Sheet                                      |
| CFO              | Cash Flow from Operating Activities                                                   |
| CFI              | Cash Flow from Investing Activities                                                   |
| CFF              | Cash Flow from Financing Activities                                                   |


---

# Business Rules & Assumptions

### Revenue
Revenue is mapped from the **Sales** line item reported by Screener.

### EBITDA
Operating Profit is used as an EBITDA proxy.

**Reason:**  Screener does not consistently provide EBITDA across all companies. Using Operating Profit ensures a consistent metric across the dataset.

### Equity
Equity is defined as :  `Equity = Equity Capital + Reserves`

This represents shareholders' net worth and is used for ROE calculations.

### Debt
Debt is defined as :  `Debt = Borrowings`
Other Liabilities are excluded because they contain operational and non-interest-bearing obligations that may distort leverage ratios.

Examples include :-  Trade Payables ,  Deferred Tax Liabilities ,  Accrued Expenses.

Borrowings are used as reported by Screener. No adjustments were made to exclude potential lease liabilities in order to maintain consistency across companies.

### Banking-Specific Treatment
- For banking institutions, Deposits are retained as a separate field.
- Deposits represent the primary funding source of banks and are economically different from corporate borrowings.

---

# Validation Rules

#### Balance Sheet Validation

Accounting equation used:
`Assets = Equity + Liabilities`

Wherein:
- Non-Banking Companies
			`Liabilities = Borrowings + OtherLiabilities`
- Banking Companies
			`Liabilities = Borrowings + OtherLiabilities + Deposits`

This approach allows a single validation process to be applied consistently across all companies.

> Validation checks were performed to confirm balance sheet consistency before analysis.

---
# Key Analysis Definitions

Revenue Growth (%) = Year-over-Year Revenue Change

Profit Growth (%) = Year-over-Year Net Profit Change

ROE = Net Profit / Equity

ROA = Net Profit / Assets

Debt-to-Equity = Borrowings / Equity

Asset Turnover = Revenue / Assets
