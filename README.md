# ☕ CafeChain-DB: Relational Database Management System

A comprehensive, highly normalized relational database designed to manage the operations, staff, and analytics of a cafe network. Built with **Oracle SQL** and **PL/SQL**, featuring automated business logic and a Python-based mock data generator.

---

## 🛠️ Tech Stack & Skills Highlighted
* **Database:** Oracle SQL, PL/SQL (Triggers, Stored Procedures logic)
* **Scripting/Automation:** Python 3 (Faker library)
* **Architecture:** Entity-Relationship Modeling (ERD), Database Normalization (3NF)
* **Analytics:** Advanced SQL (Correlated Subqueries, Aggregations, HAVING clauses, JOINs)

---

## 🌟 Key Features

* **Robust Architecture:** 17 normalized tables handling complex relationships (1:N, N:M) including employee shifts, order history, and promotional product mapping.
* **Automated Business Logic (PL/SQL Triggers):**
  * **Loyalty Program:** Automatically calculates and updates customer points based on order actions and payment amounts.
  * **Data Integrity:** Strict validation for customer phone numbers (exactly 9 digits) and automatic formatting (e.g., uppercasing names).
  * **Security & Audit:** Blocks the deletion of premium/budget products and automatically logs all order status changes into an `Order_History` audit table.
* **Data Automation:** Includes a custom Python script (`data_generator.py`) utilizing the `Faker` library to populate the database with hundreds of realistic, relational mock records, ensuring robust testing of queries and triggers.
* **Business Intelligence:** Pre-built analytical queries solving real-world business problems (e.g., identifying top-spending customers, calculating average order values per location, and filtering above-average employee performance).

---

## 📂 Repository Structure

The project is organized to reflect professional development standards:

```text
CafeChain-DB/
├── docs/
│   └── ERD_diagram.png             # Physical Data Model diagram
├── scripts/
│   ├── data_generator.py           # Python script for generating mock data
│   └── requirements.txt            # Python dependencies (Faker)
├── sql/
│   ├── 1_schema_and_tables.sql     # DDL: Table creation and Foreign Keys
│   ├── 2_triggers.sql              # PL/SQL: Business logic and validations
│   ├── 3_insert_mock_data.sql      # DML: Generated data (run after triggers)
│   └── 4_analytical_queries.sql    # DQL: Business reports and analysis
└── README.md                       # Project documentation


```

📊 Entity-Relationship Diagram (ERD)
The database schema is fully documented. You can view the physical data model below:

🚀 How to Run the Project
Set up the Schema: Run sql/1_schema_and_tables.sql in your Oracle SQL environment to build the tables and relationships.

Apply Business Logic: Execute sql/2_triggers.sql to compile the triggers.

Populate Data (Optional but recommended): * You can run the pre-generated sql/3_insert_mock_data.sql.

Alternatively, generate fresh data yourself by running the Python script:

Bash
cd scripts
pip install -r requirements.txt
python data_generator.py > ../sql/3_insert_mock_data.sql

Run Analytics: Open sql/4_analytical_queries.sql to test the business intelligence reports.
