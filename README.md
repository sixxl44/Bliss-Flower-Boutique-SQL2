# Bliss Flower Boutique – Database System

A relational database system built in Oracle SQL for managing a flower shop's staff, customers, orders, products, and billing — with role-based access control for different staff levels.

## Overview

This project models the core operations of a flower boutique: staff management, customer records, order processing, product catalog, and billing. It demonstrates database design, role-based security, stored procedures, functions, triggers, and query optimization in Oracle SQL.

## Database Schema

- **Staff** — employee records (ID, phone, salary, email)
- **Customer** — customer records, linked to the staff member who registered them
- **Order_** — customer orders with status and total price
- **Product** — product catalog (type, price)
- **Order_Product** — join table linking orders to products with quantities
- **Bill** — billing/receipt records linked to orders and staff

## Role-Based Access Control

Three roles with different privilege levels:

| Role | Access |
|---|---|
| **Admin** | Full privileges on all tables |
| **Manager** | Select/Insert/Update on Staff, Orders, Products |
| **Cashier** | Select/Insert on Orders, Select on Customers |

## Key Features

- **Stored Procedure** — `UpdateProductStock`: updates product quantity after new stock arrives
- **Function** — `GetStaffSalaryByID_`: returns a staff member's salary by ID
- **Trigger** — `SetDefaultOrderStatus`: automatically sets a new order's status to "Pending" if not provided
- **Indexing** — index on `Customer(Phone_Num)` to speed up phone-based lookups
- **Join Query** — retrieves all customers with completed orders via a join between Customer and Order_

## How to Run

1. Run the script in Oracle SQL Developer (or any Oracle-compatible client).
2. Tables are created and populated with sample data automatically.
3. Roles and users (`admin_user`, `manager_user`, `cashier_user`) are created with their respective privileges.
4. Run the sample `SELECT` statements at the bottom of the script to test procedures, functions, and triggers.
