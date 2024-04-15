# Banking Application
This repository contains the source code for a simple banking application built using Oracle SQL and PL/SQL. The application is designed to manage customer accounts, handle transactions such as deposits and withdrawals, and maintain up-to-date account balance information.

## Features
* Customer Management: Add and manage customer details including name, address, and phone number.
* Account Management: Create accounts, update account details, and track account balances over time.
* Transaction Handling: Support for deposit and withdrawal transactions.
* Balance Checks: Functionality to check the current balance and total balance across all accounts for a customer.
* Automated Updates: Use of triggers to automatically update the last transaction date after each transaction.
## Technologies
* Oracle SQL: For database creation and manipulation.
* Oracle PL/SQL: For writing stored procedures, functions, and triggers.
* Oracle APEX: For application development and deployment.
### Database Schema
## Tables
* Customers: Stores customer information.
* Accounts: Stores account details linked to customers.
* Transactions: Stores transaction details associated with accounts.
## Sequences
* customer_seq: Used for auto-incrementing the c_id primary key in the Customers table.
* account_seq: Used for auto-incrementing the acc_id primary key in the Accounts table.
* transaction_seq: Used for auto-incrementing the transaction_id primary key in the Transactions table.
## Triggers
* update_last_transaction: A trigger that updates the last_transaction_date in the Accounts table after each transaction.
## Packages
* banking_pkg: Contains procedures and functions for managing deposits, withdrawals, balance checks, and total customer balance calculations.
