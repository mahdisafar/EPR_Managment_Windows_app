# ERP Accounting

A complete offline-first **Accounting & Financial Management System** for **Windows Desktop**, built with Flutter. Fully Persian (Farsi) and RTL, with multi-currency support, automatic double-entry journal, and professional invoice printing.

---

## Key Features

| Feature | Description |
| --- | --- |
| **Dashboard** | Financial summary cards, income/expense chart, and date-range filters (Today / Week / Month / Year / All-Time / Custom) |
| **Sales & Purchase Invoices** | Multi-item invoices with automatic stock deduction, landed-cost calculation (freight, customs, labor), and instant PDF print |
| **Inventory** | Real-time stock levels with weighted-average landed-cost pricing |
| **Customers** | Live customer balances with itemized statements and payment recording |
| **Shipments** | Transit shipment lifecycle tracking with expense types linked directly to cash accounts |
| **General Ledger** | Every financial event auto-posted as a traceable journal entry (credit / debit / balance) |
| **Reports** | Profit & Loss, customer balances, shipment cost summaries, with Excel export |
| **Multi-Currency** | Toman base currency with USD / EUR / TRY / IRR and configurable exchange rates |

---

## 1. Dashboard

Financial overview at a glance: income, external expenses, total receivables, and net profit — with an interactive 6-month chart and quick-action shortcuts.

![Dashboard](https://github.com/user-attachments/assets/ce0b6022-20a4-4494-90b7-98cf7fe429d4)

---

## 2. Sales Invoice

Multi-item sale invoices with customer selection, live totals, in-app print preview, and standard PDF generation. Stock and customer balances update automatically on submit.

![Sale Invoice](https://github.com/user-attachments/assets/67ef122f-2fe4-4ae7-b5c8-f00552199203)

---

## 3. Purchase Invoice

Purchase invoices with side costs (freight / customs / loading) that feed directly into **landed-cost** calculation, plus supplier name tracking.

![Purchase Invoice](https://github.com/user-attachments/assets/3d179bc7-cbef-4367-a8e3-be4c4abe3d8f)

---

## 4. Invoice List

Searchable, filterable list of all sales and purchase invoices with per-row **print/PDF** buttons, running totals, and Excel export.

![Invoice List](https://github.com/user-attachments/assets/f2db4653-e04b-4c06-9539-5bc677b0ec7c)

---

## 5. Inventory

Product catalog with real-time stock, purchase price, and landed cost — every sale and purchase updates stock automatically.

![Inventory](https://github.com/user-attachments/assets/78943d40-8407-402d-b742-c9203615aa3e)

---

## 6. Customers

Customer registry with live balance, phone, and address — plus one-click itemized statements and payment recording.

![Customers](PASTE_CUSTOMERS_LINK)

---

## 7. Shipments

Transit shipment management with route tracking (origin → destination), 9-stage status lifecycle, and shipment expenses auto-posted to the journal.

![Shipments](PASTE_SHIPMENTS_LINK)

---

## 8. General Ledger

Chronological journal of every financial event — documents, references, credit/debit columns, and running balance with summary bar.

![General Ledger](PASTE_LEDGER_LINK)

---

## 9. Reports

Profit & Loss report with revenue, COGS, gross/net profit, customer balance table, and trend charts — with Excel export and custom date ranges.

![Reports](PASTE_REPORTS_LINK)

---

## 10. Accounts

Cash and bank account management with receipts/payments in any currency — balances, customer receivables, and the journal stay in sync automatically.

![Accounts](PASTE_ACCOUNTS_LINK)

---

## 11. Personal Expenses

Daily personal expense tracking with categories — automatically reflected in cash accounts and reports.

![Personal Expenses](PASTE_PERSONAL_EXPENSES_LINK)

---

## 12. Settings

Company profile for invoice headers, exchange-rate management, **database backup/restore**, and password change.

![Settings](PASTE_SETTINGS_LINK)

---

## Architecture & Tech Stack

Built following **Clean Architecture** principles, structured by feature (`data`, `domain`, `presentation`):

* **State Management:** BLoC / Cubit
* **Dependency Injection:** GetIt + Injectable
* **Navigation:** GoRouter
* **Local Database:** SQLite (sqflite)
* **Functional Error Handling:** dartz
* **PDF & Printing:** pdf, printing
* **Excel Export:** excel, file_selector
* **Localization:** intl (Persian locale, RTL)

## Run

```bash
flutter pub get
dart run build_runner build
flutter run -d windows
